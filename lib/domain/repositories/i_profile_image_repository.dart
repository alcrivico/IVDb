import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

abstract class IProfileImageRepository {
  Future<Either<FailException, ImageResponse>> downloadProfileImage(
      String path);

  Future<Either<FailException, UploadImageResponse>> uploadProfileImage(
      String fileName, String imageData);

  Future<Either<FailException, DeleteImageResponse>> deleteProfileImage(
      String path);
}
