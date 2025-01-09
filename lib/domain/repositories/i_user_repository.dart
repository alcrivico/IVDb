import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/entities/rating_entity.dart';

abstract class IUserRepository {
  Future<Either<FailException, UserEntity>> getUser(
      String email, String password);

  Future<Either<FailException, Map<String, dynamic>>> login(
      String email, String password);

  Future<Either<FailException, UserEntity>> signup(
      String username, String email, String password);

  Future<void> logout();

  Future<Either<FailException, ApplicationEntity>> uploadApplication(
      String email, String request);

  Future<Either<FailException, List<ApplicationEntity>>> getApplications();

  Future<Either<FailException, ApplicationEntity>> getApplication(String email);

  Future<Either<FailException, ApplicationEntity>> updateApplication(
      String email, String request);

  Future<Either<FailException, ApplicationEntity>> evaluateApplication(
      String email, bool state);

  Future<Either<FailException, Map<String, dynamic>>> uploadRating(
      String email, String title, DateTime releaseDate, int rate);

  Future<Either<FailException, Map<String, dynamic>>> uploadComment(
      String email, String title, DateTime releaseDate, String comment);

  Future<Either<FailException, List<RatingEntity>>> getUserRatings(
      String email);
}
