import 'package:rmd2526zabrotskyimykola/data/datasources/user_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/data/repositories/user_repository_impl.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/auth_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/connectivity_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/mqtt_service.dart';

final AuthService authService = AuthService(
  UserRepositoryImpl(UserLocalDataSourcePrefs()),
);

final ConnectivityService connectivityService = ConnectivityService();

final MqttService mqttService = MqttService(
  server: '2610881802de4755b572ad2d3dd64a0f.s1.eu.hivemq.cloud',
  port: 8883,
  username: 'mykolaz',
  password: 'Vbrjkf13542',
  temperatureTopic: 'esp32/dht/temperature',
  humidityTopic: 'esp32/dht/humidity',
);
