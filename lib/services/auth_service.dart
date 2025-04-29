import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/utils/api_constants.dart';

class AuthService {
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
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
