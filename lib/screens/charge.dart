import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/battery/battery_bloc.dart';
import 'package:iot_flutter_lab/logic/battery/battery_state.dart';

class ChargingPage extends StatelessWidget {
  const ChargingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BatteryFlashlightBloc()..add(StartMonitoring()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Зарядка & Ліхтарик')),
        body: BlocBuilder<BatteryFlashlightBloc, BatteryFlashlightState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 40),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.isFlashlightOn ?
                     Colors.yellow.withValues(alpha: 0.3) : Colors.grey[200],
                  ),
                  child: Icon(
                    state.isFlashlightOn ? 
                      Icons.lightbulb : Icons.lightbulb_outline,
                    size: 100,
                    color: state.isFlashlightOn ? Colors.orange : Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  state.isCharging ? 'ЗАРЯДЖАЄТЬСЯ' : 'ЖИВЛЕННЯ ВІДСУТНЄ',
                  style: 
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (context, index) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.flash_on, size: 16),
                      title: Text(state.logs[index]),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
