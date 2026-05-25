import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/auth/auth_state.dart';
import 'package:iot_flutter_lab/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final RemoteAuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('token');

    if (token != null && userId != null) {
      emit(Authenticated(userId));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        emit(Authenticated(user.id));
      } else {
        emit(const AuthError('Невірний логін або пароль'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final success = await _authRepository.register(name, email, password);
      if (success) {
        emit(Unauthenticated());
      } else {
        emit(const AuthError('Помилка реєстрації: користувач вже існує'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() {
    _authRepository.logout();
    emit(Unauthenticated());
  }
}
