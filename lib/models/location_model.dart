import 'package:geolocator/geolocator.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
  });

  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lon'] ?? 0).toDouble(),
      cityName: json['name'],
      country: json['sys']?['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude,
      'name': cityName,
      'country': country,
    };
  }
}