import 'package:rmd2526zabrotskyimykola/domain/entities/weather_info.dart';

abstract class WeatherRepository {
  Future<WeatherInfo> getWeather(String city);
}
