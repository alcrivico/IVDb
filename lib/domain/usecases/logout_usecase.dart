import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class LogoutUsecase {
  final IUserRepository _userRepository;

  LogoutUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<void> call() {
    return _userRepository.logout();
  }
}

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return LogoutUsecase(userRepository: userRepository);
});
