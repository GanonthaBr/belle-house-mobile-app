import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class LandsProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isLoading = false;
  List<dynamic>? _landsInfos;
  String? _error;
  DateTime? _lastFetchTime;
  Timer? _autoRefreshTimer;

  // Getters
  bool get isLoading => _isLoading;
  List<dynamic>? get landsInfos => _landsInfos;
  String? get error => _error;
  DateTime? get lastFetchTime => _lastFetchTime;

  void startAutoRefresh({Duration interval = const Duration(minutes: 5)}) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(interval, (timer) {
      refreshLands();
    });
  }

  // Call this to stop auto-refresh (e.g., on dispose)
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }

  // Check if data is stale (older than 5 minutes)
  bool get isDataStale {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!).inMinutes > 1;
  }

  // Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Fetch lands list with automatic retry (built into ApiServices)
  Future<void> getLandsList({bool forceRefresh = false}) async {
    // Skip if data is fresh and not forcing refresh
    if (!forceRefresh &&
        !isDataStale &&
        _landsInfos != null &&
        _landsInfos!.isNotEmpty) {
      // print('Using cached house data');
      return;
    }

    setLoading(true);
    _error = null;

    try {
      final response = await _homeServices.fetchParcelles();
      if (response.containsKey('data')) {
        _landsInfos = response['data'];

        _lastFetchTime = DateTime.now();
        _error = null;
      } else if (response.containsKey('error')) {
        _error = response['error'];
      } else {
        _error = 'Unexpected response format';
      }
    } catch (e) {
      _error = 'Network error: $e';
      // print('Exception in getHouseList: $e');
    } finally {
      setLoading(false);
    }
  }

  // Manual refresh method
  Future<void> refreshLands() async {
    // print('Manually refreshing houses...');
    await getLandsList(forceRefresh: true);
  }

  // Retry last failed operation
  Future<void> retryLastOperation() async {
    if (_error != null) {
      // print('Retrying last failed operation...');
      clearError();
      await refreshLands();
    }
  }
}
