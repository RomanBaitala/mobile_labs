import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/servers/server_cubit.dart';
import 'package:iot_flutter_lab/logic/servers/server_state.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/widgets/add_server_dialog.dart';
import 'package:iot_flutter_lab/widgets/confirmation_dialog.dart';
import 'package:iot_flutter_lab/widgets/server_card.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerCubit, ServerState>(
      builder: (context, state) {
        final isOffline = state is ServerLoaded && state.isOffline;

        return Scaffold(
          appBar: _buildAppBar(context, isOffline),
          body: _buildBody(context, state),
          floatingActionButton: _buildFAB(context, isOffline),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isOffline) {
    return AppBar(
      title: const Text('My Servers'),
      actions: [
        if (isOffline) const Icon(Icons.wifi_off, color: Colors.red),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<ServerCubit>().fetchServers(),
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ServerState state) {
    if (state is ServerLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (state is ServerError) {
      return Center(
        child: Text(state.message, style: const TextStyle(color: Colors.red)),
      );
    }

    if (state is ServerLoaded) {
      if (state.servers.isEmpty) {
        return const Center(child: Text('У вас ще немає серверів'));
      }
      return RefreshIndicator(
        onRefresh: () => context.read<ServerCubit>().fetchServers(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.servers.length,
          itemBuilder: (context, index) =>
              _buildServerItem(context, state.servers[index]),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildServerItem(BuildContext context, ServerModel server) {
    return ServerCard(
      server: server,
      onTap: () => Navigator.pushNamed(context, '/home', arguments: server.id),
      onDelete: () => _confirmDeletion(context, server),
    );
  }

  Widget _buildFAB(BuildContext context, bool isOffline) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: isOffline ? null : () => _handleAddServer(context),
      child: Icon(Icons.add, color: isOffline ? Colors.grey : Colors.black),
    );
  }

  void _confirmDeletion(BuildContext context, ServerModel server) {
    showDialog<void>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Видалити сервер?',
        content: 'Ви впевнені, що хочете видалити "${server.name}"?',
        confirmText: 'Так, видалити',
        onConfirm: () => context.read<ServerCubit>().deleteServer(server.id),
      ),
    );
  }

  Future<void> _handleAddServer(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddServerDialog(),
    );
    if (result == true && context.mounted) {
      context.read<ServerCubit>().fetchServers();
    }
  }
}
