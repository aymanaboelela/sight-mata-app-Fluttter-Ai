import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
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

  Future<String?> sendImageToApi(Uint8List imageBytes) async {
    try {
      final multipartFile = MultipartFile.fromBytes(
        imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await dio.post(
        'https://8000-01jys1kz0a85zcfrws14rh0efp.cloudspaces.litng.ai/detect-frame/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Success
      return response.data.toString();
    } catch (e) {
      print('❌ API Error: $e');
      return null;
    }
  }
}
