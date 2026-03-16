import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(_updateStatus);
    
    _initInitialStatus();
  }

  void _initInitialStatus() async {
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final bool online = results.isNotEmpty 
      && !results.contains(ConnectivityResult.none);
    _controller.add(online);
  }

  void dispose() => _controller.close();
}
