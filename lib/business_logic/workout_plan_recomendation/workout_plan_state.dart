part of 'workout_plan_cubit.dart';

@immutable
sealed class WorkoutPlanState {}

final class WorkoutPlanInitial extends WorkoutPlanState {}

final class WorkoutPlanInitLoading extends WorkoutPlanState {}

final class WorkoutPlanLoading extends WorkoutPlanState {}

final class WorkoutPlanLoaded extends WorkoutPlanState {
  final ExerciseData exerciseData;

  WorkoutPlanLoaded(this.exerciseData);

  @override
  List<Object?> get props => [exerciseData];
}

final class WorkoutPlanError extends WorkoutPlanState {
  final String message;

  WorkoutPlanError(this.message);

  @override
  List<Object?> get props => [message];
}