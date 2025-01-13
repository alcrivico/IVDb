import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/comment_model.dart';
import 'package:ivdb/data/models/rating_model.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'rest_client.dart';

abstract class IVideogameService {
  Future<VideogameModel> showVideogame(String title, DateTime releaseDate);

  Future<List<VideogameModel>> showVideogamesList(
      {required int limit, required int page, required String filter});

  Future<RatingModel> showUserRating(
      String title, DateTime releaseDate, String email);

  Future<CommentModel> showUserComment(
      String title, DateTime releaseDate, String email);

  Future<List<CommentModel>> showCriticComments(
      String title, DateTime releaseDate);

  Future<List<CommentModel>> showPublicComments(
      String title, DateTime releaseDate);

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
      DateTime releaseDate,
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
  Future<VideogameModel> showVideogame(
      String title, DateTime releaseDate) async {
    String month = releaseDate.month.toString().length == 1
        ? '0${releaseDate.month}'
        : releaseDate.month.toString();
    String date = '${releaseDate.year}-${month}-${releaseDate.day}';
    final response = await restClient.dio.get('/videogame/single/$title/$date');

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
  Future<RatingModel> showUserRating(
      String title, DateTime releaseDate, String email) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
      'email': email,
    };

    try {
      final response =
          await restClient.dio.get('/videogame/rating/', data: data);

      if (response.statusCode == 200) {
        final rating = RatingModel.fromJson(response.data);

        return rating;
      } else {
        throw ServerException(response.data['message']);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Calificación no encontrada');
      } else {
        throw ServerException(e.response?.data['message']);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommentModel> showUserComment(
      String title, DateTime releaseDate, String email) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
      'email': email,
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
      String title, DateTime releaseDate) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
    };

    final response =
        await restClient.dio.get('/videogame/comments/critic', data: data);

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
      String title, DateTime releaseDate) async {
    final data = {
      'title': title,
      'releaseDate': releaseDate.toIso8601String(),
    };

    final response =
        await restClient.dio.get('/videogame/comments/public', data: data);

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
      'releaseDate': releaseDate.toIso8601String(),
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
    List<String> developersArray = developers.split(', ');
    List<String> platformsArray = platforms.split(', ');
    List<String> genresArray = genres.split(', ');
    final data = {
      'title': title,
      'description': description,
      'releaseDate': releaseDate.toIso8601String(),
      'imageRoute': imageRoute,
      'developers': developersArray,
      'platforms': platformsArray,
      'genres': genresArray,
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
      DateTime releaseDate,
      String newTitle,
      String newDescription,
      DateTime newReleaseDate,
      String newImageRoute,
      String newDevelopers,
      String newGenres,
      String newPlatforms) async {
    final List<String> newDevelopersArray =
        newDevelopers.split(',').map((e) => e.trim()).toList();
    final List<String> newGenresArray =
        newGenres.split(',').map((e) => e.trim()).toList();
    final List<String> newPlatformsArray =
        newPlatforms.split(',').map((e) => e.trim()).toList();

    String month = releaseDate.month.toString().length == 1
        ? '0${releaseDate.month}'
        : releaseDate.month.toString();
    String oldDate = '${releaseDate.year}-${month}-${releaseDate.day}';

    month = newReleaseDate.month.toString().length == 1
        ? '0${newReleaseDate.month}'
        : newReleaseDate.month.toString();

    String newDate = '${newReleaseDate.year}-${month}-${newReleaseDate.day}';

    final data = {
      'title': title,
      'releaseDate': oldDate,
      'newTitle': newTitle,
      'newDescription': newDescription,
      'newReleaseDate': newDate,
      'newImageRoute': newImageRoute,
      'newDevelopers': newDevelopersArray,
      'newGenres': newGenresArray,
      'newPlatforms': newPlatformsArray,
    };

    final response = await restClient.dio.put('/videogame/change', data: data);

    print('Service Response: ${response.data}');
    if (response.statusCode == 200) {
      final videogame =
          VideogameModel.fromJson(response.data['videogameUpdated']);
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
      'releaseDate': releaseDate.toIso8601String(),
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
