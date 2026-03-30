class ApiConfig {
  // Change this to your machine's IP when testing on a physical device
  static const String baseUrl = 'http://localhost:8000'; // Chrome / macOS desktop
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://YOUR_IP:8000'; // physical device

  static const String movies = '$baseUrl/api/movies/';
  static const String moviesFeatured = '$baseUrl/api/movies/featured/';
  static const String music = '$baseUrl/api/music/';
  static const String musicFeatured = '$baseUrl/api/music/featured/';
  static const String artists = '$baseUrl/api/artists/';
  static const String artistsFeatured = '$baseUrl/api/artists/featured/';
  static const String events = '$baseUrl/api/events/';
  static const String eventsUpcoming = '$baseUrl/api/events/upcoming/';
  static const String products = '$baseUrl/api/products/';
  static const String gallery = '$baseUrl/api/gallery/';
  static const String stats = '$baseUrl/api/stats/';
  static const String profile = '$baseUrl/api/auth/profile/';
  static const String submitTrack = '$baseUrl/api/submit/track/';
  static const String submitMovie = '$baseUrl/api/submit/movie/';
}
