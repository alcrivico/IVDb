import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/comment_model.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'rest_client.dart';

abstract class IVideogameService {
  Future<VideogameModel> showVideogame(String title, String releaseDate);

  Future<List<VideogameModel>> showVideogamesList(
      {required int limit, required int page, required String filter});

  Future<CommentModel> showUserComment(
      String title, String releaseDate, String email);

  Future<List<CommentModel>> showCriticComments(
      String title, String releaseDate);

  Future<List<CommentModel>> showPublicComments(
      String title, String releaseDate);

  Future<CommentModel> hideComment(
      bool value, String title, DateTime releaseDate, String email);

  Future<VideogameModel> uploadVideogame(
      String title,
      String description,
      DateTime releaseDate,
      String imageRoute,
      String developers,
      String platforms,
      String genres);

  Future<Map<String, dynamic>> updateVideogame(
      String title,
      String releaseDate,
      String newTitle,
      String newDescription,
      DateTime newReleaseDate,
      String newImageRoute,
      String newDevelopers,
      String newGenres,
      String newPlatforms);

  Future<Map<String, dynamic>> deleteVideogame(
      String title, DateTime releaseDate);
}

class VideogameService implements IVideogameService {
  VideogameService({required this.restClient});

  final RestClient restClient;

  @override
  Future<VideogameModel> showVideogame(String title, String releaseDate) async {
    final response =
        await restClient.dio.post('/videogame/single/$title/$releaseDate');

    if (response.statusCode == 200) {
      final videogame = VideogameModel.fromJson(response.data);

      return videogame;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<List<VideogameModel>> showVideogamesList(
      {required int limit, required int page, required String filter}) async {
    final response =
        await restClient.dio.get('/videogame/group/$limit/$page/$filter');

    if (response.statusCode == 200) {
      final videogames = response.data
          .map<VideogameModel>((json) => VideogameModel.fromJson(json))
          .toList();

      return videogames;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<CommentModel> showUserComment(
      String title, String releaseDate, String email) async {
    final data = {
      'email': email,
      'title': title,
      'releaseDate': releaseDate,
    };

    final response =
        await restClient.dio.get('/videogame/comment/', data: data);

    if (response.statusCode == 200) {
      final comment = CommentModel.fromJson(response.data);

      return comment;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<List<CommentModel>> showCriticComments(
      String title, String releaseDate) async {
    final response = await restClient.dio.get('/videogame/comments/critic');

    if (response.statusCode == 200) {
      final comments = response.data
          .map<CommentModel>((json) => CommentModel.fromJson(json))
          .toList();

      return comments;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<List<CommentModel>> showPublicComments(
      String title, String releaseDate) async {
    final response = await restClient.dio.get('/videogame/comments/public');

    if (response.statusCode == 200) {
      final comments = response.data
          .map<CommentModel>((json) => CommentModel.fromJson(json))
          .toList();

      return comments;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<CommentModel> hideComment(
      bool value, String title, DateTime releaseDate, String email) async {
    final data = {
      'value': value,
      'title': title,
      'releaseDate': releaseDate,
      'email': email,
    };

    final response =
        await restClient.dio.patch('/videogame/comment/hide', data: data);

    if (response.statusCode == 200) {
      final comment = CommentModel.fromJson(response.data);

      return comment;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<VideogameModel> uploadVideogame(
      String title,
      String description,
      DateTime releaseDate,
      String imageRoute,
      String developers,
      String platforms,
      String genres) async {
    final data = {
      'title': title,
      'description': description,
      'releaseDate': releaseDate,
      'imageRoute': imageRoute,
      'developers': developers,
      'platforms': platforms,
      'genres': genres
    };

    final response = await restClient.dio.post('/videogame/add', data: data);

    if (response.statusCode == 201) {
      final videogame = VideogameModel.fromJson(response.data);

      return videogame;
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<Map<String, dynamic>> updateVideogame(
      String title,
      String releaseDate,
      String newTitle,
      String newDescription,
      DateTime newReleaseDate,
      String newImageRoute,
      String newDevelopers,
      String newGenres,
      String newPlatforms) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate,
      'newTitle': newTitle,
      'newDescription': newDescription,
      'newReleaseDate': newReleaseDate,
      'newImageRoute': newImageRoute,
      'newDevelopers': newDevelopers,
      'newGenres': newGenres,
      'newPlatforms': newPlatforms,
    };

    final response =
        await restClient.dio.patch('/videogame/change', data: data);

    if (response.statusCode == 200) {
      final videogame = VideogameModel.fromJson(response.data['videogame']);
      final message = response.data['message'];

      return Map<String, dynamic>.from({
        'videogame': videogame,
        'message': message,
      });
    } else {
      throw ServerException(response.data['message']);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteVideogame(
      String title, DateTime releaseDate) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate,
    };

    final response =
        await restClient.dio.delete('/videogame/delete', data: data);

    if (response.statusCode == 200) {
      final message = response.data['message'];

      return Map<String, dynamic>.from({
        'message': message,
      });
    } else {
      throw ServerException(response.data['message']);
    }
  }
}

final videogameServiceProvider = Provider<VideogameService>((ref) {
  final restClient = ref.read(restClientProvider);
  return VideogameService(restClient: restClient);
});
