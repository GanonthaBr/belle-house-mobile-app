import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/api_services.dart';
import 'package:mobile_app/utils/api_constants.dart';

class HomeServices {
  final ApiServices _apiServices = ApiServices();

  // Generic response handler
  Map<String, dynamic> _handleResponse(
    http.Response response,
    String operation,
  ) {
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'data': data};
      } else if (response.statusCode == 401) {
        return {'error': 'Unauthorized - Please login again'};
      } else if (response.statusCode == 403) {
        return {'error': 'Access forbidden'};
      } else if (response.statusCode == 404) {
        return {'error': 'Resource not found'};
      } else if (response.statusCode >= 500) {
        return {'error': 'Server error - Please try again later'};
      } else {
        return {'error': 'Failed to $operation (${response.statusCode})'};
      }
    } catch (e) {
      return {'error': 'Failed to parse response: $e'};
    }
  }

  // Fetch all houses with automatic retry
  Future<Map<String, dynamic>> fetchHouses() async {
    try {
      // print('Fetching houses...');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/houses/',
      );
      return _handleResponse(response, 'fetch houses');
    } catch (e) {
      print('Error fetching houses: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch one house with automatic retry
  Future<Map<String, dynamic>> getHouse(String id) async {
    try {
      // print('Fetching house with ID: $id');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/houses/$id',
      );
      return _handleResponse(response, 'fetch house');
    } catch (e) {
      // print('Error fetching house: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Create new house
  Future<Map<String, dynamic>> createHouse(
    Map<String, dynamic> houseData,
  ) async {
    try {
      // print('Creating new house...');
      final response = await _apiServices.post(
        '${ApiConstants.baseUrl}/houses/',
        houseData,
      );
      return _handleResponse(response, 'create house');
    } catch (e) {
      // print('Error creating house: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Update house
  Future<Map<String, dynamic>> updateHouse(
    String id,
    Map<String, dynamic> houseData,
  ) async {
    try {
      // print('Updating house with ID: $id');
      final response = await _apiServices.put(
        '${ApiConstants.baseUrl}/houses/$id/',
        houseData,
      );
      return _handleResponse(response, 'update house');
    } catch (e) {
      // print('Error updating house: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Delete house
  Future<Map<String, dynamic>> deleteHouse(String id) async {
    try {
      // print('Deleting house with ID: $id');
      final response = await _apiServices.delete(
        '${ApiConstants.baseUrl}/houses/$id/',
      );
      return _handleResponse(response, 'delete house');
    } catch (e) {
      // print('Error deleting house: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch parcelles with automatic retry
  Future<Map<String, dynamic>> fetchParcelles() async {
    try {
      // print('Fetching parcelles...');
      final response = await _apiServices.get('${ApiConstants.baseUrl}/lands/');

      return _handleResponse(response, 'fetch parcelles');
    } catch (e) {
      // print('Error fetching parcelles: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch one parcelle with automatic retry
  Future<Map<String, dynamic>> getParcelle(String id) async {
    try {
      // print('Fetching parcelle with ID: $id');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/lands/$id',
      );
      return _handleResponse(response, 'fetch parcelle');
    } catch (e) {
      // print('Error fetching parcelle: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Create new parcelle
  Future<Map<String, dynamic>> createParcelle(
    Map<String, dynamic> parcelleData,
  ) async {
    try {
      // print('Creating new parcelle...');
      final response = await _apiServices.post(
        '${ApiConstants.baseUrl}/lands/',
        parcelleData,
      );
      return _handleResponse(response, 'create parcelle');
    } catch (e) {
      // print('Error creating parcelle: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Update parcelle
  Future<Map<String, dynamic>> updateParcelle(
    String id,
    Map<String, dynamic> parcelleData,
  ) async {
    try {
      // print('Updating parcelle with ID: $id');
      final response = await _apiServices.put(
        '${ApiConstants.baseUrl}/lands/$id/',
        parcelleData,
      );
      return _handleResponse(response, 'update parcelle');
    } catch (e) {
      // print('Error updating parcelle: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Delete parcelle
  Future<Map<String, dynamic>> deleteParcelle(String id) async {
    try {
      // print('Deleting parcelle with ID: $id');
      final response = await _apiServices.delete(
        '${ApiConstants.baseUrl}/lands/$id/',
      );
      return _handleResponse(response, 'delete parcelle');
    } catch (e) {
      // print('Error deleting parcelle: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch products with automatic retry
  Future<Map<String, dynamic>> fetchProduct() async {
    try {
      // print('Fetching products...');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/products/',
      );
      return _handleResponse(response, 'fetch products');
    } catch (e) {
      // print('Error fetching products: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch one product with automatic retry
  Future<Map<String, dynamic>> getProduct(String id) async {
    try {
      // print('Fetching product with ID: $id');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/products/$id',
      );
      return _handleResponse(response, 'fetch product');
    } catch (e) {
      print('Error fetching product: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch cars with automatic retry
  Future<Map<String, dynamic>> fetchCar() async {
    try {
      // print('Fetching cars...');
      final response = await _apiServices.get('${ApiConstants.baseUrl}/car/');
      return _handleResponse(response, 'fetch cars');
    } catch (e) {
      // print('Error fetching cars: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch one car with automatic retry
  Future<Map<String, dynamic>> getCar(String id) async {
    try {
      // print('Fetching car with ID: $id');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/car/$id',
      );
      return _handleResponse(response, 'fetch car');
    } catch (e) {
      // print('Error fetching car: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch categories with automatic retry
  Future<Map<String, dynamic>> fetchCategories() async {
    try {
      // print('Fetching categories...');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/categories/',
      );
      return _handleResponse(response, 'fetch categories');
    } catch (e) {
      // print('Error fetching categories: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Fetch one category with automatic retry
  Future<Map<String, dynamic>> getCategory(String id) async {
    try {
      // print('Fetching category with ID: $id');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/categories/$id',
      );
      return _handleResponse(response, 'fetch category');
    } catch (e) {
      // print('Error fetching category: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Get user details with automatic retry
  Future<Map<String, dynamic>> getUserInfos() async {
    try {
      // print('Fetching user info...');
      final response = await _apiServices.get(
        '${ApiConstants.baseUrlAuth}/profile/',
      );
      return _handleResponse(response, 'fetch user info');
    } catch (e) {
      // print('Error fetching user info: $e');
      return {'error': 'Network error: $e'};
    }
  }

  // Batch operations with retry
  Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      // print('Fetching all home data...');
      final results = await Future.wait([
        fetchHouses(),
        fetchParcelles(),
        fetchCategories(),
      ]);

      return {
        'houses': results[0]['data'],
        'parcelles': results[1]['data'],
        'categories': results[2]['data'],
        'success': true,
      };
    } catch (e) {
      // print('Error fetching home data: $e');
      return {'error': 'Failed to fetch home data: $e'};
    }
  }

  // Manual retry method for specific operations
  Future<Map<String, dynamic>> retryOperation(
    Future<Map<String, dynamic>> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (e) {
      // print('Retry operation failed: $e');
      return {'error': 'Retry failed: $e'};
    }
  }
}
