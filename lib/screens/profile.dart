import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/auth/auth_cubit.dart';
import 'package:iot_flutter_lab/logic/auth/auth_state.dart';
import 'package:iot_flutter_lab/widgets/confirmation_dialog.dart';
import 'package:iot_flutter_lab/widgets/profile_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final String name = (state is Authenticated)
                ? 'User ${state.userId}'
                : 'Гість';
            final String email =
                'user_${state is Authenticated ? state.userId : 
                '0'}@system.com';

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(email, style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.grey),
                  _buildMenuTiles(context),
                  const Divider(color: Colors.grey),
                  _buildActionTiles(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuTiles(BuildContext context) {
    return Column(
      children: [
        ProfileTile(
          icon: Icons.settings_remote,
          title: 'Server Connections',
          subtitle: 'Manage SSH keys',
          onTap: () {},
        ),
        ProfileTile(
          icon: Icons.notifications_active,
          title: 'Alerts',
          subtitle: 'CPU & RAM threshold',
          onTap: () {},
        ),
        ProfileTile(
          icon: Icons.security,
          title: 'Security',
          subtitle: '2FA and Access Logs',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionTiles(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.redAccent),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.redAccent),
          ),
          onTap: cubit.logout,
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text(
            'Видалити акаунт',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _confirmDeletion(context, cubit),
        ),
      ],
    );
  }

  void _confirmDeletion(BuildContext context, AuthCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Видалити акаунт?',
        content: 'Всі ваші дані будуть стерті назавжди.',
        onConfirm: () => cubit.logout(),
      ),
    );
  }
}
