import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import 'auth_service.dart';

class SubmitResult {
  final bool success;
  final String? error;
  const SubmitResult._({required this.success, this.error});
  factory SubmitResult.ok() => const SubmitResult._(success: true);
  factory SubmitResult.err(String e) => SubmitResult._(success: false, error: e);
}

class SubmitService {
  static Future<SubmitResult> submitTrack(Map<String, String> fields) async {
    return _post(ApiConfig.submitTrack, fields);
  }

  static Future<SubmitResult> submitMovie(Map<String, String> fields) async {
    return _post(ApiConfig.submitMovie, fields);
  }

  static Future<SubmitResult> updateProfile(Map<String, dynamic> body) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.patch(
        Uri.parse(ApiConfig.profile),
        headers: headers,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200) {
        await AuthService.updateProfileLocally(data);
        return SubmitResult.ok();
      }
      return SubmitResult.err(data['error'] ?? 'Update failed.');
    } catch (_) {
      return SubmitResult.err('Could not connect.');
    }
  }

  static Future<SubmitResult> _post(String url, Map<String, dynamic> body) async {
    try {
      final headers = await AuthService.authHeaders();
      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 201) return SubmitResult.ok();
      return SubmitResult.err(data['error'] ?? 'Submission failed.');
    } catch (_) {
      return SubmitResult.err('Could not connect.');
    }
  }
}
