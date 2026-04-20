import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:iot_flutter_lab/models/user.dart';
import 'package:iot_flutter_lab/repositories/iauth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteAuthRepository implements IAuthRepository {
  static const String baseUrl = 'http://100.104.74.40:5000/api/users';
  static const Duration timeout = Duration(seconds: 5);

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      return response.statusCode == 201;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is! Map<String, dynamic>) {
          throw 'Некоректна відповідь сервера';
        }

        final data = decodedBody;
        final prefs = await SharedPreferences.getInstance();

        final dynamic token = data['token'];
        if (token == null) {
          throw 'Токен відсутній у відповіді сервера';
        }
        await prefs.setString('token', token.toString());

        if (data['user'] == null) {
          throw 'Дані користувача відсутні';
        }

        final Map<String, dynamic> userData =
            data['user'] as Map<String, dynamic>;

        final user = UserModel.fromMap(userData);

        await prefs.setInt('user_id', user.id);
        await prefs.setString('user_name', user.name);
        await prefs.setString('user_email', user.email);

        return user;
      }
      return null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');

    if (id == null || name == null || email == null) return null;

    return UserModel(id: id, name: name, email: email);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }

  @override
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  String _handleError(Object e) {
    if (e is TimeoutException) return 'Сервер не відповідає';
    if (e is SocketException) return 'Відсутній інтернет';
    return e.toString();
  }
}
