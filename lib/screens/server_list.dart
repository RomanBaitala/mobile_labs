import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/repositories/server_repository.dart';
import 'package:iot_flutter_lab/widgets/add_server_dialog.dart';
import 'package:iot_flutter_lab/widgets/confirmation_dialog.dart';
import 'package:iot_flutter_lab/widgets/server_card.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final RemoteServerRepository _serverRepo = RemoteServerRepository();
  List<ServerModel> _servers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServers();
  }

  Future<void> _fetchServers() async {
    setState(() => _isLoading = true);
    try {
      final servers = await _serverRepo.getServers();
      setState(() {
        _servers = servers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteServer(int id, int index) async {
    final success = await _serverRepo.deleteServer(id);
    if (success) {
      setState(() => _servers.removeAt(index));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сервер видалено'),
            backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Servers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchServers,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _servers.isEmpty
              ? const Center(child: Text('У вас ще немає серверів'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _servers.length,
                  itemBuilder: (context, index) {
                    final server = _servers[index];
                    return ServerCard(
                      server: server,
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          '/home',
                          arguments: server.id,
                        );
                      },
                      onDelete: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            title: 'Видалити сервер?',
                            content: 'Ви впевнені, що хочете видалити '
                              '"${server.name}"?',
                            confirmText: 'Так, видалити',
                            onConfirm: () => _deleteServer(server.id, index),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final bool? result = await showDialog<bool>(
            context: context,
            builder: (context) => const AddServerDialog(),
          );

          if (result == true) {
            _fetchServers();
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
