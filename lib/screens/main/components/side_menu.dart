import 'package:admin/business_logic/menu/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                "Ronfic Research\nDashboard",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              return Column(
                children: [
                  DrawerListTile(
                    title: "Workout Plan Recommendation",
                    svgSrc: "assets/icons/menu_dashboard.svg",
                    isSelected: state.selectedMenu == "Workout Plan Recommendation",
                    press: () => context.read<MenuCubit>().selectMenu("Workout Plan Recommendation"),
                  ),
                  DrawerListTile(
                    title: "Q/A Database",
                    svgSrc: "assets/icons/menu_dashboard.svg",
                    isSelected: state.selectedMenu == "Q/A Database",
                    press: () => context.read<MenuCubit>().selectMenu("Q/A Database"),
                  ),
                  DrawerListTile(
                    title: "Q/A Chat Test",
                    svgSrc: "assets/icons/menu_tran.svg",
                    isSelected: state.selectedMenu == "Q/A Chat Test",
                    press: () => context.read<MenuCubit>().selectMenu("Q/A Chat Test"),
                  ),
                  DrawerListTile(
                    title: "Image Classification",
                    svgSrc: "assets/icons/menu_store.svg",
                    isSelected: state.selectedMenu == "Image Classification",
                    press: () => context.read<MenuCubit>().selectMenu("Image Classification"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
class DrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(isSelected ? Colors.white : Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}