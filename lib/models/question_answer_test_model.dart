class QuestionAnswerTestModel {
  final String user;
  final String question;
  final bool isExistOnDb;
  final String questionOnDb;
  final String answer;
  final String answerFrom;
  final String answeredBy;

  QuestionAnswerTestModel({
    required this.user,
    required this.question,
    required this.isExistOnDb,
    required this.questionOnDb,
    required this.answer,
    required this.answerFrom,
    required this.answeredBy,
  });

  factory QuestionAnswerTestModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerTestModel(
      user: json['user'],
      question: json['question'],
      isExistOnDb: json['is_exist_on_db'],
      questionOnDb: json['question_on_db'] ?? "",
      answer: json['answer'],
      answerFrom: json['answer_from'],
      answeredBy: json['answer_user'],
    );
  }
}