import 'package:ivdb/domain/entities/comment_entity.dart';

enum ShowCommentsStatus {
  initial,
  loading,
  success,
  error
}

class ShowCommentsState {
  final ShowCommentsStatus status;
  final String? errorMessage;
  final List<List<CommentEntity>>? comments;

  ShowCommentsState(
    {required this.status, this.errorMessage, this.comments});

  factory ShowCommentsState.initial() =>
    ShowCommentsState(status: ShowCommentsStatus.initial);
  
  ShowCommentsState copyWith(
    {ShowCommentsStatus? status,
    String? errorMessage,
    List<List<CommentEntity>>? comments}) {
      return ShowCommentsState(
        status: status?? this.status,
        comments: comments ?? this.comments,
        errorMessage: errorMessage ?? this.errorMessage);
    }
}