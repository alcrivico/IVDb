import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames_viewmodel.dart/explore_videogames_state.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/videogame_card_box.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/videogames_filter_box.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames_viewmodel.dart/explore_videogames_viewmodel.dart';

class ExploreVideogamesView extends HookConsumerWidget {
  const ExploreVideogamesView({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final exploreVideogamesState =
        ref.watch(exploreVideogamesViewmodelProvider);
    final exploreVideogamesViewModel =
        ref.read(exploreVideogamesViewmodelProvider.notifier);

    int crossAxisCount;

    if (size.width > 1000) {
      crossAxisCount = 4; // 2 filas y 4 columnas
    } else if (size.width > 600) {
      crossAxisCount = 2; // 4 filas y 2 columnas
    } else {
      crossAxisCount = 1; // 1 columna y 8 filas
    }

    return Scaffold(
      appBar: AppBar(
        title: HomeBox(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreVideogamesView(
                        user: user,
                      )),
            );
          },
        ),
        actions: [ExitDoorBox()],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1280),
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bienvenid@ ${user.username}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            color: Color(0xff1971c2))),
                    const SizedBox(width: 10),
                    if (user.roleId == 1)
                      Icon(
                        Icons.key,
                        color: Color.fromARGB(255, 194, 25, 25),
                      ),
                    if (user.roleId == 1) const SizedBox(width: 10),
                    if (user.roleId == 1)
                      TextButton(
                          child: const Text('Evaluar Usuarios'),
                          onPressed: () {
                            print('Evaluar solicitudes de usuarios');
                          }),
                    if (user.roleId == 2)
                      Icon(
                        Icons.person,
                        color: Color(0xff1971c2),
                      ),
                    if (user.roleId == 2) const SizedBox(width: 10),
                    if (user.roleId == 2)
                      TextButton(
                          child: const Text('Solicitar Privilegios'),
                          onPressed: () {
                            print('Solicitar privilegio de critico');
                          }),
                    if (user.roleId == 3)
                      Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 194, 186, 25),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size.width > 490
                              ? 4
                              : 2, // Cambia las columnas dinámicamente
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 2,
                        ),
                        itemCount: 4, // Número de botones
                        itemBuilder: (context, index) {
                          final filters = [
                            {'text': 'A - Z', 'action': 'A-Z'},
                            {'text': 'Z - A', 'action': 'Z-A'},
                            {'text': 'Más Recientes', 'action': 'MasRecientes'},
                            {'text': 'Más Antiguos', 'action': 'MasAntiguos'},
                          ];
                          final filter = filters[index];

                          return VideogamesFilterBox(
                            filter: filter['text']!,
                            onPressed: () {
                              exploreVideogamesViewModel.restart();
                              exploreVideogamesViewModel.exploreVideogames(
                                  8, 1, filter['action']!);
                            },
                            isSelected: false,
                          );
                        },
                      ),
                    ),
                    if (user.roleId == 1)
                      IconButton(
                        alignment: Alignment.center,
                        onPressed: () {
                          print('Agregar videojuego');
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'Agregar Videojuego',
                        color: Color(0xff1971c2),
                        visualDensity: VisualDensity.compact,
                      )
                  ],
                ),
                const SizedBox(height: 20),
                if (exploreVideogamesState.status ==
                    ExploreVideogamesStatus.initial)
                  const Text('Seleccione una opción')
                else if (exploreVideogamesState.status ==
                    ExploreVideogamesStatus.loading)
                  const CircularProgressIndicator()
                else if (exploreVideogamesState.status ==
                    ExploreVideogamesStatus.error)
                  Text(exploreVideogamesState.errorMessage.toString())
                else
                  SizedBox(
                      height: size.height * 0.9,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4),
                        itemCount: exploreVideogamesState.videogames!.length,
                        itemBuilder: (context, index) {
                          final videogame =
                              exploreVideogamesState.videogames![index];
                          return VideogameCardBox(
                            title: videogame.title,
                            platforms: videogame.platforms!,
                            imageData: videogame.imageData!,
                            criticAvgRating:
                                videogame.criticAvgRating?.toInt() ?? 0,
                            publicAvgRating:
                                videogame.publicAvgRating?.toInt() ?? 0,
                            onPressed: () {
                              print(
                                  'Ver detalles del videojuego ${videogame.title}');
                            },
                          );
                        },
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
