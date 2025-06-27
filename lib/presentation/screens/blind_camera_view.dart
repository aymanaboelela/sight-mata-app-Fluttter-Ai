import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:sight_mate_app/core/constants/colors.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class VoiceAICommunicationPage extends StatefulWidget {
  @override
  _VoiceAICommunicationPageState createState() =>
      _VoiceAICommunicationPageState();
}

class _VoiceAICommunicationPageState extends State<VoiceAICommunicationPage> {
  late FlutterTts _flutterTts;
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;
  Interpreter? _interpreter;
  bool _isProcessing = false;
  String _processingTime = "Processing Time: 0.0 ms";
  String _outputText = "Waiting for output...";
  List<String> _labels = [];
  Map<int, String> _indexToLabel = {};
  bool _isStreaming = false;
  Timer? _streamTimer;
  static const int _inputSize = 300;
  static const double _confidenceThreshold = 0.5;
  static const int _streamDelay = 1500;

  @override
  void initState() {
    super.initState();
    _initializeSystem();
    // Show the permission dialog after the widget is built
  }

  Future<void> _initializeSystem() async {
    try {
      _flutterTts = FlutterTts();
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      await Future.wait([
        _loadLabels(),
        _loadModel(),
        _initializeCamera(),
      ]);

      if (mounted) {
        setState(() {
          _isCameraReady = _cameraController?.value.isInitialized ?? false;
        });
      }
    } catch (e) {
      log("System initialization error: $e");
      if (mounted) setState(() => _outputText = "Initialization error: $e");
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/model/label2.txt');
      _labels = labelData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
      _indexToLabel = {for (var i = 0; i < _labels.length; i++) i: _labels[i]};
      log("Loaded ${_labels.length} labels");
    } catch (e) {
      log("Error loading labels: $e");
      if (mounted) setState(() => _outputText = "Label loading failed: $e");
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/model2.tflite',
        options: InterpreterOptions()..threads = 4,
      );

      if (_interpreter != null) {
        log("Input tensor: ${_interpreter!.getInputTensor(0).shape}");
        log("Input type: ${_interpreter!.getInputTensor(0).type}");
        final outputTensors = _interpreter!.getOutputTensors();
        for (int i = 0; i < outputTensors.length; i++) {
          log("Output tensor $i: shape=${outputTensors[i].shape}, type=${outputTensors[i].type}");
        }
      }
    } catch (e) {
      log("Error loading model: $e");
      if (mounted) setState(() => _outputText = "Model loading failed: $e");
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("No cameras available");

      _cameraController = CameraController(
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back),
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeCameraFuture = _cameraController!.initialize();
      await _initializeCameraFuture;
    } catch (e) {
      log("Camera init error: $e");
      if (mounted) setState(() => _outputText = "Camera error: $e");
    }
  }

  Future<Uint8List> _preprocessImage(Uint8List bytes) async {
    try {
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception("Failed to decode image");

      final resized = img.copyResize(image,
          width: _inputSize,
          height: _inputSize,
          interpolation: img.Interpolation.cubic);

      final input = Uint8List(_inputSize * _inputSize * 3);
      int pixelIndex = 0;

      for (var y = 0; y < _inputSize; y++) {
        for (var x = 0; x < _inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          input[pixelIndex++] = pixel.r.toInt();
          input[pixelIndex++] = pixel.g.toInt();
          input[pixelIndex++] = pixel.b.toInt();
        }
      }

      return input;
    } catch (e) {
      throw Exception("Image preprocessing failed: $e");
    }
  }

  void _startStreaming() {
    if (_isStreaming || _interpreter == null || _cameraController == null)
      return;

    setState(() => _isStreaming = true);
    _streamTimer =
        Timer.periodic(Duration(milliseconds: _streamDelay), (_) async {
      if (!_isStreaming) return;
      await _processImage();
    });
  }

  void _stopStreaming() {
    setState(() => _isStreaming = false);
    _streamTimer?.cancel();
  }

  Future<void> _processImage() async {
    if (_isProcessing || _interpreter == null || _cameraController == null) {
      log("Cannot process image: System not ready");
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final image = await _cameraController!.takePicture();
      final imageBytes = await File(image.path).readAsBytes();
      final processedImage = await _preprocessImage(imageBytes);

      final stopwatch = Stopwatch()..start();
      final output = await _runInference(processedImage);
      stopwatch.stop();
      _handleOutput(output, stopwatch.elapsedMilliseconds);
    } catch (e) {
      log("Image processing error: $e");
      if (mounted) setState(() => _outputText = "Processing error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<Map<String, dynamic>> _runInference(Uint8List input) async {
    if (_interpreter == null) throw Exception("Interpreter not initialized");

    try {
      final inputTensor = [
        input.reshape([1, _inputSize, _inputSize, 3])
      ];
      final outputTensors = _interpreter!.getOutputTensors();

      // Dynamically allocate output tensors based on their types and shapes
      final outputs = <int, dynamic>{};
      for (int i = 0; i < outputTensors.length; i++) {
        final shape = outputTensors[i].shape;
        final size = shape.reduce((a, b) => a * b);
        if (outputTensors[i].type == TensorType.float32) {
          outputs[i] = Float32List(size).reshape(shape);
        } else if (outputTensors[i].type == TensorType.uint8) {
          outputs[i] = Uint8List(size).reshape(shape);
        } else {
          throw Exception(
              "Unsupported output tensor type: ${outputTensors[i].type}");
        }
      }

      _interpreter!
          .runForMultipleInputs(inputTensor, outputs.cast<int, Object>());

      // Adjust based on actual tensor output structure
      return {
        'boxes': outputs[0][0], // Assuming batch size of 1
        'classes': outputs[1][0], // Assuming batch size of 1
        'scores': outputs[2][0], // Assuming batch size of 1
        'count': outputs[3].length > 1
            ? outputs[3][0][0]
            : outputs[3][0], // Handle scalar or array
      };
    } catch (e) {
      log("Inference error: $e");
      throw Exception("Inference failed: $e");
    }
  }

  void _handleOutput(Map<String, dynamic> output, int elapsedMs) {
    try {
      final boxes = output['boxes'] as List<dynamic>;
      final classes = output['classes'] as List<dynamic>;
      final scores = output['scores'] as List<dynamic>;
      final count = output['count'] is List
          ? (output['count'] as List)[0]
          : output['count'] as num;

      log("Output structure - Boxes: ${boxes.length}, Classes: ${classes.length}, Scores: ${scores.length}, Count: $count");

      List<String> detectedObjects = [];
      int detectionCount = count.toInt();

      detectionCount = detectionCount.clamp(0, scores.length);

      for (int i = 0; i < detectionCount; i++) {
        final score = scores[i] is num
            ? scores[i].toDouble()
            : (scores[i][0] as num).toDouble();
        if (score > _confidenceThreshold) {
          final classId = classes[i] is num
              ? classes[i].toInt()
              : (classes[i][0] as num).toInt();
          final label = _indexToLabel[classId] ?? "Unknown";
          detectedObjects.add("$label (${(score * 100).toStringAsFixed(2)}%)");

          final box = boxes[i];
          log("Detection $i: Box=[${box[0]}, ${box[1]}, ${box[2]}, ${box[3]}], Score=$score, Class=$classId");
        }
      }
      if (mounted) {
        setState(() {
          _outputText = detectedObjects.isNotEmpty
              ? "Detected: ${detectedObjects[0]}"
              : "No objects detected";
          _processingTime = "Processing Time: $elapsedMs ms";
        });

        if (detectedObjects.isNotEmpty) {
          _flutterTts.speak("${detectedObjects[0]}");
        }
      }

      log("Inference Time: $elapsedMs ms");
      log("Detected Objects: ${detectedObjects.join(', ')}");
    } catch (e) {
      log("Output handling error: $e");
      if (mounted) setState(() => _outputText = "Output error: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    _streamTimer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  bool _isCameraReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: _initializeCameraFuture == null || _cameraController == null
                ? Center(child: Lottie.asset(AppAssets.loding))
                : FutureBuilder<void>(
                    future: _initializeCameraFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasError) {
                        return RotatedBox(
                          quarterTurns: Platform.isAndroid ? 1 : 3,
                          child: CameraPreview(_cameraController!),
                        );
                      }
                      return Center(child: Lottie.asset(AppAssets.loding));
                    },
                  ),
          ),
          // Red indicator for streaming
          if (_isStreaming)
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: InkWell(
              onTap: _isStreaming ? _stopStreaming : _startStreaming,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.bb,
                    width: 100,
                    height: 100,
                  ),
                  // Red overlay on the button when streaming
                  if (_isStreaming)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // child: Container(
            //   padding: EdgeInsets.all(16),
            //   color: Colors.black54,
            //   child: Column(
            //     children: [
            //       Text(_outputText,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(fontSize: 18, color: Colors.white)),
            //       Text(_processingTime,
            //           textAlign: TextAlign.center,
            //           style: TextStyle(color: Colors.white70)),
            //       SizedBox(height: 16),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           ElevatedButton(
            //             onPressed:
            //                 _isStreaming ? _stopStreaming : _startStreaming,
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: _isStreaming
            //                   ? Colors.red
            //                   : AppColors.primaryBlueColor,
            //               padding: EdgeInsets.symmetric(
            //                   horizontal: 24, vertical: 12),
            //             ),
            //             child: Text(
            //               _isStreaming ? "Stop" : "Stream",
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 20),
            //           ElevatedButton(
            //             onPressed: _isProcessing ? null : _processImage,
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: _isProcessing
            //                   ? Colors.red
            //                   : AppColors.primaryBlueColor,
            //               padding: EdgeInsets.symmetric(
            //                   horizontal: 24, vertical: 12),
            //             ),
            //             child: Text(
            //               "Capture",
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
