class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? cloudiness;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.cloudiness,
    this.sunrise,
    this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?) ?? [];
    final wind = json['wind'] ?? {};
    final sys = json['sys'] ?? {};
    final clouds = json['clouds'] ?? {};

    return WeatherModel(
      cityName: json['name'] ?? '',
      country: sys['country'] ?? '',

      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      pressure: main['pressure'] ?? 0,

      description:
      weather.isNotEmpty ? weather[0]['description'] ?? '' : '',
      icon: weather.isNotEmpty ? weather[0]['icon'] ?? '' : '',
      mainCondition:
      weather.isNotEmpty ? weather[0]['main'] ?? '' : '',

      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),

      tempMin: (main['temp_min'])?.toDouble(),
      tempMax: (main['temp_max'])?.toDouble(),

      visibility: json['visibility'] ?? 0,
      cloudiness: clouds['all'] ?? 0,

      sunrise: sys['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)
          : null,

      sunset: sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise?.millisecondsSinceEpoch != null
            ? sunrise!.millisecondsSinceEpoch ~/ 1000
            : null,
        'sunset': sunset?.millisecondsSinceEpoch != null
            ? sunset!.millisecondsSinceEpoch ~/ 1000
            : null,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {
          'description': description,
          'icon': icon,
          'main': mainCondition,
        }
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }
}