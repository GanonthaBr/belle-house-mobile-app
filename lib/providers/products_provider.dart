import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class ProductsProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isLoading = false;
  Map<String, dynamic>? _productsInfos;
  Map<String, dynamic>? _productInfos;

  bool get isloading => _isLoading;
  Map<String, dynamic>? get productsInfos => _productsInfos;
  Map<String, dynamic>? get productInfos => _productInfos;
  //set loading
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //fetch products
  Future<void> getProducts() async {
    setLoading(true);
    final response = await _homeServices.fetchProduct();
    setLoading(false);
    _productsInfos = response;
  }

  //fetch product
  Future<void> getProduct(String id) async {
    setLoading(true);
    final response = await _homeServices.getProduct(id);
    setLoading(false);
    _productInfos = response;
  }
}
