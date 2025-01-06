import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';


class AddVideogameUsecase {
  final IVideogameRepository _videogameRepository;
  final ICoverImageRepository _coverImageRepository;

  AddVideogameUsecase({
    required IVideogameRepository videogameRepository,
    required ICoverImageRepository coverImageRepository,
  })  : _videogameRepository = videogameRepository,
        _coverImageRepository = coverImageRepository;

  Future<Either<FailException, VideogameEntity>> call(VideogameModel videogame) async {
  // Usa el nombre del archivo que ya está establecido como imageRoute
  final imageResponse = await _coverImageRepository.uploadCoverImage(
    videogame.imageRoute, // Usa el nombre del archivo aquí
    videogame.imageRoute, // Esto puede ser la ruta original o los datos de la imagen
  );

  // Manejo de la respuesta de la subida de la imagen
  return imageResponse.fold(
    (fail) {
      return Left(fail); // Retorna el error si falla la subida
    },
    (imageUploadResponse) {
      return _videogameRepository.uploadVideogame(
        videogame.title,
        videogame.description,
        videogame.releaseDate,
        videogame.imageRoute, // La ruta será solo el nombre de la imagen
        videogame.developers ?? "",
        videogame.platforms ?? "",
        videogame.genres ??"",
      );
    },
  );
}

}

final addVideogameUsecaseProvider = Provider<AddVideogameUsecase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  final coverImageRepository = ref.read(coverImageRepositoryProvider);
  return AddVideogameUsecase(
    videogameRepository: videogameRepository,
    coverImageRepository: coverImageRepository,
  );
});