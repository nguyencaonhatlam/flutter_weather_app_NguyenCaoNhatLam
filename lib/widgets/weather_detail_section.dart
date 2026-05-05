import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/date_formatter.dart';
import 'weather_detail_item.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Chi tiết thời tiết",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Grid đẹp hơn Row
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                children: [
                  WeatherDetailItem(
                    icon: Icons.water_drop,
                    label: "Độ ẩm",
                    value: "${weather.humidity}%",
                  ),
                  WeatherDetailItem(
                    icon: Icons.air,
                    label: "Gió",
                    value: "${weather.windSpeed} m/s",
                  ),
                  WeatherDetailItem(
                    icon: Icons.speed,
                    label: "Áp suất",
                    value: "${weather.pressure} hPa",
                  ),
                  WeatherDetailItem(
                    icon: Icons.visibility,
                    label: "Tầm nhìn",
                    value: "${weather.visibility ?? 0} m",
                  ),
                  WeatherDetailItem(
                    icon: Icons.wb_sunny,
                    label: "Bình minh",
                    value: DateFormatter.formatTime(
                      weather.sunrise ?? DateTime.now(),
                    ),
                  ),
                  WeatherDetailItem(
                    icon: Icons.nightlight,
                    label: "Hoàng hôn",
                    value: DateFormatter.formatTime(
                      weather.sunset ?? DateTime.now(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}