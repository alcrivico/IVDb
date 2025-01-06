import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
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
        title: Text(title),
        backgroundColor: const Color(0xff1971c2),
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
                      border: Border.all(color: const Color(0xff1971c2), width: 4),
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

              //Boton Cardone
              
              Align(
                alignment: Alignment.bottomCenter,
                child: sessionRole == 1 ?
                TextButton(onPressed: (){
                  print("Boton eliminar videojuego pulsado");
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  backgroundColor: const Color(0xff1971c2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                child: const Text(
                  "Eliminar videojuego",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
                :const SizedBox.shrink(),
              ),

              const SizedBox(height: 8), 

              //Boton actualizar
              Align(
                alignment: Alignment.bottomCenter,
                child: sessionRole == 1 ?
                TextButton(onPressed: (){
                  print("Boton actualizar videojuego pulsado");
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  backgroundColor: const Color(0xff1971c2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                child: const Text(
                  "Actualizar videojuego",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
                :const SizedBox.shrink(),
              ),

              //Boton calificar
              Align(
                alignment: Alignment.bottomCenter,
                child: sessionRole == 2 ?
                TextButton(onPressed: (){
                  print("Boton calificar videojuego pulsado");
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  backgroundColor: const Color(0xff1971c2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                child: const Text(
                  "Calificar videojuego",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
                :const SizedBox.shrink(),
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
                                (comment) => CommentCardBox(comment: comment,
                                sessionRole: user.roleId!.toInt(),
                                releaseDate: releaseDate,
                                title: title
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
                                (comment) => CommentCardBox(comment: comment,
                                sessionRole: user.roleId!.toInt(),
                                releaseDate: releaseDate,
                                title: title
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
