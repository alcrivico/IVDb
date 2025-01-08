import 'package:ivdb/domain/entities/videogame_entity.dart';

enum VideogameStatus {
  initial,
  loadingVideogame,
  loadingDeleting,
  loadingRating,
  successVideogame,
  successDeleting,
  successRating,
  errorVideogame,
  errorDeleting,
  errorRating,
}

class VideogameState {
  final VideogameStatus status;
  final String? errorMessage;
  final VideogameEntity? videogame;
  final int rate;

  VideogameState({
    required this.status,
    this.errorMessage,
    this.videogame,
    this.rate = -1,
  });

  factory VideogameState.initial() {
    return VideogameState(status: VideogameStatus.initial);
  }

  VideogameState copyWith({
    VideogameStatus? status,
    String? errorMessage,
    VideogameEntity? videogame,
    int? rate,
  }) {
    return VideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      videogame: videogame ?? this.videogame,
      rate: rate ?? this.rate,
    );
  }
}
