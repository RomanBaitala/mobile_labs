import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Підтвердження видалення'),
      content: const Text(
        'Ви впевнені, що хочете видалити акаунт? '
        'Всі ваші дані будуть стерті без можливості відновлення.'
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(); 
          },
          child: const Text('Видалити'),
        ),
      ],
    );
  }
}
