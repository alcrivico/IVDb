import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'package:ivdb/data/services/rest/videogame_service.dart';
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/mappers/comment_mapper.dart';
import 'package:ivdb/domain/mappers/videogame_mapper.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';

class VideogameRepository implements IVideogameRepository {
  final VideogameService _videogameService;

  VideogameRepository(this._videogameService);

  @override
  Future<Either<FailException, VideogameEntity>> showVideogame(
      String title, DateTime releaseDate) async {
    try {
      final result = await _videogameService.showVideogame(title, releaseDate);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, List<VideogameEntity>>> showVideogamesList(
      {required int limit, required int page, required String filter}) async {
    try {
      final result = await _videogameService.showVideogamesList(
          limit: limit, page: page, filter: filter);

      return Right(result.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, CommentEntity>> showUserComment(
      String title, DateTime releaseDate, String email) async {
    try {
      final result =
          await _videogameService.showUserComment(title, releaseDate, email);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, List<CommentEntity>>> showCriticComments(
      String title, DateTime releaseDate) async {
    try {
      final result =
          await _videogameService.showCriticComments(title, releaseDate);

      return Right(result.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, List<CommentEntity>>> showPublicComments(
      String title, DateTime releaseDate) async {
    try {
      final result =
          await _videogameService.showPublicComments(title, releaseDate);

      return Right(result.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, CommentEntity>> hideComment(
      bool value, String title, DateTime releaseDate, String email) async {
    try {
      final result =
          await _videogameService.hideComment(value, title, releaseDate, email);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, VideogameEntity>> uploadVideogame(
      String title,
      String description,
      DateTime releaseDate,
      String imageRoute,
      String developers,
      String platforms,
      String genres) async {
    try {
      final result = await _videogameService.uploadVideogame(title, description,
          releaseDate, imageRoute, developers, platforms, genres);

      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, Map<String, dynamic>>> updateVideogame(
      String title,
      DateTime releaseDate,
      String newTitle,
      String newDescription,
      DateTime newReleaseDate,
      String newImageRoute,
      String newDevelopers,
      String newGenres,
      String newPlatforms) async {
    try {
      final result = await _videogameService.updateVideogame(
          title,
          releaseDate,
          newTitle,
          newDescription,
          newReleaseDate,
          newImageRoute,
          newDevelopers,
          newGenres,
          newPlatforms);

      final videogame = result['videogame'] as VideogameModel;

      result['videogame'] = videogame.toEntity();

      return Right(result);
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, Map<String, dynamic>>> deleteVideogame(
      String title, DateTime releaseDate) async {
    try {
      final result =
          await _videogameService.deleteVideogame(title, releaseDate);

      return Right(result);
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final videogameRepositoryProvider = Provider<IVideogameRepository>((ref) {
  final videogameService = ref.read(videogameServiceProvider);
  return VideogameRepository(videogameService);
});
