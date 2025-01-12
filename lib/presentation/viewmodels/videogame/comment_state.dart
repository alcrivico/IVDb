import 'package:ivdb/domain/entities/comment_entity.dart';

enum CommentStatus { initial, loading, success, noComment, error }

class CommentState {
  final CommentStatus status;
  final String? errorMessage;
  final CommentEntity? comment;

  CommentState({required this.status, this.errorMessage, this.comment});

  factory CommentState.initial() {
    return CommentState(status: CommentStatus.initial);
  }

  CommentState copyWith(
      {CommentStatus? status, String? errorMessage, CommentEntity? comment}) {
    return CommentState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        comment: comment ?? this.comment);
  }
}
