import 'package:dartz/dartz.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

abstract class ICoverImageRepository {
  Future<Either<FailException, ImageResponse>> downloadCoverImage(String path);

  Future<Either<FailException, UploadImageResponse>> uploadCoverImage(
      String fileName, String imageData);

  Future<Either<FailException, DeleteImageResponse>> deleteCoverImage(
      String path);
}
