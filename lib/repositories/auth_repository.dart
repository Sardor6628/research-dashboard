import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _loginUrl = "https://api.ronficzone.com/user/renfit/sign-in";
  static const String _profileUrl = "https://api.ronficzone.com/user/ronficlab/get/profile/detail";
  static const String _csrfToken = "MrcDEiz859Mx44y3wdeMkKkUDntoNL754n0OotgXuJ0oUH5Z2PRR4zi4iJa0NOSD";

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        _loginUrl,
        options: Options(headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRFToken": _csrfToken,
        }),
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data["status"] == "success") {
        final userId = response.data["result"]["user_id"];
        if (userId != null) {
          final profileResponse = await _dio.post(
            _profileUrl,
            options: Options(headers: {
              "accept": "application/json",
              "Content-Type": "application/json",
              "X-CSRFToken": _csrfToken,
            }),
            data: {"user_id": userId},
          );

          final profileData = profileResponse.data;
          final userName = profileData["result"]?["name"] ?? "Unknown User";

          // Save user session
          await _storage.write(key: "user_id", value: userId);

          return UserModel(userId: userId, userName: userName);
        }
      }
      return null;
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<String?> getStoredUserId() async {
    return await _storage.read(key: "user_id");
  }

  Future<void> logout() async {
    await _storage.delete(key: "user_id");
  }
}