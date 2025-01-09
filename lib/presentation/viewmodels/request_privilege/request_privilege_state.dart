enum RequestPrivilegeStatus {
  initial,
  loading,
  success,
  error,
}

class RequestPrivilegeState {
  final RequestPrivilegeStatus status;
  final String? errorMessage;

  RequestPrivilegeState({
    required this.status,
    this.errorMessage,
  });

  factory RequestPrivilegeState.initial() =>
      RequestPrivilegeState(status: RequestPrivilegeStatus.initial);

  RequestPrivilegeState copyWith({
    RequestPrivilegeStatus? status,
    String? errorMessage,
  }) {
    return RequestPrivilegeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
