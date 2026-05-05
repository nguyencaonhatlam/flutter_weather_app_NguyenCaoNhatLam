import 'package:flutter/material.dart';

class WeatherIcons {
  // 🌤 ICON
  static IconData getIcon(String? condition) {
    final c = condition?.toLowerCase() ?? '';

    switch (c) {
      case 'clear':
        return Icons.wb_sunny;

      case 'clouds':
        return Icons.cloud;

      case 'rain':
      case 'drizzle':
        return Icons.grain;

      case 'thunderstorm':
        return Icons.flash_on;

      case 'snow':
        return Icons.ac_unit;

      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;

      case 'smoke':
        return Icons.smoke_free;

      case 'dust':
      case 'sand':
      case 'ash':
        return Icons.grain;

      case 'squall':
      case 'tornado':
        return Icons.air;

      default:
        return Icons.wb_cloudy;
    }
  }

  // 🎨 COLOR
  static Color getColor(String? condition) {
    final c = condition?.toLowerCase() ?? '';

    switch (c) {
      case 'clear':
        return Colors.orange;

      case 'clouds':
        return Colors.blueGrey;

      case 'rain':
      case 'drizzle':
        return Colors.blue;

      case 'thunderstorm':
        return Colors.deepPurple;

      case 'snow':
        return Colors.lightBlueAccent;

      case 'mist':
      case 'fog':
      case 'haze':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }

  // 🌙 Optional: icon theo ngày/đêm
  static IconData getIconWithTime({
    required String? condition,
    required bool isDay,
  }) {
    final c = condition?.toLowerCase() ?? '';

    if (c == 'clear') {
      return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    }

    return getIcon(condition);
  }
}