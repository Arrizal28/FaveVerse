import 'package:flutter/material.dart';
import 'package:faveverse/data/model/user.dart';
import 'package:faveverse/data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    final result = await authRepository.login(user);
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return result;
  }

  Future<bool> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final result = await authRepository.register(user);

    isLoadingRegister = false;
    notifyListeners();

    return result;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    await authRepository.logout();
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }
}
