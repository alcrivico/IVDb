import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/user_model.dart';
import 'package:ivdb/data/services/rest/user_service.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/mappers/user_mapper.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final UserService _userService;

  UserRepository(this._userService);

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
}

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final userService = ref.read(userServiceProvider);
  return UserRepository(userService);
});
