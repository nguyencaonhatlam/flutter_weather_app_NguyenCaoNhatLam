import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String tempUnit = "C";
  String windUnit = "m/s";
  bool is24Hour = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      tempUnit = prefs.getString("tempUnit") ?? "C";
      windUnit = prefs.getString("windUnit") ?? "m/s";
      is24Hour = prefs.getBool("is24Hour") ?? true;
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("tempUnit", tempUnit);
    await prefs.setString("windUnit", windUnit);
    await prefs.setBool("is24Hour", is24Hour);
  }

  void updateTempUnit(String value) {
    setState(() => tempUnit = value);
    saveSettings();
  }

  void updateWindUnit(String value) {
    setState(() => windUnit = value);
    saveSettings();
  }

  void updateTimeFormat(bool value) {
    setState(() => is24Hour = value);
    saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // 🌡 TEMP UNIT
          const ListTile(
            title: Text("Đơn vị nhiệt độ"),
          ),
          RadioListTile<String>(
            title: const Text("Celsius (°C)"),
            value: "C",
            groupValue: tempUnit,
            onChanged: (value) =>
                updateTempUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text("Fahrenheit (°F)"),
            value: "F",
            groupValue: tempUnit,
            onChanged: (value) =>
                updateTempUnit(value!),
          ),

          const Divider(),

          // 🌬 WIND UNIT
          const ListTile(
            title: Text("Đơn vị gió"),
          ),
          RadioListTile<String>(
            title: const Text("m/s"),
            value: "m/s",
            groupValue: windUnit,
            onChanged: (value) =>
                updateWindUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text("km/h"),
            value: "km/h",
            groupValue: windUnit,
            onChanged: (value) =>
                updateWindUnit(value!),
          ),
          RadioListTile<String>(
            title: const Text("mph"),
            value: "mph",
            groupValue: windUnit,
            onChanged: (value) =>
                updateWindUnit(value!),
          ),

          const Divider(),

          // 🕒 TIME FORMAT
          SwitchListTile(
            title: const Text("Định dạng 24 giờ"),
            value: is24Hour,
            onChanged: updateTimeFormat,
          ),
        ],
      ),
    );
  }
}