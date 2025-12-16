import 'package:rmd2526zabrotskyimykola/data/datasources/user_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/data/repositories/user_repository_impl.dart';
// ignore: directives_ordering
import 'package:rmd2526zabrotskyimykola/data/mqtt/mqtt_service_impl.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/auth_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/internet_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/mqtt_service.dart';

import 'package:rmd2526zabrotskyimykola/data/datasources/weather_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/data/repositories/weather_repository_impl.dart';
import 'package:rmd2526zabrotskyimykola/data/weather/openweather_service_impl.dart';
import 'package:rmd2526zabrotskyimykola/domain/repositories/weather_repository.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/weather_service.dart';

const InternetService internetService = InternetService();

final UserLocalDataSource userLocalDataSource = UserLocalDataSourcePrefs();

final UserRepositoryImpl userRepository = UserRepositoryImpl(
  userLocalDataSource,
);

final AuthService authService = AuthService(userRepository);

final MqttService mqttService = MqttServiceImpl(
  host: 'broker.hivemq.com',
  port: 1883,
);

const _openWeatherKey = '15e2ee89274387958997061353681800';

final WeatherLocalDataSource weatherLocal = WeatherLocalDataSource();

final WeatherService weatherService = OpenWeatherServiceImpl(
  apiKey: _openWeatherKey,
);

final WeatherRepository weatherRepository = WeatherRepositoryImpl(
  internetService,
  weatherService,
  weatherLocal,
);
