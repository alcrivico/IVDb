import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/application_model.dart';
import 'package:ivdb/data/models/comment_model.dart';
import 'rest_client.dart';
import '../../models/user_model.dart';


abstract class IUserService {
  Future<UserModel> getUser();

  Future<Map<String, dynamic>> login(String email, String password);

  Future<UserModel> signup(String username, String email, String password);

  Future<void> logout();

  Future<ApplicationModel> uploadApplication(String email, String request);

  Future<List<ApplicationModel>> getApplications();

  Future<ApplicationModel> getApplication(String email);

  Future<ApplicationModel> updateApplication(String email, String request);

  Future<ApplicationModel> evaluateApplication(String email, bool state);

  Future<Map<String, dynamic>> uploadRating(
      String email, String title, DateTime releaseDate, int rate);

  Future<Map<String, dynamic>> uploadComment(
      String email, String title, DateTime releaseDate, String comment);
}

class UserService implements IUserService {
  UserService({required this.restClient});

  final RestClient restClient;

  

  @override
  Future<UserModel> getUser() async {
    final data = {
      'email': 'email',
      'password': 'password',
    };

    final response = await restClient.dio.get('/user/', data: data);

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

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

  @override
  Future<ApplicationModel> uploadApplication(
      String email, String request) async {
    final data = {
      'email': email,
      'request': request,
    };

    final response = await restClient.dio.post('/user/application', data: data);

    if (response.statusCode == 200) {
      return ApplicationModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<List<ApplicationModel>> getApplications() async {
    final response = await restClient.dio.get('/user/applications');

    if (response.statusCode == 200) {
      final applications = response.data
          .map<ApplicationModel>((json) => ApplicationModel.fromJson(json))
          .toList();

      return applications;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<ApplicationModel> getApplication(String email) async {
    final data = {
      'email': email,
    };

    final response = await restClient.dio.get('/user/application', data: data);

    if (response.statusCode == 200) {
      return ApplicationModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<ApplicationModel> updateApplication(
      String email, String request) async {
    final data = {
      'email': email,
      'request': request,
    };

    final response =
        await restClient.dio.patch('/user/application', data: data);

    if (response.statusCode == 200) {
      return ApplicationModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<ApplicationModel> evaluateApplication(String email, bool state) async {
    final data = {
      'email': email,
      'state': state,
    };

    final response =
        await restClient.dio.patch('/user/application/evaluate', data: data);

    if (response.statusCode == 200) {
      return ApplicationModel.fromJson(response.data);
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<Map<String, dynamic>> uploadRating(
      String email, String title, DateTime releaseDate, int rate) async {
    final data = {
      'email': email,
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
      'rate': rate,
    };

    final response = await restClient.dio.post('/user/rating', data: data);

    if (response.statusCode == 201) {
      final message = response.data['message'];
      final rate = response.data['rate'];

      return Map<String, dynamic>.from({
        'message': message,
        'rate': rate,
      });
    } else {
      final message = response.data['message'];

      return Map<String, dynamic>.from({
        'message': message,
      });
    }
  }

  @override
  Future<Map<String, dynamic>> uploadComment(
      String email, String title, DateTime releaseDate, String comment) async {
    final data = {
      'email': email,
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
      'comment': comment,
    };

    final response = await restClient.dio.post('/user/comment', data: data);

    if (response.statusCode == 201) {
      final message = response.data['message'];
      final CommentModel comment =
          CommentModel.fromJson(response.data['comment']);

      return Map<String, dynamic>.from({
        'message': message,
        'comment': comment,
      });
    } else {
      final message = response.data['message'];

      return Map<String, dynamic>.from({
        'message': message,
      });
    }
  }

  Future<List<dynamic>> getUserRatings(String email) async {
  final response = await restClient.dio.get('/users/$email/ratings');
  return response.data;
}

}

final userServiceProvider = Provider<UserService>((ref) {
  final restClient = ref.read(restClientProvider);
  return UserService(restClient: restClient);
});
