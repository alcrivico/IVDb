import 'package:ivdb/domain/mappers/user_mapper.dart';

import '../../data/models/rating_model.dart';
import '../entities/rating_entity.dart';

extension RatingModelToEntity on RatingModel {
  RatingEntity toEntity() {
    return RatingEntity(
      id: id,
      rate: rate,
      createdAt: createdAt,
      videogameId: videogameId,
      userId: userId,
      user: user?.toEntity(),
    );
  }
}

extension RatingEntityToModel on RatingEntity {
  RatingModel toModel() {
    return RatingModel(
      id: id,
      rate: rate,
      createdAt: createdAt,
      videogameId: videogameId,
      userId: userId,
      user: user?.toModel(),
    );
  }
}
