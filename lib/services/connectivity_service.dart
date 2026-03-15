import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final hasInterface = 
          results.isNotEmpty && results.first != ConnectivityResult.none;
        
        if (hasInterface) {
          final hasInternet = 
            await InternetConnectionChecker.instance.hasConnection;
          _controller.add(hasInternet);
        } else {
          _controller.add(false);
        }
    });
  }

  Future<bool> checkConnection() async {
    return await InternetConnectionChecker.instance.hasConnection;
  }

  void dispose() {
    _controller.close();
  }
}
