import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class RateVideogameUsecase {
  final IUserRepository _userRepository;

  RateVideogameUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  Future<Either<FailException, Map<String, dynamic>>> call(
      String email, String title, DateTime releaseDate, int rate) async {
    return await _userRepository.uploadRating(email, title, releaseDate, rate);
  }
}

final rateVideogameUsecaseProvider = Provider<RateVideogameUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return RateVideogameUsecase(userRepository: userRepository);
});
