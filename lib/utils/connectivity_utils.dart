import 'package:mobile_app/services/connectivity_service.dart';

class ConnectivityUtils {
  static final ConnectivityService _connectivityService = ConnectivityService();

  /// Check internet connectivity and show user-friendly message
  static Future<bool> checkConnectivityWithMessage() async {
    final hasConnection = await _connectivityService.hasInternetConnection();

    if (!hasConnection) {
      // You can integrate this with your preferred way of showing messages
      // For example: ScaffoldMessenger, Fluttertoast, custom dialogs, etc.
      print('No internet connection. Please check your network and try again.');
    }

    return hasConnection;
  }

  /// Get connectivity status for UI display
  static Future<String> getConnectivityStatus() async {
    final connectivityResults =
        await _connectivityService.getConnectivityStatus();

    if (connectivityResults.isEmpty) {
      return 'No connection';
    }

    final connectionTypes = connectivityResults
        .map((result) {
          switch (result.name) {
            case 'wifi':
              return 'WiFi';
            case 'mobile':
              return 'Mobile Data';
            case 'ethernet':
              return 'Ethernet';
            case 'bluetooth':
              return 'Bluetooth';
            case 'vpn':
              return 'VPN';
            default:
              return 'Connected';
          }
        })
        .join(', ');

    // Verify actual internet access
    final hasInternet = await _connectivityService.hasInternetConnection();
    return hasInternet ? connectionTypes : 'Connected (No Internet)';
  }

  /// Listen to connectivity changes (useful for real-time UI updates)
  static Stream<String> watchConnectivityStatus() async* {
    await for (final connectivityResults
        in _connectivityService.onConnectivityChanged) {
      if (connectivityResults.isEmpty) {
        yield 'No connection';
      } else {
        final hasInternet = await _connectivityService.hasInternetConnection();
        if (hasInternet) {
          yield 'Connected';
        } else {
          yield 'Connected (No Internet)';
        }
      }
    }
  }
}
