import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:ivdb/domain/entities/user_entity.dart';

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
    required this.user
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
                'Descripcion: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Generos: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  genres,
                  style: TextStyle(fontSize: 16),
                )
              ),
              const SizedBox(height: 10),
              Text(
                'Plataformas: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  platforms,
                  style: TextStyle(fontSize: 16),
                )
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Desarrolladora: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(width: 10),
                  Text(
                    developers,
                    style: TextStyle(fontSize: 16)
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Fecha de lanzamiento: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16)
                  )
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
            ],
          ),
        ),
      ),
    );
  }
}
