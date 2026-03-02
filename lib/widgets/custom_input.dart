import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;

  const CustomInput({
    required this.label,
    required this.icon,
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2)
        )
      ),
    );
  }
}
