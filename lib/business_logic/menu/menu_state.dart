part of 'menu_cubit.dart';

class MenuState extends Equatable {
  final String selectedMenu;

  const MenuState({required this.selectedMenu});

  @override
  List<Object> get props => [selectedMenu];
}