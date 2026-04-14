import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iot_flutter_lab/models/metric.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/repositories/iserver_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RemoteServerRepository implements IServerRepository {
  static const String baseUrl = 'http://100.104.74.40:5000/api';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<bool> addServer(String name, String ip) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/servers/'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'name': name,
          'ip_address': ip,
          'status': 'disconnected',
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ServerModel>> getServers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerId = prefs.getInt('user_id');

      if (ownerId == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/servers/owner/$ownerId'), 
        headers: await _getHeaders()
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>; 
        return data.map((dynamic s) => 
          ServerModel.fromJson(s as Map<String, dynamic>)
        ).toList();
      }
      return [];
    } on TimeoutException catch (_) {
    throw 'Сервер занадто довго не відповідає';} 
    catch (e) {
      return [];
    }
  }

  @override
  Future<List<MetricModel>> getServerMetrics(int serverId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/metrics/$serverId/metrics'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((m) => MetricModel.fromJson(m as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> deleteServer(int serverId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/servers/$serverId'),
      headers: await _getHeaders(),
    );
    return response.statusCode == 200;
  }
}
