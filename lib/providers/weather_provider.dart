import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import 'package:flutter/foundation.dart';
enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  WeatherProvider(
      this._weatherService,
      this._locationService,
      this._storageService,
      );

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  // Fetch weather by city
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final weather =
      await _weatherService.getCurrentWeatherByCity(cityName);

      final forecast =
      await _weatherService.getForecast(cityName);

      _currentWeather = weather;
      _forecast = forecast;

      if (_currentWeather != null) {
        await _storageService.saveWeatherData(_currentWeather!);
      }

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _currentWeather = null;
      _forecast = [];

      _state = WeatherState.error;
      _errorMessage = e.toString().replaceFirst("Exception: ", "");

      await loadCachedWeather();
    }

    notifyListeners();
  }

  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      if (kIsWeb) {
        _currentWeather =
        await _weatherService.getCurrentWeatherByCity("Ho Chi Minh");

        _forecast =
        await _weatherService.getForecast("Ho Chi Minh");

        _state = WeatherState.loaded;
        notifyListeners();
        return;
      }

      final position = await _locationService.getCurrentLocation();

      _currentWeather =
      await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      _forecast = await _weatherService.getForecast(cityName);

      _state = WeatherState.loaded;
    } catch (e) {
      _currentWeather =
      await _weatherService.getCurrentWeatherByCity("Ho Chi Minh");

      _forecast =
      await _weatherService.getForecast("Ho Chi Minh");

      _state = WeatherState.loaded;
    }

    notifyListeners();
  }

  // Load cached weather
  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}
