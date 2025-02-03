import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } else {
      throw Exception("Permissions de localisation refusées");
    }
  }

  static Future<String> getCityAndDepartement() async {
    try {
      Position position = await _getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        String city = placemarks[0].locality ?? "Ville inconnue";
        String departement = placemarks[0].subAdministrativeArea ?? placemarks[0].administrativeArea ?? "Département inconnu";
        
        return "Ville: $city, Département: $departement";
      } else {
        return "Aucune information sur la localisation trouvée";
      }
    } catch (e) {
      print("Erreur lors de la récupération de la ville et du département: $e");
      return "Erreur de localisation";
    }
  }
}
