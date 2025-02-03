import 'package:intl/intl.dart';

class QuestionAnswer {
  final int id;
  final String question;
  final String answer;
  final String createdBy;
  final DateTime createdTime;
  final DateTime updatedTime;
  final bool isDeleted;

  QuestionAnswer({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdBy,
    required this.createdTime,
    required this.updatedTime,
    required this.isDeleted,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      createdBy: json['created_by'],
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
      isDeleted: json['is_deleted'],
    );
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}