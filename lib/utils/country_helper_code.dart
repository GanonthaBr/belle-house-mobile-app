import 'package:country_codes/country_codes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CountryCodeHelper {
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false; // Permission denied
      }
    }
    return true; // Permission granted
  }

  static Future<String> getInitialCountryCode({String fallBack = 'NE'}) async {
    try {
      // print("INSIDE");
      //Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // print("OUT");
        return fallBack;
      }
      //Get device location
      await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      //get country code with local
      final details = CountryCodes.detailsForLocale();
      print("DETAILS ${details}");
      // print("OUT");
      return details.alpha2Code ?? fallBack;
    } catch (e) {
      // print("Error $e");
      return fallBack;
    }
  }

  Future<Map<String, String>> getCountryCity({
    String fallbackCountry = 'Niger',
  }) async {
    try {
      bool permissionGranted = await requestLocationPermission();
      if (!permissionGranted) {
        return {"country": fallbackCountry, "city": "unknow"};
      }
      //get location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      //perform reverse coding to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          "country": place.country ?? fallbackCountry,
          "city": place.subAdministrativeArea ?? "Unknown",
        };
      } else {
        return {'country': fallbackCountry, 'city': 'Unknown'};
      }
    } catch (e) {
      // print("Error: $e");
      return {'country': fallbackCountry, 'city': 'Unknown'};
    }
  }
}
