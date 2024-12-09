import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class SignupUsecase {
  final IUserRepository _userRepository;

  SignupUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<FailException, UserEntity>> call(
      String username, String email, String password) {
    return _userRepository.signup(username, email, password);
  }
}

final signupUsecaseProvider = Provider<SignupUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return SignupUsecase(userRepository: userRepository);
});
