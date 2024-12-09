import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class LoginUsecase {
  final IUserRepository _userRepository;

  LoginUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<FailException, Map<String, dynamic>>> call(
      String email, String password) {
    return _userRepository.login(email, password);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return LoginUsecase(userRepository: userRepository);
});
