import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';

import '../../services/grpc/cover_image_service.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class CoverImageRepository implements ICoverImageRepository {
  final CoverImageService _service;

  CoverImageRepository(this._service);

  @override
  Future<Either<FailException, ImageResponse>> downloadCoverImage(
      String path) async {
    try {
      final result = await _service.downloadCoverImage(path);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, UploadImageResponse>> uploadCoverImage(
      String fileName, String imageData) async {
    try {
      final result = await _service.uploadCoverImage(fileName, imageData);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, DeleteImageResponse>> deleteCoverImage(
      String path) async {
    try {
      final result = await _service.deleteCoverImage(path);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final coverImageRepositoryProvider = Provider<CoverImageRepository>((ref) {
  final service = ref.read(coverImageServiceProvider);
  return CoverImageRepository(service);
});
