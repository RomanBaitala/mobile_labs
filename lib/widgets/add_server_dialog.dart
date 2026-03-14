import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/server.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Додати новий сервер'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Назва сервера'),
              validator: (value) => value == null || 
                value.isEmpty ? 'Введіть назву' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'IP Адреса', hintText: '192.168.0.1'
              ),
              validator: (value) => value == null || 
                value.isEmpty ? 'Введіть IP' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newServer = ServerModel(
                id: DateTime.now().toString(),
                name: _nameController.text,
                ipAddress: _ipController.text,
                status: ServerStatus.connected,
              );
              Navigator.pop(context, newServer);
            }
          },
          child: const Text('Додати', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
