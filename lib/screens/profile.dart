import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/user.dart';
import 'package:iot_flutter_lab/repositories/auth_repository.dart';
import 'package:iot_flutter_lab/widgets/delete_account_dialog.dart';
import 'package:iot_flutter_lab/widgets/profile_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = LocalAuthRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: FutureBuilder<UserModel?>(
        future: authRepo.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green)
            );
          }

          final user = snapshot.data;

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
                  user?.name ?? 'Без імені', 
                  style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  user?.email ?? 'no-email@system.com', 
                  style: const TextStyle(color: Colors.green)
                ),
                
                const SizedBox(height: 30),
                const Divider(color: Colors.grey),

                ProfileTile(
                  icon: Icons.settings_remote,
                  title: 'Server Connections',
                  subtitle: 'Manage SSH keys and IP addresses',
                  onTap: () {},
                ),
                ProfileTile(
                  icon: Icons.notifications_active,
                  title: 'Alerts',
                  subtitle: 'CPU & RAM threshold notifications',
                  onTap: () {},
                ),
                ProfileTile(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: '2FA and Access Logs',
                  onTap: () {},
                ),
                
                const Divider(color: Colors.grey),
                
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Logout', 
                    style: TextStyle(color: Colors.redAccent)
                  ),
                  onTap: () async {
                    await authRepo.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Видалити акаунт',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => DeleteAccountDialog(
                        onConfirm: () async {
                          await authRepo.deleteAccount();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
