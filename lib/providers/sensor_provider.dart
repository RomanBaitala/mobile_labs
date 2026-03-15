import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:iot_flutter_lab/services/connectivity_service.dart';
import 'package:iot_flutter_lab/services/mqtt_service.dart';

class SensorProvider extends ChangeNotifier {
  final MqttService _mqttService;
  final ConnectivityService _connectivityService;

  String _temperature = '--';
  bool _isOnline = false;
  final bool _isMqttConnected = false;

  String get temperature => _temperature;
  bool get isOnline => _isOnline;
  bool get isMqttConnected => _isMqttConnected;

  StreamSubscription<String>? _mqttSub;
  StreamSubscription<bool>? _connSub;

  SensorProvider(this._mqttService, this._connectivityService) {
    _init();
  }

  void _init() {
    _connSub = _connectivityService.connectivityStream.listen((status) {
      _isOnline = status;
      notifyListeners();

      if (_isOnline) {
        _mqttService.connect();
      }
    });

    _mqttSub = _mqttService.tempStream.listen((data) {
      _temperature = data;
      notifyListeners();
    });
    
  }

  @override
  void dispose() {
    _mqttSub?.cancel();
    _connSub?.cancel();
    super.dispose();
  }
}
