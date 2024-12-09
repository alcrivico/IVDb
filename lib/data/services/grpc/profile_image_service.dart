import 'package:ivdb/protos/generated/fileServices.pbgrpc.dart';
import 'grpc_client.dart';

class ProfileImageService {
  late final ProfileImageServiceClient _client;

  ProfileImageService(GrpcClient grpcClient) {
    _client = ProfileImageServiceClient(grpcClient.channel);
  }

  Future<ImageResponse> downloadProfileImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.downloadProfileImage(request);
  }

  Future<UploadImageResponse> uploadProfileImage(
      String fileName, String imageData) async {
    final request = UploadImageRequest()
      ..fileName = fileName
      ..imageData = imageData;
    return await _client.uploadProfileImage(request);
  }

  Future<DeleteImageResponse> deleteProfileImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.deleteProfileImage(request);
  }
}
