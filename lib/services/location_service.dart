import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // 🔐 Check & request permission
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  // 📍 Get current location
  Future<Position> getCurrentLocation() async {
    bool hasPermission = await checkPermission();

    if (!hasPermission) {
      throw Exception('Không có quyền truy cập vị trí');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Không thể lấy vị trí hiện tại');
    }
  }

  // 🌍 Get city name từ lat/lon
  Future<String> getCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Ưu tiên locality → subAdministrativeArea → administrativeArea
        return place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            'Unknown';
      }

      return 'Unknown';
    } catch (e) {
      return 'Unknown'; // fallback thay vì throw
    }
  }
}