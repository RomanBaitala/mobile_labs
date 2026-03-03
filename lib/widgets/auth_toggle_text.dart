import 'package:flutter/material.dart';

class AuthToggle extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const AuthToggle({
    required this.question,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16
            ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
        ),
      ],
    );
  }
}