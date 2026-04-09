import 'package:iot_flutter_lab/models/user.dart';

abstract class IAuthRepository {
  Future<bool> register(String name, String email, String password);
  Future<bool> login(String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
  Future<void> deleteAccount();
}
