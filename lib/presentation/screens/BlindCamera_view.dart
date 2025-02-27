import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAICommunicationPage extends StatefulWidget {
  @override
  _VoiceAICommunicationPageState createState() =>
      _VoiceAICommunicationPageState();
}

class _VoiceAICommunicationPageState extends State<VoiceAICommunicationPage> {
  late SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  late FlutterTts _flutterTts;
  late CameraController _cameraController;
  late Future<void> _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    // قفل الاتجاه إلى الوضع العمودي فقط
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // تعيين اللغة العربية لتحويل النص إلى كلام
    _flutterTts.setLanguage("ar-SA");
    _flutterTts.setSpeechRate(0.5);

    // تهيئة الكاميرا
    _initializeCameraFuture = _initializeCamera();
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
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
        _processUserInput(_text);
      });
    } else {
      print("Speech recognition is not available.");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _processUserInput(String userInput) async {
    String aiResponse =
        "This is a response from AI based on your input: $userInput";

    await _flutterTts.speak(aiResponse);
  }

  @override
  void dispose() {
    _cameraController.dispose();
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
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Lottie.asset(AppAssets.loding));
                }
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(_isListening
                        ? "Listening..."
                        : "Tap to Start Listening"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                      child: Text(
                          _isListening ? "Stop Listening" : "Start Listening"),
                    ),
                    const SizedBox(height: 20),
                    Text("You said: $_text"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
