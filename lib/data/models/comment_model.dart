import 'package:ivdb/data/models/rating_model.dart';

class CommentModel {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool hidden;
  final int ratingId;
  final RatingModel? rating;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.hidden = false,
    required this.ratingId,
    this.rating,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      hidden: json['hidden'] ?? false,
      ratingId: json['ratingId'],
      rating:
          json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'hidden': hidden,
      'ratingId': ratingId,
      'rating': rating?.toJson(),
    };
  }
}
