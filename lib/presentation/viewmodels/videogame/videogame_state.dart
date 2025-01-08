enum VideogameStatus {
  initial,
  loadingRate,
  loadingDeleting,
  loadingRating,
  successRate,
  successDeleting,
  successRating,
  noRate,
  errorRate,
  errorDeleting,
  errorRating
}

class VideogameState {
  final VideogameStatus status;
  final String? errorMessage;
  final int rate;

  VideogameState({
    required this.status,
    this.errorMessage,
    this.rate = -1,
  });

  factory VideogameState.initial() {
    return VideogameState(status: VideogameStatus.initial);
  }

  VideogameState copyWith({
    VideogameStatus? status,
    String? errorMessage,
    int? rate,
  }) {
    return VideogameState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rate: rate ?? this.rate,
    );
  }
}
