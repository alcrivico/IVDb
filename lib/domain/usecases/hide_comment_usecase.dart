import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';

class HideCommentUsecase {
  final IVideogameRepository _iVideogameRepository;

  HideCommentUsecase({required IVideogameRepository iVideogameRepository}) : _iVideogameRepository = iVideogameRepository;

  Future<Either<FailException, CommentEntity>> call (
    bool value, String title, DateTime releaseDate, String email) {
    return _iVideogameRepository.hideComment(value, title, releaseDate, email);
  }
}

final hideCommentUseCaseProvider = Provider<HideCommentUsecase>((ref){
  final videogameRepository = ref.read(videogameRepositoryProvider);
  return HideCommentUsecase(iVideogameRepository: videogameRepository);
});