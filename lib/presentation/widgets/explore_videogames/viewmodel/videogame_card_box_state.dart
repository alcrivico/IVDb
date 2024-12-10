enum VideogameCardBoxStatus {
  initial,
  loading,
  success,
  error,
}

class VideogameCarBoxState {
  final VideogameCardBoxStatus status;
  final String? errorMessage;
  final String? imageData;

  VideogameCarBoxState({
    required this.status,
    this.errorMessage,
    this.imageData,
  });

  factory VideogameCarBoxState.initial() =>
      VideogameCarBoxState(status: VideogameCardBoxStatus.initial);

  VideogameCarBoxState copyWith({
    VideogameCardBoxStatus? status,
    String? errorMessage,
    String? imageData,
  }) {
    return VideogameCarBoxState(
      status: status ?? this.status,
      imageData: imageData ?? this.imageData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
