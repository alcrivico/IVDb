import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/delete_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/rate_videogame_usecase.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogame_state.dart';

class VideogameViewModel extends StateNotifier<VideogameState> {
  final DeleteVideogameUseCase _deleteVideogameUseCase;
  final RateVideogameUsecase _rateVideogameUsecase;

  VideogameViewModel(this._deleteVideogameUseCase, this._rateVideogameUsecase)
      : super(VideogameState.initial());

  Future<void> deleteVideogame(VideogameEntity videogame) async {
    state = state.copyWith(status: VideogameStatus.loadingDeleting);
    final result = await _deleteVideogameUseCase.call(videogame);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: VideogameStatus.errorDeleting,
          errorMessage: failure.message,
        );
        throw Exception(failure.message);
      },
      (success) {
        state = state.copyWith(status: VideogameStatus.successDeleting);
      },
    );
  }

  Future<void> rateVideogame(
      String email, String title, DateTime releaseDate, int rate) async {
    state = state.copyWith(status: VideogameStatus.loadingRating);
    final result =
        await _rateVideogameUsecase.call(email, title, releaseDate, rate);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: VideogameStatus.errorRating,
          errorMessage: failure.message,
        );
        throw Exception(failure.message);
      },
      (success) {
        state = state.copyWith(
            status: VideogameStatus.successRating, rate: success['rate']);
      },
    );
  }
}

final videogameViewModelProvider =
    StateNotifierProvider<VideogameViewModel, VideogameState>((ref) {
  final deleteVideogameUseCase = ref.read(deleteVideogameUseCaseProvider);
  final rateVideogameUseCase = ref.read(rateVideogameUsecaseProvider);
  return VideogameViewModel(deleteVideogameUseCase, rateVideogameUseCase);
});
