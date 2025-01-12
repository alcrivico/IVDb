import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RestClient {
  late final Dio _dio;
  String? _authToken;

  RestClient({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Agregar interceptores para manejar encabezados y errores
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Agregar el token dinámicamente al encabezado 'x-token'
        if (_authToken != null &&
            !['/signup', '/login'].contains(options.path)) {
          options.headers['x-token'] = _authToken;
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Establecer el token después de login
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Eliminar el token al cerrar sesión
  void clearAuthToken() {
    _authToken = null;
  }
}

final restClientProvider = Provider<RestClient>((ref) {
  return RestClient(
      baseUrl:
          'http://localhost:8080/api'); //localhost --> Windows 10.0.2.2 --> Android
});
