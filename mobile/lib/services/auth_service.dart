import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class AuthService {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _usernameKey = 'username';
  static const _isProdKey = 'is_prod';
  static const _producerTypesKey = 'producer_types';

  // ── Token helpers ─────────────────────────────────────────────────────────

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  static Future<bool> isProd() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isProdKey) ?? false;
  }

  static Future<List<String>> producerTypes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_producerTypesKey) ?? [];
  }

  static Future<String?> username() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // ── Register ──────────────────────────────────────────────────────────────

  static Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 201) {
        await _saveTokens(data);
        return AuthResult.success(data['user']['username'] as String);
      }
      return AuthResult.failure(data['error'] ?? 'Registration failed.');
    } catch (_) {
      return AuthResult.failure('Could not connect to server.');
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  static Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        await _saveTokens(data);
        return AuthResult.success(data['user']['username'] as String);
      }
      return AuthResult.failure(data['error'] ?? 'Invalid credentials.');
    } catch (_) {
      return AuthResult.failure('Could not connect to server.');
    }
  }

  // ── Refresh ───────────────────────────────────────────────────────────────

  static Future<String?> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString(_refreshKey);
    if (refresh == null) return null;
    try {
      final res = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await prefs.setString(_accessKey, data['access'] as String);
        return data['access'] as String;
      }
      await logout();
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_usernameKey);
  }

  // ── Auth header ───────────────────────────────────────────────────────────

  static Future<Map<String, String>> authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<void> _saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, data['access'] as String);
    await prefs.setString(_refreshKey, data['refresh'] as String);
    final user = data['user'] as Map<String, dynamic>;
    await prefs.setString(_usernameKey, user['username'] as String);
    await prefs.setBool(_isProdKey, (user['is_prod'] as bool?) ?? false);
    final types = (user['producer_types'] as List?)?.cast<String>() ?? [];
    await prefs.setStringList(_producerTypesKey, types);
  }

  static Future<void> updateProfileLocally(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isProdKey, (user['is_prod'] as bool?) ?? false);
    final types = (user['producer_types'] as List?)?.cast<String>() ?? [];
    await prefs.setStringList(_producerTypesKey, types);
  }
}

class AuthResult {
  final bool success;
  final String? username;
  final String? error;

  const AuthResult._({required this.success, this.username, this.error});

  factory AuthResult.success(String username) =>
      AuthResult._(success: true, username: username);

  factory AuthResult.failure(String error) =>
      AuthResult._(success: false, error: error);
}
