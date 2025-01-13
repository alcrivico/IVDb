import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/screens/videogame/videogame_view.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_image.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_multi_combo_box.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_state.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';

class AddVideogameView extends ConsumerStatefulWidget {
  final UserEntity user;
  const AddVideogameView({super.key, required this.user});

  @override
  ConsumerState<AddVideogameView> createState() => _AddVideogameViewState();
}

class _AddVideogameViewState extends ConsumerState<AddVideogameView> {
  List<String> selectedDevelopers = [];
  List<String> selectedGenres = [];
  List<String> selectedPlatforms = [];
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
      imageRoute: selectedImagePath?.split(RegExp(r'[/\\]')).last ?? '',
      imageBytes: selectedImageBytes!,
      developers: selectedDevelopers.join(', '),
      platforms: selectedPlatforms.join(', '),
      genres: selectedGenres.join(', '),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addVideogameState = ref.watch(addVideogameViewModelProvider);

    ref.listen<AddVideogameState>(addVideogameViewModelProvider,
        (previous, next) {
      if (next.status == AddVideogameStatus.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => VideogameView(
                      title: title,
                      releaseDate: DateTime.parse(releaseDateController.text
                          .split('/')
                          .reversed
                          .join('-')),
                      imageData: base64Encode(selectedImageBytes!),
                      user: widget.user,
                    )),
            (Route<dynamic> route) => false,
          );
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: HomeBox(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreVideogamesView(widget.user)),
              (Route<dynamic> route) =>
                  false, // Elimina todas las rutas anteriores
            );
          },
        ),
        actions: [ExitDoorBox()],
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300, // Ajusta este valor según sea necesario
                      child: VideoGameMultiSelectComboBox(
                        title: "Desarrolladores",
                        items: developers.keys.toList(),
                        selectedItems: selectedDevelopers,
                        onSelectionChanged: (selected) {
                          setState(() {
                            selectedDevelopers = selected;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300, // Ajusta este valor según sea necesario
                      child: VideoGameMultiSelectComboBox(
                        title: "Géneros",
                        items: genres.keys.toList(),
                        selectedItems: selectedGenres,
                        onSelectionChanged: (selected) {
                          setState(() {
                            selectedGenres = selected;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 300, // Ajusta este valor según sea necesario
                      child: VideoGameMultiSelectComboBox(
                        title: "Plataformas",
                        items: platforms.keys.toList(),
                        selectedItems: selectedPlatforms,
                        onSelectionChanged: (selected) {
                          setState(() {
                            selectedPlatforms = selected;
                          });
                        },
                      ),
                    ),
                  ],
                ),
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
                  if (addVideogameState.status == AddVideogameStatus.error)
                    const Text(
                      'No se pudo agregar el videojuego',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (addVideogameState.status == AddVideogameStatus.success)
                    Column(
                      children: [
                        const Text(
                          '¡Videojuego agregado con éxito!',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 24, // Tamaño de fuente grande
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
