import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/signup_usecase.dart';
import 'package:ivdb/presentation/viewmodels/signup/signup_state.dart';

class SignupViewModel extends StateNotifier<SignupState> {
  final SignupUsecase _signupUsecase;

  SignupViewModel(this._signupUsecase) : super(SignupState.initial());

  Future<Map<String, dynamic>> signup(String username, String email,
      String password, String confirmPassword) async {
    try {
      state = state.copyWith(status: SignupStatus.loading);

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        state = state.copyWith(
          status: SignupStatus.error,
          errorMessage: 'Todos los campos son requeridos',
        );
        return {'status': state, 'errorMessage': state.errorMessage};
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        state = state.copyWith(
          status: SignupStatus.error,
          errorMessage:
              'El correo electrónico no tiene el formato correcto, prueba cambiarlo',
        );
        return {'status': state, 'errorMessage': state.errorMessage};
      }

      if (password != confirmPassword) {
        state = state.copyWith(
          status: SignupStatus.error,
          errorMessage:
              'Las contraseñas no coinciden, digíta exactamente igual ambas contraseñas',
        );
        return {'status': state, 'errorMessage': state.errorMessage};
      }

      final response = await _signupUsecase.call(username, email, password);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: SignupStatus.error,
            errorMessage: failure.message,
          );
        },
        (data) {
          state = state.copyWith(
            status: SignupStatus.success,
            user: data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: SignupStatus.error,
        errorMessage: e.toString(),
      );
    }

    return {'status': state, 'errorMessage': state.errorMessage};
  }

  void reset() {
    state = SignupState.initial();
  }
}

final signupViewModelProvider =
    StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  final signupUsecase = ref.read(signupUsecaseProvider);
  return SignupViewModel(signupUsecase);
});
