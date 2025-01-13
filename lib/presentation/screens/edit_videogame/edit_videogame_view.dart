import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/screens/videogame/videogame_view.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_image.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_multi_combo_box.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:ivdb/presentation/viewmodels/edit_videogame/edit_videogame_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/edit_videogame/edit_videogame_state.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';

class EditVideogameView extends ConsumerStatefulWidget {
  final VideogameEntity videogame;
  final String? oldImageData;
  final UserEntity user;

  const EditVideogameView(
      {super.key,
      required this.videogame,
      required this.oldImageData,
      required this.user});

  @override
  ConsumerState<EditVideogameView> createState() => _EditVideogameViewState();
}

class _EditVideogameViewState extends ConsumerState<EditVideogameView> {
  // Variables iniciales para los datos del videojuego
  late String title;
  late String description;
  late List<String> selectedDevelopers;
  late List<String> selectedGenres;
  late List<String> selectedPlatforms;
  Uint8List? selectedImageBytes;
  String? selectedImagePath;
  final TextEditingController releaseDateController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    // Cargar los datos iniciales del videojuego
    title = widget.videogame.title;
    description = widget.videogame.description;
    releaseDateController.text =
        DateFormat('dd/MM/yyyy').format(widget.videogame.releaseDate);
    selectedDevelopers = widget.videogame.developers?.split(', ') ?? [];
    selectedGenres = widget.videogame.genres?.split(', ') ?? [];
    selectedPlatforms = widget.videogame.platforms?.split(', ') ?? [];
    selectedImagePath = widget.videogame.imageRoute;

    if (widget.videogame.imageData != null &&
        widget.videogame.imageData!.isNotEmpty) {
      try {
        selectedImageBytes = base64Decode(widget.oldImageData!);
      } catch (e) {
        throw Exception('Error al decodificar la imagen');
      }
    }
  }

  void _editVideogame() {
    String dateInput = releaseDateController.text;
    RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(dateInput)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fecha en formato incorrecto. Debe ser DD/MM/AAAA'),
        ),
      );
      return;
    }

    DateTime releaseDate =
        DateTime.parse(dateInput.split('/').reversed.join('-'));

    final editVideogameViewModel =
        ref.read(editVideogameViewModelProvider.notifier);

    editVideogameViewModel.editVideogame(
      originalVideogame: widget.videogame,
      newTitle: title,
      newDescription: description,
      newReleaseDate: releaseDate,
      newImageRoute: selectedImagePath?.split(RegExp(r'[/\\]')).last ?? '',
      newImageBytes: selectedImageBytes, // Pasar nueva imagen si es que hay
      newDevelopers: selectedDevelopers.join(', '),
      newPlatforms: selectedPlatforms.join(', '),
      newGenres: selectedGenres.join(', '),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editVideogameState = ref.watch(editVideogameViewModelProvider);

    ref.listen<EditVideogameState>(editVideogameViewModelProvider,
        (previous, next) {
      if (next.status == EditVideogameStatus.success) {
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
                      // Manejar la imagen de forma segura
                      imageData: selectedImageBytes != null
                          ? base64Encode(selectedImageBytes!)
                          : widget.oldImageData ??
                              '', // Si no hay imagen nueva, usar la original o cadena vacía
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
              // Imagen del videojuego
              Center(
                child: VideogameImageBox(
                  onImageSelected: (imageBytes, imagePath) {
                    setState(() {
                      selectedImageBytes = imageBytes;
                      selectedImagePath = imagePath;
                    });
                  },
                  imageBytes: selectedImageBytes,
                  initialImageBase64: widget.oldImageData,
                ),
              ),
              const SizedBox(height: 20),

              // Desarrolladores, géneros y plataformas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
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
                      width: 300,
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
                      width: 300,
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

              TextFormField(
                initialValue: title,
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
                initialValue: description,
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

              // Botón para guardar cambios
              ButtonBox(
                onPressed: _editVideogame,
                text: 'Guardar Cambios',
              ),
              if (editVideogameState.status == EditVideogameStatus.loading)
                const CircularProgressIndicator(),
              if (editVideogameState.status == EditVideogameStatus.error)
                Text(
                  editVideogameState.errorMessage ??
                      'Error al editar el videojuego',
                  style: const TextStyle(color: Colors.red),
                ),
              if (editVideogameState.status == EditVideogameStatus.success)
                const Text(
                  '¡Videojuego editado con éxito!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
