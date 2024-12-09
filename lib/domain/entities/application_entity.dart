class ApplicationEntity {
  final int? id;
  final String? request;
  final DateTime? requestDate;
  final bool state;
  final int? userId;

  ApplicationEntity({
    this.id,
    this.request,
    this.requestDate,
    required this.state,
    this.userId,
  });
}
