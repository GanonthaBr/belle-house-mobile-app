import 'dart:convert';

import 'package:mobile_app/services/api_services.dart';
import 'package:mobile_app/utils/api_constants.dart';

class HomeServices {
  final ApiServices _apiServices = ApiServices();
  //fetch all houses
  Future<Map<String, dynamic>> fetchHouses() async {
    try {
      final response = await _apiServices.get(
        '${ApiConstants.baseUrl}/houses/',
      );
      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);

        return {'data': resp};
      } else {
        print('Error: ${response.statusCode}');
        return {'error': 'something went wrong'};
      }
    } catch (e) {
      return {'error': 'Network error: $e'};
    }
  }

  //fetch one house
  Future<Map<String, dynamic>> getHouse(String id) async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/houses/${id}',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data};
    } else {
      return {'error': 'something went wrong!'};
    }
  }

  //fetch parcelles
  Future<Map<String, dynamic>> fetchParcelles() async {
    final response = await _apiServices.get('${ApiConstants.baseUrl}/lands/');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Parcelles data: $data');
      return {'data': data};
    } else {
      print('Error: ${response.statusCode}');
      return {'error': 'something went wrong'};
    }
  }

  //fetch one parcelle
  Future<Map<String, dynamic>> getParcelle(String id) async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/lands/$id',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data};
    } else {
      return {'error': 'something went wrong'};
    }
  }

  //fetch products
  Future<Map<String, dynamic>> fetchProduct() async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/products/',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Product data: $data');
      return {'data': data};
    } else {
      print('Error: ${response.statusCode}');
      return {'error': 'something went wrong'};
    }
  }

  //fetch one product
  Future<Map<String, dynamic>> getProduct(String id) async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/products/$id',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data};
    } else {
      return {'error': 'something went wrong'};
    }
  }

  //fetch cars
  Future<Map<String, dynamic>> fetchCar() async {
    final response = await _apiServices.get('${ApiConstants.baseUrl}/car/');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Cars data: $data');
      return {'data': data};
    } else {
      print('Error: ${response.statusCode}');
      return {'error': 'something went wrong'};
    }
  }

  //fetch one car
  Future<Map<String, dynamic>> getCar(String id) async {
    final response = await _apiServices.get('${ApiConstants.baseUrl}/car/$id');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data};
    } else {
      return {'error': 'something went wrong'};
    }
  }

  //fetch categories
  Future<Map<String, dynamic>> fetchCategories() async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/categories/',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Categories data: $data');
      return {'data': data};
    } else {
      print('Error: ${response.statusCode}');
      return {'error': 'something went wrong'};
    }
  }

  //fetch one category
  Future<Map<String, dynamic>> getCategory(String id) async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrl}/categories/$id',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data};
    } else {
      return {'error': 'something went wrong'};
    }
  }

  //get user details
  Future<Map<String, dynamic>> getUserInfos() async {
    final response = await _apiServices.get(
      '${ApiConstants.baseUrlAuth}/profile/',
    );
    print("User Info: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {'data': data};
    } else {
      return {'error': 'something went wrong'};
    }
  }
}
