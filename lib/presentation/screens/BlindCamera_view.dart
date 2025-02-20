import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';

class VoiceAICommunicationPage extends StatefulWidget {
  @override
  _VoiceAICommunicationPageState createState() =>
      _VoiceAICommunicationPageState();
}

class _VoiceAICommunicationPageState extends State<VoiceAICommunicationPage> {
  late stt.SpeechToText _speech;
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

    // Initialize the camera controller
    _initializeCameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    await _cameraController.initialize();
    setState(() {});
  }

  // Start listening to user's voice
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

  // Stop listening
  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Process the input from the user (send it to AI and get a response)
  void _processUserInput(String userInput) async {
    // هنا يمكنك إرسال النص إلى الـ AI
    String aiResponse =
        "This is a response from AI based on your input: $userInput";

    // بعدها قم بتحويل الرد إلى صوت
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
        child: Center(
          child: Stack(
            children: [
              FutureBuilder<void>(
                future: _initializeCameraFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CameraPreview(_cameraController),
                    );
                  } else {
                    return CircularProgressIndicator();
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
                        child: Text(_isListening
                            ? "Stop Listening"
                            : "Start Listening"),
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
      ),
    );
  }
}
