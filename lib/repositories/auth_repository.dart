import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_flutter_lab/models/user.dart';
import 'package:iot_flutter_lab/repositories/iauth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RemoteAuthRepository implements IAuthRepository {
  static const String baseUrl = 'http://100.104.74.40:5000/api/users';

  @override
  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 201;
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
       
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString('token', data['token'] as String);

      
        debugPrint('JWT Token: ${data['token']}');
        final userData = data['user'];
        
        await prefs.setInt('user_id', userData['id'] as int);
        await prefs.setString('user_name', userData['name'] as String);
        await prefs.setString('user_email', userData['email'] as String);
        
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final name = prefs.getString('user_name');
    final id = prefs.getInt('user_id');

    if (email == null || name == null || id == null) {
      return null;
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
    );
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_id');
  }

  @override
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
