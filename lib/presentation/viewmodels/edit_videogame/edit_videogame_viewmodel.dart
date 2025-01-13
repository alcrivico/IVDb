import 'dart:typed_data';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/edit_videogame_usacase.dart';
import 'package:ivdb/presentation/viewmodels/edit_videogame/edit_videogame_state.dart';

class EditVideogameViewModel extends StateNotifier<EditVideogameState> {
  final EditVideogameUsecase _editVideogameUsecase;
  late VideogameEntity _originalVideogame; // Almacena el videojuego original

  EditVideogameViewModel(this._editVideogameUsecase)
      : super(EditVideogameState.initial());

  void setOriginalVideogame(VideogameEntity originalVideogame) {
    _originalVideogame = originalVideogame; // Configura el videojuego original
  }

  Future<void> editVideogame({
  required String newTitle,
  required String newDescription,
  required DateTime newReleaseDate,
  required String newImageRoute,
  Uint8List? newImageBytes,
  String? newDevelopers,
  String? newPlatforms,
  String? newGenres,
}) async {
  try {
    state = state.copyWith(status: EditVideogameStatus.loading);

    // Crear modelo original a partir de la entidad
    final originalVideogameModel = VideogameModel(
      id: _originalVideogame.id,
      title: _originalVideogame.title,
      description: _originalVideogame.description,
      releaseDate: _originalVideogame.releaseDate,
      imageRoute: _originalVideogame.imageRoute,
      developers: _originalVideogame.developers,
      platforms: _originalVideogame.platforms,
      genres: _originalVideogame.genres,
    );

    // Crear modelo actualizado
    final updatedVideogame = VideogameModel(
      id: _originalVideogame.id,
      title: newTitle,
      description: newDescription,
      releaseDate: newReleaseDate,
      imageRoute: newImageRoute,
      developers: newDevelopers ?? _originalVideogame.developers,
      platforms: newPlatforms ?? _originalVideogame.platforms,
      genres: newGenres ?? _originalVideogame.genres,
    );

    // Llamar al caso de uso
    final response = await _editVideogameUsecase.call(
      originalVideogameModel, // Usar el modelo original
      updatedVideogame,
      newImageBytes,
    );

    response.fold(
      (failure) {
        state = state.copyWith(
          status: EditVideogameStatus.error,
          errorMessage: failure.message,
        );
      },
      (editedVideogame) {
        state = state.copyWith(
          status: EditVideogameStatus.success,
          videogame: editedVideogame,
        );
      },
    );
  } catch (e) {
    state = state.copyWith(
      status: EditVideogameStatus.error,
      errorMessage: e.toString(),
    );
  }
}

}


final editVideogameViewModelProvider =
    StateNotifierProvider<EditVideogameViewModel, EditVideogameState>((ref) {
  final editVideogameUsecase = ref.read(editVideogameUsecaseProvider);
  return EditVideogameViewModel(editVideogameUsecase);
});
