import '../../data/models/videogame_model.dart';
import '../entities/videogame_entity.dart';

extension VideogameModelToEntity on VideogameModel {
  VideogameEntity toEntity() {
    return VideogameEntity(
      id: id,
      title: title,
      releaseDate: releaseDate,
      description: description,
      imageRoute: imageRoute,
      developers: developers,
      platforms: platforms,
      genres: genres,
      criticAvgRating: criticAvgRating,
      publicAvgRating: publicAvgRating,
    );
  }
}

extension VideogameEntityToModel on VideogameEntity {
  VideogameModel toModel() {
    return VideogameModel(
      id: id,
      title: title,
      releaseDate: releaseDate,
      description: description,
      imageRoute: imageRoute,
      developers: developers,
      platforms: platforms,
      genres: genres,
      criticAvgRating: criticAvgRating,
      publicAvgRating: publicAvgRating,
    );
  }
}
