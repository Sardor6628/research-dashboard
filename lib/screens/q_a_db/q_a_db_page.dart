import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:admin/business_logic/question_answer/question_answer_cubit.dart';
import 'package:admin/models/question_answer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionAndAnswerDatabasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question & Answer Database",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ElevatedButton.icon(
                onPressed: () => _showQuestionDialog(context),
                icon: Icon(Icons.add),
                label: Text("Add Question"),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<QuestionAnswerCubit, QuestionAnswerState>(
            builder: (context, state) {
              if (state is QuestionAnswerLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is QuestionAnswerLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.questions.length,
                        itemBuilder: (context, index) {
                          final question = state.questions[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(question.question),
                              subtitle: Text(question.answer),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showQuestionDialog(
                                        context,
                                        question: question),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _confirmDelete(context, question.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: state.currentPage > 1
                                ? () => context
                                    .read<QuestionAnswerCubit>()
                                    .previousPage()
                                : null,
                            child: Text("Previous"),
                          ),
                          SizedBox(width: 10),
                          Text("Page ${state.currentPage}"),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<QuestionAnswerCubit>().nextPage(),
                            child: Text("Next"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text("Failed to load questions"));
              }
            },
          ),
        ),
      ],
    );
  }

  void _showQuestionDialog(BuildContext context, {QuestionAnswer? question}) {
    final TextEditingController questionController =
        TextEditingController(text: question?.question ?? '');
    final TextEditingController answerController =
        TextEditingController(text: question?.answer ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question == null ? "Add Question" : "Edit Question"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: "Question"),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              String? userName =
                  state is AuthLoggedIn ? state.userName : "Admin";
              return ElevatedButton(
                onPressed: () {
                  if (question == null) {
                    context.read<QuestionAnswerCubit>().createQuestion(
                          questionController.text,
                          answerController.text,
                          userName ?? "", // Replace with actual user
                        );
                  } else {
                    context.read<QuestionAnswerCubit>().updateQuestion(
                          question.id,
                          questionController.text,
                          answerController.text,
                        );
                  }
                  Navigator.pop(context);
                },
                child: Text(question == null ? "Add" : "Update"),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Question"),
        content: Text("Are you sure you want to delete this question?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QuestionAnswerCubit>().deleteQuestion(id);
              Navigator.pop(context);
            },
            child: Text("Delete"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
