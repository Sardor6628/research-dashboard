part of 'question_answer_test_cubit.dart';

abstract class QuestionAnswerTestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionAnswerTestInitial extends QuestionAnswerTestState {}

class QuestionAnswerTestLoading extends QuestionAnswerTestState {}

class QuestionAnswerTestLoaded extends QuestionAnswerTestState {
  final QuestionAnswerTestModel response;
  QuestionAnswerTestLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class QuestionAnswerTestError extends QuestionAnswerTestState {
  final String message;
  QuestionAnswerTestError(this.message);

  @override
  List<Object?> get props => [message];
}