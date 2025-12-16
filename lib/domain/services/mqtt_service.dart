abstract class MqttService {
  Stream<String> temperatureStream();
  Stream<String> humidityStream();

  Future<void> connect();
  Future<void> disconnect();
}
