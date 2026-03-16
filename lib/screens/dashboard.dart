import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/domain/models/server.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final server = ModalRoute.of(context)!.settings.arguments as ServerModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(server.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusCard(server),
            const SizedBox(height: 20),
            const Text(
              'Temperature Data',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Center(
              child: Text(
                '24°C',
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ServerModel server) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.dns, color: _getStatusColor(server.status)),
        title: const Text('Connection Status'),
        trailing: Text(server.status.name.toUpperCase()),
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
