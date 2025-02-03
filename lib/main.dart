import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:admin/business_logic/menu/menu_cubit.dart';
import 'package:admin/business_logic/question_answer/question_answer_cubit.dart';
import 'package:admin/business_logic/question_answer_test/question_answer_test_cubit.dart';
import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/repositories/auth_repository.dart';
import 'package:admin/repositories/question_answer_repository.dart';
import 'package:admin/repositories/question_answer_test_repository.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository())..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        BlocProvider(create: (context) => MenuCubit()),
        BlocProvider(
          create: (context) =>
              QuestionAnswerCubit(QuestionAnswerRepository())..fetchQuestions(),
        ),
        BlocProvider(
          create: (context) =>
              QuestionAnswerTestCubit(QuestionAnswerTestRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Admin Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return MainScreen();
          },
        ),
      ),
    );
  }
}
