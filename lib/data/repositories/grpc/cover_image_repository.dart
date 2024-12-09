import '../../services/grpc/cover_image_service.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class CoverImageRepository {
  final CoverImageService _service;

  CoverImageRepository(this._service);

  Future<ImageResponse> downloadCoverImage(String path) {
    return _service.downloadCoverImage(path);
  }

  Future<UploadImageResponse> uploadCoverImage(
      String fileName, String imageData) {
    return _service.uploadCoverImage(fileName, imageData);
  }

  Future<DeleteImageResponse> deleteCoverImage(String path) {
    return _service.deleteCoverImage(path);
  }
}
