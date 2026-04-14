import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/repositories/server_repository.dart';

class AddServerDialog extends StatefulWidget {
  const AddServerDialog({super.key});

  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  
  final _serverRepo = RemoteServerRepository();
  bool _isLoading = false;

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await _serverRepo.addServer(
          _nameController.text.trim(),
          _ipController.text.trim(),
        );

        if (success && mounted) {
          Navigator.pop(context, true); 
        } else {
          throw Exception('Не вдалося додати сервер');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Помилка: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

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
              enabled: !_isLoading,
              decoration: const InputDecoration(labelText: 'Назва сервера'),
              validator: (value) => value == null ||
                value.isEmpty ? 'Введіть назву' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ipController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'IP Адреса', 
                hintText: '100.x.y.z (Tailscale)'
              ),
              validator: (value) => value == null || 
                value.isEmpty ? 'Введіть IP' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(strokeWidth: 2)
            ),
          )
        else
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: _handleSave,
            child: const Text('Додати', style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}
