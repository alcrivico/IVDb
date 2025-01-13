import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class CommentVideogameUseCase {
  final IUserRepository _userRepository;

  CommentVideogameUseCase({required IUserRepository userRepository})
  :_userRepository = userRepository;

  Future<Either<FailException, Map<String, dynamic>>> call(
    String email, String title, DateTime releaseDate, String comment) async {
      return await _userRepository.uploadComment(email, title, releaseDate, comment);
    }
}

final commentVideogameUseCaseProvider = Provider<CommentVideogameUseCase>((ref){
  final userRepository = ref.read(userRepositoryProvider);
  return CommentVideogameUseCase(userRepository:  userRepository);
});