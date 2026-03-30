import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../models/track.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<Track> _tracks = [];
  bool _loading = true;
  String _selectedGenre = 'all';

  static const _genres = ['all', 'afrobeats', 'hiphop', 'rnb', 'gospel', 'pop', 'jazz'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final genre = _selectedGenre == 'all' ? null : _selectedGenre;
      final tracks = await ApiService.fetchTracks(genre: genre);
      if (mounted) setState(() { _tracks = tracks; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music')),
      body: Column(
        children: [
          _buildGenreFilter(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 1.5))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _tracks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _TrackTile(track: _tracks[i]),
                  ),
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
}

class _TrackTile extends StatelessWidget {
  final Track track;
  const _TrackTile({required this.track});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: track.thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: track.thumbnail!,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(track.artistName, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(track.genre, style: theme.textTheme.labelSmall),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 52,
        height: 52,
        color: const Color(0xFF222222),
        child: const Icon(Icons.music_note, color: Color(0xFF444444), size: 20),
      );
}
