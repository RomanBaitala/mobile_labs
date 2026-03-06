import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dns, size:80, color: Colors.green),
            const SizedBox(height: 32),
            const CustomInput(label: 'Username', icon: Icons.verified_user),
            const SizedBox(height: 16),
            const CustomInput(
              label: 'Password', 
              icon: Icons.password, 
              isPassword: true
            ),
            const SizedBox(height: 16),
            CustomLoginButton(
              buttonText: 'Login',
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            const SizedBox(height: 8), 
            AuthToggle(
              question: 'Немає акаунту?', 
              actionText: 'Зареєструватись', 
              onTap: () => Navigator.pushNamed(context, '/register')
            )
          ],
        )
      ),
    );
  }
}
