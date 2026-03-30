import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';
import '../services/submit_service.dart';

class ProducerScreen extends StatefulWidget {
  final VoidCallback? onViewAsConsumer;
  const ProducerScreen({super.key, this.onViewAsConsumer});

  @override
  State<ProducerScreen> createState() => _ProducerScreenState();
}

class _ProducerScreenState extends State<ProducerScreen> {
  List<String> _types = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    AuthService.producerTypes().then((t) {
      if (mounted) setState(() { _types = t; _loading = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        title: const Text('Studio'),
        backgroundColor: appBg,
        actions: [
          if (widget.onViewAsConsumer != null)
            TextButton.icon(
              onPressed: widget.onViewAsConsumer,
              icon: const Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF888899)),
              label: const Text(
                'Consumer View',
                style: TextStyle(fontSize: 12, color: Color(0xFF888899)),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: gold, strokeWidth: 1.5))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionLabel('Your Roles'),
                const SizedBox(height: 8),
                _TypeChips(
                  selected: _types,
                  onChanged: (types) async {
                    await SubmitService.updateProfile({
                      'is_prod': true,
                      'producer_types': types,
                    });
                    if (mounted) setState(() => _types = types);
                  },
                ),
                const SizedBox(height: 32),
                if (_types.contains('musician')) ...[
                  _sectionLabel('Submit a Track'),
                  const SizedBox(height: 12),
                  _TrackForm(),
                  const SizedBox(height: 32),
                ],
                if (_types.any((t) => ['actor', 'actress', 'director', 'producer'].contains(t))) ...[
                  _sectionLabel('Submit a Film'),
                  const SizedBox(height: 12),
                  _MovieForm(),
                ],
              ],
            ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: gold,
          letterSpacing: 1,
        ),
      );
}

// ── Type chips ────────────────────────────────────────────────────────────────

class _TypeChips extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const _TypeChips({required this.selected, required this.onChanged});

  static const _all = ['musician', 'actor', 'actress', 'director', 'producer', 'writer', 'photographer'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _all.map((t) {
        final on = selected.contains(t);
        return GestureDetector(
          onTap: () {
            final next = List<String>.from(selected);
            on ? next.remove(t) : next.add(t);
            onChanged(next);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: on ? primaryGradient : null,
              color: on ? null : const Color(0xFF1A1A26),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: on ? Colors.transparent : const Color(0xFF2A2A36),
              ),
            ),
            child: Text(
              t,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: on ? Colors.black : const Color(0xFF888899),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Track form ────────────────────────────────────────────────────────────────

class _TrackForm extends StatefulWidget {
  @override
  State<_TrackForm> createState() => _TrackFormState();
}

class _TrackFormState extends State<_TrackForm> {
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _youtube = TextEditingController();
  final _spotify = TextEditingController();
  String _genre = 'afrobeats';
  bool _loading = false;
  String? _msg;
  bool _success = false;

  static const _genres = ['afrobeats', 'hiphop', 'rnb', 'gospel', 'pop', 'jazz', 'other'];

  @override
  void dispose() {
    _title.dispose(); _artist.dispose();
    _youtube.dispose(); _spotify.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) {
      setState(() { _msg = 'Title is required.'; _success = false; });
      return;
    }
    setState(() { _loading = true; _msg = null; });
    final result = await SubmitService.submitTrack({
      'title': _title.text.trim(),
      'artist_name': _artist.text.trim(),
      'genre': _genre,
      'youtube_url': _youtube.text.trim(),
      'spotify_url': _spotify.text.trim(),
    });
    if (mounted) {
      setState(() {
        _loading = false;
        _success = result.success;
        _msg = result.success ? 'Submitted! Under review.' : result.error;
      });
      if (result.success) {
        _title.clear(); _artist.clear(); _youtube.clear(); _spotify.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      children: [
        _Input(label: 'Track Title *', ctrl: _title),
        _Input(label: 'Artist Name', ctrl: _artist),
        _GenrePicker(genres: _genres, value: _genre, onChanged: (v) => setState(() => _genre = v)),
        _Input(label: 'YouTube URL', ctrl: _youtube),
        _Input(label: 'Spotify URL', ctrl: _spotify),
        if (_msg != null) _StatusMsg(msg: _msg!, success: _success),
        _SubmitBtn(label: 'Submit Track', loading: _loading, onTap: _submit),
      ],
    );
  }
}

// ── Movie form ────────────────────────────────────────────────────────────────

class _MovieForm extends StatefulWidget {
  @override
  State<_MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<_MovieForm> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _trailer = TextEditingController();
  final _youtube = TextEditingController();
  String _genre = 'drama';
  bool _loading = false;
  String? _msg;
  bool _success = false;

  static const _genres = ['action', 'drama', 'comedy', 'thriller', 'documentary', 'short', 'other'];

  @override
  void dispose() {
    _title.dispose(); _desc.dispose();
    _trailer.dispose(); _youtube.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) {
      setState(() { _msg = 'Title is required.'; _success = false; });
      return;
    }
    setState(() { _loading = true; _msg = null; });
    final result = await SubmitService.submitMovie({
      'title': _title.text.trim(),
      'description': _desc.text.trim(),
      'genre': _genre,
      'trailer_url': _trailer.text.trim(),
      'youtube_url': _youtube.text.trim(),
    });
    if (mounted) {
      setState(() {
        _loading = false;
        _success = result.success;
        _msg = result.success ? 'Submitted! Under review.' : result.error;
      });
      if (result.success) {
        _title.clear(); _desc.clear(); _trailer.clear(); _youtube.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      children: [
        _Input(label: 'Film Title *', ctrl: _title),
        _Input(label: 'Description', ctrl: _desc, maxLines: 3),
        _GenrePicker(genres: _genres, value: _genre, onChanged: (v) => setState(() => _genre = v)),
        _Input(label: 'Trailer URL', ctrl: _trailer),
        _Input(label: 'YouTube URL', ctrl: _youtube),
        if (_msg != null) _StatusMsg(msg: _msg!, success: _success),
        _SubmitBtn(label: 'Submit Film', loading: _loading, onTap: _submit),
      ],
    );
  }
}

// ── Shared form widgets ───────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E1E2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .expand((w) => [w, const SizedBox(height: 12)])
            .toList()
          ..removeLast(),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final int maxLines;
  const _Input({required this.label, required this.ctrl, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF666677), fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A28),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A3A)),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenrePicker extends StatelessWidget {
  final List<String> genres;
  final String value;
  final ValueChanged<String> onChanged;
  const _GenrePicker({required this.genres, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Genre',
            style: TextStyle(fontSize: 11, color: Color(0xFF666677), fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A28),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A3A)),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1A1A28),
            underline: const SizedBox.shrink(),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            items: genres.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      ],
    );
  }
}

class _StatusMsg extends StatelessWidget {
  final String msg;
  final bool success;
  const _StatusMsg({required this.msg, required this.success});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: success
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 12,
          color: success ? Colors.green : const Color(0xFFFF6B6B),
        ),
      ),
    );
  }
}

class _SubmitBtn extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;
  const _SubmitBtn({required this.label, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          gradient: primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                )
              : Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
        ),
      ),
    );
  }
}
