import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
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
  List<String> _labels = [];
  bool _isStreaming = false;
  Timer? _streamTimer;
  late Isolate _isolate;
  late SendPort _sendPort;

  @override
  void initState() {
    super.initState();
    _initializeSystem();
    _initializeCameraFuture = _initializeCamera();
    _startIsolate();
  }

  void _initializeSystem() async {
    _flutterTts = FlutterTts();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await _loadModel();
    await _loadLabels();
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/model/label.txt');
      _labels = labelData.split('\n').map((label) => label.trim()).toList();
      log("Loaded ${_labels.length} labels");
    } catch (e) {
      log("Error loading labels: $e");
      setState(() => _outputText = "Label loading failed: ${e.toString()}");
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
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);
      log("Input Shape: ${inputTensor.shape}, Output Shape: ${outputTensor.shape}");
    } catch (e) {
      log("Error loading model: $e");
      setState(() => _outputText = "Model loading failed: ${e.toString()}");
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
    } catch (e) {
      log("Camera init error: $e");
      setState(() => _outputText = "Camera error: ${e.toString()}");
    }
  }

  void _startIsolate() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
    _sendPort = await receivePort.first;
  }

  static void _isolateEntry(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is List) {
        final imageBytes = message[0] as Uint8List;
        final sendResultPort = message[1] as SendPort;
        try {
          final processedImage = await _preprocessImage(imageBytes);
          sendResultPort.send(processedImage);
        } catch (e) {
          sendResultPort.send(e);
        }
      }
    }
  }

  Future<Float32List> _preprocessImageInIsolate(Uint8List imageBytes) async {
    final receivePort = ReceivePort();
    _sendPort.send([imageBytes, receivePort.sendPort]);
    final result = await receivePort.first;
    if (result is Float32List) {
      return result;
    } else {
      throw result;
    }
  }

  static Future<Float32List> _preprocessImage(List<int> bytes) async {
    try {
      final image = img.decodeImage(Uint8List.fromList(bytes))!;
      final oriented = img.copyRotate(image, angle: 90);
      final resized = img.copyResize(oriented, width: 256, height: 256);

      final inputBuffer = Float32List(256 * 256 * 3);
      int pixelIndex = 0;

      for (var y = 0; y < 256; y++) {
        for (var x = 0; x < 256; x++) {
          final pixel = resized.getPixel(x, y);
          inputBuffer[pixelIndex++] = pixel.r / 255.0;
          inputBuffer[pixelIndex++] = pixel.g / 255.0;
          inputBuffer[pixelIndex++] = pixel.b / 255.0;
        }
      }
      return inputBuffer;
    } catch (e) {
      throw Exception("Image processing failed: ${e.toString()}");
    }
  }

  void _startStreaming() async {
    if (_isStreaming || _interpreter == null) return;
    setState(() => _isStreaming = true);

    while (_isStreaming) {
      try {
        final image = await _cameraController.takePicture();
        final imageBytes = await File(image.path).readAsBytes();
        final processedImage = await _preprocessImageInIsolate(imageBytes);
        final stopwatch = Stopwatch()..start();
        final output = _runInference(processedImage);
        stopwatch.stop();
        _handleOutput(output, stopwatch.elapsedMilliseconds);
        // add custom delay duration in settings screen
        // Add a 1500ms delay after processing (before the next iteration)
        await Future.delayed(const Duration(milliseconds: 1500));
      } catch (e) {
        log("Stream error: ${e.toString()}");
      }
    }
  }

  void _stopStreaming() {
    if (!_isStreaming) return;
    setState(() => _isStreaming = false);
    _streamTimer?.cancel();
  }

  Future<void> _processImage() async {
    if (_isProcessing || _interpreter == null) return;
    setState(() => _isProcessing = true);

    try {
      final imageFile = await _cameraController.takePicture();
      final imageBytes = await File(imageFile.path).readAsBytes();
      final processedImage = await _preprocessImageInIsolate(imageBytes);
      final stopwatch = Stopwatch()..start();
      final output = _runInference(processedImage);
      stopwatch.stop();
      _handleOutput(output, stopwatch.elapsedMilliseconds);
    } catch (e) {
      log("Processing error: ${e.toString()}");
      setState(() => _outputText = "Processing error: ${e.toString()}");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  List<dynamic> _runInference(Float32List input) {
    try {
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);
      _interpreter!.run(input.reshape([1, 256, 256, 3]), output);
      return output;
    } catch (e) {
      throw Exception("Inference failed: ${e.toString()}");
    }
  }

  void _handleOutput(List<dynamic> output, int elapsedMs) {
    try {
      final predictions = output[0] as List<dynamic>;
      final maxIndex = _argMax(predictions);
      final maxConfidence = predictions[maxIndex].toDouble();
      final className = _labels.isNotEmpty && maxIndex < _labels.length
          ? _labels[maxIndex]
          : 'Unknown';
      setState(() {
        _outputText =
            "Detected: $className (${(maxConfidence * 100).toStringAsFixed(2)}%)";
        _processingTime = "Processing Time: ${elapsedMs}ms";
      });
      _flutterTts.speak("I detect $className");
    } catch (e) {
      log("Output handling error: ${e.toString()}");
      setState(() => _outputText = "Output error: ${e.toString()}");
    }
  }

  int _argMax(List<dynamic> list) {
    int maxIndex = 0;
    double maxValue = list[0].toDouble();
    for (int i = 1; i < list.length; i++) {
      final currentValue = list[i].toDouble();
      if (currentValue > maxValue) {
        maxValue = currentValue;
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter?.close();
    _streamTimer?.cancel();
    _flutterTts.stop();
    _isolate.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    quarterTurns: Platform.isAndroid ? 1 : 3,
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
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: Column(
                children: [
                  Text(_outputText,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text(_processingTime,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        label: _isStreaming ? "Stop" : "Stream",
                        onPressed:
                            _isStreaming ? _stopStreaming : _startStreaming,
                        isActive: _isStreaming,
                      ),
                      SizedBox(width: 20),
                      _buildActionButton(
                        label: "Capture",
                        onPressed: _isProcessing ? null : _processImage,
                        isActive: _isProcessing,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
    bool isActive = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.red : AppColors.primaryBlueColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
