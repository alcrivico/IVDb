import 'package:ivdb/domain/entities/user_entity.dart';

enum SignupStatus {
  initial,
  loading,
  success,
  error,
}

class SignupState {
  final SignupStatus status;
  final String? errorMessage;
  final UserEntity? user;

  SignupState({required this.status, this.user, this.errorMessage});

  // Estado inicial
  factory SignupState.initial() => SignupState(status: SignupStatus.initial);

  // Métodos de conveniencia para cambiar el estado
  SignupState copyWith(
      {SignupStatus? status, String? errorMessage, UserEntity? user}) {
    return SignupState(
      status: status ?? this.status,
      user: user ?? user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
