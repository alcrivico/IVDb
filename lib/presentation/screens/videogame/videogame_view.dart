import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogame_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogames_viewmodel.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/widgets/show_comments/comment_card_box.dart';
import 'package:ivdb/domain/usecases/show_comments_usecase.dart';

class VideogameView extends HookConsumerWidget {
  const VideogameView({
    super.key,
    required this.videogame,
    required this.user,
  });

  final UserEntity user;

  final VideogameEntity videogame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final String formattedDate = dateFormat.format(videogame.releaseDate);

    // Obtener comentarios
    final showCommentsUseCase = ref.watch(showCommentsUseCaseProvider);

    final int? sessionRole = user.roleId;

    final videogameState = ref.watch(videogameViewModelProvider);
    final videogameViewModel = ref.read(videogameViewModelProvider.notifier);

    ref.listen<VideogameState>(videogameViewModelProvider, (previous, next) {
      if (next.status == VideogameStatus.successDeleting) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ExploreVideogamesView(user)),
            (Route<dynamic> route) =>
                false, // Elimina todas las rutas anteriores
          );
        });
      }
    });

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
                      base64Decode(videogame.imageData ?? ''),
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
                'Titulo: ${videogame.title}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Descripcion: ${videogame.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Generos: ${videogame.genres}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Plataformas: ${videogame.platforms}',
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
                  Text(videogame.developers ?? '',
                      style: const TextStyle(fontSize: 16)),
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
                    videogame.criticAvgRating.toString(),
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
                    videogame.publicAvgRating.toString(),
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
                      if (videogameState.status ==
                          VideogameStatus.loadingDeleting)
                        const CircularProgressIndicator()
                      else
                        TextButton(
                          onPressed: () {
                            videogameViewModel.deleteVideogame(
                                videogame); // Eliminar videojuego
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
                future: showCommentsUseCase.call(
                    videogame.title, videogame.releaseDate),
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
                                    releaseDate: videogame.releaseDate,
                                    title: videogame.title),
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
                                    releaseDate: videogame.releaseDate,
                                    title: videogame.title),
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
