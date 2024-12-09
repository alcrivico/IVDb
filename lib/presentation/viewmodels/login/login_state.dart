import 'package:ivdb/domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;
  final UserEntity? user;

  LoginState({required this.status, this.user, this.errorMessage});

  // Estado inicial
  factory LoginState.initial() => LoginState(status: LoginStatus.initial);

  // Métodos de conveniencia para cambiar el estado
  LoginState copyWith(
      {LoginStatus? status, String? errorMessage, UserEntity? user}) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
