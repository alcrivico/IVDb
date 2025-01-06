import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/comment_model.dart';
import 'package:ivdb/data/models/rating_model.dart';
import 'package:ivdb/data/models/user_model.dart';
import 'package:ivdb/data/services/rest/user_service.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/mappers/application_mapper.dart';
import 'package:ivdb/domain/mappers/comment_mapper.dart';
import 'package:ivdb/domain/mappers/rating_mapper.dart';
import 'package:ivdb/domain/mappers/user_mapper.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';
import 'package:ivdb/domain/entities/rating_entity.dart';

class UserRepository implements IUserRepository {
  final UserService _userService;

  UserRepository(this._userService);

  @override
  Future<Either<FailException, UserEntity>> getUser() async {
    try {
      final result = await _userService.getUser();
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, Map<String, dynamic>>> login(
      String email, String password) async {
    try {
      final result = await _userService.login(email, password);
      final user = result['user'] as UserModel;
      result['user'] = user.toEntity();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, UserEntity>> signup(
      String username, String email, String password) async {
    try {
      final result = await _userService.signup(username, email, password);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<void> logout() {
    try {
      return _userService.logout();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<FailException, ApplicationEntity>> uploadApplication(
      String email, String request) async {
    try {
      final result = await _userService.uploadApplication(email, request);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, List<ApplicationEntity>>>
      getApplications() async {
    try {
      final result = await _userService.getApplications();
      return Right(result.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, ApplicationEntity>> getApplication(
      String email) async {
    try {
      final result = await _userService.getApplication(email);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, ApplicationEntity>> updateApplication(
      String email, String request) async {
    try {
      final result = await _userService.updateApplication(email, request);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, ApplicationEntity>> evaluateApplication(
      String email, bool state) async {
    try {
      final result = await _userService.evaluateApplication(email, state);

      // Log para verificar la respuesta del servicio
      print(
          'Respuesta de evaluateApplication en UserService: ${result.toJson()}');

      return Right(result.toEntity());
    } on DioException catch (e) {
      print('Error de DioException: ${e.response?.data}');
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      print('Error desconocido: $e');
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, Map<String, dynamic>>> uploadRating(
      String email, String title, DateTime releaseDate, int rate) async {
    try {
      final result =
          await _userService.uploadRating(email, title, releaseDate, rate);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, Map<String, dynamic>>> uploadComment(
      String email, String title, DateTime releaseDate, String comment) async {
    try {
      final result =
          await _userService.uploadComment(email, title, releaseDate, comment);
      final commentResponse = result['comment'] as CommentModel;
      result['comment'] = commentResponse.toEntity();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerException(e.response?.data['message']));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, List<RatingEntity>>> getUserRatings(
      String email) async {
    try {
      final response = await _userService.getUserRatings(email);
      final ratings = (response)
          .map((rating) => RatingModel.fromJson(rating).toEntity())
          .toList();
      return Right(ratings);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final userService = ref.read(userServiceProvider);
  return UserRepository(userService);
});
