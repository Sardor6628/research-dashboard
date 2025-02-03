import 'package:admin/business_logic/question_answer_test/question_answer_test_cubit.dart';
import 'package:admin/models/question_answer_test_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionAndAnswerTestPage extends StatefulWidget {
  @override
  _QuestionAndAnswerTestPageState createState() => _QuestionAndAnswerTestPageState();
}

class _QuestionAndAnswerTestPageState extends State<QuestionAndAnswerTestPage> {
  final TextEditingController _questionController = TextEditingController();
  String user = "Admin"; // Replace with actual user fetching logic

  void _askQuestion() {
    final questionText = _questionController.text.trim();
    if (questionText.isNotEmpty) {
      context.read<QuestionAnswerTestCubit>().askQuestion(user, questionText);
      _questionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _questionController,
            decoration: InputDecoration(
              labelText: "Ask a question...",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: _askQuestion,
              ),
            ),
            onSubmitted: (_) => _askQuestion(), // Sends request when Enter is pressed
          ),
        ),
        Expanded(
          child: BlocBuilder<QuestionAnswerTestCubit, QuestionAnswerTestState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: state is QuestionAnswerTestLoading
                    ? Center(child: CircularProgressIndicator())
                    : state is QuestionAnswerTestLoaded
                    ? _buildResponseUI(state.response)
                    : state is QuestionAnswerTestError
                    ? Center(child: Text(state.message))
                    : Center(child: Text("Ask a question to get started.")),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResponseUI(QuestionAnswerTestModel response) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Question:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(response.question, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Divider(),
            SingleChildScrollView(child: Text("Answer:", style: TextStyle(fontWeight: FontWeight.bold))),
            Text(response.answer, style: TextStyle(fontSize: 16)),
            if (response.isExistOnDb)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Divider(),
                  Text("Existing Question in DB:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(response.questionOnDb, style: TextStyle(fontSize: 16, color: Colors.blue)),
                ],
              ),
            SizedBox(height: 10),
            Text("Source: ${response.answerFrom}", style: TextStyle(fontStyle: FontStyle.italic)),
            Visibility(
                visible: response.isExistOnDb,
                child: Text("Answered by: ${response.answeredBy}", style: TextStyle(fontStyle: FontStyle.italic))),
          ],
        ),
      ),
    );
  }
}