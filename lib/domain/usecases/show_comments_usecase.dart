import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';

class ShowCommentsUseCase {
  final IVideogameRepository _iVideogameRepository;

  ShowCommentsUseCase({required IVideogameRepository iVideogameRepository}) : _iVideogameRepository = iVideogameRepository;

  Future<Either<FailException, List<List<CommentEntity>>>> call(
  String title,
  DateTime releaseDate,
) async {
  // Obtener comentarios públicos
  final commentPublicList =
      await _iVideogameRepository.showPublicComments(title, releaseDate);

  // Obtener comentarios críticos
  final commentCriticList =
      await _iVideogameRepository.showCriticComments(title, releaseDate);

  // Combinar los resultados manejando errores
  return commentCriticList.fold(
    (fail) => Left(fail), // Si hay un error en comentarios críticos
    (criticList) {
      return commentPublicList.fold(
        (fail) => Left(fail), // Si hay un error en comentarios públicos
        (publicList) {
          // Ambos son exitosos, combinar listas
          return Right([criticList, publicList]);
        },
      );
    },
  );
}

}

final showCommentsUseCaseProvider = Provider<ShowCommentsUseCase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  return ShowCommentsUseCase(iVideogameRepository: videogameRepository);
});

