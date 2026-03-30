class Track {
  final int id;
  final String title;
  final String artistName;
  final String genre;
  final String? releaseDate;
  final String? thumbnail;
  final String youtubeUrl;
  final String spotifyUrl;
  final bool featured;

  Track({
    required this.id,
    required this.title,
    required this.artistName,
    required this.genre,
    this.releaseDate,
    this.thumbnail,
    required this.youtubeUrl,
    required this.spotifyUrl,
    required this.featured,
  });

  factory Track.fromJson(Map<String, dynamic> j) => Track(
        id: j['id'],
        title: j['title'],
        artistName: j['artist_name'],
        genre: j['genre'],
        releaseDate: j['release_date'],
        thumbnail: j['thumbnail'],
        youtubeUrl: j['youtube_url'] ?? '',
        spotifyUrl: j['spotify_url'] ?? '',
        featured: j['featured'] ?? false,
      );
}
