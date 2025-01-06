import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/delete_videogame_usecase.dart';
import 'package:ivdb/presentation/viewmodels/delete_videogames/delete_videogame_state.dart';

class DeleteVideogameViewModel extends StateNotifier<DeleteVideogameState> {
  final DeleteVideogameUseCase _deleteVideogameUseCase;

  DeleteVideogameViewModel(this._deleteVideogameUseCase)
      : super(DeleteVideogameState.initial());

  Future<void> deleteVideogame(VideogameEntity videogame) async {
    state = state.copyWith(status: DeleteVideogameStatus.loading);
    final result = await _deleteVideogameUseCase.call(videogame);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: DeleteVideogameStatus.error,
          errorMessage: failure.message,
        );
        throw Exception(failure.message);
      },
      (success) {
        state = state.copyWith(status: DeleteVideogameStatus.success);
      },
    );
  }
}

final videogameDetailsViewModelProvider =
    StateNotifierProvider<DeleteVideogameViewModel, DeleteVideogameState>(
        (ref) {
  final deleteVideogameUseCase = ref.read(deleteVideogameUseCaseProvider);
  return DeleteVideogameViewModel(deleteVideogameUseCase);
});
