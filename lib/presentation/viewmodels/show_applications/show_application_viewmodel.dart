import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/show_applications_usecase.dart';
import 'package:ivdb/presentation/viewmodels/show_applications/show_application_state.dart';

class ShowApplicationsViewModel extends StateNotifier<ShowApplicationsState> {
  final ShowApplicationsUseCase _showApplicationsUseCase;

  ShowApplicationsViewModel(this._showApplicationsUseCase)
      : super(ShowApplicationsState.initial());

  Future<void> fetchApplications() async {
    try {
      // Cambia el estado a loading
      state = state.copyWith(status: ShowApplicationsStatus.loading);

      // Llama al caso de uso
      final response = await _showApplicationsUseCase.call();

      response.fold(
        // Manejo de error
        (failure) {
          state = state.copyWith(
            status: ShowApplicationsStatus.error,
            errorMessage: failure.message,
          );
        },
        // Manejo de éxito
        (applications) {
          state = state.copyWith(
            status: ShowApplicationsStatus.success,
            applications: applications,
          );
        },
      );
    } catch (e) {
      // Manejo genérico de errores
      state = state.copyWith(
        status: ShowApplicationsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void restart() {
    state = ShowApplicationsState.initial();
  }
}

final showApplicationsViewModelProvider =
    StateNotifierProvider<ShowApplicationsViewModel, ShowApplicationsState>((ref) {
  final showApplicationsUseCase = ref.read(showApplicationsUseCaseProvider);
  return ShowApplicationsViewModel(showApplicationsUseCase);
});
