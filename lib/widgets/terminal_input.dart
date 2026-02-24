import 'package:flutter/material.dart';

class TerminalInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const TerminalInput({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.terminal, color: Colors.green),
            SizedBox(width: 8),
            Text('Введіть команду', style: TextStyle(color: Colors.green)),
          ],
        ),
        hintText: 'Приклад: help або reset',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightGreenAccent, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.green),
        prefixIcon: Icon(Icons.code, color: Colors.green),
      ),
      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      onSubmitted: onSubmitted,
    );
  }
}
