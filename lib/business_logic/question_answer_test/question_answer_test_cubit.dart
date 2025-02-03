import 'package:admin/models/question_answer_test_model.dart';
import 'package:admin/repositories/question_answer_test_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'question_answer_test_state.dart';

class QuestionAnswerTestCubit extends Cubit<QuestionAnswerTestState> {
  final QuestionAnswerTestRepository repository;

  QuestionAnswerTestCubit(this.repository) : super(QuestionAnswerTestInitial());

  Future<void> askQuestion(String user, String question) async {
    try {
      emit(QuestionAnswerTestLoading());
      final response = await repository.askQuestion(user, question);
      if (response != null) {
        emit(QuestionAnswerTestLoaded(response));
      } else {
        emit(QuestionAnswerTestError("Failed to get an answer"));
      }
    } catch (e) {
      emit(QuestionAnswerTestError("Error: $e"));
    }
  }
}