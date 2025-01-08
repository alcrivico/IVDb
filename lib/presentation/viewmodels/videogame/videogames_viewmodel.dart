import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/delete_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/rate_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/show_videogame_usecase.dart';
import 'package:ivdb/presentation/viewmodels/videogame/rate_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogame_state.dart';

class VideogameViewModel extends StateNotifier<VideogameState> {
  final ShowVideogameUsecase _showVideogameUsecase;
  final DeleteVideogameUseCase _deleteVideogameUseCase;
  final RateVideogameUsecase _rateVideogameUsecase;

  VideogameViewModel(this._showVideogameUsecase, this._deleteVideogameUseCase,
      this._rateVideogameUsecase)
      : super(VideogameState.initial());

  Future<VideogameEntity> showVideogame(
      String title, DateTime releaseDate, String email) async {
    state = state.copyWith(status: VideogameStatus.loadingVideogame);
    final result = await _showVideogameUsecase.call(title, releaseDate, email);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: VideogameStatus.errorVideogame,
          errorMessage: failure.message,
        );

        throw ServerException(failure.message);
      },
      (success) {
        state = state.copyWith(
          status: VideogameStatus.successVideogame,
          videogame: success,
        );
        return success;
      },
    );
  }

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

class RateViewModel extends StateNotifier<RateState> {
  final ShowVideogameUsecase _showVideogameUsecase;

  RateViewModel(this._showVideogameUsecase) : super(RateState.initial());

  Future<int> getVideogameRate(
      String title, DateTime releaseDate, String email) async {
    state = state.copyWith(status: RateStatus.loading);
    final result =
        await _showVideogameUsecase.showUserRating(title, releaseDate, email);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: RateStatus.noRate,
          errorMessage: failure.message,
          rate: -1,
        );

        return -1;
      },
      (success) {
        state = state.copyWith(
          status: RateStatus.success,
          errorMessage: 'Hasta el error mesage funciona',
          rate: success.rate,
        );

        return success.rate;
      },
    );

    return state.rate;
  }
}

final videogameViewModelProvider =
    StateNotifierProvider<VideogameViewModel, VideogameState>((ref) {
  final showVideogameUsecase = ref.read(showVideogameUsecaseProvider);
  final deleteVideogameUseCase = ref.read(deleteVideogameUseCaseProvider);
  final rateVideogameUseCase = ref.read(rateVideogameUsecaseProvider);
  return VideogameViewModel(
      showVideogameUsecase, deleteVideogameUseCase, rateVideogameUseCase);
});

final rateViewModelProvider =
    StateNotifierProvider<RateViewModel, RateState>((ref) {
  final showVideogameUsecase = ref.read(showVideogameUsecaseProvider);
  return RateViewModel(showVideogameUsecase);
});
