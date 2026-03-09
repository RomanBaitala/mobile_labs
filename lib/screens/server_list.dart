import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/widgets/server_card.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final List<ServerModel> _servers = [
    ServerModel(
      id: '1', 
      name: 'Main Web Server', 
      ipAddress: '192.168.1.10', 
      status: ServerStatus.connected
    ),
    ServerModel(
      id: '2', 
      name: 'Database Node', 
      ipAddress: '192.168.1.11', 
      status: ServerStatus.connectionLost
    ),
    ServerModel(
      id: '3', 
      name: 'Backup Storage', 
      ipAddress: '10.0.0.5', 
      status: ServerStatus.disconnected
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          return ServerCard(
            server: _servers[index],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connecting to ${_servers[index].name}...')
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
