import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_combo_box.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_image.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_state.dart';

class AddVideogameView extends ConsumerStatefulWidget {
  const AddVideogameView({super.key});

  @override
  ConsumerState<AddVideogameView> createState() => _AddVideogameViewState();
}

class _AddVideogameViewState extends ConsumerState<AddVideogameView> {
  String? selectedDeveloper;
  String? selectedGenre;
  String? selectedPlatform;
  Uint8List? selectedImageBytes;
  String? selectedImagePath;
  final TextEditingController releaseDateController = TextEditingController();
  String title = '';
  String description = '';

  final Map<String, int> developers = {
    "Bethesda Game Studios": 3,
    "CD Projekt Red": 4,
    "Epic Games": 8,
    "Naughty Dog": 5,
    "Nintendo": 6,
    "Rockstar Games": 2,
    "Ubisoft": 1,
    "Valve": 7,
  };

  final Map<String, int> genres = {
    "Action": 1,
    "Adventure": 2,
    "Horror": 8,
    "Puzzle": 7,
    "RPG": 3,
    "Simulation": 4,
    "Sports": 6,
    "Strategy": 5,
  };

  final Map<String, int> platforms = {
    "Nintendo Switch": 7,
    "PC": 1,
    "PS3": 2,
    "PS4": 5,
    "PS5": 8,
    "Wii": 4,
    "Xbox 360": 3,
    "Xbox One": 6,
    "Xbox Series X/S": 9,
  };

  void _addVideogame() {
    String dateInput = releaseDateController.text;
    RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(dateInput)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Fecha en formato incorrecto. Debe ser DD/MM/AAAA')),
      );
      return;
    }

    DateTime releaseDate =
        DateTime.parse(dateInput.split('/').reversed.join('-'));

    final addVideogameViewModel =
        ref.read(addVideogameViewModelProvider.notifier);

    addVideogameViewModel.addVideogame(
      title: title,
      description: description,
      releaseDate: releaseDate,
      imageRoute: selectedImagePath ?? '',
      imageBytes: selectedImageBytes!,
      developers: selectedDeveloper,
      platforms: selectedPlatform,
      genres: selectedGenre,
    );
  }

  @override
  Widget build(BuildContext context) {
    final addVideogameState = ref.watch(addVideogameViewModelProvider);
    final addVideogameViewModel =
        ref.read(addVideogameViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Videojuego'),
        backgroundColor: const Color(0xff1971c2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: VideogameImageBox(
                  onImageSelected: (imageBytes, imagePath) {
                    setState(() {
                      selectedImageBytes = imageBytes;
                      selectedImagePath = imagePath;
                    });
                  },
                  imageBytes: selectedImageBytes,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VideogameComboBox(
                      title: "Desarrolladores",
                      items: developers.keys.toList(),
                      selectedItem: selectedDeveloper,
                      onChanged: (value) {
                        setState(() {
                          selectedDeveloper = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VideogameComboBox(
                      title: "Géneros",
                      items: genres.keys.toList(),
                      selectedItem: selectedGenre,
                      onChanged: (value) {
                        setState(() {
                          selectedGenre = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: VideogameComboBox(
                      title: "Plataformas",
                      items: platforms.keys.toList(),
                      selectedItem: selectedPlatform,
                      onChanged: (value) {
                        setState(() {
                          selectedPlatform = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Título",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: releaseDateController,
                    decoration: InputDecoration(
                      labelText: "Fecha de lanzamiento (DD/MM/AAAA)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonBox(
                    onPressed: _addVideogame,
                    text: 'Agregar Videojuego',
                  ),
                  if (addVideogameState.status == AddVideogameStatus.loading)
                    const CircularProgressIndicator(),
                  if (addVideogameState == AddVideogameStatus.error)
                    const Text(
                      'No se pudo agregar el videojuego',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (addVideogameState == AddVideogameStatus.success)
                    const Text(
                      'Videojuego agregado con éxito',
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
