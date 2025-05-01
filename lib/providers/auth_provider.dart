import 'package:flutter/material.dart';
import 'package:mobile_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    setLoading(true);
    //log user in
    final result = await _authService.loginUser(
      username: username,
      password: password,
      phoneNumber: phoneNumber,
    );

    setLoading(false);

    return result;
  }

  //Logout
  Future<void> logout() async {
    await _authService.logoutUser();
    notifyListeners();
  }
}
