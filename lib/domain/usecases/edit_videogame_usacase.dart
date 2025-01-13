import 'dart:convert';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';
import 'package:ivdb/data/models/videogame_model.dart';
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
    VideogameModel originalVideogame, 
    VideogameModel updatedVideogame, 
    Uint8List? newImageBytes,
  ) async {
    // Subir nueva imagen si corresponde
    if (newImageBytes != null) {
      String base64Image = base64Encode(newImageBytes);

      final imageResponse = await _coverImageRepository.uploadCoverImage(
        updatedVideogame.imageRoute, // Nuevo nombre de la ruta
        base64Image,
      );

      // Manejar error en la subida de imagen
      final imageResult = imageResponse.fold(
        (fail) => fail,
        (_) => null,
      );
      if (imageResult != null) return Left(imageResult);
    }

    // Actualizar videojuego en el repositorio
    return _videogameRepository.updateVideogame(
      originalVideogame.title,
      originalVideogame.releaseDate,
      updatedVideogame.title,
      updatedVideogame.description,
      updatedVideogame.releaseDate,
      updatedVideogame.imageRoute,
      updatedVideogame.developers ?? "",
      updatedVideogame.genres ?? "",
      updatedVideogame.platforms ?? "",
    ).then((result) => result.fold(
          (fail) => Left(fail),
          (successData) {
            return Right(VideogameEntity(
              id: originalVideogame.id,
              title: updatedVideogame.title,
              description: updatedVideogame.description,
              releaseDate: updatedVideogame.releaseDate,
              imageRoute: updatedVideogame.imageRoute,
              developers: updatedVideogame.developers,
              platforms: updatedVideogame.platforms,
              genres: updatedVideogame.genres,
            ));
          },
        ));
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
