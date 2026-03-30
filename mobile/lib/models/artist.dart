class Artist {
  final int id;
  final String name;
  final String category;
  final String bio;
  final String? photo;
  final String instagramUrl;
  final bool featured;

  Artist({
    required this.id,
    required this.name,
    required this.category,
    required this.bio,
    this.photo,
    required this.instagramUrl,
    required this.featured,
  });

  factory Artist.fromJson(Map<String, dynamic> j) => Artist(
        id: j['id'],
        name: j['name'],
        category: j['category'],
        bio: j['bio'],
        photo: j['photo'],
        instagramUrl: j['instagram_url'] ?? '',
        featured: j['featured'] ?? false,
      );
}
