import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_section.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // 🚀 Load weather khi mở app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () =>
            context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            // 🔄 Loading
            if (provider.state == WeatherState.loading) {
              return const LoadingShimmer();
            }

            // ❌ Error
            if (provider.state == WeatherState.error) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () =>
                    provider.fetchWeatherByLocation(),
              );
            }

            // ⚠️ No data
            if (provider.currentWeather == null) {
              return const Center(
                child: Text('No weather data'),
              );
            }

            // ✅ Data OK
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🌤 Current weather
                  CurrentWeatherCard(
                    weather: provider.currentWeather!,
                  ),

                  const SizedBox(height: 16),

                  // ⏰ Hourly forecast (24h)
                  HourlyForecastList(
                    forecasts: provider.forecast,
                  ),

                  const SizedBox(height: 16),

                  // 📅 Daily forecast (5 ngày)
                  DailyForecastSection(
                    forecasts: provider.forecast,
                  ),

                  const SizedBox(height: 16),

                  // 📊 Weather details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: WeatherDetailsSection(
                      weather: provider.currentWeather!,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}