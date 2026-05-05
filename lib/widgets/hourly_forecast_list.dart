import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("Không có dữ liệu")),
      );
    }

    final displayList =
    forecasts.length > 10 ? forecasts.take(10).toList() : forecasts;

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final item = displayList[index];

          return Container(
            width: 85,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ⏰ Time
                Text(
                  DateFormatter.formatTime(item.dateTime),
                  style: const TextStyle(fontSize: 14),
                ),

                // 🌤 Icon
                CachedNetworkImage(
                  imageUrl:
                  'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                  height: 40,
                  errorWidget: (c, u, e) =>
                  const Icon(Icons.cloud, size: 30),
                ),

                // 🌡 Temp
                Text(
                  "${item.temperature.round()}°",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}