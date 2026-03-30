import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../widgets/media_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<Movie> _movies = [];
  bool _loading = true;
  String _selectedGenre = 'all';

  static const _genres = ['all', 'action', 'drama', 'comedy', 'thriller', 'documentary', 'short'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final genre = _selectedGenre == 'all' ? null : _selectedGenre;
      final movies = await ApiService.fetchMovies(genre: genre);
      if (mounted) setState(() { _movies = movies; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Films')),
      body: Column(
        children: [
          _buildGenreFilter(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 1.5))
                : _movies.isEmpty
                    ? Center(child: Text('no films found', style: Theme.of(context).textTheme.bodyMedium))
                    : _buildGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreFilter() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final genre = _genres[i];
          final selected = _selectedGenre == genre;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedGenre = genre);
              _load();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? Theme.of(context).colorScheme.primary : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selected ? Colors.transparent : const Color(0xFF2A2A2A)),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.black : const Color(0xFF999999),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _movies.length,
      itemBuilder: (_, i) {
        final m = _movies[i];
        return MediaCard(
          title: m.title,
          subtitle: m.genre,
          imageUrl: m.thumbnail,
          tag: m.featured ? 'featured' : null,
          width: double.infinity,
          height: 220,
        );
      },
    );
  }
}
