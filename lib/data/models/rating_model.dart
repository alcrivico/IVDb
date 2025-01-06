import 'package:ivdb/data/models/user_model.dart';

class RatingModel {
  final int id;
  final int rate;
  final DateTime? createdAt;
  final int videogameId;
  final int userId;
  final UserModel? user;

  RatingModel({
    required this.id,
    required this.rate,
    required this.createdAt,
    required this.videogameId,
    required this.userId,
    this.user,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rate: json['rate'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      videogameId: json['videogameId'],
      userId: json['userId'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'createdAt': createdAt?.toIso8601String(),
      'videogameId': videogameId,
      'userId': userId,
      'user': user?.toJson(),
    };
  }
}
