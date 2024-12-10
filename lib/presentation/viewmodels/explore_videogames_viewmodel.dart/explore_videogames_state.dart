import 'package:ivdb/domain/entities/videogame_entity.dart';

enum ExploreVideogamesStatus {
  initial,
  loading,
  success,
  error,
}

class ExploreVideogamesState {
  final ExploreVideogamesStatus status;
  final String? errorMessage;
  final List<VideogameEntity>? videogames;

  ExploreVideogamesState(
      {required this.status, this.errorMessage, this.videogames});

  factory ExploreVideogamesState.initial() =>
      ExploreVideogamesState(status: ExploreVideogamesStatus.initial);

  ExploreVideogamesState copyWith(
      {ExploreVideogamesStatus? status,
      String? errorMessage,
      List<VideogameEntity>? videogames}) {
    return ExploreVideogamesState(
      status: status ?? this.status,
      videogames: videogames ?? this.videogames,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
