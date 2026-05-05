import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

enum LocationState { idle, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  LocationModel? location;
  LocationState state = LocationState.idle;
  String error = "";

  Future<void> getCurrentLocation() async {
    try {
      state = LocationState.loading;
      notifyListeners();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception("Vui lòng bật GPS");
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception("Bạn đã từ chối quyền vị trí");
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        throw Exception("Cấp quyền vị trí trong cài đặt");
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      location = LocationModel.fromPosition(pos);

      state = LocationState.loaded;
      error = "";
    } catch (e) {
      location = null;
      state = LocationState.error;
      error = e.toString().replaceFirst("Exception: ", "");
    }

    notifyListeners();
  }

  Future<void> retry() async {
    await getCurrentLocation();
  }

  void clear() {
    location = null;
    state = LocationState.idle;
    error = "";
    notifyListeners();
  }
}