// providers/favorite_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/services/client_services.dart';

class FavoritesProvider with ChangeNotifier {
  final HomeServices _apiService = HomeServices();

  // Track loading states
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Map<String, dynamic>? _favoritesInfos;

  // Store favorites locally (optional, for caching)
  final Set<String> _favoriteItems = <String>{};

  // Track individual item loading states
  final Set<String> _loadingItems = <String>{};

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Set<String> get favoriteItems => _favoriteItems;
  Map<String, dynamic>? get favoritesInfos => _favoritesInfos;

  // Check if item is favorited
  bool isFavorited(int contentTypeId, int objectId) {
    // print('checking...');
    // print(_favoriteItems);
    return _favoriteItems.contains('${contentTypeId}_$objectId');
  }

  // Check if specific item is loading
  bool isItemLoading(int contentTypeId, int objectId) {
    return _loadingItems.contains('${contentTypeId}_$objectId');
  }

  // Add to favorites
  Future<bool> addFavorite({
    required int contentTypeId,
    required int objectId,
    String? itemName,
  }) async {
    final itemKey = '${contentTypeId}_$objectId';

    _setItemLoading(itemKey, true);
    _clearMessages();

    try {
      final result = await _apiService.addFavorite(
        contentTypeId: contentTypeId,
        objectId: objectId,
      );

      if (result['data'] != null) {
        // Add to local cache
        _favoriteItems.add(itemKey);
        _setSuccessMessage(result['message'] ?? 'Added to favorites');
        notifyListeners();
        return true;
      } else {
        _setError(result['message'] ?? 'Failed to add to favorites');
        return false;
      }
    } on SocketException {
      _setError('No internet connection. Please check your network.');
      return false;
    } on TimeoutException {
      _setError('Request timeout. Please try again.');
      return false;
    } catch (e) {
      // Handle different types of errors
      String errorMessage = 'Failed to add to favorites';

      if (e.toString().contains('Server error')) {
        errorMessage =
            'Server temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('Failed to refresh access token')) {
        errorMessage = 'Session expired. Please log in again.';
        // You might want to trigger logout here
      } else {
        errorMessage =
            'Failed to add to favorites: ${_extractErrorMessage(e.toString())}';
      }

      _setError(errorMessage);
      return false;
    } finally {
      _setItemLoading(itemKey, false);
    }
  }

  // Remove from favorites
  Future<bool> removeFavorite({
    required int contentTypeId,
    required int objectId,
  }) async {
    final itemKey = '${contentTypeId}_$objectId';
    late final String modelName;

    _setItemLoading(itemKey, true);
    _clearMessages();
    if (contentTypeId == 11) {
      modelName = 'Houses';
    }

    try {
      final result = await _apiService.removeFavorite(
        model: modelName,
        objectId: objectId,
      );
      if (result['data'] != null) {
        // Remove from local cache
        _favoriteItems.remove(itemKey);
        _setSuccessMessage(result['message']);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } on SocketException {
      _setError('No internet connection. Please check your network.');
      return false;
    } on TimeoutException {
      _setError('Request timeout. Please try again.');
      return false;
    } catch (e) {
      String errorMessage = 'Failed to remove from favorites';

      if (e.toString().contains('Server error')) {
        errorMessage =
            'Server temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('Failed to refresh access token')) {
        errorMessage = 'Session expired. Please log in again.';
      } else {
        errorMessage =
            'Failed to remove from favorites: ${_extractErrorMessage(e.toString())}';
      }

      _setError(errorMessage);
      return false;
    } finally {
      _setItemLoading(itemKey, false);
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite({
    required int contentTypeId,
    required int objectId,
    String? itemName,
  }) async {
    if (isFavorited(contentTypeId, objectId)) {
      return await removeFavorite(
        contentTypeId: contentTypeId,
        objectId: objectId,
      );
    } else {
      // print("Adding to Favorite list");
      return await addFavorite(
        contentTypeId: contentTypeId,
        objectId: objectId,
        itemName: itemName,
      );
    }
  }

  // Helper methods
  void _setItemLoading(String itemKey, bool loading) {
    if (loading) {
      _loadingItems.add(itemKey);
    } else {
      _loadingItems.remove(itemKey);
    }
    _isLoading = _loadingItems.isNotEmpty;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error ?? 'Unknown error';
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccessMessage(String message) {
    _successMessage = message ?? '';
    _errorMessage = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  // Extract clean error message from exception string
  String _extractErrorMessage(String? fullError) {
    if (fullError == null) return 'Unknown error';
    // Remove "Exception: " prefix if present
    if (fullError.startsWith('Exception: ')) {
      return fullError.substring(11);
    }
    return fullError;
  }

  // Clear messages (useful for UI)
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  // Load user's favorites (call this when app starts or user logs in)
  Future<void> getFavorites() async {
    try {
      _isLoading = true;
      final response = await _apiService.fetchFavorites();
      if (response.containsKey('data')) {
        _favoritesInfos = response['data'];

        // _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // print('Exception in getHouseList: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
