enum DeleteVideogameStatus { initial, loading, success, error }

class DeleteVideogameState {
  final DeleteVideogameStatus status;
  final String? errorMessage;

  DeleteVideogameState({
    required this.status,
    this.errorMessage,
  });

  factory DeleteVideogameState.initial() {
    return DeleteVideogameState(status: DeleteVideogameStatus.initial);
  }

  DeleteVideogameState copyWith({
    DeleteVideogameStatus? status,
    String? errorMessage,
  }) {
    return DeleteVideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
