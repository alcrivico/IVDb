import 'package:ivdb/domain/entities/comment_entity.dart';

enum HideCommentStatus {
  initial,
  loading,
  success, 
  error
}

class HideCommentState {
  final HideCommentStatus status;
  final String? errorMessage;
  final CommentEntity? hiddenComment;

  HideCommentState(
    {required this.status, this.errorMessage, this.hiddenComment});
  
  factory HideCommentState.initial() =>
    HideCommentState(status: HideCommentStatus.initial);

  HideCommentState copyWith(
    {HideCommentStatus? status,
    String? errorMessage,
    CommentEntity? hiddenComment}) {
      return HideCommentState(
        status: status?? this.status,
        hiddenComment: hiddenComment?? this.hiddenComment,
        errorMessage: errorMessage?? this.errorMessage);
    }
}

