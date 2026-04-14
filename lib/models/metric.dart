class MetricModel {
  final int id;
  final int serverId;
  final double cpuUsage;
  final double cpuTemperature;
  final double memoryUsage;
  final DateTime timestamp;

  MetricModel({
    required this.id,
    required this.serverId,
    required this.cpuUsage,
    required this.cpuTemperature,
    required this.memoryUsage,
    required this.timestamp,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      id: json['id'] as int,
      serverId: json['server_id'] as int,
      cpuUsage: (json['cpu_usage'] as num).toDouble(),
      cpuTemperature: (json['cpu_temperature'] as num).toDouble(),
      memoryUsage: (json['memory_usage'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'server_id': serverId,
    'cpu_usage': cpuUsage,
    'cpu_temperature': cpuTemperature,
    'memory_usage': memoryUsage,
    'timestamp': timestamp.toIso8601String(),
  };
}
