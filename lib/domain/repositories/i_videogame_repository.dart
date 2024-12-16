import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';

abstract class IVideogameRepository {
  Future<Either<FailException, VideogameEntity>> showVideogame(
      String title, String releaseDate);

  Future<Either<FailException, List<VideogameEntity>>> showVideogamesList(
      {required int limit, required int page, required String filter});

  Future<Either<FailException, CommentEntity>> showUserComment(
      String title, String releaseDate, String email);

  Future<Either<FailException, List<CommentEntity>>> showCriticComments(
      String title, String releaseDate);

  Future<Either<FailException, List<CommentEntity>>> showPublicComments(
      String title, String releaseDate);

  Future<Either<FailException, CommentEntity>> hideComment(
      bool value, String title, DateTime releaseDate, String email);

  Future<Either<FailException, VideogameEntity>> uploadVideogame(
      String title,
      String description,
      DateTime releaseDate,
      String imageRoute,
      String developers,
      String platforms,
      String genres);

  Future<Either<FailException, Map<String, dynamic>>> updateVideogame(
      String title,
      String releaseDate,
      String newTitle,
      DateTime newReleaseDate,
      String newDescription,
      String newImageRoute,
      String newDevelopers,
      String newPlatforms,
      String newGenres);

  Future<Either<FailException, Map<String, dynamic>>> deleteVideogame(
      String title, DateTime releaseDate);
}
