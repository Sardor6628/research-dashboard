import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuState(selectedMenu: "Workout Plan Recommendation"));

  void selectMenu(String menuName) {
    emit(MenuState(selectedMenu: menuName));
  }
}