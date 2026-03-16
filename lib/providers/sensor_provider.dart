import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:iot_flutter_lab/services/connectivity_service.dart';
import 'package:iot_flutter_lab/services/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class SensorProvider extends ChangeNotifier {
  final MqttService _mqttService;
  final ConnectivityService _connectivityService;

  String _temperature = '--';
  bool _isOnline = false;

  String get temperature => _temperature;
  bool get isOnline => _isOnline;
  bool get isMqttConnected => _mqttService.client.connectionStatus?.state
    == MqttConnectionState.connected;

  StreamSubscription<String>? _mqttSub;
  StreamSubscription<bool>? _connSub;

  SensorProvider(this._mqttService, this._connectivityService) {
  _init();
}

void _init() async {
  final initialStatus = await Connectivity().checkConnectivity();
  _isOnline = initialStatus.isNotEmpty 
    && !initialStatus.contains(ConnectivityResult.none);
  
  if (_isOnline) {
    _mqttService.connect('espWemos/server_data_mobile');
  }
  notifyListeners();

  _connSub = _connectivityService.connectivityStream.listen((status) {
    if (_isOnline == status) return;
    
    _isOnline = status;
    if (_isOnline) {
      _mqttService.connect('espWemos/server_data_mobile');
    }
    notifyListeners();
  });

  _mqttSub = _mqttService.tempStream.listen((rawPayload) {
    try {
      final Map<String, dynamic> data = 
        jsonDecode(rawPayload) as Map<String, dynamic>;
      
      if (data.containsKey('current_temp')) {
        final temp = data['current_temp'];
        _temperature = temp.toString(); 
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Помилка парсингу температури: $e');
    }
    notifyListeners();
  });
}

  void retry() {
    if (_isOnline) _mqttService.connect('espWemos/server_data_mobile');
  }

  @override
  void dispose() {
    _mqttSub?.cancel();
    _connSub?.cancel();
    super.dispose();
  }
}
