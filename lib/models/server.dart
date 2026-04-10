enum ServerStatus { connected, disconnected, connectionLost }

class ServerModel {
  final int id;
  final String name;
  final String ipAddress;
  ServerStatus status;

  ServerModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.status,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    ServerStatus status;
    switch (json['status']) {
      case 'connected': status = ServerStatus.connected; break;
      case 'connectionLost': status = ServerStatus.connectionLost; break;
      default: status = ServerStatus.disconnected;
    }

    return ServerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      ipAddress: json['ip_address'] as String,
      status: status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ip_address': ipAddress,
    'status': status.toString().split('.').last,
  };
}
