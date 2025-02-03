import 'package:admin/constants/constant_endpoints.dart';
import 'package:dio/dio.dart';
import '../models/question_answer_test_model.dart';

class QuestionAnswerTestRepository {
  final Dio _dio = Dio();

  Future<QuestionAnswerTestModel?> askQuestion(String user, String question) async {
    try {
      final response = await _dio.post(
        ConstantEndpoints.BASE_URL+ConstantEndpoints.QUESTION_ANSWER_TEST,
        data: {"user": user, "question": question},
      );

      if (response.statusCode == 200 && response.data["status"] == "success") {
        return QuestionAnswerTestModel.fromJson(response.data["result"]);
      } else {
        throw Exception("Failed to fetch response");
      }
    } catch (e) {
      throw Exception("Error asking question: $e");
    }
  }
}