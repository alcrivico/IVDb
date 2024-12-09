import 'package:dio/dio.dart';
import 'rest_client.dart';

class VideogameService {
  final RestClient _restClient;

  VideogameService(this._restClient);

  // Obtener información de un videojuego por título y fecha de lanzamiento
  Future<Response> fetchVideogame(String title, String releaseDate) async {
    return await _restClient.dio.get('/single/$title/$releaseDate');
  }

  // Obtener una lista de videojuegos con paginación y filtros
  Future<Response> fetchVideogames(
      {required int limit, required int page, required String filter}) async {
    return await _restClient.dio.get('/group/$limit/$page/$filter');
  }

  // Obtener un comentario de usuario
  Future<Response> fetchUserComment() async {
    return await _restClient.dio.get('/comment');
  }

  // Obtener comentarios críticos
  Future<Response> fetchCriticComments() async {
    return await _restClient.dio.get('/comments/critic');
  }

  // Obtener comentarios públicos
  Future<Response> fetchPublicComments() async {
    return await _restClient.dio.get('/comments/public');
  }

  // Ocultar un comentario
  Future<Response> hideComment(String commentId) async {
    final data = {'commentId': commentId};
    return await _restClient.dio.patch('/comment/hide', data: data);
  }

  // Agregar un nuevo videojuego
  Future<Response> addVideogame(Map<String, dynamic> videogameData) async {
    return await _restClient.dio.post('/add', data: videogameData);
  }

  // Actualizar un videojuego existente
  Future<Response> updateVideogame(Map<String, dynamic> updatedData) async {
    return await _restClient.dio.put('/change', data: updatedData);
  }

  // Eliminar un videojuego
  Future<Response> deleteVideogame(String videogameId) async {
    final data = {'videogameId': videogameId};
    return await _restClient.dio.delete('/delete', data: data);
  }
}
