import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class ProductsProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isLoading = false;
  List<dynamic>? _productsInfos;
  String? _error;
  DateTime? _lastFetchTime;

  // Getters
  bool get isLoading => _isLoading;
  List<dynamic>? get productsInfos => _productsInfos;
  String? get error => _error;
  DateTime? get lastFetchTime => _lastFetchTime;

  // Check if data is stale (older than 5 minutes)
  bool get isDataStale {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!).inMinutes > 5;
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

  // Fetch products list with automatic retry (built into ApiServices)
  Future<void> getProductsList({bool forceRefresh = false}) async {
    // Skip if data is fresh and not forcing refresh
    if (!forceRefresh &&
        !isDataStale &&
        _productsInfos != null &&
        _productsInfos!.isNotEmpty) {
      // print('Using cached house data');
      return;
    }

    setLoading(true);
    _error = null;

    try {
      final response = await _homeServices.fetchProduct();

      if (response.containsKey('data')) {
        _productsInfos = response['data'];

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
  Future<void> refreshProducts() async {
    // print('Manually refreshing houses...');
    await getProductsList(forceRefresh: true);
  }

  // Retry last failed operation
  Future<void> retryLastOperation() async {
    if (_error != null) {
      // print('Retrying last failed operation...');
      clearError();
      await refreshProducts();
    }
  }
}
