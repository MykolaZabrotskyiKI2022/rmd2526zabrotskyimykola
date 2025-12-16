import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rmd2526zabrotskyimykola/domain/services/mqtt_service.dart';

class MqttServiceImpl implements MqttService {
  MqttServiceImpl({required String host, required int port})
    : _host = host,
      _port = port;

  final String _host;
  final int _port;

  late final MqttServerClient _client;

  final StreamController<String> _tempCtrl =
      StreamController<String>.broadcast();
  final StreamController<String> _humCtrl =
      StreamController<String>.broadcast();

  StreamSubscription<dynamic>? _updatesSub;

  @override
  Stream<String> temperatureStream() => _tempCtrl.stream;

  @override
  Stream<String> humidityStream() => _humCtrl.stream;

  bool _isConnected = false;

  @override
  Future<void> connect() async {
    if (_isConnected) {
      return;
    }

    final clientId = 'flutter_${DateTime.now().millisecondsSinceEpoch}';
    _client = MqttServerClient(_host, clientId);
    _client.port = _port;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
      rethrow;
    }

    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      throw Exception('MQTT not connected');
    }

    _isConnected = true;

    _client.subscribe('mykolaz/esp32/dht/temperature', MqttQos.atMostOnce);
    _client.subscribe('mykolaz/esp32/dht/humidity', MqttQos.atMostOnce);

    _updatesSub?.cancel();
    _updatesSub = _client.updates!.listen(_onMessage);
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (final msg in messages) {
      final payloadMsg = msg.payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        payloadMsg.payload.message,
      );

      if (msg.topic == 'mykolaz/esp32/dht/temperature') {
        _tempCtrl.add(payload);
        print('Temperature: $payload');
      }

      if (msg.topic == 'mykolaz/esp32/dht/humidity') {
        _humCtrl.add(payload);
        print('Humidity: $payload');
      }
    }
  }

  @override
  Future<void> disconnect() async {
    await _updatesSub?.cancel();
    _updatesSub = null;

    _client.disconnect();
    _isConnected = false;
  }
}
