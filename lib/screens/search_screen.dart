import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<String> history = [];
  List<String> favorites = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList("history") ?? [];
      favorites = prefs.getStringList("favorites") ?? [];
    });
  }

  Future<void> saveHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();

    history.remove(city);
    history.insert(0, city);

    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList("history", history);
    setState(() {});
  }

  Future<void> toggleFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();

    if (favorites.contains(city)) {
      favorites.remove(city);
    } else {
      if (favorites.length >= 5) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chỉ tối đa 5 thành phố")),
        );
        return;
      }
      favorites.add(city);
    }

    await prefs.setStringList("favorites", favorites);
    setState(() {});
  }

  Future<void> searchCity(String city) async {
    if (city.trim().isEmpty) return;

    setState(() => isLoading = true);

    await saveHistory(city);

    final provider =
    Provider.of<WeatherProvider>(context, listen: false);

    try {
      await provider.fetchWeatherByCity(city);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy thành phố")),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Widget buildCityItem(String city) {
    final isFav = favorites.contains(city);

    return ListTile(
      title: Text(city),
      leading: const Icon(Icons.location_city),
      trailing: IconButton(
        icon: Icon(
          isFav ? Icons.star : Icons.star_border,
          color: isFav ? Colors.amber : null,
        ),
        onPressed: () => toggleFavorite(city),
      ),
      onTap: () => searchCity(city),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search City"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔍 SEARCH BOX
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Nhập thành phố...",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          searchCity(_controller.text),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: searchCity,
                ),

                const SizedBox(height: 20),

                // ⭐ FAVORITES
                if (favorites.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "⭐ Yêu thích",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...favorites.map(buildCityItem),
                  const SizedBox(height: 20),
                ],

                // 🕘 HISTORY
                if (history.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🕘 Lịch sử tìm kiếm",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView(
                            children:
                            history.map(buildCityItem).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 🔄 Loading overlay
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}