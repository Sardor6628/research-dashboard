import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:admin/business_logic/menu/menu_cubit.dart';
import 'package:admin/screens/auth/login.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoggedIn) {
            return BlocBuilder<MenuCubit, MenuState>(
              builder: (context, menuState) {
                return Stack(
                  children: [
                    _getPage(menuState.selectedMenu),
                  ],
                );
              },
            );
          } else {
            return Stack(
              children: [
                // Blurred Background
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                ),
                // Login Dialog
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
        return Center(child: Text("Q/A Database Screen", style: TextStyle(fontSize: 24)));
      case "Q/A Chat Test":
        return Center(child: Text("Q/A Chat Test Screen", style: TextStyle(fontSize: 24)));
      case "Image Classification":
        return Center(child: Text("Image Classification Screen", style: TextStyle(fontSize: 24)));
      default:
        return Center(child: Text("Dashboard", style: TextStyle(fontSize: 24)));
    }
  }
}