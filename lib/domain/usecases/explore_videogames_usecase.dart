import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class ExploreVideogamesUsecase {
  final IVideogameRepository _videogameRepository;
  final ICoverImageRepository _coverImageRepository;

  ExploreVideogamesUsecase(
      {required IVideogameRepository videogameRepository,
      required ICoverImageRepository coverImageRepository})
      : _videogameRepository = videogameRepository,
        _coverImageRepository = coverImageRepository;

  Future<Either<FailException, List<VideogameEntity>>> call(
      int limit, int page, String filter) async {
    // Obtiene la lista de videojuegos
    Either<FailException, List<VideogameEntity>> videogameList =
        await _videogameRepository.showVideogamesList(
            limit: limit, page: page, filter: filter);

    if (videogameList.isRight()) {
      // Carga las imágenes de forma concurrente
      final result = await videogameList.fold(
        (fail) => Future<Either<FailException, List<VideogameEntity>>>.value(
            Left(fail)),
        (videogames) async {
          final List<Future<void>> imageLoadingFutures = [];
          for (var videogame in videogames) {
            final imageLoadingFuture = _coverImageRepository
                .downloadCoverImage(videogame.imageRoute)
                .then((imageData) {
              imageData.fold(
                (fail) => print("Error al cargar imagen: ${fail.message}"),
                (imageResponse) {
                  videogame.imageData = imageResponse.imageData;
                },
              );
            });
            imageLoadingFutures.add(imageLoadingFuture);
          }

          // Espera a que todas las imágenes se carguen
          await Future.wait(imageLoadingFutures);
          return Right(videogames);
        },
      );

      return videogameList;
    }

    return videogameList;
  }
}

final exploreVideogamesUsecaseProvider =
    Provider<ExploreVideogamesUsecase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  final coverImageRepository = ref.read(coverImageRepositoryProvider);
  return ExploreVideogamesUsecase(
      videogameRepository: videogameRepository,
      coverImageRepository: coverImageRepository);
});
