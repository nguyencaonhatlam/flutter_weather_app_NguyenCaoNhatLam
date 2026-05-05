import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final dateText =
    DateFormat('EEEE, d MMM', 'vi_VN').format(weather.dateTime);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 🌍 City
          Text(
            "${weather.cityName}, ${weather.country}",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // 📅 Date
          Text(
            dateText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          // 🌤 Icon
          CachedNetworkImage(
            imageUrl:
            'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 110,
            placeholder: (context, url) =>
            const CircularProgressIndicator(color: Colors.white),
            errorWidget: (context, url, error) =>
            const Icon(Icons.cloud, size: 80, color: Colors.white),
          ),

          const SizedBox(height: 10),

          // 🌡 Temperature
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              fontSize: 72,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),

          // 🌥 Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          // 🌡 Feels like
          Text(
            'Cảm giác như ${weather.feelsLike.round()}°',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 Gradient theo thời tiết
  LinearGradient _getWeatherGradient(String condition) {
    final c = condition.toLowerCase();

    switch (c) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          colors: [Color(0xFF4B79A1), Color(0xFF283E51)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF414345)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'snow':
        return const LinearGradient(
          colors: [Color(0xFFE6DADA), Color(0xFF274046)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}