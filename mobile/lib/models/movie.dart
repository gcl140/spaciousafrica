class Movie {
  final int id;
  final String title;
  final String description;
  final String genre;
  final String? releaseDate;
  final String? thumbnail;
  final String trailerUrl;
  final bool featured;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    this.releaseDate,
    this.thumbnail,
    required this.trailerUrl,
    required this.featured,
  });

  factory Movie.fromJson(Map<String, dynamic> j) => Movie(
        id: j['id'],
        title: j['title'],
        description: j['description'],
        genre: j['genre'],
        releaseDate: j['release_date'],
        thumbnail: j['thumbnail'],
        trailerUrl: j['trailer_url'] ?? '',
        featured: j['featured'] ?? false,
      );
}
