import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/battery/battery_state.dart';
import 'package:my_flashlight/my_flashlight.dart';


class BatteryFlashlightBloc extends Bloc<BatteryEvent, BatteryFlashlightState> {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batterySubscription;

  BatteryFlashlightBloc() : super(BatteryFlashlightState.initial()) {
    on<StartMonitoring>(_onStartMonitoring);
    on<BatteryStatusChanged>(_onBatteryStatusChanged);
  }

  void _onStartMonitoring(
    StartMonitoring event, Emitter<BatteryFlashlightState> emit
  ) {
    _batterySubscription?.cancel();
    _batterySubscription = _battery.onBatteryStateChanged.listen((status) {
      add(BatteryStatusChanged(status));
    });
  }

  Future<void> _onBatteryStatusChanged(
    BatteryStatusChanged event, 
    Emitter<BatteryFlashlightState> emit
  ) async {
    final bool currentlyCharging = event.status == BatteryState.charging;
    
    if (currentlyCharging == state.isCharging) return;

    final String time = 
      DateTime.now().toString().split('.').first.split(' ').last;
    final String logMsg = 
      currentlyCharging ? '[$time] Connected' : '[$time] Disconnected';
    
    final updatedLogs = List<String>.from(state.logs)..insert(0, logMsg);

    try {
      await MyFlashlight.toggleLight(currentlyCharging);
      
      emit(state.copyWith(
        isCharging: currentlyCharging,
        isFlashlightOn: currentlyCharging,
        logs: updatedLogs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isCharging: currentlyCharging,
        logs: updatedLogs..insert(0, 'Error: $e'),
      ));
    }
  }

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    return super.close();
  }
}
