import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';

class WeatherService {
  // ⏱ timeout cho request
  static const Duration timeoutDuration = Duration(seconds: 10);

  // 🌤 Current weather by city
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'q': cityName},
      );

      final response = await http
          .get(Uri.parse(url))
          .timeout(timeoutDuration);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố');
      } else {
        throw Exception(data['message'] ?? 'Lỗi tải dữ liệu');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  // 📍 Current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat,
      double lon,
      ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
        },
      );

      final response = await http
          .get(Uri.parse(url))
          .timeout(timeoutDuration);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Lỗi tải dữ liệu');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  // 📅 Forecast theo city
  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'q': cityName},
      );

      final response = await http
          .get(Uri.parse(url))
          .timeout(timeoutDuration);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final List list = data['list'];
        return list
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Lỗi forecast');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  // 📅 Forecast theo tọa độ (QUAN TRỌNG - nên dùng)
  Future<List<ForecastModel>> getForecastByCoordinates(
      double lat,
      double lon,
      ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
        },
      );

      final response = await http
          .get(Uri.parse(url))
          .timeout(timeoutDuration);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final List list = data['list'];
        return list
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Lỗi forecast');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst("Exception: ", ""));
    }
  }

  // 🌥 Icon URL
  String getIconUrl(String iconCode) {
    return "https://openweathermap.org/img/wn/$iconCode@2x.png";
  }
}