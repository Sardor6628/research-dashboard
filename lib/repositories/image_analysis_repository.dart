import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:admin/constants/constant_endpoints.dart';
import 'package:dio/dio.dart';
import '../models/image_analysis_model.dart';

class ImageAnalysisRepository {
  final Dio _dio = Dio();

  Future<ImageAnalysisResult?> analyzeImage(html.File imageFile) async {
    try {
      final reader = html.FileReader();
      final completer = Completer<Uint8List>();

      reader.onLoadEnd.listen((event) {
        completer.complete(reader.result as Uint8List);
      });

      reader.readAsArrayBuffer(imageFile);
      Uint8List fileBytes = await completer.future;

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileBytes, filename: imageFile.name),
      });

      final response = await _dio.post(
          ConstantEndpoints.BASE_URL + ConstantEndpoints.IMAGE_CLASSIFICATION,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "ngrok-skip-browser-warning": "true"
          }));

      if (response.statusCode == 200 && response.data.containsKey("angles")) {
        return ImageAnalysisResult.fromJson(response.data);
      } else {
        throw Exception("Failed to analyze image");
      }
    } catch (e) {
      throw Exception("Error analyzing image: $e");
    }
  }
}
