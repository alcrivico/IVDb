import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/usecases/download_cover_usecase.dart';
import 'videogame_card_box_state.dart';

class VideogameCarBoxViewmodel extends StateNotifier<VideogameCarBoxState> {
  final DownloadCoverUsecase _downloadCoverUsecase;

  VideogameCarBoxViewmodel(this._downloadCoverUsecase)
      : super(VideogameCarBoxState.initial());

  Future<String?> downloadCover(String path) async {
    try {
      state = state.copyWith(status: VideogameCardBoxStatus.loading);

      final response = await _downloadCoverUsecase.call(path);

      return response.fold(
        (failure) {
          state = state.copyWith(
            status: VideogameCardBoxStatus.error,
            errorMessage: failure.message,
          );
          throw ServerException(failure.message);
        },
        (data) {
          state = state.copyWith(
              status: VideogameCardBoxStatus.success,
              imageData: data.imageData);
          return data.imageData;
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: VideogameCardBoxStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final videogameCarBoxViewmodelProvider =
    StateNotifierProvider<VideogameCarBoxViewmodel, VideogameCarBoxState>(
        (ref) {
  final downloadCoverUsecase = ref.read(downloadCoverUsecaseProvider);
  return VideogameCarBoxViewmodel(downloadCoverUsecase);
});
