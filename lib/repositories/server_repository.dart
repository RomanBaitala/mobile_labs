import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:iot_flutter_lab/models/metric.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/repositories/iserver_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteServerRepository implements IServerRepository {
  static const String baseUrl = 'http://100.104.74.40:5000/api';
  static const Duration _timeout = Duration(seconds: 7);

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
      final response = await http
          .post(
            Uri.parse('$baseUrl/servers/'),
            headers: await _getHeaders(),
            body: jsonEncode({
              'name': name,
              'ip_address': ip,
              'status': 'disconnected',
            }),
          )
          .timeout(_timeout);

      return response.statusCode == 201;
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<List<ServerModel>> getServers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ownerId = prefs.getInt('user_id');
      if (ownerId == null) {
        throw 'Помилка авторизації: ID користувача відсутній';
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/servers/owner/$ownerId'),
            headers: await _getHeaders(),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((s) => ServerModel.fromJson(s as Map<String, dynamic>))
            .toList();
      } else {
        throw 'Не вдалося отримати список серверів (${response.statusCode})';
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<List<MetricModel>> getServerMetrics(int serverId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/metrics/$serverId/metrics'),
            headers: await _getHeaders(),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map((m) => MetricModel.fromJson(m as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<bool> deleteServer(int serverId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/servers/$serverId'),
            headers: await _getHeaders(),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      throw _handleException(e);
    }
  }

  String _handleException(Object e) {
    if (e is SocketException) return 'Відсутнє підключення до мережі';
    if (e is TimeoutException) return 'Сервер занадто довго не відповідає';
    return e.toString().replaceAll('Exception: ', '');
  }
}
