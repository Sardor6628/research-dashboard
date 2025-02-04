import 'package:admin/constants/constant_endpoints.dart';
import 'package:dio/dio.dart';
import '../models/question_answer_model.dart';

class QuestionAnswerRepository {
  final Dio _dio = Dio();
  static const String _baseUrl = ConstantEndpoints.BASE_URL +
      ConstantEndpoints
          .QUESTION_ANSWER; // Replace with your actual API base URL

  Future<List<QuestionAnswer>> fetchQuestions(int page, int pageSize) async {
    try {
      final response = await _dio.get("$_baseUrl/",
          queryParameters: {"page": page, "size": pageSize},
          options: Options(headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "ngrok-skip-browser-warning": "true"
          }));
      if (response.statusCode == 200 && response.data["status"] == "success") {
        List<QuestionAnswer> questions =
            (response.data["result"]["items"] as List)
                .map((json) => QuestionAnswer.fromJson(json))
                .toList();
        return questions;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<QuestionAnswer?> createQuestion(
      String question, String answer, String createdBy) async {
    try {
      final response = await _dio.post("$_baseUrl/", data: {
        "question": question,
        "answer": answer,
        "created_by": createdBy
      });

      if (response.statusCode == 200 && response.data["status"] == "success") {
        return QuestionAnswer.fromJson(response.data["result"]);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error creating question: $e");
    }
  }

  Future<QuestionAnswer?> updateQuestion(
      int id, String question, String answer) async {
    try {
      final response = await _dio.put(
        "$_baseUrl/$id",
        data: {"question": question, "answer": answer},
      );

      if (response.statusCode == 200 && response.data["status"] == "success") {
        return QuestionAnswer.fromJson(response.data["result"]);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error updating question: $e");
    }
  }

  Future<bool> deleteQuestion(int id) async {
    final response = await _dio.delete("$_baseUrl/$id");

    return response.statusCode == 200 && response.data["status"] == "success";
    try {
      final response = await _dio.delete("$_baseUrl/$id");

      return response.statusCode == 200 && response.data["status"] == "success";
    } catch (e) {
      throw Exception("Error deleting question: $e");
    }
  }
}
