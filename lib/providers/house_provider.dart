import 'package:flutter/widgets.dart';
import 'package:mobile_app/services/client_services.dart';

class HouseProvider with ChangeNotifier {
  final HomeServices _homeServices = HomeServices();
  bool _isloading = false;
  List<dynamic>? _housesInfos;
  Map<String, dynamic>? _houseInfos;
  String? _error;

  bool get isLoading => _isloading;
  List<dynamic>? get housesInfos => _housesInfos;
  Map<String, dynamic>? get houseInfos => _houseInfos;
  String? get error => _error;

  //set load state
  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  //house list
  Future<void> getHouseList() async {
    setLoading(true);
    _error = null;
    try {
      final response = await _homeServices.fetchHouses();

      _housesInfos = response['data'];
      print('HI: $_houseInfos');
      print('HH');
      setLoading(false);
    } catch (e) {
      print('Caught: $e');
      _error = 'Error: $e';
    }
  }

  // Method to refresh houses list
  Future<void> refreshHouses() async {
    await getHouseList();
  }

  // Method to filter houses by type
  List<dynamic> getHousesByType(String type) {
    if (_housesInfos == null) return [];
    return _housesInfos!
        .where((house) => house['type_of_contract'] == type)
        .toList();
  }

  // Method to get houses by area
  List<dynamic> getHousesByArea(String area) {
    if (_housesInfos == null) return [];
    return _housesInfos!
        .where(
          (house) =>
              house['area']?.toLowerCase().contains(area.toLowerCase()) ??
              false,
        )
        .toList();
  }

  //house
  Future<void> getHouse(String id) async {
    setLoading(true);
    final response = await _homeServices.getHouse(id);
    setLoading(false);
    _houseInfos = response;
  }
}

extension on Map<String, dynamic> {
  where(bool Function(dynamic house) param0) {}
}
