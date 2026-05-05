import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dự báo thời tiết"),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    // 🔄 Loading
    if (provider.state == WeatherState.loading) {
      return const LoadingShimmer();
    }

    // ❌ Error
    if (provider.state == WeatherState.error) {
      return ErrorWidgetCustom(
        message: provider.errorMessage,
        onRetry: () {
          provider.refreshWeather();
        },
      );
    }

    // ⚠️ Không có data
    if (provider.state == WeatherState.loaded &&
        provider.forecast.isEmpty) {
      return const Center(
        child: Text("Không có dữ liệu dự báo"),
      );
    }

    // ✅ Data OK
    return RefreshIndicator(
      onRefresh: () => provider.refreshWeather(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌍 City name
            if (provider.currentWeather != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "${provider.currentWeather!.cityName}, ${provider.currentWeather!.country}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // ⏰ Hourly forecast (24h)
            HourlyForecastList(
              forecasts: provider.forecast,
            ),

            const SizedBox(height: 16),

            // 📅 Daily forecast (5 ngày)
            DailyForecastSection(
              forecasts: provider.forecast,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}