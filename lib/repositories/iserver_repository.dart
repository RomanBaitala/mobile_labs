import 'package:iot_flutter_lab/models/metric.dart';
import 'package:iot_flutter_lab/models/server.dart';

abstract class IServerRepository {
  Future<List<ServerModel>> getServers();
  Future<bool> addServer(String name, String ip);
  Future<List<MetricModel>> getServerMetrics(int serverId);
  Future<bool> deleteServer(int serverId);
}
