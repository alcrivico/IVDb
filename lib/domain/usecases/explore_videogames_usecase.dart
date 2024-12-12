import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';

class ExploreVideogamesUsecase {
  final IVideogameRepository _videogameRepository;

  ExploreVideogamesUsecase({required IVideogameRepository videogameRepository})
      : _videogameRepository = videogameRepository;

  Future<Either<FailException, List<VideogameEntity>>> call(
      int limit, int page, String filter) {
    return _videogameRepository.showVideogamesList(
        limit: limit, page: page, filter: filter);
  }
}

final exploreVideogamesUsecaseProvider =
    Provider<ExploreVideogamesUsecase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  return ExploreVideogamesUsecase(videogameRepository: videogameRepository);
});
