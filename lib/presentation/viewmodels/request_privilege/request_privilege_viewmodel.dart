import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/request_privilege_usecase.dart';
import 'package:ivdb/presentation/viewmodels/request_privilege/request_privilege_state.dart';

class RequestPrivilegeViewModel extends StateNotifier<RequestPrivilegeState> {
  final RequestPrivilegeUseCase _requestPrivilegeUseCase;

  RequestPrivilegeViewModel(this._requestPrivilegeUseCase)
      : super(RequestPrivilegeState.initial());

  Future<void> sendRequest(String email, String request) async {
    try {
      // Cambia el estado a `loading`
      state = state.copyWith(status: RequestPrivilegeStatus.loading);

      // Llama al caso de uso para enviar la solicitud
      final response = await _requestPrivilegeUseCase.call(email, request);

      response.fold(
        // Manejo de error
        (failure) {
          state = state.copyWith(
            status: RequestPrivilegeStatus.error,
            errorMessage: failure.message,
          );
        },
        // Manejo de éxito
        (success) {
          state = state.copyWith(status: RequestPrivilegeStatus.success, application: success);
          
        },
      );
    } catch (e) {
      // Manejo genérico de errores
      state = state.copyWith(
        status: RequestPrivilegeStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void restart() {
    state = RequestPrivilegeState.initial();
  }
}

final requestPrivilegeViewModelProvider =
    StateNotifierProvider<RequestPrivilegeViewModel, RequestPrivilegeState>(
  (ref) {
    final requestPrivilegeUseCase = ref.read(requestPrivilegeUseCaseProvider);
    return RequestPrivilegeViewModel(requestPrivilegeUseCase);
  },
);
