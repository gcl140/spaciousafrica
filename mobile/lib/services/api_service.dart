import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/movie.dart';
import '../models/track.dart';
import '../models/artist.dart';
import '../models/event.dart';
import '../models/product.dart';

class ApiService {
  static Future<T> _get<T>(
    String url,
    T Function(dynamic) parse,
  ) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parse(json.decode(response.body));
    }
    throw Exception('Failed to load from $url');
  }

  static Future<Map<String, int>> fetchStats() => _get(
        ApiConfig.stats,
        (data) => Map<String, int>.from(
          (data as Map).map((k, v) => MapEntry(k.toString(), v as int)),
        ),
      );

  static Future<List<Movie>> fetchFeaturedMovies() => _get(
        ApiConfig.moviesFeatured,
        (data) => (data as List).map((e) => Movie.fromJson(e)).toList(),
      );

  static Future<List<Movie>> fetchMovies({String? genre}) => _get(
        genre != null
            ? '${ApiConfig.movies}?genre=$genre'
            : ApiConfig.movies,
        (data) => (data as List).map((e) => Movie.fromJson(e)).toList(),
      );

  static Future<List<Track>> fetchFeaturedTracks() => _get(
        ApiConfig.musicFeatured,
        (data) => (data as List).map((e) => Track.fromJson(e)).toList(),
      );

  static Future<List<Track>> fetchTracks({String? genre}) => _get(
        genre != null
            ? '${ApiConfig.music}?genre=$genre'
            : ApiConfig.music,
        (data) => (data as List).map((e) => Track.fromJson(e)).toList(),
      );

  static Future<List<Artist>> fetchFeaturedArtists() => _get(
        ApiConfig.artistsFeatured,
        (data) => (data as List).map((e) => Artist.fromJson(e)).toList(),
      );

  static Future<List<Artist>> fetchArtists({String? category}) => _get(
        category != null
            ? '${ApiConfig.artists}?category=$category'
            : ApiConfig.artists,
        (data) => (data as List).map((e) => Artist.fromJson(e)).toList(),
      );

  static Future<List<Event>> fetchUpcomingEvents() => _get(
        ApiConfig.eventsUpcoming,
        (data) => (data as List).map((e) => Event.fromJson(e)).toList(),
      );

  static Future<List<Event>> fetchEvents() => _get(
        ApiConfig.events,
        (data) => (data as List).map((e) => Event.fromJson(e)).toList(),
      );

  static Future<List<Product>> fetchProducts({bool inStockOnly = false}) => _get(
        inStockOnly
            ? '${ApiConfig.products}?in_stock=true'
            : ApiConfig.products,
        (data) => (data as List).map((e) => Product.fromJson(e)).toList(),
      );
}
