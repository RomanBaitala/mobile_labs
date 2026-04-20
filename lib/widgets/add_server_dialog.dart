import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/servers/server_cubit.dart';
import 'package:iot_flutter_lab/logic/servers/server_state.dart';

class AddServerDialog extends StatefulWidget {
  const AddServerDialog({super.key});

  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ServerCubit>().addServer(
        _nameController.text.trim(),
        _ipController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerCubit, ServerState>(
      listener: (context, state) {
        if (state is ServerLoaded) {
          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<ServerCubit, ServerState>(
        builder: (context, state) {
          final isLoading = state is ServerLoading;

          return AlertDialog(
            title: const Text('Додати новий сервер'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Назва сервера',
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введіть назву' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ipController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      labelText: 'IP Адреса',
                      hintText: '100.x.y.z (Tailscale)',
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введіть IP' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Скасувати'),
              ),
              if (isLoading)
                const _LoadingIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _handleSave,
                  child: const Text(
                    'Додати',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
      ),
    );
  }
}
