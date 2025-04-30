import 'dart:convert';

import 'package:mobile_app/services/api_services.dart';
import 'package:mobile_app/utils/api_constants.dart';

class HomeServices {
  final ApiServices _apiServices = ApiServices();

  Future<void> fetchHouses() async {
    final response = await _apiServices.get('${ApiConstants.baseUrl}/houses/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Houses data: $data');
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
