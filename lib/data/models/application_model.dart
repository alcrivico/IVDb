class ApplicationModel {
  final int id;
  final String? request;
  final DateTime? requestDate;
  final bool state;
  final int? userId;

  ApplicationModel({
    required this.id,
    required this.request,
    required this.requestDate,
    required this.state,
    required this.userId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      request: json['request'],
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : null,
      state: json['state'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request': request,
      'requestDate': requestDate?.toIso8601String(),
      'state': state,
      'userId': userId
    };
  }
}
