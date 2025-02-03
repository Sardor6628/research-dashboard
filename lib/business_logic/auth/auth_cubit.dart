import 'package:admin/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkLoginStatus() async {
    final userId = await _authRepository.getStoredUserId();
    if (userId != null) {
      emit(AuthLoggedIn(userId: userId));
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        emit(AuthLoggedIn(userId: user.userId, userName: user.userName));
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthLoggedOut());
  }
}