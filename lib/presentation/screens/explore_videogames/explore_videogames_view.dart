import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/domain/entities/user_entity.dart';
import 'package:ivdb/presentation/viewmodels/explore_videogames_viewmodel.dart/explore_videogames_state.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/videogame_card_box.dart';
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
            constraints: BoxConstraints(maxWidth: 500),
            width: size.width * 0.9,
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Bienvenido ${user.username}'),
                const SizedBox(height: 20),
                const Text('Explora los videojuegos'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(exploreVideogamesViewmodelProvider.notifier)
                            .restart();
                        exploreVideogamesViewModel.exploreVideogames(
                            8, 1, 'MasRecientes');
                      },
                      child: const Text('Más Recientes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(exploreVideogamesViewmodelProvider.notifier)
                            .restart();
                        exploreVideogamesViewModel.exploreVideogames(
                            8, 1, 'MasAntiguos');
                      },
                      child: const Text('Más Antiguos'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(exploreVideogamesViewmodelProvider.notifier)
                            .restart();
                        exploreVideogamesViewModel.exploreVideogames(
                            8, 1, 'A-Z');
                      },
                      child: const Text('A - Z'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(exploreVideogamesViewmodelProvider.notifier)
                            .restart();
                        exploreVideogamesViewModel.exploreVideogames(
                            8, 1, 'Z-A');
                      },
                      child: const Text('Z - A'),
                    ),
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
                  Column(
                    children: exploreVideogamesState.videogames!
                        .map((videogame) => VideogameCardBox(
                            title: videogame.title,
                            platforms: videogame.platforms!,
                            imageRoute: videogame.imageRoute,
                            criticAvgRating:
                                videogame.criticAvgRating?.toInt() ?? 0,
                            publicAvgRating:
                                videogame.publicAvgRating?.toInt() ?? 0))
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
