import 'package:admin/constants/constant_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Logger logger = Logger();
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  /// **Login Method**
  /// - Sends login request
  /// - Stores user session in secure storage
  Future<UserModel?> login(String email, String password) async {
    try {
      logger.i("Attempting login for: $email");

      // Send login request
      final response = await _dio.post(
        ConstantEndpoints.BASE_URL+ConstantEndpoints.LOGIN,
        options: Options(headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true"

        }),
        data: {"email": email, "password": password},
      );

      logger.d("Login Response: ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == "success") {
        final String userId = response.data["user_id"];
        final String userName = response.data["user_name"];

        logger.i("Login successful, User ID: $userId, Name: $userName");

        // Save user session
        await _storage.write(key: "user_id", value: userId);
        await _storage.write(key: "user_name", value: userName);
        logger.i("User session stored");

        return UserModel(userId: userId, userName: userName);
      } else {
        logger.w("Login failed: ${response.data}");
        return null;
      }
    } catch (e) {
      logger.e("Login request failed: ${e.toString()}");
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  /// **Get Stored User ID**
  /// - Retrieves only the logged-in `user_id`
  Future<String?> getStoredUserId() async {
    try {
      final userId = await _storage.read(key: "user_id");
      if (userId != null) {
        logger.i("Retrieved stored user ID: $userId");
        return userId;
      }
      logger.w("No user ID found in storage");
      return null;
    } catch (e) {
      logger.e("Failed to read stored user ID: ${e.toString()}");
      return null;
    }
  }

  /// **Get Stored User Data**
  /// - Retrieves both `user_id` and `user_name`
  Future<UserModel?> getStoredUser() async {
    try {
      final userId = await getStoredUserId();
      final userName = await _storage.read(key: "user_name");

      if (userId != null && userName != null) {
        logger.i("Retrieved stored user: $userName ($userId)");
        return UserModel(userId: userId, userName: userName);
      }
      logger.w("No user session found");
      return null;
    } catch (e) {
      logger.e("Failed to read stored user: ${e.toString()}");
      return null;
    }
  }

  /// **Logout Method**
  /// - Deletes stored session data
  Future<void> logout() async {
    try {
      await _storage.delete(key: "user_id");
      await _storage.delete(key: "user_name");
      logger.i("User logged out successfully");
    } catch (e) {
      logger.e("Error during logout: ${e.toString()}");
    }
  }
}