import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'rest_client.dart';

abstract class IVideogameService {
  Future<VideogameModel> showVideogame(String title, String releaseDate);

  Future<List<VideogameModel>> showVideogamesList(
      {required int limit, required int page, required String filter});
}

class VideogameService implements IVideogameService {
  VideogameService({required this.restClient});

  final RestClient restClient;

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
}

final videogameServiceProvider = Provider<VideogameService>((ref) {
  final restClient = ref.read(restClientProvider);
  return VideogameService(restClient: restClient);
});
