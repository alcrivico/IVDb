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
  static final userClient =
      RestClient(baseUrl: 'http://localhost:8080/api/user');

  UserService();

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await userClient.dio.post('/login', data: data);

    if (response.statusCode == 200) {
      final token = response.headers.value('x-token');

      if (token != null) {
        userClient.setAuthToken(token);
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

    final response = await userClient.dio.post('/signup', data: data);

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      print(UserModel.fromJson(response.data));
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<void> logout() async {
    userClient.clearAuthToken();
  }
}

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
