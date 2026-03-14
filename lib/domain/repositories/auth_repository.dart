import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iot_flutter_lab/domain/models/user.dart';
import 'package:iot_flutter_lab/domain/repositories/iauth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements IAuthRepository {
  static const _keyEamil = 'user_email';
  static const _keyName = 'user_name';
  static const _keyPassword = 'user_password';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<bool> register(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyEamil, user.email);
    await prefs.setString(_keyName, user.name);

    await _secureStorage.write(key: _keyPassword, value: user.password);

    return true;
  }

  @override
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(_keyEamil);
    final savedPass = await _secureStorage.read(key: _keyPassword);

    return email == savedEmail && password == savedPass;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEamil);
    final name = prefs.getString(_keyName);
    if (email == null) return null;
    
    return UserModel(
      email: email,
      name: name ?? 'User',
      password: '',
    );
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secureStorage.deleteAll();
  }

  @override
  Future<void> deleteAccount() async {
    Future<void> deleteAccount() async => await logout();
  }
}
