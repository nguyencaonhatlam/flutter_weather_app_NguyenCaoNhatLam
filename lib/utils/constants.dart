class AppConstants {
  // 🌐 API (KHÔNG để API key ở đây)
  static const String baseUrl =
      "https://api.openweathermap.org/data/2.5";

  static const String currentWeatherEndpoint = "/weather";
  static const String forecastEndpoint = "/forecast";

  static const String defaultUnits = "metric";
  static const String defaultLang = "vi";

  // ⏱ Timeout (dùng Duration thay vì int)
  static const Duration requestTimeout = Duration(seconds: 10);

  // 📦 Cache keys
  static const String cacheWeatherKey = "cached_weather";
  static const String cacheForecastKey = "cached_forecast";
  static const String lastUpdateKey = "last_update";

  // ⚙️ Settings keys
  static const String tempUnitKey = "tempUnit";
  static const String windUnitKey = "windUnit";
  static const String timeFormatKey = "is24Hour";

  // 🔍 Search
  static const String favoritesKey = "favorites";
  static const String historyKey = "history";

  // 📍 Location
  static const String lastLocationKey = "last_location";
}