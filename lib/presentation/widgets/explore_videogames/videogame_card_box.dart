import 'dart:convert';
import 'package:flutter/material.dart';

class VideogameCardBox extends StatelessWidget {
  const VideogameCardBox({
    super.key,
    required this.title,
    required this.platforms,
    required this.imageData,
    required this.criticAvgRating,
    required this.publicAvgRating,
    required this.onPressed,
  });

  final String title;
  final String platforms;
  final String imageData;
  final int criticAvgRating;
  final int publicAvgRating;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
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
                    title,
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
                    platforms,
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
                              base64Decode(imageData),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                            ), // Mantén proporciones para la imagen
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
                  const SizedBox(height: 10)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
