enum EvaluateApplicationStatus { initial, loading, success, error }

class EvaluateApplicationState {
  final EvaluateApplicationStatus status;
  final String? errorMessage;

  EvaluateApplicationState({
    required this.status,
    this.errorMessage,
  });

  factory EvaluateApplicationState.initial() {
    return EvaluateApplicationState(status: EvaluateApplicationStatus.initial);
  }

  EvaluateApplicationState copyWith({
    EvaluateApplicationStatus? status,
    String? errorMessage,
  }) {
    return EvaluateApplicationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
