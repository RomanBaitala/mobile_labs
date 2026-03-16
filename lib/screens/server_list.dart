import 'package:flutter/material.dart';

import 'package:iot_flutter_lab/domain/models/server.dart';
import 'package:iot_flutter_lab/providers/sensor_provider.dart';
import 'package:iot_flutter_lab/widgets/add_server_dialog.dart';
import 'package:iot_flutter_lab/widgets/confirmation_dialog.dart';
import 'package:iot_flutter_lab/widgets/server_card.dart';

import 'package:provider/provider.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final List<ServerModel> _servers = [
    ServerModel(
      id: '1', 
      name: 'Temp Sensor', 
      ipAddress: '192.168.1.10', 
      status: ServerStatus.connected
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Servers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); 
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _servers.length,
        itemBuilder: (context, index) {
          final server = _servers[index];
          final bool isCurrentServer = index == 0;
          return ServerCard(
            server: isCurrentServer 
              ? server.copyWith(status: _mapMqttStatus(sensorProvider))
              : server,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/dashboard',
                arguments: _servers[index],
              );
            },
            onDelete: () {
              showDialog<void>(
                context: context,
                builder: (context) => ConfirmationDialog(
                  title: 'Видалити сервер?',
                  content: 'Ви впевнені, що хочете видалити '
                    '"${_servers[index].name}"?',
                  confirmText: 'Так, видалити',
                  onConfirm: () {
                    setState(() => _servers.removeAt(index));
                  },
                ),
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final ServerModel? result = await showDialog<ServerModel>(
            context: context,
            builder: (context) => const AddServerDialog(),
          );

          if (result != null) {
            setState(() {
              _servers.add(result);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  ServerStatus _mapMqttStatus(SensorProvider provider) {
    if (!provider.isOnline) return ServerStatus.connectionLost;
    if (provider.isMqttConnected) return ServerStatus.connected;
    return ServerStatus.disconnected;
  }
}
