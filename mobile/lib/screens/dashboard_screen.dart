import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../models/event.dart';
import '../models/artist.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_header.dart';
import '../widgets/media_card.dart';
import '../widgets/glass_card.dart';
import 'movies_screen.dart';
import 'events_screen.dart';
import 'artists_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool isProd;
  final VoidCallback? onGoToStudio;
  const DashboardScreen({super.key, this.isProd = false, this.onGoToStudio});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int>? _stats;
  List<Movie> _featuredMovies = [];
  List<Event> _upcomingEvents = [];
  List<Artist> _featuredArtists = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ApiService.fetchStats(),
        ApiService.fetchFeaturedMovies(),
        ApiService.fetchUpcomingEvents(),
        ApiService.fetchFeaturedArtists(),
      ]);
      if (mounted) {
        setState(() {
          _stats = results[0] as Map<String, int>;
          _featuredMovies = results[1] as List<Movie>;
          _upcomingEvents = (results[2] as List<Event>).take(3).toList();
          _featuredArtists = results[3] as List<Artist>;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = 'Could not connect.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: gold)),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        color: gold,
        backgroundColor: surface,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (_featuredMovies.isNotEmpty) ...[
                    _buildFeaturedMovies(),
                    const SizedBox(height: 32),
                  ],
                  if (_upcomingEvents.isNotEmpty) ...[
                    _buildUpcomingEvents(),
                    const SizedBox(height: 32),
                  ],
                  if (_featuredArtists.isNotEmpty)
                    _buildArtists(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    final s = _stats ?? {};
    final stats = [
      ('Films', s['movies'] ?? 0, Icons.movie_outlined),
      ('Artists', s['artists'] ?? 0, Icons.people_outline),
      ('Events', s['events'] ?? 0, Icons.event_outlined),
      ('Tracks', s['tracks'] ?? 0, Icons.music_note_outlined),
    ];

    return Container(
      height: 360,
      width: double.infinity,
      decoration: const BoxDecoration(gradient: heroGradient),
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [gold.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [burnOrange.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            primaryGradient.createShader(bounds),
                        child: const Text(
                          'Spacious Africa',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      if (widget.isProd)
                        GestureDetector(
                          onTap: widget.onGoToStudio,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mic_none_outlined, size: 12, color: Colors.black),
                                SizedBox(width: 4),
                                Text(
                                  'Studio',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          borderRadius: BorderRadius.circular(20),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Headline
                  const Text(
                    'African\nEntertainment',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1.5,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Films · Music · Events · Culture',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.45),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const Spacer(),

                  // Stats glass row
                  SizedBox(
                    height: 68,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: stats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final (label, value, icon) = stats[i];
                        return SizedBox(
                          width: 140,
                          child: StatCard(label: label, value: value.toString(), icon: icon),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMovies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Featured Films',
          actionLabel: 'See All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoviesScreen()),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredMovies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final m = _featuredMovies[i];
              return MediaCard(
                title: m.title,
                subtitle: m.genre[0].toUpperCase() + m.genre.substring(1),
                imageUrl: m.thumbnail,
                tag: m.genre,
                width: 155,
                height: 230,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Upcoming Events',
          actionLabel: 'See All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventsScreen()),
          ),
        ),
        const SizedBox(height: 14),
        ..._upcomingEvents.map((e) => _EventTile(event: e)),
      ],
    );
  }

  Widget _buildArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Artists',
          actionLabel: 'See All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArtistsScreen()),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredArtists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => _ArtistBubble(artist: _featuredArtists[i]),
          ),
        ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  final Event event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        opacity: 0.06,
        child: Row(
          children: [
            // Date box
            Container(
              width: 48,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E2E), Color(0xFF252535)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: gold.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => primaryGradient.createShader(b),
                    child: Text(
                      event.eventDate.split('-')[2],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Text(
                    _monthAbbr(event.eventDate),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF888899)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(
                    '${event.venue}${event.city.isNotEmpty ? " · ${event.city}" : ""}',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (event.isFree)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: const Text(
                  'Free',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _monthAbbr(String date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final m = int.tryParse(date.split('-')[1]) ?? 1;
    return months[m - 1];
  }
}

class _ArtistBubble extends StatelessWidget {
  final Artist artist;
  const _ArtistBubble({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [gold.withOpacity(0.6), burnOrange.withOpacity(0.3)],
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF1A1A26),
            backgroundImage: artist.photo != null ? NetworkImage(artist.photo!) : null,
            child: artist.photo == null
                ? const Icon(Icons.person, color: Color(0xFF444455), size: 22)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          artist.name.split(' ').first,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
