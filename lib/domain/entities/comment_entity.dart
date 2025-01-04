import 'package:ivdb/domain/entities/rating_entity.dart';

class CommentEntity {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool hidden;
  final int ratingId;
  final RatingEntity? rating;

  CommentEntity({
    required this.id,
    required this.content,
    required this.createdAt,
    this.hidden = false,
    required this.ratingId,
    this.rating,
  });
}
