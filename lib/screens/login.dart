import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/repositories/auth_repository.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  final _authRepo = LocalAuthRepository();

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passController.text.trim();

    final success = await _authRepo.login(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: Невірний email або пароль!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.dns, size: 80, color: Colors.green),
              const SizedBox(height: 32),
              CustomInput(
                label: 'Email', 
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomInput(
                label: 'Password', 
                icon: Icons.password, 
                isPassword: true,
                controller: _passController,
              ),
              const SizedBox(height: 32),
              CustomLoginButton(
                buttonText: 'Login',
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 16), 
              AuthToggle(
                question: 'Немає акаунту?', 
                actionText: 'Зареєструватись', 
                onTap: () => Navigator.pushNamed(context, '/register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
