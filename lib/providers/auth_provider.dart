import 'package:flutter/material.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/client_services.dart';
import 'package:mobile_app/utils/country_helper_code.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final HomeServices _homeServices = HomeServices();
  final CountryCodeHelper _countryhelper = CountryCodeHelper();
  bool _isLoading = false;
  Map<String, dynamic>? _userInfo;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userInfo => _userInfo;

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

  Future<Map<String, dynamic>> register({
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    setLoading(true);
    final result = await _authService.registerUser(
      phoneNumber: phoneNumber,
      password: password,
      username: username,
    );
    setLoading(false);
    return result;
  }

  //Logout
  Future<void> logout() async {
    await _authService.logoutUser();
    notifyListeners();
  }

  //user infos
  Future<void> fetchUserInfo() async {
    setLoading(true);
    final result = await _homeServices.getUserInfos();
    print("THE R: $result");
    setLoading(false);

    if (result.containsKey('data')) {
      _userInfo = result['data'];
    } else {
      _userInfo = null;
    }
    notifyListeners();
  }

  //
  Future<Map<String, String>> getCountryAndCity() async {
    setLoading(true);
    final result = _countryhelper.getCountryCity();
    setLoading(false);
    return result;
  }
}
