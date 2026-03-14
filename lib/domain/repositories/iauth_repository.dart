import 'package:iot_flutter_lab/domain/models/user.dart';

abstract class IAuthRepository {
  Future<bool> register(UserModel user);
  Future<bool> login(String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
  Future<void> deleteAccount();
}
