import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiServices {
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Generic retry wrapper for API calls
  Future<T> _executeWithRetry<T>(
    Future<T> Function() apiCall, {
    int maxRetries = ApiServices.maxRetries,
    Duration delay = ApiServices.retryDelay,
    bool Function(Exception)? shouldRetry,
  }) async {
    int attemptCount = 0;
    Exception? lastException;

    while (attemptCount < maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attemptCount++;

        // print('API call failed (attempt $attemptCount/$maxRetries): $e');

        // Check if we should retry this type of error
        if (shouldRetry != null && !shouldRetry(lastException)) {
          throw lastException;
        }

        // Don't retry on last attempt
        if (attemptCount >= maxRetries) {
          throw lastException;
        }

        // Wait before retry with exponential backoff
        await Future.delayed(delay * attemptCount);
        // print(
        //   'Retrying API call in ${delay.inSeconds * attemptCount} seconds...',
        // );
      }
    }

    throw lastException ?? Exception('Unknown error during retry');
  }

  // Determine if an error should trigger a retry
  bool _shouldRetryError(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    // Retry network errors, timeouts, and server errors
    return errorMessage.contains('network') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('socket') ||
        errorMessage.contains('handshake') ||
        error is SocketException ||
        error is HttpException;
  }

  // Enhanced GET requests with retry
  Future<http.Response> get(String url) async {
    return await _executeWithRetry(
      () async => _performGet(url),
      shouldRetry: _shouldRetryError,
    );
  }

  // Internal GET method
  Future<http.Response> _performGet(String url) async {
    final accessToken = await _tokenStorage.getAccessToken();

    final response = await http
        .get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(const Duration(seconds: 30)); // Add timeout

    // Handle token refresh for 401 errors
    if (response.statusCode == 401) {
      // print('Access token expired, refreshing...');
      final isRefreshed = await _authService.refreshAccessToken();

      if (isRefreshed) {
        final newAccessToken = await _tokenStorage.getAccessToken();
        return await http
            .get(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'Bearer $newAccessToken', // Fixed typo: was "Bear"
              },
            )
            .timeout(const Duration(seconds: 30));
      } else {
        throw Exception('Failed to refresh access token');
      }
    }

    // Check for server errors that should trigger retry
    if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return response;
  }

  // Enhanced POST requests with retry
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return await _executeWithRetry(
      () async => _performPost(url, body),
      shouldRetry: (error) {
        // Don't retry validation errors (400, 422), but retry network/server errors
        final errorMsg = error.toString();
        return !errorMsg.contains('400') &&
            !errorMsg.contains('422') &&
            _shouldRetryError(error);
      },
    );
  }

  // Internal POST method
  Future<http.Response> _performPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();

    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body), // Ensure proper JSON encoding
        )
        .timeout(const Duration(seconds: 45)); // Longer timeout for POST

    // Handle token refresh for 401 errors
    if (response.statusCode == 401) {
      // print('Access token expired, refreshing...');
      final isRefreshed = await _authService.refreshAccessToken();

      if (isRefreshed) {
        final newAccessToken = await _tokenStorage.getAccessToken();
        return await http
            .post(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newAccessToken',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 45));
      } else {
        throw Exception('Failed to refresh access token');
      }
    }

    // Check for server errors that should trigger retry
    if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return response;
  }

  // PUT method with retry
  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    return await _executeWithRetry(
      () async => _performPut(url, body),
      shouldRetry: (error) {
        final errorMsg = error.toString();
        return !errorMsg.contains('400') &&
            !errorMsg.contains('422') &&
            _shouldRetryError(error);
      },
    );
  }

  Future<http.Response> _performPut(
    String url,
    Map<String, dynamic> body,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();

    final response = await http
        .put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 45));

    if (response.statusCode == 401) {
      final isRefreshed = await _authService.refreshAccessToken();
      if (isRefreshed) {
        final newAccessToken = await _tokenStorage.getAccessToken();
        return await http
            .put(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newAccessToken',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 45));
      } else {
        throw Exception('Failed to refresh access token');
      }
    }

    if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return response;
  }

  // DELETE method with retry
  Future<http.Response> delete(String url, Map<String, dynamic>? body) async {
    print("URL: $url");
    return await _executeWithRetry(
      () async => _performDelete(url, body),
      shouldRetry: _shouldRetryError,
    );
  }

  Future<http.Response> _performDelete(
    String url,
    Map<String, dynamic>? body,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();

    final response = await http
        .delete(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 401) {
      final isRefreshed = await _authService.refreshAccessToken();
      if (isRefreshed) {
        final newAccessToken = await _tokenStorage.getAccessToken();
        return await http
            .delete(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newAccessToken',
              },
            )
            .timeout(const Duration(seconds: 30));
      } else {
        throw Exception('Failed to refresh access token');
      }
    }

    if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    }

    return response;
  }

  // Manual retry method for specific operations
  Future<http.Response> retryRequest(
    Future<http.Response> Function() request, {
    int maxRetries = 3,
  }) async {
    return await _executeWithRetry(
      request,
      maxRetries: maxRetries,
      shouldRetry: _shouldRetryError,
    );
  }
}
