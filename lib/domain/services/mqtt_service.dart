import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttService({
    required String server,
    required int port,
    required this.username,
    required this.password,
    required this.temperatureTopic,
    required this.humidityTopic,
  }) : _client = MqttServerClient.withPort(
          server,
          'flutter_${DateTime.now().millisecondsSinceEpoch}',
          port,
        ) {
    _client
      ..logging(on: false)
      ..keepAlivePeriod = 20
      ..onDisconnected = _onDisconnected
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..setProtocolV311();
  }

  final String username;
  final String password;
  final String temperatureTopic;
  final String humidityTopic;
  final MqttServerClient _client;

  final ValueNotifier<double?> temperature = ValueNotifier(null);
  final ValueNotifier<double?> humidity = ValueNotifier(null);
  final ValueNotifier<bool> connected = ValueNotifier(false);

  StreamSubscription<List<MqttReceivedMessage<MqttMessage?>>?>? _subscription;

  Future<void> connect() async {
    if (connected.value) return;

    final message = MqttConnectMessage()
        .authenticateAs(username, password)
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = message;

    try {
      await _client.connect();
      connected.value = true;
      _client.subscribe(temperatureTopic, MqttQos.atMostOnce);
      _client.subscribe(humidityTopic, MqttQos.atMostOnce);
      _subscription = _client.updates?.listen((event) {
        if (event != null) {
          _handleMessages(event);
        }
      });
    } on Exception {
      connected.value = false;
      _client.disconnect();
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _client.disconnect();
    connected.value = false;
    temperature.value = null;
    humidity.value = null;
  }

  void _handleMessages(List<MqttReceivedMessage<MqttMessage?>> events) {
    for (final event in events) {
      final payload = event.payload as MqttPublishMessage?;
      if (payload == null) continue;

      final builder = MqttPublishPayload.bytesToStringAsString(payload.payload.message);
      final value = double.tryParse(builder);

      if (event.topic == temperatureTopic) {
        temperature.value = value;
      } else if (event.topic == humidityTopic) {
        humidity.value = value;
      }
    }
  }

  void _onDisconnected() {
    connected.value = false;
    temperature.value = null;
    humidity.value = null;
  }
}
