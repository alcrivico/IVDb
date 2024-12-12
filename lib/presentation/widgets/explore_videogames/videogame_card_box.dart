import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/presentation/widgets/explore_videogames/viewmodel/videogame_card_box_state.dart';
import './viewmodel/videogame_car_box_viewmodel.dart';

class VideogameCardBox extends ConsumerWidget {
  const VideogameCardBox({
    super.key,
    required this.title,
    required this.platforms,
    required this.imageRoute,
    required this.criticAvgRating,
    required this.publicAvgRating,
  });

  final String title;
  final String platforms;
  final String imageRoute;
  final int criticAvgRating;
  final int publicAvgRating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final viewModel = ref.read(videogameCarBoxViewmodelProvider.notifier);

    // Descargar la imagen cuando se construye el widget
    //Future.microtask(() => viewModel.downloadCover(imageRoute));

    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Card(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: const Color(0xff1971c2), width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xff1971c2),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                platforms,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xff1971c2),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff1971c2),
                          width: 4,
                        ),
                      ),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      criticAvgRating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        color: Color(0xff1971c2),
                      ),
                    ),
                    const Text(
                      '/',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        color: Color(0xff1971c2),
                      ),
                    ),
                    Text(
                      publicAvgRating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        color: Color(0xff1971c2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
