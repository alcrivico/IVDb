import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class RequestPrivilegeUseCase {
  final IUserRepository _userRepository;

  RequestPrivilegeUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<FailException, bool>> call(String email, String request) async {
    try {
      final result = await _userRepository.updateApplication(email, request);

      if (result.isRight()) {
        return const Right(true); // Solicitud enviada con éxito
      }

      return Left(result.fold((l) => l, (r) => ServerException('Error')));
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final requestPrivilegeUseCaseProvider =
    Provider<RequestPrivilegeUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return RequestPrivilegeUseCase(userRepository: userRepository);
});
