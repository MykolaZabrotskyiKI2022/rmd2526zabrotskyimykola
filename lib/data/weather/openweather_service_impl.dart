import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:rmd2526zabrotskyimykola/domain/entities/weather_info.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/weather_service.dart';

class OpenWeatherServiceImpl implements WeatherService {
  const OpenWeatherServiceImpl({required this.apiKey});

  final String apiKey;

  @override
  Future<WeatherInfo> fetchWeather(String city) async {
    final uri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?q=$city&units=metric&appid=$apiKey',
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Weather API error: ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return WeatherInfo.fromJson(json);
  }
}
