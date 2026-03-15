import 'dart:async';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final MqttServerClient client; 
  final Logger _logger = Logger();

  final _tempController = StreamController<String>.broadcast();
  Stream<String> get tempStream => _tempController.stream;

  MqttService(String server, String clientId)
    : client = MqttServerClient(server, clientId);

  Future<void> connect() async {
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      _logger.e('MQTT connection failed: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      _logger.i('MQTT connected');
    } else {
      _logger.e('MQTT connection failed');
      client.disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages ) {
      final recivedMessage = messages[0].payload as MqttPublishMessage;

      final payload = MqttPublishPayload.bytesToStringAsString(
        recivedMessage.payload.message
      );

      _tempController.add(payload);

    });
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void onConnected() {
    _logger.i('Connected');
  }

  void onDisconnected() {
    _logger.w('Disconnected');
  }
}
