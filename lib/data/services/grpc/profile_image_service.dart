import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/protos/generated/fileServices.pbgrpc.dart';
import 'grpc_client.dart';

abstract class IProfileImageService {
  Future<ImageResponse> downloadProfileImage(String path);

  Future<UploadImageResponse> uploadProfileImage(
      String fileName, String imageData);

  Future<DeleteImageResponse> deleteProfileImage(String path);
}

class ProfileImageService implements IProfileImageService {
  late final ProfileImageServiceClient _client;

  ProfileImageService(GrpcClient grpcClient) {
    _client = ProfileImageServiceClient(grpcClient.channel);
  }

  @override
  Future<ImageResponse> downloadProfileImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.downloadProfileImage(request);
  }

  @override
  Future<UploadImageResponse> uploadProfileImage(
      String fileName, String imageData) async {
    final request = UploadImageRequest()
      ..fileName = fileName
      ..imageData = imageData;
    return await _client.uploadProfileImage(request);
  }

  @override
  Future<DeleteImageResponse> deleteProfileImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.deleteProfileImage(request);
  }
}

final profileImageServiceProvider = Provider((ref) {
  final grpcClient = ref.read(grpcClientProvider);
  return ProfileImageService(grpcClient);
});
