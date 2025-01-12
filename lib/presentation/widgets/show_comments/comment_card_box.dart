import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/domain/usecases/hide_comment_usecase.dart';
import 'package:ivdb/presentation/screens/videogame/videogame_view.dart';

class CommentCardBox extends HookConsumerWidget {
  const CommentCardBox(
      {super.key,
      required this.comment,
      required this.sessionRole,
      required this.releaseDate,
      required this.title,
      required this.imageData,
      required this.user});

  final CommentEntity comment;
  final int sessionRole;
  final DateTime releaseDate;
  final String title;
  final String imageData;
  final UserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final String formattedDate = dateFormat.format(comment.createdAt);

    final String username = comment.rating?.user?.username ?? 'Anónimo';
    final int rating = comment.rating?.rate ?? 0;

    // Ocultar comentario
    final hideCommentUseCase = ref.watch(hideCommentUseCaseProvider);

    return SizedBox(
      width: 300, // Ancho fijo
      height: 200, // Alto fijo
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: const Color(0xff1971c2), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del comentario
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Maneja texto largo
              ),
              const SizedBox(height: 5),

              // Contenido del comentario

              Flexible(
                child: SingleChildScrollView(
                  child: Text(comment.content,
                      style: const TextStyle(fontSize: 16), maxLines: null),
                ),
              ),

              const SizedBox(height: 5),

              // Fecha de creación del comentario
              Text(
                "A fecha de: $formattedDate",
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),

              // Rating del comentario (si existe)
              if (comment.rating != null)
                Text(
                  "Rating: $rating",
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 5),

              // Botón "Ocultar"
              Align(
                alignment: Alignment.bottomRight,
                child: sessionRole == 1
                    ? TextButton(
                        onPressed: () async {
                          final bool value = true;
                          final String email =
                              comment.rating?.user?.email ?? 'not email';
                          final result = await hideCommentUseCase.call(
                              value, title, releaseDate, email);
                          result.fold((failure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error al ocultar el comentario"),
                                backgroundColor: Colors.red));
                          }, (_) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Comentario ocultado"),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideogameView(
                                      title: title,
                                      releaseDate: releaseDate,
                                      imageData: imageData,
                                      user: user)),
                              (Route<dynamic> route) =>
                                  false, // Elimina todas las rutas anteriores
                            );
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          backgroundColor: const Color(0xff1971c2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Ocultar",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
