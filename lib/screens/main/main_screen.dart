import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:admin/business_logic/menu/menu_cubit.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/screens/auth/login.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/image_clasification/image_classification_main_page.dart';
import 'package:admin/screens/q_a_db/q_a_db_page.dart';
import 'package:admin/screens/q_a_test/q_a_test_page.dart';
import 'package:admin/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoggedIn) {
            return SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: SideMenu(),
                    ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Header(userName: authState.userName ?? "User"),
                        ),
                        Expanded(
                          child: BlocBuilder<MenuCubit, MenuState>(
                            builder: (context, menuState) {
                              return _getPage(menuState.selectedMenu);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                ),
                Center(
                  child: LoginDialog(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _getPage(String menu) {
    switch (menu) {
      case "Q/A Database":
        return QuestionAndAnswerDatabasePage();
      case "Q/A Chat Test":
        return QuestionAndAnswerTestPage();
      case "Image Classification":
        return ImageClassificationMainPage();
      default:
        return Container(); // Displays dashboard by default
    }
  }
}
