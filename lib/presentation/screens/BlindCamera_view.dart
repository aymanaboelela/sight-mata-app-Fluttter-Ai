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
  late CameraController _cameraController;
  late Future<void> _initializeCameraFuture;
  Interpreter? _interpreter;
  bool _isProcessing = false;
  String _processingTime = "Processing Time: 0.0 ms";
  String _outputText = "Waiting for output...";
  List<String> _labels = []; // List to store class labels
  bool _isStreaming = false; // To control streaming
  Timer? _streamTimer; // Timer for streaming frames

  @override
  void initState() {
    super.initState();
    _initializeSystem();
    _initializeCameraFuture = _initializeCamera();
  }

  void _initializeSystem() async {
    _flutterTts = FlutterTts();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await _loadModel();
    await _loadLabels(); // Load class labels
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await rootBundle
          .loadString('assets/model/label.txt'); // Ensure the file name matches
      _labels = labelData.split('\n');
      log("Labels loaded: $_labels");
    } catch (e) {
      log("Error loading labels: $e");
      setState(() {
        _outputText = "Error loading labels: $e";
      });
    }
  }

  Future<void> _loadModel() async {
    try {
      log("Loading model from assets...");
      _interpreter = await Interpreter.fromAsset(
        'assets/model/model.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      log("Model loaded successfully");

      // Log input and output tensor shapes
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      log("Input Tensor Shape: ${inputTensor.shape}");
      log("Output Tensor Shape: ${outputTensor.shape}");
    } catch (e) {
      log("Error loading model: $e");
      setState(() {
        _outputText = "Error loading model: $e";
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back),
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController.initialize();
      if (mounted) setState(() {});
      log("Camera initialized successfully");
    } catch (e) {
      log("Error initializing camera: $e");
    }
  }

  void _startStreaming() {
    if (_isStreaming || _interpreter == null) return;

    setState(() => _isStreaming = true);

    // Process frames every 500ms (adjust as needed)
    _streamTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (!_isStreaming) {
        timer.cancel();
        return;
      }

      try {
        final image = await _cameraController.takePicture();
        final imageBytes = await File(image.path).readAsBytes();
        final processedImage = await _preprocessImage(imageBytes);

        final stopwatch = Stopwatch()..start();
        final output = _runInference(processedImage);
        stopwatch.stop();

        _handleOutput(output, stopwatch.elapsedMilliseconds);
      } catch (e) {
        log("Error processing frame: $e");
      }
    });
  }

  void _stopStreaming() {
    if (!_isStreaming) return;

    setState(() => _isStreaming = false);
    _streamTimer?.cancel();
  }

  Future<void> _processImage() async {
    if (_isProcessing || _interpreter == null) {
      log("Processing skipped: _isProcessing=$_isProcessing, _interpreter=${_interpreter == null ? 'null' : 'loaded'}");
      setState(() {
        _outputText = _interpreter == null
            ? "Model not loaded. Please check logs."
            : "Processing skipped.";
      });
      return;
    }

    setState(() => _isProcessing = true);

    try {
      log("Capturing image...");
      final imageFile = await _cameraController.takePicture();
      log("Image captured: ${imageFile.path}");

      final imageBytes = await File(imageFile.path).readAsBytes();
      log("Image bytes loaded: ${imageBytes.length} bytes");

      final processedImage = await _preprocessImage(imageBytes);
      log("Image preprocessed successfully");

      final stopwatch = Stopwatch()..start();
      final output = _runInference(processedImage);
      stopwatch.stop();

      _handleOutput(output, stopwatch.elapsedMilliseconds);
    } catch (e) {
      log("Error processing image: $e");
      setState(() {
        _outputText = "Error processing image: $e";
      });
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<Float32List> _preprocessImage(List<int> bytes) async {
    final image = img.decodeImage(Uint8List.fromList(bytes))!;
    final oriented = _correctOrientation(image);
    final resized =
        img.copyResize(oriented, width: 640, height: 640); // Resize to 640x640

    // Ensure the image is in RGB format (3 channels)
    final inputBuffer = Float32List(640 * 640 * 3);
    int pixelIndex = 0;

    for (var y = 0; y < 640; y++) {
      for (var x = 0; x < 640; x++) {
        final pixel = resized.getPixel(x, y);
        inputBuffer[pixelIndex++] = pixel.r / 255.0; // Normalize to [0, 1]
        inputBuffer[pixelIndex++] = pixel.g / 255.0;
        inputBuffer[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return inputBuffer;
  }

  img.Image _correctOrientation(img.Image image) {
    return img.copyRotate(image, angle: 90);
  }

  List<dynamic> _runInference(Float32List input) {
    // Get input and output tensor shapes
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);

    log("Input Tensor Shape: ${inputTensor.shape}");
    log("Output Tensor Shape: ${outputTensor.shape}");

    // Ensure the input matches the expected shape
    if (inputTensor.shape[1] != 640 ||
        inputTensor.shape[2] != 640 ||
        inputTensor.shape[3] != 3) {
      throw Exception(
          "Input shape mismatch. Expected [1, 640, 640, 3], got ${inputTensor.shape}");
    }

    // Prepare output buffer
    final outputShape = outputTensor.shape;
    final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
        .reshape(outputShape);

    // Run inference
    _interpreter!.run(input.reshape([1, 640, 640, 3]), output);
    log("Inference completed: $output");

    return output;
  }

  void _handleOutput(List<dynamic> output, int elapsedMs) {
    // Assuming output is a single tensor with shape [1, 84, 8400]
    final predictions = output[0]; // Shape: [84, 8400]

    // Parse the output to extract bounding boxes, class scores, and class indices
    final List<Map<String, dynamic>> detectedObjects = [];

    for (var i = 0; i < 8400; i++) {
      // Extract class scores (last 80 values in each column)
      final classScores =
          predictions.sublist(4, 84).map((score) => score[i]).toList();

      // Find the class with the highest score
      final maxClassIndex = _argMax(classScores);
      final maxClassScore = classScores[maxClassIndex];

      // Filter out low-confidence predictions
      if (maxClassScore > 0.5) {
        // Adjust the threshold as needed
        // Extract bounding box coordinates (first 4 values in each column)
        final bbox =
            predictions.sublist(0, 4).map((coord) => coord[i]).toList();

        detectedObjects.add({
          'bbox': bbox, // [x, y, width, height]
          'classIndex': maxClassIndex,
          'confidence': maxClassScore,
        });
      }
    }

    // Log detected objects
    log("Detected Objects: $detectedObjects");

    // Update UI with the first detected object (or handle multiple objects)
    if (detectedObjects.isNotEmpty) {
      final firstObject = detectedObjects.first;
      final className =
          _labels.isNotEmpty && firstObject['classIndex'] < _labels.length
              ? _labels[firstObject['classIndex']]
              : 'Unknown';

      setState(() {
        _outputText =
            "Detected: $className (${(firstObject['confidence'] * 100).toStringAsFixed(2)}%)";
        _processingTime = "Processing Time: ${elapsedMs}ms";
      });

      _flutterTts.speak("I detect $className");
    } else {
      setState(() {
        _outputText = "No objects detected";
        _processingTime = "Processing Time: ${elapsedMs}ms";
      });

      _flutterTts.speak("No objects detected");
    }
  }

  int _argMax(List<dynamic> list) {
    return list.asMap().entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter?.close();
    _streamTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Image Detection")),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<void>(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return RotatedBox(
                    quarterTurns: -3,
                    child: CameraPreview(_cameraController),
                  );
                }
                return Center(child: Lottie.asset(AppAssets.loding));
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_outputText, style: TextStyle(fontSize: 18)),
                Text(_processingTime),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _isStreaming ? _stopStreaming : _startStreaming,
                      child: Text(
                        _isStreaming ? "Stop Streaming" : "Start Streaming",
                        style:
                            const TextStyle(color: AppColors.primaryBlueColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isProcessing ? null : _processImage,
                      child: Text(
                        _isProcessing ? "Processing..." : "Capture Image",
                        style:
                            const TextStyle(color: AppColors.primaryBlueColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
