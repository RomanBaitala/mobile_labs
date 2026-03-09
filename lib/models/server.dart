enum ServerStatus { connected, disconnected, connectionLost }

class ServerModel {
  final String id;
  final String name;
  final String ipAddress;
  ServerStatus status;

  ServerModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.status,
  });
}
