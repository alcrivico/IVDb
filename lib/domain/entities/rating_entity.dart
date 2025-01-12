import 'package:ivdb/domain/entities/user_entity.dart';

class RatingEntity {
  final int id;
  final int rate;
  final DateTime? createdAt;
  final int videogameId;
  final int userId;
  final UserEntity? user;

  RatingEntity({
    required this.id,
    required this.rate,
    required this.createdAt,
    required this.videogameId,
    required this.userId,
    this.user,
  });
}
