import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart'; // Your HomeServices

class HouseProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();

  bool _isLoading = false;
  List<dynamic>? _housesInfos;
  Map<String, dynamic>? _houseInfos;
  String? _error;
  DateTime? _lastFetchTime;

  // Getters
  bool get isLoading => _isLoading;
  List<dynamic>? get housesInfos => _housesInfos;
  Map<String, dynamic>? get houseInfos => _houseInfos;
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

  // Fetch house list with automatic retry (built into ApiServices)
  Future<void> getHouseList({bool forceRefresh = false}) async {
    // Skip if data is fresh and not forcing refresh
    if (!forceRefresh &&
        !isDataStale &&
        _housesInfos != null &&
        _housesInfos!.isNotEmpty) {
      // print('Using cached house data');
      return;
    }

    setLoading(true);
    _error = null;

    try {
      print('Fetching house list...');
      final response = await _homeServices.fetchHouses();

      if (response.containsKey('data')) {
        _housesInfos = response['data'];
        print(_houseInfos);
        _lastFetchTime = DateTime.now();
        _error = null;
        print('Successfully fetched ${_housesInfos?.length ?? 0} houses');
      } else if (response.containsKey('error')) {
        _error = response['error'];
        print('Error from service: $_error');
      } else {
        _error = 'Unexpected response format';
        print('Unexpected response: $response');
      }
    } catch (e) {
      _error = 'Network error: $e';
      // print('Exception in getHouseList: $e');
    } finally {
      setLoading(false);
    }
  }

  // Manual refresh method
  Future<void> refreshHouses() async {
    // print('Manually refreshing houses...');
    await getHouseList(forceRefresh: true);
  }

  // Retry last failed operation
  Future<void> retryLastOperation() async {
    if (_error != null) {
      // print('Retrying last failed operation...');
      clearError();
      await refreshHouses();
    }
  }

  // Fetch single house with automatic retry
  Future<void> getHouse(String id) async {
    setLoading(true);
    _error = null;

    try {
      print('Fetching house with ID: $id');
      final response = await _homeServices.getHouse(id);

      if (response.containsKey('data')) {
        _houseInfos = response;
        _error = null;
        print('Successfully fetched house: $id');
      } else if (response.containsKey('error')) {
        _error = response['error'];
        print('Error fetching house: $_error');
      } else {
        _error = 'Unexpected response format';
      }
    } catch (e) {
      _error = 'Network error: $e';
      print('Exception in getHouse: $e');
    } finally {
      setLoading(false);
    }
  }

  // Add new house with retry
  Future<bool> addHouse(Map<String, dynamic> houseData) async {
    setLoading(true);
    _error = null;

    try {
      print('Adding new house...');
      final response = await _homeServices.createHouse(houseData);

      if (response.containsKey('data')) {
        // Add the new house to the local list
        if (_housesInfos != null) {
          _housesInfos!.add(response['data']);
        }
        _error = null;
        setLoading(false);
        print('Successfully added house');
        return true;
      } else if (response.containsKey('error')) {
        _error = response['error'];
        setLoading(false);
        print('Error adding house: $_error');
        return false;
      } else {
        _error = 'Unexpected response format';
        setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      setLoading(false);
      print('Exception in addHouse: $e');
      return false;
    }
  }

  // Update house with retry
  Future<bool> updateHouse(String id, Map<String, dynamic> houseData) async {
    setLoading(true);
    _error = null;

    try {
      print('Updating house with ID: $id');
      final response = await _homeServices.updateHouse(id, houseData);

      if (response.containsKey('data')) {
        // Update the house in the local list
        if (_housesInfos != null) {
          final index = _housesInfos!.indexWhere(
            (house) => house['id'].toString() == id,
          );
          if (index != -1) {
            _housesInfos![index] = response['data'];
          }
        }
        _error = null;
        setLoading(false);
        print('Successfully updated house');
        return true;
      } else if (response.containsKey('error')) {
        _error = response['error'];
        setLoading(false);
        print('Error updating house: $_error');
        return false;
      } else {
        _error = 'Unexpected response format';
        setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      setLoading(false);
      print('Exception in updateHouse: $e');
      return false;
    }
  }

  // Delete house with retry
  Future<bool> deleteHouse(String id) async {
    setLoading(true);
    _error = null;

    try {
      print('Deleting house with ID: $id');
      final response = await _homeServices.deleteHouse(id);

      if (response.containsKey('data') || !response.containsKey('error')) {
        // Remove the house from the local list
        if (_housesInfos != null) {
          _housesInfos!.removeWhere((house) => house['id'].toString() == id);
        }
        _error = null;
        setLoading(false);
        print('Successfully deleted house');
        return true;
      } else if (response.containsKey('error')) {
        _error = response['error'];
        setLoading(false);
        print('Error deleting house: $_error');
        return false;
      } else {
        _error = 'Unexpected response format';
        setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Network error: $e';
      setLoading(false);
      print('Exception in deleteHouse: $e');
      return false;
    }
  }

  // Get houses by type with null safety
  List<dynamic> getHousesByType(String type) {
    if (_housesInfos == null) return [];
    return _housesInfos!
        .where((house) => house['type_of_contract'] == type)
        .toList();
  }

  // Get houses by area with null safety
  List<dynamic> getHousesByArea(String area) {
    if (_housesInfos == null) return [];
    return _housesInfos!
        .where(
          (house) =>
              house['area']?.toLowerCase()?.contains(area.toLowerCase()) ??
              false,
        )
        .toList();
  }

  // Search houses
  List<dynamic> searchHouses(String query) {
    if (_housesInfos == null || query.isEmpty) return _housesInfos ?? [];

    final searchQuery = query.toLowerCase();
    return _housesInfos!.where((house) {
      final name = house['name']?.toLowerCase() ?? '';
      final area = house['area']?.toLowerCase() ?? '';
      final description = house['description']?.toLowerCase() ?? '';

      return name.contains(searchQuery) ||
          area.contains(searchQuery) ||
          description.contains(searchQuery);
    }).toList();
  }

  // Get houses count
  int get housesCount => _housesInfos?.length ?? 0;

  // Get houses for sale
  List<dynamic> get housesForSale => getHousesByType('sale');

  // Get houses for rent
  List<dynamic> get housesForRent => getHousesByType('rent');

  // Batch retry for multiple failed operations
  Future<void> retryAllFailedOperations() async {
    print('Retrying all failed operations...');
    await refreshHouses();
  }

  // Execute operation with custom retry logic
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    try {
      print('Executing $operationName...');
      return await operation();
    } catch (e) {
      print('$operationName failed, using service retry: $e');
      // The retry is already handled in ApiServices, so we just rethrow
      rethrow;
    }
  }
}
