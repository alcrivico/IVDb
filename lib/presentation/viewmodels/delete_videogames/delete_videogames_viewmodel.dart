import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/delete_videogame_usecase.dart';

class VideogameDetailsViewModel extends StateNotifier<bool> {
  final DeleteVideogameUseCase _deleteVideogameUseCase;

  VideogameDetailsViewModel(this._deleteVideogameUseCase) : super(false);

  Future<void> deleteVideogame(String title, DateTime releaseDate) async {
    state = true; 
    final result = await _deleteVideogameUseCase.call(title, releaseDate);

    result.fold(
      (failure) {
        state = false; 
        throw Exception(failure.message); 
      },
      (success) {
        state = false; 
      },
    );
  }
}

final videogameDetailsViewModelProvider =
    StateNotifierProvider<VideogameDetailsViewModel, bool>((ref) {
  final deleteVideogameUseCase = ref.read(deleteVideogameUseCaseProvider);
  return VideogameDetailsViewModel(deleteVideogameUseCase);
});
