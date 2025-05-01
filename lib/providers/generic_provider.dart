import 'package:flutter/material.dart';
import 'package:mobile_app/utils/country_helper_code.dart';

class GenericProvider with ChangeNotifier {
  final CountryCodeHelper _countryhelper = CountryCodeHelper();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Map<String, String>> getCountryAndCity() async {
    setLoading(true);
    final result = _countryhelper.getCountryCity();
    setLoading(false);
    return result;
  }
}
