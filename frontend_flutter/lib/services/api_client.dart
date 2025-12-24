import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class ApiClient {
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final res = await http
        .post(
          Uri.parse('$apiBase$path'),
          headers: {'Content-Type': 'application/json', ...?headers},
          body: jsonEncode(body ?? {}),
        )
        .timeout(timeout);

    final data = _safeJson(res.body);
    data['_status'] = res.statusCode;
    return data;
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final res = await http
        .get(Uri.parse('$apiBase$path'), headers: {...?headers})
        .timeout(timeout);

    final data = _safeJson(res.body);
    data['_status'] = res.statusCode;
    return data;
  }

  Map<String, dynamic> _safeJson(String text) {
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'detail': decoded.toString()};
    } catch (_) {
      return {'detail': text};
    }
  }

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final res = await http
        .get(Uri.parse('$apiBase$path'), headers: {...?headers})
        .timeout(timeout);

    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Expected list response. Got: ${res.body}');
  }
}
