import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';

  // 📦 Save weather data
  Future<void> saveWeatherData(WeatherModel weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _weatherKey,
        json.encode(weather.toJson()),
      );

      await prefs.setInt(
        _lastUpdateKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // tránh crash app
      print("Save weather error: $e");
    }
  }

  // 📥 Get cached weather
  Future<WeatherModel?> getCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherJson = prefs.getString(_weatherKey);

      if (weatherJson != null) {
        final data = json.decode(weatherJson);
        return WeatherModel.fromJson(data);
      }
    } catch (e) {
      print("Load weather error: $e");
    }

    return null;
  }

  // ⏱ Check cache (30 phút)
  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);

    if (lastUpdate == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - lastUpdate;

    return difference < 30 * 60 * 1000;
  }

  // 🧹 Clear cache (optional nhưng nên có)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
    await prefs.remove(_lastUpdateKey);
  }

  // ⭐ Save favorite cities
  Future<void> saveFavoriteCities(List<String> cities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoriteCitiesKey, cities);
    } catch (e) {
      print("Save favorite error: $e");
    }
  }

  // ⭐ Get favorite cities
  Future<List<String>> getFavoriteCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoriteCitiesKey) ?? [];
    } catch (e) {
      print("Load favorite error: $e");
      return [];
    }
  }
}