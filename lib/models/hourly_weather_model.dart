class HourlyWeatherModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;
  final double? pop;

  HourlyWeatherModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    this.pop,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?) ?? [];
    final wind = json['wind'] ?? {};

    return HourlyWeatherModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
          (json['dt'] ?? 0) * 1000),

      temperature: (main['temp'] ?? 0).toDouble(),

      description:
      weather.isNotEmpty ? weather[0]['description'] ?? '' : '',

      icon: weather.isNotEmpty ? weather[0]['icon'] ?? '' : '',

      windSpeed: (wind['speed'] ?? 0).toDouble(),

      humidity: main['humidity'] ?? 0,

      pop: json['pop'] != null ? (json['pop']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature,
        'humidity': humidity,
      },
      'weather': [
        {
          'description': description,
          'icon': icon,
        }
      ],
      'wind': {
        'speed': windSpeed,
      },
      'pop': pop,
    };
  }
}