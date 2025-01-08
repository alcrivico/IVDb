import 'package:grpc/grpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GrpcClient {
  late ClientChannel _channel;

  GrpcClient() {
    _channel = ClientChannel(
      '10.0.2.2', //Windows --> localhost // Android --> 10.0.2.2
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  ClientChannel get channel => _channel;

  Future<void> shutdown() async {
    await _channel.shutdown();
  }
}

final grpcClientProvider = Provider((ref) {
  return GrpcClient();
});
