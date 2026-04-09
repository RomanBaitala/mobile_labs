import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/domain/validators/user_validator.dart';
import 'package:iot_flutter_lab/repositories/auth_repository.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _authRepo = RemoteAuthRepository();

  void _handleRegister() async {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await _authRepo.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passController.text.trim(),
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Реєстрація успішна! Тепер увійдіть.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else if (mounted) {
          throw Exception('Такий користувач вже існує або сервер недоступний');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Помилка: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
            ),
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
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.dns, size: 80, color: Colors.green),
                const SizedBox(height: 32),
                CustomInput(
                  label: 'Name',
                  icon: Icons.person,
                  controller: _nameController,
                  validation: (value) => value == null || value.isEmpty
                      ? 'Введіть ім\'я'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: 'Email',
                  icon: Icons.email,
                  controller: _emailController,
                  validation: UserValidator.validateEmail,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: 'Password',
                  icon: Icons.password,
                  isPassword: true,
                  controller: _passController,
                  validation: UserValidator.validatePassword,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  label: 'Confirm Password',
                  icon: Icons.lock_reset,
                  isPassword: true,
                  controller: _confirmPassController,
                  validation: (value) => UserValidator.validateCompPassword(
                    _passController.text,
                    value,
                  ),
                ),
                const SizedBox(height: 32),

                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.green)
                else
                  CustomLoginButton(
                    buttonText: 'Register',
                    onPressed: _handleRegister,
                  ),

                const SizedBox(height: 16),
                AuthToggle(
                  question: 'Вже маєте акаунт?',
                  actionText: 'Увійти',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
