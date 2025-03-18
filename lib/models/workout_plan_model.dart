import 'dart:convert';

class ExerciseData {
  final String status;
  final Map<String, MuscleGroup> result;
  final List<Exercise> allSortedExercises;
  final List<WorkoutPlan> top5;

  ExerciseData({
    required this.status,
    required this.result,
    required this.allSortedExercises,
    required this.top5,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    try {
      Map<String, dynamic> resultData = json['result'] ?? {};

      Map<String, MuscleGroup> parsedResult = {};
      resultData.forEach((key, value) {
        if (key != 'all_sorted_exercises' && key != 'top_5' && value is Map<String, dynamic>) {
          parsedResult[key] = MuscleGroup.fromJson(value);
        }
      });

      return ExerciseData(
        status: json['status'] ?? 'unknown',
        result: parsedResult,
        allSortedExercises: (resultData['all_sorted_exercises'] as List?)
            ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
        top5: (resultData['top_5'] as List?)
            ?.map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
      );
    } catch (e) {
      throw Exception("Error parsing ExerciseData: ${e.toString()}");
    }
  }
}

class MuscleGroup {
  final String searchValues;
  final int difference;
  final String weakSide;
  final List<Exercise> similarExercises;
  final String typeCode;

  MuscleGroup({
    required this.searchValues,
    required this.difference,
    required this.weakSide,
    required this.similarExercises,
    required this.typeCode,
  });

  factory MuscleGroup.fromJson(Map<String, dynamic> json) {
    try {
      return MuscleGroup(
        searchValues: json['search_values'] ?? '',
        difference: json['difference'] ?? 0,
        weakSide: json['weak_side'] ?? '',
        similarExercises: (json['similar_exercises'] as List?)
            ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
        typeCode: json['type_code'] ?? '',
      );
    } catch (e) {
      throw Exception("Error parsing MuscleGroup: ${e.toString()}");
    }
  }
}

class Exercise {
  final int id;
  final String name;
  final int similarityPercentage;
  final double weightedScore;
  final String typeCode;

  Exercise({
    required this.id,
    required this.name,
    required this.similarityPercentage,
    required this.weightedScore,
    required this.typeCode,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    try {
      return Exercise(
        id: json['id'] ?? 0,
        name: json['name'] ?? 'Unknown Exercise',
        similarityPercentage: json['similarity_percentage'] ?? 0,
        weightedScore: (json['weighted_score'] is num)
            ? (json['weighted_score'] as num).toDouble()
            : 0.0,
        typeCode: json['type_code'] ?? '',
      );
    } catch (e) {
      throw Exception("Error parsing Exercise: ${e.toString()}");
    }
  }
}

class WorkoutPlan {
  final String workoutName;
  final int matchingCount;

  WorkoutPlan({
    required this.workoutName,
    required this.matchingCount,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      workoutName: json['workout_name'] ?? 'Unknown Plan',
      matchingCount: json['matching_count'] ?? 0,
    );
  }
}