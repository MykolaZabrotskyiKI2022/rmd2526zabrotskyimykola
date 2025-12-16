import 'package:rmd2526zabrotskyimykola/data/datasources/user_local_data_source.dart';
import 'package:rmd2526zabrotskyimykola/data/repositories/user_repository_impl.dart';
import 'package:rmd2526zabrotskyimykola/data/mqtt/mqtt_service_impl.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/auth_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/internet_service.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/mqtt_service.dart';

final InternetService internetService = InternetService();

final UserLocalDataSource userLocalDataSource = UserLocalDataSourcePrefs();

final UserRepositoryImpl userRepository = UserRepositoryImpl(
  userLocalDataSource,
);

final AuthService authService = AuthService(userRepository);

final MqttService mqttService = MqttServiceImpl(
  host: 'broker.hivemq.com',
  port: 1883,
);
