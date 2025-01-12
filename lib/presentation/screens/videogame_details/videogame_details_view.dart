import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/widgets/show_comments/comment_card_box.dart';
import 'package:ivdb/domain/usecases/show_comments_usecase.dart';

class VideogameDetailsView extends HookConsumerWidget {
  const VideogameDetailsView({
    super.key,
    required this.title,
    required this.platforms,
    required this.imageData,
    required this.criticAvgRating,
    required this.publicAvgRating,
    required this.id,
    required this.releaseDate,
    required this.developers,
    required this.genres,
    required this.description,
    required this.user,
  });

  final UserEntity user;

  final String title;
  final String platforms;
  final String imageData;
  final int criticAvgRating;
  final int publicAvgRating;
  final int id;
  final DateTime releaseDate;
  final String developers;
  final String genres;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final String formattedDate = dateFormat.format(releaseDate);

    // Obtener comentarios
    final showCommentsUseCase = ref.watch(showCommentsUseCaseProvider);

    final int? sessionRole = user.roleId;

    return Scaffold(
      appBar: AppBar(
        title: HomeBox(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreVideogamesView(
                        user,
                      )),
            );
          },
        ),
        actions: [ExitDoorBox()],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen y detalles básicos
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff1971c2), width: 4),
                    ),
                    child: Image.memory(
                      base64Decode(imageData),
                      width: 400,
                      height: 400,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 100),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Titulo: $title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Descripcion: $description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Generos: $genres',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Plataformas: $platforms',
                //user.roleId.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Desarrolladora: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(developers, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Fecha de lanzamiento: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(formattedDate, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Calificacion de los criticos:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    criticAvgRating.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    'Calificacion del publico:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    publicAvgRating.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              SizedBox(height: 20),

              if (sessionRole == 1)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centra los botones horizontalmente
                    children: [
                      TextButton(
                        onPressed: () {
                          print('Editar videojuego');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Color(0xff1971c2)),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el valor según sea necesario
                            ),
                          ),
                        ),
                        child: Text('Editar'),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          print('Eliminar videojuego');
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Color.fromARGB(255, 194, 25, 25)),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Ajusta el valor según sea necesario
                            ),
                          ),
                        ),
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: TextButton(
                    onPressed: () {
                      print('Calificar videojuego');
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Color(0xff1971c2)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Ajusta el valor según sea necesario
                        ),
                      ),
                    ),
                    child: Text('Calificar'),
                  ),
                ),
              // Mostrar comentarios
              const SizedBox(height: 20),
              FutureBuilder(
                future: showCommentsUseCase.call(title, releaseDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al obtener los comentarios: ${snapshot.error}',
                        style: const TextStyle(color: Colors.amber),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final result = snapshot.data;
                    return result!.fold(
                      (fail) => Center(
                        child: Text(
                          'Error: ${fail.message}',
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ),
                      (comments) {
                        final criticComments = comments[0];
                        final publicComments = comments[1];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Comentarios de los críticos:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1971c2),
                              ),
                            ),
                            if (criticComments.isEmpty)
                              const Text(
                                'Aun no existen comentarios de los criticos.',
                                style: TextStyle(fontSize: 16),
                              )
                            else
                              ...criticComments.map(
                                (comment) => CommentCardBox(
                                  comment: comment,
                                  sessionRole: user.roleId!.toInt(),
                                  releaseDate: releaseDate,
                                  title: title,
                                  imageData: imageData,
                                  user: user,
                                ),
                              ),
                            const SizedBox(height: 20),
                            const Text(
                              'Comentarios del público:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1971c2),
                              ),
                            ),
                            if (publicComments.isEmpty)
                              const Text(
                                'Aun no existen comentarios del publico.',
                                style: TextStyle(fontSize: 16),
                              )
                            else
                              ...publicComments.map(
                                (comment) => CommentCardBox(
                                  comment: comment,
                                  sessionRole: user.roleId!.toInt(),
                                  releaseDate: releaseDate,
                                  title: title,
                                  imageData: imageData,
                                  user: user,
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No hay comentarios disponibles.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
