import 'package:country_codes/country_codes.dart';
import 'package:geolocator/geolocator.dart';

class CountryCodeHelper {
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
}
