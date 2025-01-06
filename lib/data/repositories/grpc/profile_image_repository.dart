import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/repositories/i_profile_image_repository.dart';

import '../../services/grpc/profile_image_service.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class ProfileImageRepository implements IProfileImageRepository {
  final ProfileImageService _service;

  ProfileImageRepository(this._service);

  @override
  Future<Either<FailException, DeleteImageResponse>> deleteProfileImage(
      String path) async {
    try {
      final result = await _service.deleteProfileImage(path);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, ImageResponse>> downloadProfileImage(
      String path) async {
    try {
      final result = await _service.downloadProfileImage(path);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<FailException, UploadImageResponse>> uploadProfileImage(
      String fileName, String imageData) async {
    try {
      final result = await _service.uploadProfileImage(fileName, imageData);

      return Right(result);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}

final profileImageRepositoryProvider = Provider<ProfileImageRepository>((ref) {
  final service = ref.read(profileImageServiceProvider);
  return ProfileImageRepository(service);
});
