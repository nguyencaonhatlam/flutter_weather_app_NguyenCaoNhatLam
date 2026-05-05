class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?) ?? [];
    final wind = json['wind'] ?? {};

    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
          (json['dt'] ?? 0) * 1000),

      temperature: (main['temp'] ?? 0).toDouble(),

      description:
      weather.isNotEmpty ? weather[0]['description'] ?? '' : '',

      icon: weather.isNotEmpty ? weather[0]['icon'] ?? '' : '',

      tempMin: (main['temp_min'] ?? 0).toDouble(),
      tempMax: (main['temp_max'] ?? 0).toDouble(),

      humidity: main['humidity'] ?? 0,

      windSpeed: (wind['speed'] ?? 0).toDouble(),
    );
  }
}