enum ServerStatus { connected, disconnected, connectionLost, unknown }

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

  ServerModel copyWith({
    int? id,
    String? name,
    String? ipAddress,
    ServerStatus? status,
  }) {
    return ServerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      status: status ?? this.status,
    );
  }

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    ServerStatus status;
    switch (json['status']) {
      case 'connected': status = ServerStatus.connected; break;
      case 'connectionLost': status = ServerStatus.connectionLost; break;
      case 'unknown': status = ServerStatus.unknown; break;
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
