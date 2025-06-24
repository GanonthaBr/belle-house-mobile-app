import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Check if the device has an internet connection
  Future<bool> hasInternetConnection() async {
    try {
      // First check connectivity status
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();

      // If no connectivity, return false
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // Even if connected to wifi/mobile, we need to verify actual internet access
      // Try to lookup a reliable host
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      // If any error occurs, assume no internet
      return false;
    }
  }

  /// Get current connectivity status
  Future<List<ConnectivityResult>> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  /// Listen to connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> isConnectedToWiFi() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  Future<bool> isConnectedToMobile() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }
}
