import 'package:flutter/foundation.dart';
import 'package:iot_flutter_lab/domain/models/user.dart';
import 'package:iot_flutter_lab/domain/repositories/iauth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final IAuthRepository _repository;
  
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _currentUser;

  AuthProvider(this._repository) {
    checkAuth();
  }

  AuthStatus get status => _status;
  UserModel? get user => _currentUser;

  Future<void> checkAuth() async {
    final user = await _repository.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _repository.login(email, password);
    if (success) {
      await checkAuth();
    }
    return success;
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
