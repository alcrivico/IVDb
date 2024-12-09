import '../../services/grpc/profile_image_service.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class ProfileImageRepository {
  final ProfileImageService _service;

  ProfileImageRepository(this._service);

  Future<ImageResponse> downloadProfileImage(String path) {
    return _service.downloadProfileImage(path);
  }

  Future<UploadImageResponse> uploadProfileImage(
      String fileName, String imageData) {
    return _service.uploadProfileImage(fileName, imageData);
  }

  Future<DeleteImageResponse> deleteProfileImage(String path) {
    return _service.deleteProfileImage(path);
  }
}
