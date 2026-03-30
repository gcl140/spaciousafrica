import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? tag;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const MediaCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.tag,
    this.width = 160,
    this.height = 220,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A26),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _shimmer(),
                errorWidget: (_, __, ___) => _placeholder(),
              )
            else
              _placeholder(),

            // Bottom gradient + glass info
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xCC000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tag
            if (tag != null)
              Positioned(
                top: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC9A84C), Color(0xFFE8875A)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _shimmer() => Container(
        color: const Color(0xFF1E1E2A),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 1, color: Color(0xFF333344)),
        ),
      );

  Widget _placeholder() => Container(
        color: const Color(0xFF1A1A26),
        child: const Center(
          child: Icon(Icons.movie_outlined, color: Color(0xFF333344), size: 32),
        ),
      );
}
