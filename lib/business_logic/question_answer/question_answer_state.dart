part of 'question_answer_cubit.dart';

abstract class QuestionAnswerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionAnswerInitial extends QuestionAnswerState {}

class QuestionAnswerLoading extends QuestionAnswerState {}

class QuestionAnswerLoaded extends QuestionAnswerState {
  final List<QuestionAnswer> questions;
  final int currentPage;

  QuestionAnswerLoaded(this.questions, this.currentPage);

  @override
  List<Object?> get props => [questions, currentPage];
}

class QuestionAnswerError extends QuestionAnswerState {
  final String message;
  QuestionAnswerError(this.message);

  @override
  List<Object?> get props => [message];
}