class VideogameEntity {
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

  VideogameEntity({
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
}
