import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/edit_videogame/edit_videogame_view.dart';
import 'package:ivdb/presentation/screens/explore_videogames/explore_videogames_view.dart';
import 'package:ivdb/presentation/viewmodels/videogame/comment_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/rate_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogame_state.dart';
import 'package:ivdb/presentation/viewmodels/videogame/videogames_viewmodel.dart';
import 'package:ivdb/presentation/widgets/shared/confirmation_message_box.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/widgets/show_comments/comment_card_box.dart';
import 'package:ivdb/domain/usecases/show_comments_usecase.dart';
import 'package:ivdb/presentation/widgets/videogame/rating_circle_box.dart';
import 'package:ivdb/presentation/widgets/videogame/rating_input_box.dart';

class VideogameView extends HookConsumerWidget {
  const VideogameView({
    super.key,
    required this.title,
    required this.releaseDate,
    required this.imageData,
    required this.user,
  });

  final UserEntity user;

  final String title;

  final DateTime releaseDate;

  final String imageData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videogameState = ref.watch(videogameViewModelProvider);
    final videogameViewModel = ref.read(videogameViewModelProvider.notifier);
    final rateState = ref.watch(rateViewModelProvider);
    final commentState = ref.watch(commentViewModelProvider);
    final commentViewModel = ref.watch(commentViewModelProvider.notifier);
    final rateViewModel = ref.read(rateViewModelProvider.notifier);
    final int? sessionRole = user.roleId;
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateFormat rightDateFormat = DateFormat('yyyy-MM-dd');
    final String formattedDate = dateFormat.format(releaseDate);
    final DateTime rightFormattedDate =
        DateTime.parse(rightDateFormat.format(releaseDate));
    final showCommentsUseCase = ref.watch(showCommentsUseCaseProvider);
    final TextEditingController commentController = TextEditingController();

    useEffect(() {
      Future.microtask(() async {
        await videogameViewModel.showVideogame(
            title, rightFormattedDate, user.email);
      });

      if (sessionRole != 1) {
        Future.microtask(() async {
          await rateViewModel.getVideogameRate(
              title, rightFormattedDate, user.email);
        });

        Future.microtask(() async {
          await commentViewModel.getComment(title, releaseDate, user.email);
        });
      }
      return null;
    }, []);

    Widget rated = Container();

    Widget comment = SizedBox.shrink();

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

    ref.listen<VideogameState>(videogameViewModelProvider, (previous, next) {
      if (next.status == VideogameStatus.successRating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
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
      }
    });

    ref.listen<VideogameState>(videogameViewModelProvider, (previous, next) {
      if (next.status == VideogameStatus.successComment) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          videogameViewModel.restart();
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
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: HomeBox(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreVideogamesView(user)),
              (Route<dynamic> route) =>
                  false, // Elimina todas las rutas anteriores
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
              if (videogameState.status == VideogameStatus.loadingVideogame)
                const Center(child: CircularProgressIndicator())
              else if (videogameState.status ==
                  VideogameStatus.successVideogame)
                Text(
                  'Titulo: ${videogameState.videogame?.title}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1971c2),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                'Descripcion: ${videogameState.videogame?.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Generos: ${videogameState.videogame?.genres}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Plataformas: ${videogameState.videogame?.platforms}',
                //user.roleId.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Desarrolladora: ',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      videogameState.videogame?.developers ?? 'N/A',
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.visible,
                    ),
                  ),
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
              const Text(
                'Calificaciones',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1971c2)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Críticos',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                      const SizedBox(height: 5),
                      RatingCircleBox(
                          rate:
                              (videogameState.videogame?.criticAvgRating ?? -1)
                                  .toInt()),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Público',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                      const SizedBox(height: 5),
                      RatingCircleBox(
                          rate:
                              (videogameState.videogame?.publicAvgRating ?? -1)
                                  .toInt()),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
              Consumer(
                builder: (context, watch, child) {
                  if (rateState.status == RateStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (rateState.status == RateStatus.error) {
                    rated = Column(
                      children: [
                        const Text(
                          'Otorgada',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'),
                        ),
                        const SizedBox(height: 5),
                        RatingCircleBox(rate: -1),
                      ],
                    );

                    return Center(
                      child: rated,
                    );
                  } else if (rateState.status == RateStatus.success) {
                    rated = Column(
                      children: [
                        Text(
                          'Otorgada',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'),
                        ),
                        const SizedBox(height: 5),
                        RatingCircleBox(rate: rateState.rate),
                      ],
                    );

                    return Center(
                      child: rated,
                    );
                  }

                  return Center(
                    child: rated,
                  );
                },
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
                          //print('Editar videojuego');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditVideogameView(
                                    videogame: videogameState.videogame!,
                                    oldImageData: imageData,
                                    user: user)),
                            (Route<dynamic> route) =>
                                false, // Elimina todas las rutas anteriores
                          );
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
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationMessageBox(
                                  title: 'Confirmar',
                                  message:
                                      '¿Estás seguro de eliminar este videojuego?',
                                  action: 'Eliminar',
                                  cancel: 'Cancelar',
                                );
                              },
                            );
                            if (result == true) {
                              videogameViewModel.deleteVideogame(
                                  title,
                                  releaseDate,
                                  videogameState.videogame?.imageRoute ?? '');
                            }
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
                    onPressed: () async {
                      final result = await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return RatingInputBox();
                        },
                      );

                      if (result != null) {
                        videogameViewModel.rateVideogame(
                            user.email, title, releaseDate, result);
                      }
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
              if (sessionRole != 1)
                const Text(
                  'Comentarios',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1971c2)),
                ),
              Consumer(builder: (context, watch, child) {
                if (commentState.status == CommentStatus.loading &&
                    sessionRole != 1 &&
                    rateState.rate != -1) {
                  comment = const Center(child: CircularProgressIndicator());
                } else if (commentState.status == CommentStatus.noComment &&
                    sessionRole != 1 &&
                    rateState.rate != -1) {
                  comment = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Añade un comentario: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        height: 150,
                        child: TextField(
                          controller: commentController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu comentario...',
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          ref.listen<VideogameState>(
                            videogameViewModelProvider,
                            (previous, next) {
                              if (next.status ==
                                  VideogameStatus.successComment) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Comentario enviado"),
                                  backgroundColor: Colors.green,
                                ));
                                commentController.clear();
                              }
                            },
                          );

                          return ElevatedButton(
                            onPressed: () async {
                              final String email = user.email;
                              final String comment = commentController.text;
                              if (comment.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "El comentario no puede estar vacio"),
                                  backgroundColor: Colors.orange,
                                ));
                                return;
                              }
                              await videogameViewModel.commentVideogame(
                                  email, title, releaseDate, comment);
                              await commentViewModel.getComment(
                                  title, releaseDate, user.email);
                            },
                            child: const Text("Enviar comentario"),
                          );
                        },
                      )
                    ],
                  );
                } else if (commentState.status == CommentStatus.success &&
                    sessionRole != 1 &&
                    rateState.rate != -1) {
                  comment = commentState.comment != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Tu comentario: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            CommentCardBox(
                                comment: commentState.comment!,
                                sessionRole: user.id,
                                releaseDate: releaseDate,
                                title: title,
                                imageData: imageData,
                                user: user),
                          ],
                        )
                      : SizedBox.shrink();
                } else if (commentState.status == CommentStatus.error) {
                  comment = SizedBox.shrink();
                } else if (commentState.status == CommentStatus.initial) {
                  comment = SizedBox.shrink();
                }
                return Center(
                  child: comment,
                );
              }),
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
                            const SizedBox(height: 20)
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
