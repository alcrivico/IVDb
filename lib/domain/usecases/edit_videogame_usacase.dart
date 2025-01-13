import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';

class EditVideogameUsecase {
  final IVideogameRepository _videogameRepository;
  final ICoverImageRepository _coverImageRepository;

  EditVideogameUsecase({
    required IVideogameRepository videogameRepository,
    required ICoverImageRepository coverImageRepository,
  })  : _videogameRepository = videogameRepository,
        _coverImageRepository = coverImageRepository;

  Future<Either<FailException, VideogameEntity>> call(
    VideogameEntity originalVideogame,
    VideogameEntity updatedVideogame,
  ) async {
    try {
      // Si hay nueva imagen
      if (updatedVideogame.imageData != null) {
        final deleteResponse = await _coverImageRepository.deleteCoverImage(
          originalVideogame.imageRoute,
        );

        if (deleteResponse.isRight()) {
          final uploadResponse = await _coverImageRepository.uploadCoverImage(
            updatedVideogame.imageRoute,
            updatedVideogame.imageData!,
          );

          if (uploadResponse.isRight()) {
            final updateResponse = await _videogameRepository.updateVideogame(
              originalVideogame.title,
              originalVideogame.releaseDate,
              updatedVideogame.title,
              updatedVideogame.description,
              updatedVideogame.releaseDate,
              updatedVideogame.imageRoute,
              updatedVideogame.developers!,
              updatedVideogame.genres!,
              updatedVideogame.platforms!,
            );

            return updateResponse.fold(
              (fail) => Left(fail),
              (successData) {
                if (successData["videogame"] == null) {
                  return Left(ServerException("Invalid response format"));
                }
                return Right(successData["videogame"] as VideogameEntity);
              },
            );
          }
        }
      }

      // Si no hay nueva imagen, actualizar directamente
      final updateResponse = await _videogameRepository.updateVideogame(
        originalVideogame.title,
        originalVideogame.releaseDate,
        updatedVideogame.title,
        updatedVideogame.description,
        updatedVideogame.releaseDate,
        updatedVideogame.imageRoute,
        updatedVideogame.developers!,
        updatedVideogame.genres!,
        updatedVideogame.platforms!,
      );

      return updateResponse.fold(
        (fail) => Left(fail),
        (successData) {
          if (successData["videogame"] == null) {
            return Left(ServerException("Invalid response format"));
          }
          return Right(successData["videogame"] as VideogameEntity);
        },
      );
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final editVideogameUsecaseProvider = Provider<EditVideogameUsecase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  final coverImageRepository = ref.read(coverImageRepositoryProvider);
  return EditVideogameUsecase(
    videogameRepository: videogameRepository,
    coverImageRepository: coverImageRepository,
  );
});
