import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/domain/validators/user_validator.dart';
import 'package:iot_flutter_lab/logic/auth/auth_cubit.dart';
import 'package:iot_flutter_lab/logic/auth/auth_state.dart';
import 'package:iot_flutter_lab/widgets/auth_toggle_text.dart';
import 'package:iot_flutter_lab/widgets/custom_input.dart';
import 'package:iot_flutter_lab/widgets/custom_login_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: const SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(24), child: _RegisterForm()),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      final authCubit = context.read<AuthCubit>();
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      authCubit
          .register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passController.text.trim(),
          )
          .then((_) {
            if (!mounted) return;

            if (authCubit.state is! AuthError) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Реєстрація успішна! Увійдіть.'),
                  backgroundColor: Colors.green,
                ),
              );
              navigator.pushReplacementNamed('/login');
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.dns, size: 80, color: Colors.green),
          const SizedBox(height: 32),
          CustomInput(
            label: 'Name',
            icon: Icons.person,
            controller: _nameController,
            validation: (v) => v == null || v.isEmpty ? 'Введіть ім\'я' : null,
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
            validation: (v) =>
                UserValidator.validateCompPassword(_passController.text, v),
          ),
          const SizedBox(height: 32),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator(color: Colors.green);
              }
              return CustomLoginButton(
                buttonText: 'Register',
                onPressed: _onRegisterPressed,
              );
            },
          ),
          const SizedBox(height: 16),
          AuthToggle(
            question: 'Вже маєте акаунт?',
            actionText: 'Увійти',
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
