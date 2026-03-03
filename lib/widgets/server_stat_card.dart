import 'package:flutter/material.dart';

class ServerStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color statusColor;

  const ServerStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.statusColor = Colors.green,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(icon, size: 40, color: Colors.blueGrey),
                CircleAvatar(radius: 6, backgroundColor: statusColor),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(
                fontSize: 20, 
                color: Colors.green, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}
