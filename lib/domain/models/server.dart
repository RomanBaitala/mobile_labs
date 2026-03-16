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

  ServerModel copyWith({ServerStatus? status}) {
    return ServerModel(
      id: id,
      name: name,
      ipAddress: ipAddress,
      status: status ?? this.status,
    );
  }
}
