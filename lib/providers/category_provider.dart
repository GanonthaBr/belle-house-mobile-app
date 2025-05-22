import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class CategoryProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isloading = false;
  Map<String, dynamic>? _categoriesInfos;
  Map<String, dynamic>? _categoryInfos;

  bool get isloading => _isloading;
  Map<String, dynamic>? get categoriesInfos => _categoriesInfos;
  Map<String, dynamic>? get categoryInfos => _categoryInfos;

  //set loading
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  //fetch categories

  Future<void> getCategories() async {
    setLoading(true);
    final response = await _homeServices.fetchCategories();
    setLoading(false);
    _categoriesInfos = response;
  }
  //fetch category

  Future<void> getCategory(String id) async {
    setLoading(true);
    final response = await _homeServices.getCategory(id);
    setLoading(false);
    _categoryInfos = response;
  }
}
