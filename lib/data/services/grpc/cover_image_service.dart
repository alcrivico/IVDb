import 'package:ivdb/protos/generated/fileServices.pbgrpc.dart';
import 'grpc_client.dart';

class CoverImageService {
  late final CoverImageServiceClient _client;

  CoverImageService(GrpcClient grpcClient) {
    _client = CoverImageServiceClient(grpcClient.channel);
  }

  Future<ImageResponse> downloadCoverImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.downloadCoverImage(request);
  }

  Future<UploadImageResponse> uploadCoverImage(
      String fileName, String imageData) async {
    final request = UploadImageRequest()
      ..fileName = fileName
      ..imageData = imageData;
    return await _client.uploadCoverImage(request);
  }

  Future<DeleteImageResponse> deleteCoverImage(String path) async {
    final request = ImageRequest()..path = path;
    return await _client.deleteCoverImage(request);
  }
}
