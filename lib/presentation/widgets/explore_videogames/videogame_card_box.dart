import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ivdb/domain/entities/videogame_entity.dart';
import '../../screens/videogame/videogame_view.dart';
import 'package:ivdb/domain/entities/user_entity.dart';

// Asegúrate de importar la clase de detalles

class VideogameCardBox extends StatelessWidget {
  const VideogameCardBox(
      {super.key, required this.videogame, required this.user});

  final UserEntity user;

  final VideogameEntity videogame;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navegación a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideogameView(
              title: videogame.title,
              releaseDate: videogame.releaseDate,
              imageData: videogame.imageData ?? '',
              user: user,
            ),
          ),
        );
      },
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 25),
                  Text(
                    videogame.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      color: Color(0xff1971c2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    videogame.platforms ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      color: Color(0xff1971c2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
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
                            child: Image.memory(
                              base64Decode(videogame.imageData ?? ''),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          videogame.criticAvgRating != null
                              ? videogame.criticAvgRating.toString()
                              : '0',
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
                          videogame.publicAvgRating != null
                              ? videogame.publicAvgRating.toString()
                              : '0',
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
            ],
          ),
        ),
      ),
    );
  }
}
