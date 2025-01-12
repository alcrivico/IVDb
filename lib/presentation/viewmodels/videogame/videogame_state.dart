import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';

enum VideogameStatus {
  initial,
  loadingVideogame,
  loadingDeleting,
  loadingRating,
  loadingComment,
  successVideogame,
  successDeleting,
  successRating,
  successComment,
  errorVideogame,
  errorDeleting,
  errorRating,
  errorComment
}

class VideogameState {
  final VideogameStatus status;
  final String? errorMessage;
  final VideogameEntity? videogame;
  final int rate;
  final CommentEntity? comment;
  //final String comment;

  VideogameState({
    required this.status,
    this.errorMessage,
    this.videogame,
    this.rate = -1,
    this.comment,
  });

  factory VideogameState.initial() {
    return VideogameState(status: VideogameStatus.initial);
  }

  VideogameState copyWith({
    VideogameStatus? status,
    String? errorMessage,
    VideogameEntity? videogame,
    int? rate,
    CommentEntity? comment,
  }) {
    return VideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      videogame: videogame ?? this.videogame,
      rate: rate ?? this.rate,
      comment: comment ?? this.comment,
    );
  }
}
