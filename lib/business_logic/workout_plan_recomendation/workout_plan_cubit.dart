import 'package:admin/repositories/workout_plan_recommendation.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:admin/models/workout_plan_model.dart';
import 'package:admin/repositories/image_analysis_repository.dart';

part 'workout_plan_state.dart';

class WorkoutPlanCubit extends Cubit<WorkoutPlanState> {
  final WorkoutPlanRecommendationRepository _repository;

  WorkoutPlanCubit(this._repository) : super(WorkoutPlanInitial());

  Future<void> fetchWorkoutPlan(String userId) async {
    try {
      emit(WorkoutPlanLoading());

      final ExerciseData? exerciseData = await _repository.getExerciseData(userId);

      if (exerciseData != null) {
        emit(WorkoutPlanLoaded(exerciseData));
      } else {
        emit(WorkoutPlanError("Failed to fetch workout plan data."));
      }
    } catch (e) {
      emit(WorkoutPlanError("An error occurred: ${e.toString()}"));
    }
  }
}