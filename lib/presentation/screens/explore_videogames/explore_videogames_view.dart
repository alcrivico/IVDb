import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/screens/add_videogame/add_videogame_view.dart';
import 'package:ivdb/presentation/screens/show_applications/show_applications_view.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames/explore_videogames_state.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/videogame_card_box.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/videogames_filter_box.dart';
import 'package:ivdb/presentation/widgets/shared/exit_door_box.dart';
import 'package:ivdb/presentation/screens/request_privilege/request_privilege_view.dart';
import 'package:ivdb/presentation/widgets/shared/home_box.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames/explore_videogames_viewmodel.dart';

class ExploreVideogamesView extends HookConsumerWidget {
  const ExploreVideogamesView(this.user, {super.key});

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

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        exploreVideogamesViewModel.exploreVideogames(8, 1, 'A-Z');
      });
      return null;
    }, []);

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
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1280),
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
                      const Icon(
                        Icons.key,
                        color: Color.fromARGB(255, 194, 25, 25),
                      ),
                    if (user.roleId == 1) const SizedBox(width: 10),
                    if (user.roleId == 1)
                      Flexible(
                        child: TextButton(
                          child: const Text('Evaluar Usuarios',
                              textAlign: TextAlign.center),
                          onPressed: () {
                            // Navegar a la pantalla de evaluación de usuarios
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowApplicationsView(user),
                              ),
                            );
                          },
                        ),
                      ),
                    if (user.roleId == 2)
                      const Icon(
                        Icons.person,
                        color: Color(0xff1971c2),
                      ),
                    if (user.roleId == 2) const SizedBox(width: 10),
                    if (user.roleId == 2)
                      Flexible(
                        child: TextButton(
                          child: const Text('Solicitar Privilegios',
                              textAlign: TextAlign.center),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RequestPrivilegeView(user: user),
                              ),
                            );
                          },
                        ),
                      ),
                    if (user.roleId == 3)
                      const Icon(
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
                          crossAxisCount: size.width > 490 ? 4 : 2,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddVideogameView(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'Agregar Videojuego',
                        color: const Color(0xff1971c2),
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
                    height: size.height -
                        kToolbarHeight -
                        400, // Ajusta este valor según sea necesario
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: exploreVideogamesState.videogames!.length,
                      itemBuilder: (context, index) {
                        final videogame =
                            exploreVideogamesState.videogames![index];
                        return VideogameCardBox(
                          videogame: videogame,
                          user: user,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
