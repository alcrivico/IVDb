import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/data/models/videogame_model.dart';
import 'package:ivdb/domain/usecases/add_videogame_usecase.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_state.dart';

class AddVideogameViewModel extends StateNotifier<AddVideogameState> {
  final AddVideogameUsecase _addVideogameUsecase;

  AddVideogameViewModel(this._addVideogameUsecase)
      : super(AddVideogameState.initial());

  Future<void> addVideogame({
    required String title,
    required String description,
    required DateTime releaseDate,
    required String imageRoute, 
    required Uint8List imageBytes,
    String? developers,
    String? platforms,
    String? genres,
  }) async {
    try {
      state = state.copyWith(status: AddVideogameStatus.loading);

      // Crea un modelo de videojuego
      final videogame = VideogameModel(
        id: 0,
        title: title,
        description: description,
        releaseDate: releaseDate,
        imageRoute: imageRoute, 
        developers: developers ?? "", 
        platforms: platforms ?? "", 
        genres: genres ?? "", 
      );

      // Agrega el videojuego
      final response = await _addVideogameUsecase.call(videogame, imageBytes);

      response.fold(
        (failure) {
          state = state.copyWith(
            status: AddVideogameStatus.error,
            errorMessage: failure.message,
          );
        },
        (addedVideogame) {
          state = state.copyWith(
            status: AddVideogameStatus.success,
            videogame: addedVideogame,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AddVideogameStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void restart() {
    state = AddVideogameState.initial();
  }
}

final addVideogameViewModelProvider =
    StateNotifierProvider<AddVideogameViewModel, AddVideogameState>((ref) {
  final addVideogameUsecase = ref.read(addVideogameUsecaseProvider);
  return AddVideogameViewModel(addVideogameUsecase);
});

