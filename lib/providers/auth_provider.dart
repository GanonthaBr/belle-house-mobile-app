import 'package:flutter/material.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/client_services.dart';
import 'package:mobile_app/services/token_storage.dart';
import 'package:mobile_app/utils/country_helper_code.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final HomeServices _homeServices = HomeServices();
  final CountryCodeHelper _countryhelper = CountryCodeHelper();
  final TokenStorage _tokenStorage = TokenStorage();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _countryCity;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userInfo => _userInfo;
  Map<String, dynamic>? get countryCity => _countryCity;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsAuthenticated(bool value) {
    _isAuthenticated = value;
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

  Future<void> checkLogin() async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      setIsAuthenticated(true);
    }
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
    setIsAuthenticated(false);
    notifyListeners();
  }

  //user infos
  Future<void> fetchUserInfo() async {
    setLoading(true);
    final result = await _homeServices.getUserInfos();
    // print("THE result: $result");
    setLoading(false);

    if (result.containsKey('data')) {
      _userInfo = result['data'];
    } else {
      _userInfo = null;
    }
    notifyListeners();
  }

  //
  Future<void> getCountryAndCity() async {
    setLoading(true);
    final response = await _countryhelper.getCountryCity();
    setLoading(false);
    _countryCity = response;
  }
}
