import 'package:shared_preferences/shared_preferences.dart';
import 'package:faveverse/data/api/api_services.dart';
import 'package:faveverse/data/model/user.dart';

class AuthRepository {
  final String _tokenKey = "auth_token";

  final ApiServices apiServices;

  AuthRepository({required this.apiServices});

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 500));
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<bool> login(User user) async {
    try {
      final loginResponse = await apiServices.login(user);
      final token = loginResponse.loginResult.token;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(User user) async {
    try {
      await apiServices.register(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
