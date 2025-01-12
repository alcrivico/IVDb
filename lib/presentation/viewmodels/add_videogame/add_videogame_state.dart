import 'package:ivdb/domain/entities/videogame_entity.dart';

enum AddVideogameStatus {
  initial,
  loading,
  success,
  error,
}

class AddVideogameState {
  final AddVideogameStatus status;
  final String? errorMessage;
  final VideogameEntity? videogame; 

  AddVideogameState({
    required this.status,
    this.errorMessage,
    this.videogame,
  });

  // Estado inicial
  factory AddVideogameState.initial() {
    return AddVideogameState(
      status: AddVideogameStatus.initial,
      errorMessage: null,
      videogame: null, 
    );
  }

  // Método para copiar con cambios
  AddVideogameState copyWith({
    AddVideogameStatus? status,
    String? errorMessage,
    VideogameEntity? videogame, 
  }) {
    return AddVideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      videogame: videogame ?? this.videogame, 
    );
  }
}
