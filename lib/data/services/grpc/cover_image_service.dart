import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/protos/generated/fileServices.pbgrpc.dart';
import 'grpc_client.dart';

abstract class ICoverImageService {
  Future<ImageResponse> downloadCoverImage(String path);

  Future<UploadImageResponse> uploadCoverImage(
      String fileName, String imageData);

  Future<DeleteImageResponse> deleteCoverImage(String path);
}

class CoverImageService implements ICoverImageService {
  late final CoverImageServiceClient _client;

  CoverImageService(GrpcClient grpcClient) {
    _client = CoverImageServiceClient(grpcClient.channel);
  }

  @override
  Future<ImageResponse> downloadCoverImage(String path) async {
    final request = ImageRequest()..path = path;
    print('Sending gRPC request to download cover image with path: $path');
    final response = await _client.downloadCoverImage(request);
    print(
        'Received gRPC response for download cover image: ${response.imageData}');
    return response;
  }

  @override
  Future<UploadImageResponse> uploadCoverImage(
      String fileName, String imageData) async {
    final request = UploadImageRequest()
      ..fileName = fileName
      ..imageData = imageData;
    print(
        'Sending gRPC request to upload cover image with fileName: $fileName');
    final response = await _client.uploadCoverImage(request);
    print('Received gRPC response for upload cover image: ${response.message}');
    return response;
  }

  @override
  Future<DeleteImageResponse> deleteCoverImage(String path) async {
    final request = ImageRequest()..path = path;
    print('Sending gRPC request to delete cover image with path: $path');
    final response = await _client.deleteCoverImage(request);
    print('Received gRPC response for delete cover image: ${response.message}');
    return response;
  }
}

final coverImageServiceProvider = Provider((ref) {
  final grpcClient = ref.read(grpcClientProvider);
  return CoverImageService(grpcClient);
});
