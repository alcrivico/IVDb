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


class AddVideogameUsecase {
  final IVideogameRepository _videogameRepository;
  final ICoverImageRepository _coverImageRepository;

  AddVideogameUsecase({
    required IVideogameRepository videogameRepository,
    required ICoverImageRepository coverImageRepository,
  })  : _videogameRepository = videogameRepository,
        _coverImageRepository = coverImageRepository;

  Future<Either<FailException, VideogameEntity>> call(VideogameModel videogame, Uint8List imageBytes) async {
  
  String base64Image = base64Encode(imageBytes);

  final imageResponse = await _coverImageRepository.uploadCoverImage(
    videogame.imageRoute, //El nombre que tendra la ruta
    base64Image, //Para que el formato de la imagen sea valido
  );

  // Manejo de la respuesta de la subida de la imagen
  return imageResponse.fold(
    (fail) {
      return Left(fail); 
    },
    (imageUploadResponse) {
      return _videogameRepository.uploadVideogame(
        videogame.title,
        videogame.description,
        videogame.releaseDate,
        videogame.imageRoute, 
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