import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/evaluate_application_usecase.dart';
import 'package:ivdb/presentation/viewmodels/evaluate_application/evaluate_application_state.dart';

class EvaluateApplicationViewModel
    extends StateNotifier<EvaluateApplicationState> {
  final EvaluateApplicationUseCase _evaluateApplicationUseCase;

  EvaluateApplicationViewModel(this._evaluateApplicationUseCase)
      : super(EvaluateApplicationState.initial());

  Future<void> evaluateApplication(String email, bool isApproved) async {
    // Cambia el estado a 'loading'
    state = state.copyWith(status: EvaluateApplicationStatus.loading);

    // Llama al UseCase para evaluar la solicitud
    final result = await _evaluateApplicationUseCase.call(email, isApproved);

    result.fold(
      (failure) {
        // Actualiza el estado en caso de error
        state = state.copyWith(
          status: EvaluateApplicationStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        // Actualiza el estado en caso de éxito
        state = state.copyWith(status: EvaluateApplicationStatus.success);
      },
    );
  }
}

final evaluateApplicationViewModelProvider = StateNotifierProvider<
    EvaluateApplicationViewModel, EvaluateApplicationState>((ref) {
  final useCase = ref.read(evaluateApplicationUseCaseProvider);
  return EvaluateApplicationViewModel(useCase);
});
