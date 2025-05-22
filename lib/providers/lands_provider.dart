import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class LandsProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isloading = false;
  Map<String, dynamic>? _landsInfos;
  Map<String, dynamic>? _landInfos;

  bool get isloading => _isloading;
  Map<String, dynamic>? get landsInfos => _landsInfos;
  Map<String, dynamic>? get landInfos => _landInfos;

  //set loading
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  //get lands
  Future<void> getLands() async {
    setLoading(true);
    final response = await _homeServices.fetchParcelles();
    setLoading(false);
    _landsInfos = response;
  }

  //get land
  Future<void> getLand(String id) async {
    setLoading(true);
    final response = await _homeServices.getParcelle(id);
    setLoading(false);
    _landInfos = response;
  }
}
