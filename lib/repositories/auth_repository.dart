import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/user.dart';
import 'package:iot_flutter_lab/repositories/iauth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements IAuthRepository {
  @override
  Future<bool> register(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_password', user.password);
    await prefs.setString('user_name', user.name);
    return true;
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPass = prefs.getString('user_password');
    return email == savedEmail && password == savedPass;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    if (email == null) return null;
    return UserModel(
      email: email,
      name: prefs.getString('user_name') ?? 'Admin',
      password: '',
    );
  }

  @override
  Future<void> logout() async {
    debugPrint('User logged out');
  }

  @override
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
