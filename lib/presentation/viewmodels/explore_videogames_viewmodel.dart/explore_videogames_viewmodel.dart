import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/explore_videogames_usecase.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames_viewmodel.dart/explore_videogames_state.dart';

class ExploreVideogamesViewmodel extends StateNotifier<ExploreVideogamesState> {
  final ExploreVideogamesUsecase _exploreVideogamesUsecase;

  ExploreVideogamesViewmodel(this._exploreVideogamesUsecase)
      : super(ExploreVideogamesState.initial());

  Future<Map<String, dynamic>> exploreVideogames(
      int limit, int page, String filter) async {
    try {
      state = state.copyWith(status: ExploreVideogamesStatus.loading);

      final response =
          await _exploreVideogamesUsecase.call(limit, page, filter);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: ExploreVideogamesStatus.error,
            errorMessage: failure.message,
          );
        },
        (data) {
          state = state.copyWith(
            status: ExploreVideogamesStatus.success,
            videogames: data,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: ExploreVideogamesStatus.error,
        errorMessage: e.toString(),
      );
    }

    return {'status': state.status, 'errorMessage': state.errorMessage};
  }

  void restart() {
    state = ExploreVideogamesState.initial();
  }
}

final exploreVideogamesViewmodelProvider =
    StateNotifierProvider<ExploreVideogamesViewmodel, ExploreVideogamesState>(
        (ref) {
  final exploreVideogamesUsecase = ref.read(exploreVideogamesUsecaseProvider);
  return ExploreVideogamesViewmodel(exploreVideogamesUsecase);
});
