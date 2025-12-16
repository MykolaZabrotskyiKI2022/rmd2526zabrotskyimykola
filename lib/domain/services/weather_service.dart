import 'package:rmd2526zabrotskyimykola/domain/entities/weather_info.dart';

abstract class WeatherService {
  Future<WeatherInfo> fetchWeather(String city);
}
