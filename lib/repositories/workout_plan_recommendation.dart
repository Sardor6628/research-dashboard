import 'package:admin/constants/constant_endpoints.dart';
import 'package:admin/models/workout_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class WorkoutPlanRecommendationRepository {
  final Dio _dio = Dio();
  final Logger logger = Logger();

  Future<ExerciseData?> getExerciseData(String userId) async {
    try {
      // Send request to get exercise data
      logger.d("${ConstantEndpoints.BASE_URL}${ConstantEndpoints.WORKOUT_PLAN_RECOMMENDATION}");
      final response = await _dio.post(
        "${ConstantEndpoints.BASE_URL}${ConstantEndpoints.WORKOUT_PLAN_RECOMMENDATION}",
        options: Options(headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true"
        }),
        queryParameters: {"user_id_from_ronfic_db": userId},
      );

      logger.d("Exercise Data Response: ${response.data}");

      if (response.statusCode == 200 &&
          response.data["status"] == "success" &&
          response.data['result'] != null) {
        return ExerciseData.fromJson(response.data);
      } else {
        logger.w("Exercise data retrieval failed: ${response.data}");
        return null;
      }
    } catch (e) {
      logger.e("Error fetching exercise data: ${e.toString()}");
      return null;
    }
  }
}