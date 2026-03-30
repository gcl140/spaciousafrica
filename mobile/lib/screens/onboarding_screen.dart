import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _slideUp;
  bool _showSignIn = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _slideUp = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: appBg,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Container(decoration: const BoxDecoration(gradient: heroGradient)),
            Positioned(
              top: -80, right: -60,
              child: _Orb(300, gold, 0.28),
            ),
            Positioned(
              bottom: 220, left: -80,
              child: _Orb(240, burnOrange, 0.18),
            ),
            Positioned(top: 220, left: 44, child: _Dot(12, gold, 0.4)),
            Positioned(top: 150, right: 90, child: _Dot(8, burnOrange, 0.5)),
            Positioned(top: 340, right: 40, child: _Dot(5, gold, 0.3)),

            // Logo
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icon/spac.png', width: 76, height: 76),
                    const SizedBox(height: 14),
                    const Text(
                      'SPACIOUS AFRICA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: gold,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated sheet
            AnimatedBuilder(
              animation: _slideUp,
              builder: (_, __) {
                const sheetH = 460.0;
                final offset = sheetH * (1 - _slideUp.value);
                return Positioned(
                  bottom: -offset,
                  left: 0,
                  right: 0,
                  height: sheetH,
                  child: _buildSheet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheet() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x1FFFFFFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Page content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              child: _showSignIn
                  ? _SignInPage(key: const ValueKey('signin'), onDone: widget.onDone)
                  : _LandingPage(key: const ValueKey('landing')),
            ),
          ),

          // CTA button — only on landing page
          if (!_showSignIn) Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 24, 36),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (!_showSignIn) {
                    setState(() => _showSignIn = true);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [gold, burnOrange],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Enter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Landing Page ──────────────────────────────────────────────────────────────

class _LandingPage extends StatelessWidget {
  const _LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Africa's\nEntertainment\nHub.",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.5,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Films, music, events and culture —\nall in one place.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0x66FFFFFF),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sign In Page ──────────────────────────────────────────────────────────────

class _SignInPage extends StatefulWidget {
  final VoidCallback onDone;
  const _SignInPage({super.key, required this.onDone});

  @override
  State<_SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<_SignInPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() { _loading = true; _error = null; });
    final result = await AuthService.login(
      username: _userCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    if (result.success) {
      widget.onDone();
    } else {
      setState(() { _error = result.error; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in to continue',
            style: TextStyle(fontSize: 14, color: Color(0x4DFFFFFF)),
          ),
          const SizedBox(height: 24),
          _Field(hint: 'Username', icon: Icons.person_outline, obscure: false, controller: _userCtrl),
          const SizedBox(height: 10),
          _Field(hint: 'Password', icon: Icons.lock_outline, obscure: true, controller: _passCtrl),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: const TextStyle(fontSize: 12, color: Color(0xFFFF6B6B)),
            ),
          ],
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _loading ? null : _signIn,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: _loading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: widget.onDone,
              child: const Text(
                'Continue as guest',
                style: TextStyle(fontSize: 13, color: Color(0x47FFFFFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;
  const _Field({required this.hint, required this.icon, required this.obscure, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x18FFFFFF)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x47FFFFFF), fontSize: 14),
          suffixIcon: Icon(icon, color: const Color(0x38FFFFFF), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _Orb(this.size, this.color, this.opacity, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: opacity), Colors.transparent],
          ),
        ),
      );
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _Dot(this.size, this.color, this.opacity, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      );
}
