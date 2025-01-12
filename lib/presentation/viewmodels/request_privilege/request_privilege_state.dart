import 'package:ivdb/domain/entities/application_entity.dart';

enum RequestPrivilegeStatus {
  initial,
  loading,
  success,
  error,
}

class RequestPrivilegeState {
  final ApplicationEntity? application;
  final RequestPrivilegeStatus status;
  final String? errorMessage;

  RequestPrivilegeState({
    this.application,
    required this.status,
    this.errorMessage,
  });

  factory RequestPrivilegeState.initial() =>
      RequestPrivilegeState(status: RequestPrivilegeStatus.initial);

  RequestPrivilegeState copyWith({
    ApplicationEntity? application,
    RequestPrivilegeStatus? status,
    String? errorMessage,
  }) {
    return RequestPrivilegeState(
      application: application ?? this.application,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
