import 'dart:convert';
import 'dart:typed_data';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/domain/usecases/edit_videogame_usacase.dart';
import 'package:ivdb/presentation/viewmodels/edit_videogame/edit_videogame_state.dart';

class EditVideogameViewModel extends StateNotifier<EditVideogameState> {
  final EditVideogameUsecase
      _editVideogameUsecase; // Almacena el videojuego original

  EditVideogameViewModel(this._editVideogameUsecase)
      : super(EditVideogameState.initial());

  Future<void> editVideogame({
    required VideogameEntity originalVideogame,
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
      // Crear modelo actualizado

      String? imageData;
      if (newImageBytes != null) {
        imageData = base64Encode(newImageBytes);
      } else {
        imageData = originalVideogame.imageData;
      }

      final updatedVideogame = VideogameEntity(
          id: originalVideogame.id,
          title: newTitle,
          description: newDescription,
          releaseDate: newReleaseDate,
          imageRoute: newImageRoute,
          imageData: imageData,
          developers: newDevelopers,
          platforms: newPlatforms,
          genres: newGenres);

      // Llamar al caso de uso
      final response = await _editVideogameUsecase.call(
        originalVideogame, // Usar el modelo original
        updatedVideogame,
      );

      response.fold(
        (failure) {
          print('EditVideogame error: ${failure.message}');
          state = state.copyWith(
            status: EditVideogameStatus.error,
            errorMessage: failure.message,
          );
        },
        (editedVideogame) {
          print('EditVideogame success');
          state = EditVideogameState(
            status: EditVideogameStatus.success,
            videogame: editedVideogame,
            errorMessage: null,
          );
          print('New state: ${state.status}');
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
