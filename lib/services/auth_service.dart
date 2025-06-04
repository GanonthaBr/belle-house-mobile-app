import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/token_storage.dart';
import 'package:mobile_app/utils/api_constants.dart';

class AuthService {
  final TokenStorage _tokenStorage = TokenStorage();
  //register
  Future<Map<String, dynamic>> registerUser({
    required String phoneNumber,
    required String password,
    required String username,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrlAuth}/register/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
          'password': password,
          'username': username,
        }),
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        //save tokens
        await _tokenStorage.saveTokens(data['access'], data['refresh']);
        return {
          'success': true,
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message']};
      } else {
        return {'success': false, 'message': 'An unknown error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  //login
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
    required String phoneNumber,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrlAuth}/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'phone_number': phoneNumber,
        }),
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //save tokens
        await _tokenStorage.saveTokens(data['access'], data['refresh']);
        return {
          'success': true,
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Vos informations sont incorrectes',
        };
      } else {
        return {'success': false, 'message': 'An unknown error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  //logout
  Future<void> logoutUser() async {
    await _tokenStorage.clearTokens();
  }

  //refresh access token
  Future<bool> refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    // print("RefreshT: $refreshToken");
    if (refreshToken == null) {
      //no refresh token available
      return false;
    }
    final url = Uri.parse('${ApiConstants.baseUrlAuth}/token/refresh/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );
      // print("SC: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("DATA: $data");
        await _tokenStorage.saveTokens(data['access']);
        // print("It WENT WELL");

        return true;
      } else {
        //refresh token invalid or expired
        await _tokenStorage.clearTokens();
        return false;
      }
    } catch (e) {
      // print('Error refreshing: $e');
      return false;
    }
  }
}
