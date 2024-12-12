import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';

abstract class IVideogameRepository {
  Future<Either<FailException, List<VideogameEntity>>> showVideogamesList(
      {required int limit, required int page, required String filter});

  Future<Either<FailException, VideogameEntity>> showVideogame(
      String title, String releaseDate);
}
