import 'package:grpc/grpc.dart';

class GrpcClient {
  late ClientChannel _channel;

  GrpcClient() {
    _channel = ClientChannel(
      'localhost', // Cambiar a la dirección del servidor en la hotspot
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  ClientChannel get channel => _channel;

  Future<void> shutdown() async {
    await _channel.shutdown();
  }
}
