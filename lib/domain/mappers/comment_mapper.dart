import 'package:ivdb/domain/mappers/rating_mapper.dart';

import '../../data/models/comment_model.dart';
import '../entities/comment_entity.dart';

extension CommentModelToEntity on CommentModel {
  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      content: content,
      createdAt: createdAt,
      hidden: hidden,
      ratingId: ratingId,
      rating: rating?.toEntity(),
    );
  }
}

extension CommentEntityToModel on CommentEntity {
  CommentModel toModel() {
    return CommentModel(
      id: id,
      content: content,
      createdAt: createdAt,
      hidden: hidden,
      ratingId: ratingId,
      rating: rating?.toModel(),
    );
  }
}
