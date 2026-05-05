import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../utils/weather_icons.dart';
import '../utils/date_formatter.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final daily = _groupByDay(forecasts);

    return Column(
      children: daily.entries.take(5).map((entry) {
        final dayForecasts = entry.value;

        final minTemp = dayForecasts
            .map((e) => e.tempMin)
            .reduce((a, b) => a < b ? a : b);

        final maxTemp = dayForecasts
            .map((e) => e.tempMax)
            .reduce((a, b) => a > b ? a : b);

        final weather = dayForecasts[0];

        return ListTile(
          leading: Icon(
            WeatherIcons.getIcon(weather.description),
            color: WeatherIcons.getColor(weather.description),
          ),
          title: Text(
            DateFormatter.formatDay(weather.dateTime),
          ),
          subtitle: Text(weather.description),
          trailing: Text(
            "${minTemp.round()}° / ${maxTemp.round()}°",
          ),
        );
      }).toList(),
    );
  }

  // 📅 Group forecast theo ngày
  Map<String, List<ForecastModel>> _groupByDay(
      List<ForecastModel> forecasts) {
    final Map<String, List<ForecastModel>> map = {};

    for (var item in forecasts) {
      final key =
          "${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}";

      if (!map.containsKey(key)) {
        map[key] = [];
      }

      map[key]!.add(item);
    }

    return map;
  }
}