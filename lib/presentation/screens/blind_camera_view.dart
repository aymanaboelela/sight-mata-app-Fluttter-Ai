import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';

late List<CameraDescription> cameras;


class LiveCameraDetectionScreen extends StatefulWidget {
  const LiveCameraDetectionScreen({super.key});

  @override
  State<LiveCameraDetectionScreen> createState() =>
      _LiveCameraDetectionScreenState();
}

class _LiveCameraDetectionScreenState extends State<LiveCameraDetectionScreen> {
  late CameraController _cameraController;
  bool _isCameraReady = false;
  bool _isStreaming = false;
  bool _isWaitingForResponse = false; // ✅ لمنع تداخل الإرسال
  String responseText = '';
  Timer? _timer;
  final FlutterTts tts = FlutterTts();

  final Dio dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
        maxWidth: 90,
      ),
    );

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  void _startStream() async {
    if (!_isStreaming && _cameraController.value.isInitialized) {
      _isStreaming = true;
      await tts.speak("بدأ الكشف"); // ✅ نطق عند بدء الكشف
      _timer = Timer.periodic(const Duration(seconds: 2), (_) => _sendFrame());
      setState(() {
        responseText = '📷 Streaming started...';
      });
    }
  }

  void _stopStream() async {
    _isStreaming = false;
    _timer?.cancel();
    await tts.speak("تم إيقاف الكشف"); // ✅ نطق عند التوقف
    setState(() {
      responseText = '⏹️ Streaming stopped';
    });
  }

  Future<void> _sendFrame() async {
    if (_isWaitingForResponse) return;
    _isWaitingForResponse = true;

    try {
      final image = await _cameraController.takePicture();
      final Uint8List bytes = await image.readAsBytes();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: 'frame.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await dio.post(
        'https://8000-01jys1kz0a85zcfrws14rh0efp.cloudspaces.litng.ai/detect-frame/',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      final detections = (response.data['detections'] as List);

      if (detections.isNotEmpty) {
        final detection = detections.first;
        final message =
            "${detection['class']} is to the ${detection['position']}";
        setState(() {
          responseText = message;
        });
        await tts.speak(message); // ✅ فورًا أول ما ييجي الرد
      } else {
        setState(() {
          responseText = "❌ No clear detection found.";
        });
        await tts.speak("No clear detection found");
      }
    } catch (e) {
      setState(() {
        responseText = "❌ Error sending frame: $e";
      });
    } finally {
      _isWaitingForResponse = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraReady
          ? Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_cameraController),
                ),
                Positioned(
                  bottom: 60,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Text(
                        responseText,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          backgroundColor: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isStreaming ? null : _startStream,
                            icon: const Icon(Icons.play_arrow,
                                size: 30), // تكبير الأيقونة
                            label: const Text(
                              "Start",
                              style: TextStyle(fontSize: 20), // تكبير النص
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              minimumSize:
                                  const Size(140, 60), // حجم الزر الكلي
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _isStreaming ? _stopStream : null,
                            icon: const Icon(Icons.stop,
                                size: 30), // تكبير الأيقونة
                            label: const Text(
                              "Stop",
                              style: TextStyle(fontSize: 20), // تكبير النص
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              minimumSize: const Size(140, 60),
                              backgroundColor:
                                  Colors.red, // لون مميز لزر الإيقاف
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Lottie.asset(
                AppAssets.loding,
                width: 150,
                height: 150,
              ),
            ),
    );
  }
}
