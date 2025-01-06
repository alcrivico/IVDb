import 'package:ivdb/domain/entities/application_entity.dart';

class ApplicationModel {
  final int id;
  final String? request;
  final DateTime? requestDate;
  final bool state;
  final int? userId;
  final String? email; 

  ApplicationModel({
    required this.id,
    this.request,
    this.requestDate,
    required this.state,
    this.userId,
    this.email, 
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
      email: json['email'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request': request,
      'requestDate': requestDate?.toIso8601String(),
      'state': state,
      'userId': userId,
      'email': email, 
    };
  }
}

// Extension to map ApplicationModel to ApplicationEntity
extension ApplicationModelMapper on ApplicationModel {
  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      request: request,
      requestDate: requestDate,
      state: state,
      userId: userId,
      email: email,
    );
  }
}
