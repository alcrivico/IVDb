import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/comment_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/delete_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/rate_videogame_usecase.dart';
import 'package:ivdb/domain/usecases/show_videogame_usecase.dart';
import 'package:ivdb/presentation/viewmodels/videogame/comment_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/rate_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogame_state.dart';

class VideogameViewModel extends StateNotifier<VideogameState> {
  final ShowVideogameUsecase _showVideogameUsecase;
  final DeleteVideogameUseCase _deleteVideogameUseCase;
  final RateVideogameUsecase _rateVideogameUsecase;
  final CommentVideogameUseCase _commentVideogameUseCase;

  VideogameViewModel(this._showVideogameUsecase, this._deleteVideogameUseCase,
      this._rateVideogameUsecase, this._commentVideogameUseCase)
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

  Future<void> deleteVideogame(
      String title, DateTime releaseDate, String imageRoute) async {
    state = state.copyWith(status: VideogameStatus.loadingDeleting);
    final result =
        await _deleteVideogameUseCase.call(title, releaseDate, imageRoute);

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

  Future<void> commentVideogame(
      String email, String title, DateTime releaseDate, String comment) async {
    state = state.copyWith(status: VideogameStatus.loadingComment);
    final result =
        await _commentVideogameUseCase.call(email, title, releaseDate, comment);

    result.fold((failure) {
      state = state.copyWith(
        status: VideogameStatus.errorComment,
        errorMessage: failure.message,
      );
    }, (success) {
      if (success.containsKey('comment')) {
        state = state.copyWith(
          status: VideogameStatus.successComment,
          comment: success['comment'],
        );
      } else {
        state = state.copyWith(
          status: VideogameStatus.errorComment,
          errorMessage: 'Respuesta inválida del servidor',
        );
      }
    });
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

  void restart() {
    state = VideogameState.initial();
  }
}

class CommentViewModel extends StateNotifier<CommentState> {
  final ShowVideogameUsecase _showVideogameUsecase;

  CommentViewModel(this._showVideogameUsecase) : super(CommentState.initial());

  Future<void> getComment(
      String title, DateTime releaseDate, String email) async {
    state = state.copyWith(status: CommentStatus.loading);
    final result =
        await _showVideogameUsecase.showUserComment(title, releaseDate, email);

    result.fold((failure) {
      state = state.copyWith(
          status: CommentStatus.noComment,
          errorMessage: failure.message,
          comment: null);
    }, (success) {
      state = state.copyWith(
          status: CommentStatus.success,
          errorMessage: "Entro en sucess",
          comment: success);

      return success.content;
    });
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
  final commentVideogameUseCase = ref.read(commentVideogameUseCaseProvider);
  return VideogameViewModel(showVideogameUsecase, deleteVideogameUseCase,
      rateVideogameUseCase, commentVideogameUseCase);
});

final rateViewModelProvider =
    StateNotifierProvider<RateViewModel, RateState>((ref) {
  final showVideogameUsecase = ref.read(showVideogameUsecaseProvider);
  return RateViewModel(showVideogameUsecase);
});

final commentViewModelProvider =
    StateNotifierProvider<CommentViewModel, CommentState>((ref) {
  final showVideogameUsecase = ref.read(showVideogameUsecaseProvider);
  return CommentViewModel(showVideogameUsecase);
});
