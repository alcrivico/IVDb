class VideogameModel {
  final int id;
  final String title;
  final String description;
  final DateTime releaseDate;
  final String imageRoute;
  final String? developers;
  final String? platforms;
  final String? genres;
  final double? criticAvgRating;
  final double? publicAvgRating;

  VideogameModel({
    required this.id,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.imageRoute,
    this.developers,
    this.platforms,
    this.genres,
    this.criticAvgRating,
    this.publicAvgRating,
  });

  factory VideogameModel.fromJson(Map<String, dynamic> json) {
    return VideogameModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      releaseDate: DateTime.parse(json['releaseDate']),
      imageRoute: json['imageRoute'],
      developers: json['developers'],
      platforms: json['platforms'],
      genres: json['genres'],
      criticAvgRating: json['criticAvgRating'] != null
          ? double.tryParse(json['criticAvgRating'].toString())
          : null,
      publicAvgRating: json['publicAvgRating'] != null
          ? double.tryParse(json['publicAvgRating'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'releaseDate': releaseDate.toIso8601String(),
      'imageRoute': imageRoute,
      'developers': developers,
      'platforms': platforms,
      'genres': genres,
      'criticAvgRating': criticAvgRating,
      'publicAvgRating': publicAvgRating,
    };
  }
}
