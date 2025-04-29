import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/utils/api_constants.dart';

class AuthService {
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
      return {'success': false, 'message': 'An error occurred: $e'};
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

        return {
          'success': true,
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Invalid credentials'};
      } else {
        return {'success': false, 'message': 'An unknown error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  //logout
  Future<Map<String, dynamic>> logoutUser({
    required String refreshToken,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrlAuth}/logout/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }
      if (response.statusCode == 204) {
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {'success': false, 'message': 'An unknown error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
