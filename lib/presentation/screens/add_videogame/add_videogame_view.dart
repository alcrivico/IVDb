import 'dart:typed_data'; // Asegúrate de importar esta librería
import 'package:flutter/material.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_combo_box.dart';
import 'package:ivdb/presentation/widgets/add_videogame/videogame_image.dart';
import 'package:ivdb/presentation/widgets/shared/button_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_viewmodel.dart';
import 'package:ivdb/presentation/viewmodels/add_videogame/add_videogame_state.dart';

class AddVideogameView extends ConsumerStatefulWidget {
  const AddVideogameView({Key? key}) : super(key: key);

  @override
  ConsumerState<AddVideogameView> createState() => _AddVideogameViewState();
}

class _AddVideogameViewState extends ConsumerState<AddVideogameView> {
  String? selectedDeveloper;
  String? selectedGenre;
  String? selectedPlatform;
  Uint8List? selectedImageBytes;
  final TextEditingController releaseDateController = TextEditingController();
  
  // Definir title y description como miembros de la clase
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
    // Validar fecha
    String dateInput = releaseDateController.text;
    RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(dateInput)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fecha en formato incorrecto. Debe ser DD/MM/AAAA')),
      );
      return;
    }

    // Convertir fecha de string a DateTime
    DateTime releaseDate = DateTime.parse(dateInput.split('/').reversed.join('-'));

    String imageRoute = "nombre_de_la_imagen.jpg"; // Usa el nombre de la imagen cargada

    final addVideogameViewModel = ref.read(addVideogameViewModelProvider);
    addVideogameViewModel.addVideogame(
      title: title,
      description: description,
      releaseDate: releaseDate,
      imageRoute: imageRoute,
      developers: selectedDeveloper,
      platforms: selectedPlatform,
      genres: selectedGenre,
    );
  }

  @override
  Widget build(BuildContext context) {
    final addVideogameViewModel = ref.watch(addVideogameViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Videojuego'),
        backgroundColor: const Color(0xff1971c2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideogameImageBox(
                onImageSelected: (imageBytes) {
                  setState(() {
                    selectedImageBytes = imageBytes;
                  });
                },
                imageBytes: selectedImageBytes,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideogameComboBox(
                    title: "Desarrolladores",
                    items: developers.keys.toList(),
                    selectedItem: selectedDeveloper,
                    onChanged: (value) {
                      setState(() {
                        selectedDeveloper = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  VideogameComboBox(
                    title: "Géneros",
                    items: genres.keys.toList(),
                    selectedItem: selectedGenre,
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  VideogameComboBox(
                    title: "Plataformas",
                    items: platforms.keys.toList(),
                    selectedItem: selectedPlatform,
                    onChanged: (value) {
                      setState(() {
                        selectedPlatform = value;
                      });
                    },
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
                      title = value; // Guardar el título en una variable
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
                      description = value; // Guardar la descripción en una variable
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
                    onPressed: _addVideogame, // Llamar a la función que valida y agrega el videojuego
                    text: 'Agregar Videojuego',
                  ),
                  // Mostrar estado de carga, éxito o error
                  if (addVideogameViewModel.state.status == AddVideogameStatus.loading)
                    const CircularProgressIndicator(),
                  if (addVideogameViewModel.state.status == AddVideogameStatus.error)
                    Text(
                      addVideogameViewModel.state.errorMessage ?? 'Error al agregar el videojuego',
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (addVideogameViewModel.state.status == AddVideogameStatus.success)
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
