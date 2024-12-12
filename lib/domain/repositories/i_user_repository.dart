import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/user_entity.dart';

abstract class IUserRepository {
  Future<Either<FailException, Map<String, dynamic>>> login(
      String email, String password);

  Future<Either<FailException, UserEntity>> signup(
      String username, String email, String password);

  Future<void> logout();
}
