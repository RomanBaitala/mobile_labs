import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/providers/auth_provider.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passController.text.trim();

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: Невірний email або пароль!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    if (success && mounted){
      Navigator.of(context).pop();
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
      body: _isLoading ? 
        const Center(child: CircularProgressIndicator()) 
        : Padding(
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
