import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/onboarding_screen.dart';
import 'services/auth_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/movies_screen.dart';
import 'screens/music_screen.dart';
import 'screens/events_screen.dart';
import 'screens/artists_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/producer_screen.dart';

void main() => runApp(const SpaciousAfricaApp());

class SpaciousAfricaApp extends StatefulWidget {
  const SpaciousAfricaApp({super.key});

  @override
  State<SpaciousAfricaApp> createState() => _SpaciousAfricaAppState();
}

class _SpaciousAfricaAppState extends State<SpaciousAfricaApp> {
  bool _onboarded = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    AuthService.isLoggedIn().then((loggedIn) {
      if (mounted) setState(() { _onboarded = loggedIn; _checking = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spacious Africa',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: _checking
          ? const Scaffold(
              backgroundColor: Color(0xFF08080F),
              body: Center(child: CircularProgressIndicator(color: gold, strokeWidth: 1.5)),
            )
          : _onboarded
              ? const RootNav()
              : OnboardingScreen(onDone: () => setState(() => _onboarded = true)),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;
  bool _isProd = false;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    AuthService.isProd().then((v) {
      if (mounted) setState(() { _isProd = v; _loadingProfile = false; });
    });
  }

  void _goToStudio() {
    if (_isProd) setState(() => _index = _studioIndex);
  }

  int get _studioIndex => _isProd ? 6 : -1;

  List<Widget> get _screens => [
    DashboardScreen(isProd: _isProd, onGoToStudio: _goToStudio),
    const MoviesScreen(),
    const MusicScreen(),
    const EventsScreen(),
    const ArtistsScreen(),
    const ShopScreen(),
    if (_isProd) ProducerScreen(onViewAsConsumer: () => setState(() => _index = 0)),
  ];

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile) {
      return const Scaffold(
        backgroundColor: Color(0xFF08080F),
        body: Center(child: CircularProgressIndicator(color: gold, strokeWidth: 1.5)),
      );
    }

    final screens = _screens;
    final safeIndex = _index.clamp(0, screens.length - 1);

    return Scaffold(
      body: IndexedStack(index: safeIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (i) => setState(() => _index = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), label: 'Films'),
          const BottomNavigationBarItem(icon: Icon(Icons.music_note_outlined), label: 'Music'),
          const BottomNavigationBarItem(icon: Icon(Icons.event_outlined), label: 'Events'),
          const BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Artists'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
          if (_isProd)
            const BottomNavigationBarItem(icon: Icon(Icons.mic_none_outlined), label: 'Studio'),
        ],
      ),
    );
  }
}
