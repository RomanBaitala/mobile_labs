import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  final Connectivity _connectivity = Connectivity();
  
  List<ServerModel> _servers = [];
  bool _isLoading = true;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _fetchServers();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isNotEmpty) _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Connectivity error: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.first;
    if (!mounted) return;

    setState(() => _connectivityResult = result);

    if (result == ConnectivityResult.none) {
      _setServersUnknown();
    } else {
      _fetchServers();
    }
  }

  void _setServersUnknown() {
    setState(() {
      _servers = _servers.map((s) => 
        s.copyWith(status: ServerStatus.unknown)).toList();
    });
  }

  Future<void> _fetchServers() async {
    if (_connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
        _setServersUnknown();
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final servers = await _serverRepo.getServers();
      if (mounted) {
        setState(() {
          _servers = servers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _setServersUnknown();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteServer(int id, int index) async {
    final success = await _serverRepo.deleteServer(id);
    if (success && mounted) {
      setState(() => _servers.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сервер видалено'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = _connectivityResult == ConnectivityResult.none;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Servers'),
        actions: [
          if (isOffline) const Icon(Icons.wifi_off, color: Colors.red),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchServers),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: isOffline ? null : _handleAddServer,
        child: Icon(Icons.add, color: isOffline ? Colors.grey : Colors.black),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green)
      );
    }
    if (_servers.isEmpty) {
      return const Center(child: Text('У вас ще немає серверів'));
    }

    return RefreshIndicator(
      onRefresh: _fetchServers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _servers.length,
        itemBuilder: (context, index) {
          final server = _servers[index];
          return ServerCard(
            server: server,
            onTap: () => Navigator.pushNamed(context, '/home', arguments: server.id),
            onDelete: () => _confirmDeletion(server, index),
          );
        },
      ),
    );
  }

  void _confirmDeletion(ServerModel server, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Видалити сервер?',
        content: 'Ви впевнені, що хочете видалити "${server.name}"?',
        confirmText: 'Так, видалити',
        onConfirm: () => _deleteServer(server.id, index),
      ),
    );
  }

  Future<void> _handleAddServer() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddServerDialog(),
    );
    if (result == true) _fetchServers();
  }
}
