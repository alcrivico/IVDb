import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/hide_comment_usecase.dart';
import 'package:ivdb/presentation/viewmodels/hide_comment/hide_comment_state.dart';

class HideCommentViewmodel extends StateNotifier<HideCommentState> {
  final HideCommentUsecase _hideCommentUsecase;

  HideCommentViewmodel(this._hideCommentUsecase) :super(HideCommentState.initial());

  Future<void> hideComment(bool value, String title, DateTime releaseDate, String email) async {
    try {
      state = state.copyWith(status: HideCommentStatus.loading);
      final response = await _hideCommentUsecase.call(value, title, releaseDate, email);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: HideCommentStatus.error,
            errorMessage: failure.message
          );
        },
        (hideComment) {
          state = state.copyWith(
            status: HideCommentStatus.success,
            hiddenComment: hideComment
          );
        }
      );
    } catch(e) {
      state = state.copyWith(
        status: HideCommentStatus.error,
        errorMessage: e.toString()
      );
    }
  }
}