import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();

  //get requests
  Future<http.Response> get(String url) async {
    final accessToken = await _tokenStorage.getAccessToken();
    // print("AT: $accessToken");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 401) {
      // print('It\'s expired');
      //access token expired, refresh it
      final isRefreshed = await _authService.refreshAccessToken();
      // print(isRefreshed);
      if (isRefreshed) {
        //make the request again with a new access token
        final newAccessToken = await _tokenStorage.getAccessToken();
        return await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bear $newAccessToken',
          },
        );
      }
    }
    return response;
  }

  //post requests
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final accessToken = await _tokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );
    if (response.statusCode == 401) {
      //refresh the access token
      final isRefreshed = await _authService.refreshAccessToken();
      if (isRefreshed) {
        //make request
        final newAccessToken = _tokenStorage.getAccessToken();
        return await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newAccessToken',
          },
          body: body,
        );
      }
    }
    return response;
  }
}
