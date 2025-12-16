import 'package:rmd2526zabrotskyimykola/data/datasources/weather_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/domain/entities/weather_info.dart';
import 'package:rmd2526zabrotskyimykola/domain/repositories/weather_repository.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/internet_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/weather_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._net, this._api, this._local);

  final InternetService _net;
  final WeatherService _api;
  final WeatherLocalDataSource _local;

  @override
  Future<WeatherInfo> getWeather(String city) async {
    final online = await _net.hasInternet();

    if (online) {
      final info = await _api.fetchWeather(city);

      await _local.save(
        city: city,
        json: {
          'name': info.city,
          'weather': [
            {'description': info.description, 'icon': info.icon},
          ],
          'main': {
            'temp': info.temp,
            'feels_like': info.feelsLike,
            'humidity': info.humidity,
          },
          'wind': {'speed': info.windSpeed},
        },
      );
      return info;
    }

    final cached = await _local.load(city);
    if (cached == null) {
      throw Exception('No Internet and no cached weather');
    }
    return WeatherInfo.fromJson(cached);
  }
}
