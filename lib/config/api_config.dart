class ApiConfig {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5';

  // ✅ hardcode cho web
  static const String apiKey = "e300d3d510e51537752f8775d529216e";

  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');

    params['appid'] = apiKey;
    params['units'] = 'metric';
    params['lang'] = 'vi';
    return uri.replace(queryParameters: params).toString();
  }
}