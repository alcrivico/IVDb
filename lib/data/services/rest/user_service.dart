import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'rest_client.dart';
import '../../models/user_model.dart';

abstract class IUserService {
  Future<Map<String, dynamic>> login(String email, String password);

  Future<UserModel> signup(String username, String email, String password);

  Future<void> logout();
}

class UserService implements IUserService {
  UserService({required this.restClient});

  final RestClient restClient;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await restClient.dio.post('/user/login', data: data);

    if (response.statusCode == 200) {
      final token = response.headers.value('x-token');

      if (token != null) {
        restClient.setAuthToken(token);
      } else {
        throw ServerException(
            'Token no encontrado en la respuesta del servidor');
      }

      final message = response.data['message'];
      final user = UserModel.fromJson(response.data['user']);

      return Map<String, dynamic>.from({
        'message': message,
        'user': user,
      });
    } else {
      final message = response.data['message'];

      return Map<String, dynamic>.from({
        'message': message,
      });
    }
  }

  @override
  Future<UserModel> signup(
      String username, String email, String password) async {
    final data = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await restClient.dio.post('/user/signup', data: data);

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<void> logout() async {
    restClient.clearAuthToken();
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  final restClient = ref.read(restClientProvider);
  return UserService(restClient: restClient);
});
