import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class WeatherLocalDataSource {
  static const _keyJson = 'weather_json';
  static const _keyCity = 'weather_city';

  // ignore: lines_longer_than_80_chars
  Future<void> save({
    required String city,
    required Map<String, dynamic> json,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCity, city);
    await prefs.setString(_keyJson, jsonEncode(json));
  }

  Future<Map<String, dynamic>?> load(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString(_keyCity);
    final raw = prefs.getString(_keyJson);
    if (savedCity != city || raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
