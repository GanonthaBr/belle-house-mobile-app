import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class HouseProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isloading = false;
  Map<String, dynamic>? _housesInfos;
  Map<String, dynamic>? _houseInfos;

  bool get loading => _isloading;
  Map<String, dynamic>? get housesInfos => _housesInfos;
  Map<String, dynamic>? get houseInfos => _houseInfos;

  //set load state
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  //house list
  Future<void> getHouseList() async {
    setLoading(true);
    final response = await _homeServices.fetchHouses();
    setLoading(false);
    _housesInfos = response;
  }

  //house
  Future<void> getHouse(String id) async {
    setLoading(true);
    final response = await _homeServices.getHouse(id);
    setLoading(false);
    _houseInfos = response;
  }
}
