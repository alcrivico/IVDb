import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';
import 'package:ivdb/protos/generated/fileServices.pbgrpc.dart';

class DeleteVideogameUseCase {
  final IVideogameRepository _videogameRepository;
  final ICoverImageRepository _coverImageRepository;

  DeleteVideogameUseCase(
      {required IVideogameRepository videogameRepository,
      required ICoverImageRepository coverImageRepository})
      : _videogameRepository = videogameRepository,
        _coverImageRepository = coverImageRepository;

  Future<Either<FailException, DeleteImageResponse>> call(
      String title, DateTime releaseDate, String imageRoute) async {
    Either<FailException, Map<String, dynamic>> videogameDeletion =
        await _videogameRepository.deleteVideogame(title, releaseDate);

    Either<FailException, DeleteImageResponse> coverImageDeletion;

    if (videogameDeletion.isRight()) {
      coverImageDeletion = await videogameDeletion.fold(
        (fail) => Future<Either<FailException, DeleteImageResponse>>.value(
            Left(fail)),
        (deletionResponse) async {
          var deletionResult =
              await _coverImageRepository.deleteCoverImage(imageRoute);

          if (deletionResult.isLeft()) {
            return Left(
                ServerException('Error al eliminar la imagen del videojuego'));
          }
          return deletionResult.fold(
            (fail) => Left(fail),
            (response) => Right(response),
          );
        },
      );
    } else {
      coverImageDeletion =
          Left(ServerException('Error al eliminar el videojuego'));
    }

    return coverImageDeletion;
  }
}

final deleteVideogameUseCaseProvider = Provider<DeleteVideogameUseCase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  final coverImageRepository = ref.read(coverImageRepositoryProvider);
  return DeleteVideogameUseCase(
      videogameRepository: videogameRepository,
      coverImageRepository: coverImageRepository);
});
