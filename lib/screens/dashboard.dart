import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/widgets/server_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server Control'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        )
      ]),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        padding: const EdgeInsets.all(16),
        children: const [
          ServerStatCard(title: 'CPU Load', value: '24%', icon: Icons.memory),
          ServerStatCard(
            title: 'RAM Usage', 
            value: '4.2/8 GB', 
            icon: Icons.storage
          ),
          ServerStatCard(title: 'Uptime', value: '12d 4h', icon: Icons.timer),
          ServerStatCard(title: 'Temp', value: '42°C', icon: Icons.thermostat),
        ],
      ),
    );
  }
}
