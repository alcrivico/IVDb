import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/login_usecase.dart';
import 'package:ivdb/domain/usecases/logout_usecase.dart';
import 'package:ivdb/presentation/viewmodels/login/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  LoginViewModel(this._loginUsecase, this._logoutUsecase)
      : super(LoginState.initial());

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      state = state.copyWith(status: LoginStatus.loading);

      final response = await _loginUsecase.call(email, password);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: LoginStatus.error,
            errorMessage: failure.message,
          );
        },
        (data) {
          state = state.copyWith(
            status: LoginStatus.success,
            user: data['user'],
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      );
    }

    return {'status': state.status, 'errorMessage': state.errorMessage};
  }

  void logout() {
    try {
      _logoutUsecase.call();
      state = LoginState.initial();
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final loginUsecase = ref.read(loginUsecaseProvider);
  final logoutUsecase = ref.read(logoutUsecaseProvider);
  return LoginViewModel(loginUsecase, logoutUsecase);
});
