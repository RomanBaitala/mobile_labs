import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/auth/auth_cubit.dart';
import 'package:iot_flutter_lab/logic/auth/auth_state.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/servers');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: const _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
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
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator(color: Colors.green);
                }
                return CustomLoginButton(
                  buttonText: 'Login',
                  onPressed: () {
                    context.read<AuthCubit>().login(
                      _emailController.text.trim(),
                      _passController.text.trim(),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            AuthToggle(
              question: 'Немає акаунту?',
              actionText: 'Зареєструватись',
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }
}
