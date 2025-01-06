import 'package:ivdb/domain/entities/application_entity.dart';

enum ShowApplicationsStatus {
  initial,
  loading,
  success,
  error,
}

class ShowApplicationsState {
  final ShowApplicationsStatus status;
  final String? errorMessage;
  final List<ApplicationEntity>? applications;

  ShowApplicationsState({
    required this.status,
    this.errorMessage,
    this.applications,
  });

  factory ShowApplicationsState.initial() =>
      ShowApplicationsState(status: ShowApplicationsStatus.initial);

  ShowApplicationsState copyWith({
    ShowApplicationsStatus? status,
    String? errorMessage,
    List<ApplicationEntity>? applications,
  }) {
    return ShowApplicationsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      applications: applications ?? this.applications,
    );
  }
}
