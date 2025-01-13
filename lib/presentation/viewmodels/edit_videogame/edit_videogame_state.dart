import 'package:ivdb/domain/entities/videogame_entity.dart';

enum EditVideogameStatus {
  initial,
  loading,
  success,
  error,
}

class EditVideogameState {
  final EditVideogameStatus status;
  final String? errorMessage;
  final VideogameEntity? videogame;

  EditVideogameState({
    required this.status,
    this.errorMessage,
    this.videogame,
  });

  factory EditVideogameState.initial() {
    return EditVideogameState(
      status: EditVideogameStatus.initial,
      errorMessage: null,
      videogame: null,
    );
  }

  EditVideogameState copyWith({
    EditVideogameStatus? status,
    String? errorMessage,
    VideogameEntity? videogame,
  }) {
    return EditVideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      videogame: videogame ?? this.videogame,
    );
  }
}
