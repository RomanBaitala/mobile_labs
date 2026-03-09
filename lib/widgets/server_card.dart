import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/server.dart';

class ServerCard extends StatelessWidget {
  final ServerModel server;
  final VoidCallback onTap;

  const ServerCard({
    required this.server, 
    required this.onTap, 
    super.key
  });

  Color _getStatusColor() {
    switch (server.status) {
      case ServerStatus.connected: return Colors.green;
      case ServerStatus.disconnected: return Colors.grey;
      case ServerStatus.connectionLost: return Colors.red;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.dns, color: statusColor, size: 40),
        title: Text(server.name, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        subtitle: Text(server.ipAddress),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                server.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10, 
                  color: statusColor, 
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
