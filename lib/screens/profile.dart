import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/widgets/profile_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Admin_User_01', 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const Text(
              'status: Superuser', 
              style: TextStyle(color: Colors.green)
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
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
