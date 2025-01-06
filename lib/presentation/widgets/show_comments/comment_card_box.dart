import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart'; 
import 'package:ivdb/domain/entities/comment_entity.dart';
import 'package:ivdb/domain/usecases/hide_comment_usecase.dart';

class CommentCardBox extends HookConsumerWidget { 
  const CommentCardBox({
    super.key,
    required this.comment,
    required this.sessionRole,
    required this.releaseDate,
    required this.title
  });

  final CommentEntity comment;
  final int sessionRole;
  final DateTime releaseDate;
  final String title;

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
      height: 180, // Alto fijo
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
              Expanded(
                child: Text(
                  comment.content,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 4, // Limita a 4 líneas
                  overflow: TextOverflow.ellipsis, // Añade "..." si el texto es demasiado largo
                ),
              ),
              const SizedBox(height: 5),

              // Fecha de creación del comentario
              Text(
                "Creado en: $formattedDate",
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
                          final String email = comment.rating?.user?.email ?? 'not email';
                          final result = await hideCommentUseCase.call(value, title, releaseDate, email);
                          result.fold(
                            (failure){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al ocultar el comentario"),
                              backgroundColor: Colors.red)
                              );
                            },
                            (_){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Comentario ocultado"), 
                              backgroundColor: Colors.green,)
                              );
                            }
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
