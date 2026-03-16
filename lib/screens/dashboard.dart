import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/domain/models/server.dart';
import 'package:iot_flutter_lab/providers/sensor_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final server = ModalRoute.of(context)!.settings.arguments as ServerModel;
    final sensorProvider = context.watch<SensorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(server.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.sensors,
              color: sensorProvider.isMqttConnected 
                ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(server),
                  const SizedBox(height: 40),
                  
                  const Center(
                    child: Text(
                      'Temperature Data',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          sensorProvider.temperature != '--' 
                              ? '${sensorProvider.temperature}°C' 
                              : '--°C',
                          style: TextStyle(
                            fontSize: 48, 
                            fontWeight: FontWeight.bold,
                            color: sensorProvider.isOnline 
                              ? Colors.white : Colors.white24,
                          ),
                        ),
                        if (sensorProvider.isOnline 
                          && !sensorProvider.isMqttConnected)
                          const Text(
                            'Connecting to MQTT...',
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 65, 65, 65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSmallStatus('MQTT',
                          sensorProvider.isMqttConnected),
                        _buildSmallStatus('NETWORK', sensorProvider.isOnline),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatus(String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatusCard(ServerModel server) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(Icons.dns, color: _getStatusColor(server.status)),
        title: const Text('Server Node Status'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(server.status),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            server.status.name.toUpperCase(),
            style: TextStyle(
              color: _getStatusColor(server.status),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ServerStatus status) {
    switch (status) {
      case ServerStatus.connected: return Colors.green;
      case ServerStatus.disconnected: return Colors.grey;
      case ServerStatus.connectionLost: return Colors.red;
    }
  }
}
