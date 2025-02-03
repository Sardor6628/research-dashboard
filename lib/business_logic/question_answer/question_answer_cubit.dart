import 'package:admin/models/question_answer_model.dart';
import 'package:admin/repositories/question_answer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'question_answer_state.dart';

class QuestionAnswerCubit extends Cubit<QuestionAnswerState> {
  final QuestionAnswerRepository repository;
  int currentPage = 1;
  final int pageSize = 30;

  QuestionAnswerCubit(this.repository) : super(QuestionAnswerInitial());

  Future<void> fetchQuestions() async {
    try {
      emit(QuestionAnswerLoading());
      final questions = await repository.fetchQuestions(currentPage, pageSize);
      emit(QuestionAnswerLoaded(questions, currentPage));
    } catch (e) {
      emit(QuestionAnswerError("Failed to load data"));
    }
  }

  void nextPage() {
    currentPage++;
    fetchQuestions();
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchQuestions();
    }
  }

  Future<void> createQuestion(String question, String answer, String createdBy) async {
    try {
      final newQuestion = await repository.createQuestion(question, answer, createdBy);
      if (newQuestion != null) {
        fetchQuestions(); // Refresh list after adding
      }
    } catch (e) {
      emit(QuestionAnswerError("Failed to create question"));
    }
  }

  Future<void> updateQuestion(int id, String question, String answer) async {
    try {
      final updatedQuestion = await repository.updateQuestion(id, question, answer);
      if (updatedQuestion != null) {
        fetchQuestions(); // Refresh after update
      }
    } catch (e) {
      emit(QuestionAnswerError("Failed to update question"));
    }
  }

  Future<void> deleteQuestion(int id) async {
    try {
      final success = await repository.deleteQuestion(id);
      if (success) {
        fetchQuestions(); // Refresh after delete
      }
    } catch (e) {
      emit(QuestionAnswerError("Failed to delete question"));
    }
  }
}