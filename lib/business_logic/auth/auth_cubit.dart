import 'package:admin/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final Logger logger = Logger();

  AuthCubit(this._authRepository) : super(AuthInitial());

  /// **Check Login Status**
  /// - Checks if a user is logged in by retrieving the `user_id`
  Future<void> checkLoginStatus() async {
    try {
      final userId = await _authRepository.getStoredUserId();
      if (userId != null) {
        final user = await _authRepository.getStoredUser();
        emit(AuthLoggedIn(userId: user!.userId, userName: user.userName));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      logger.e("Error checking login status: $e");
      emit(AuthError("Error checking login status"));
    }
  }

  /// **Login User**
  /// - Calls the API via `AuthRepository`
  /// - Stores session if successful
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        logger.i("User logged in: ${user.userId}");
        Fluttertoast.showToast(
          msg: "User logged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        emit(AuthLoggedIn(userId: user.userId, userName: user.userName));
      } else {
        Fluttertoast.showToast(
          msg: "Invalid credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        logger.w("Invalid credentials entered");
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      logger.e("Login failed: $e");
      emit(AuthError(e.toString()));
    }
  }

  /// **Get Stored User ID**
  /// - Fetches stored `user_id` via `AuthRepository`
  Future<String?> getStoredUserId() async {
    try {
      final userId = await _authRepository.getStoredUserId();
      if (userId != null) {
        logger.i("Retrieved stored user ID: $userId");
      } else {
        logger.w("No user ID found in storage");
      }
      return userId;
    } catch (e) {
      logger.e("Failed to read stored user ID: $e");
      return null;
    }
  }

  /// **Logout User**
  /// - Clears stored session & emits `AuthLoggedOut`
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      logger.i("User logged out successfully");
      emit(AuthLoggedOut());
    } catch (e) {
      logger.e("Logout failed: $e");
      emit(AuthError("Logout failed"));
    }
  }
}
