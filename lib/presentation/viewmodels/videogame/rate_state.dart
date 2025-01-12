enum RateStatus {
  initial,
  loading,
  success,
  noRate,
  error,
}

class RateState {
  final RateStatus status;
  final String? errorMessage;
  final int rate;

  RateState({
    required this.status,
    this.errorMessage,
    this.rate = -1,
  });

  factory RateState.initial() {
    return RateState(status: RateStatus.initial);
  }

  RateState copyWith({
    RateStatus? status,
    String? errorMessage,
    int? rate,
  }) {
    return RateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rate: rate ?? this.rate,
    );
  }
}
