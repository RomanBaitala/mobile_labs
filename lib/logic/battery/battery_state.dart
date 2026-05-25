import 'package:battery_plus/battery_plus.dart';

abstract class BatteryEvent {}

class BatteryStatusChanged extends BatteryEvent {
  final BatteryState status;
  BatteryStatusChanged(this.status);
}

class StartMonitoring extends BatteryEvent {}

class BatteryFlashlightState {
  final bool isCharging;
  final bool isFlashlightOn;
  final List<String> logs;

  BatteryFlashlightState({
    required this.isCharging,
    required this.isFlashlightOn,
    required this.logs,
  });

  factory BatteryFlashlightState.initial() {
    return BatteryFlashlightState(
      isCharging: false, isFlashlightOn: false, logs: []
    );
  }

  BatteryFlashlightState copyWith({
    bool? isCharging,
    bool? isFlashlightOn,
    List<String>? logs,
  }) {
    return BatteryFlashlightState(
      isCharging: isCharging ?? this.isCharging,
      isFlashlightOn: isFlashlightOn ?? this.isFlashlightOn,
      logs: logs ?? this.logs,
    );
  }
}
