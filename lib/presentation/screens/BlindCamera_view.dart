import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
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
  List<String> _labels = [];
  bool _isStreaming = false;
  Timer? _streamTimer;

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

  void _startStreaming() {
    if (_isStreaming || _interpreter == null) return;
    setState(() => _isStreaming = true);
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
        log("Stream error: ${e.toString()}");
      }
    });
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
      final processedImage = await _preprocessImage(imageBytes);
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

  Future<Float32List> _preprocessImage(List<int> bytes) async {
    try {
      final image = img.decodeImage(Uint8List.fromList(bytes))!;
      final oriented = img.copyRotate(image, angle: 90);
      final resized = img.copyResize(oriented, width: 256, height: 256);

      final inputBuffer = Float32List(256 * 256 * 3);
      int pixelIndex = 0;

      for (var y = 0; y < 256; y++) {
        for (var x = 0; x < 256; x++) {
          final pixel = resized.getPixel(x, y);
          inputBuffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
          inputBuffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
          inputBuffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
        }
      }
      return inputBuffer;
    } catch (e) {
      throw Exception("Image processing failed: ${e.toString()}");
    }
  }

  List<double> _runInference(Float32List input) {
    try {
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      final output = List<double>.filled(outputShape.reduce((a, b) => a * b), 0.0);
      _interpreter!.run(input, output);
      return output;
    } catch (e) {
      throw Exception("Inference failed: ${e.toString()}");
    }
  }

  List<double> _softmax(List<double> logits) {
    final double maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final double sum = logits
        .map((l) => math.exp(l - maxLogit))
        .fold(0.0, (a, b) => a + b);
    return logits.map((l) => math.exp(l - maxLogit) / sum).toList();
  }

  void _handleOutput(List<double> output, int elapsedMs) {
    try {
      final probabilities = _softmax(output);
      final maxProbability = probabilities.reduce(math.max);
      final maxClassIndex = probabilities.indexOf(maxProbability);

      if (maxProbability > 0.5 && maxClassIndex < _labels.length) {
        final className = _labels[maxClassIndex];
        setState(() {
          _outputText = "Detected: $className (${(maxProbability * 100).toStringAsFixed(2)}%)";
          _processingTime = "Processing Time: ${elapsedMs}ms";
        });
        _flutterTts.speak("I detect $className");
      } else {
        setState(() {
          _outputText = "No confident detection (${(maxProbability * 100).toStringAsFixed(2)}%)";
          _processingTime = "Processing Time: ${elapsedMs}ms";
        });
      }
    } catch (e) {
      log("Output handling error: ${e.toString()}");
      setState(() => _outputText = "Output error: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter?.close();
    _streamTimer?.cancel();
    _flutterTts.stop();
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
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text(_processingTime, 
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        label: _isStreaming ? "Stop" : "Stream",
                        onPressed: _isStreaming ? _stopStreaming : _startStreaming,
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