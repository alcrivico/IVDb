import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/usecases/show_comments_usecase.dart';
import 'package:ivdb/presentation/viewmodels/show_comments/show_comments_state.dart';

class ShowCommentsViewmodel extends StateNotifier<ShowCommentsState> {
  final ShowCommentsUseCase _showCommentsUseCase;

  ShowCommentsViewmodel(this._showCommentsUseCase): super(ShowCommentsState.initial());

  Future<void> showComments(String title, DateTime releaseDate) async {
    try {
      state = state.copyWith(status: ShowCommentsStatus.loading);

      final response = await _showCommentsUseCase.call(title, releaseDate);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: ShowCommentsStatus.error,
            errorMessage: failure.message,
          );
        },
        (comments) {
          state = state.copyWith(
            status: ShowCommentsStatus.success,
            comments: comments
          );
        }
      );
    } catch(e) {
      state = state.copyWith(
        status: ShowCommentsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}