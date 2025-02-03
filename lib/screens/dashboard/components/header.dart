import 'package:admin/business_logic/auth/auth_cubit.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/constants.dart';

class Header extends StatelessWidget {
  final String userName;
  const Header({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(child: Container()),
        ProfileCard(userName: userName)
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String userName;
  const ProfileCard({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          context.read<AuthCubit>().logout(); // Logout Action
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(left: defaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(userName),
              ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}