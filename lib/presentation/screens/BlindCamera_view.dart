import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';

class VoiceAICommunicationPage extends StatefulWidget {
  @override
  _VoiceAICommunicationPageState createState() =>
      _VoiceAICommunicationPageState();
}

class _VoiceAICommunicationPageState extends State<VoiceAICommunicationPage> {
  late FlutterTts _flutterTts;
  late CameraController _cameraController;
  late Future<void> _initializeCameraFuture;
  OrtSession? _session;
  bool _isProcessingFrame = false;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    // قفل الاتجاه إلى الوضع العمودي فقط
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // تهيئة بيئة OnnxRuntime
    OrtEnv.instance.init();

    // تحميل نموذج ONNX
    _loadModel();

    // تهيئة الكاميرا
    _initializeCameraFuture = _initializeCamera();
  }

  Future<void> _loadModel() async {
    try {
      final modelPath = "assets/model/model.onnx";
      final modelData = await rootBundle.load(modelPath);
      final directory = await getTemporaryDirectory();
      final tempFile = File("${directory.path}/model.onnx");
      await tempFile.writeAsBytes(modelData.buffer.asUint8List());

      final sessionOptions = OrtSessionOptions();
      _session = OrtSession.fromBuffer(modelData.buffer.asUint8List(), sessionOptions);
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading ONNX model: $e");
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }

    // بدء بث الفيديو ومعالجة كل Frame
    _cameraController.startImageStream((CameraImage image) {
       imageFormatGroup: ImageFormatGroup.jpeg;
      if (!_isProcessingFrame && _session != null) {
        _isProcessingFrame = true;
        _processCameraFrame(image).then((_) {
          _isProcessingFrame = false;
        });
      }
    });
  }

  Future<void> _processCameraFrame(CameraImage image) async {
    try {
      if (_session == null) {
        print("ONNX model session is not initialized yet.");
        return;
      }
      List<int> inputData = image.planes[0].bytes;
      final shape = [1, inputData.length];
      final inputOrt = OrtValueTensor.createTensorWithDataList(inputData, shape);
      final inputs = {'input': inputOrt};
      final runOptions = OrtRunOptions();
      final outputs = await _session!.runAsync(runOptions, inputs);

      inputOrt.release();
      runOptions.release();
      outputs?.forEach((element) {
        element?.release();
      });

      if (outputs != null && outputs.isNotEmpty) {
        String result = outputs.first.toString();
        print("Model Output: $result");
        await _flutterTts.speak("I detected: $result");
      }
    } catch (e) {
      print("Error processing frame: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    OrtEnv.instance.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: CameraPreview(
                          
                          _cameraController),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Lottie.asset(AppAssets.loding));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
