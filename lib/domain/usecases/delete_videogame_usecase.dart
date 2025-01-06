import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';


class DeleteVideogameUseCase {
  final IVideogameRepository _videogameRepository;

  DeleteVideogameUseCase({required IVideogameRepository videogameRepository})
      : _videogameRepository = videogameRepository;

  Future<Either<FailException, Map<String, dynamic>>> call(
      String title, DateTime releaseDate) async {
    return await _videogameRepository.deleteVideogame(title, releaseDate);
  }
}

final deleteVideogameUseCaseProvider =
    Provider<DeleteVideogameUseCase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  return DeleteVideogameUseCase(videogameRepository: videogameRepository);
});
