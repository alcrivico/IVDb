import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class EvaluateApplicationUseCase {
  final IUserRepository _userRepository;

  EvaluateApplicationUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<FailException, ApplicationEntity>> call(
    String email, bool state) async {
  return await _userRepository.evaluateApplication(email, state);
}
}

final evaluateApplicationUseCaseProvider =
    Provider<EvaluateApplicationUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return EvaluateApplicationUseCase(userRepository: userRepository);
});
