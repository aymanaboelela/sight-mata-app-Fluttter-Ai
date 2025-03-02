import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart'; // استيراد مكتبة TFLite
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // مكتبة لتحويل الصور
import 'dart:core'; // لاستخدام Stopwatch

class VoiceAICommunicationPage extends StatefulWidget {
  @override
  _VoiceAICommunicationPageState createState() =>
      _VoiceAICommunicationPageState();
}

class _VoiceAICommunicationPageState extends State<VoiceAICommunicationPage> {
  late FlutterTts _flutterTts;
  late CameraController _cameraController;
  late Future<void> _initializeCameraFuture;
  Interpreter? _interpreter; // الجلسة الخاصة بـ TFLite
  bool _isProcessingFrame = false;
  String _processingTime =
      "Processing Time: 0.0 ms"; // لتخزين وعرض وقت المعالجة
  String _outputText = "Waiting for output..."; // لعرض النص الناتج من النموذج

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    // قفل الاتجاه إلى الوضع العمودي فقط (بورتريت)
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // تحميل نموذج TFLite
    _loadModel();

    // تهيئة الكاميرا
    _initializeCameraFuture = _initializeCamera();
  }

  // تحميل نموذج TFLite
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/model/model_- 21 february 2025 15_42.tflite'); // تحديد المسار للنموذج
      log("Model loaded successfully.");
    } catch (e) {
      log("Error loading TFLite model: $e");
    }
  }

  // تهيئة الكاميرا
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

  // التقاط صورة ثابتة وإرسالها إلى النموذج
  Future<void> _takePictureAndSendToModel() async {
    try {
      // التقاط صورة ثابتة
      XFile imageFile = await _cameraController.takePicture();

      debugPrint("Image captured: ${imageFile.path}");

      // تحميل الصورة وتحويلها إلى بيانات بايت
      File image = File(imageFile.path);
      List<int> imageBytes = await image.readAsBytes();

      debugPrint("Image size: ${imageBytes.length} bytes");

      // إرسال الصورة للنموذج
      await _sendToModel(imageBytes);
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
  }

  // إرسال الصورة إلى نموذج TFLite
  Future<void> _sendToModel(List<int> imageBytes) async {
    try {
      // بدء قياس وقت المعالجة
      final stopwatch = Stopwatch()..start();

      debugPrint(
          "Input Data (first 100 bytes): ${imageBytes.sublist(0, 100)}...");
      debugPrint("Input data length: ${imageBytes.length} bytes");

      // التأكد من أن البيانات ليست فارغة
      if (imageBytes.isEmpty) {
        debugPrint("Input data is empty!");
        return;
      }

      // تحويل الصورة من YUV إلى RGB باستخدام المكتبة
      final img.Image? convertedImage = img.decodeImage(
          Uint8List.fromList(imageBytes)); // تحويل الصورة من YUV إلى RGB

      if (convertedImage == null) {
        debugPrint("Error: Failed to decode image.");
        return;
      }

      // تغيير حجم الصورة إلى الحجم المتوقع للنموذج (مثل 224x224)
      final resizedImage = img.copyResize(convertedImage,
          width: 224, height: 224); // تعديل الحجم

      debugPrint(
          "Converted and resized image: ${resizedImage.width}x${resizedImage.height}");

      // تخصيص المخرجات
      var output = List.filled(1,
          List.filled(10, 0)); // تخصيص حجم المخرجات بناءً على احتياجات النموذج

      // إرسال البيانات إلى النموذج
      _interpreter?.run(resizedImage.getBytes(), output);

      // التحقق من النتيجة
      String result = output.toString();
      debugPrint("Model Output: $result");

      setState(() {
        _outputText = result; // تخزين النص الناتج من النموذج
      });

      // التحدث بالنتيجة
      await _flutterTts.speak("I detected: $result");

      stopwatch.stop();
      setState(() {
        _processingTime =
            "Processing Time: ${stopwatch.elapsedMilliseconds} ms"; // تحديث وقت المعالجة
      });
    } catch (e) {
      debugPrint("Error processing image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter?.close(); // إغلاق الجلسة بعد الانتهاء
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Image Detection")),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // عرض الكاميرا في وضع بورتريت وتغطية كامل الشاشة
                Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context)
                        .size
                        .height, // ملء الشاشة بالكامل
                    child: CameraPreview(_cameraController),
                  ),
                ),
                // زر لالتقاط الصورة أسفل الكاميرا
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _takePictureAndSendToModel,
                      child: Text("Capture Image"),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Lottie.asset(AppAssets.loding));
          }
        },
      ),
    );
  }
}
