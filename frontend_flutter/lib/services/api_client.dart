import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  static const _kAccess = 'access_token';

  String? _token;

  static Future<void> preloadToken() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(_kAccess);
    if (token != null && token.isNotEmpty) {
      ApiClient.instance.setToken(token);
    }
  }

  Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kAccess);
  }

  void setToken(String token) {
    _token = token;
  }

  Future<void> clearToken() async {
    _token = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kAccess);
  }

  Map<String, String> _headers([Map<String, String>? extra]) {
    return {
      'Accept': 'application/json',
      if (_token != null && _token!.isNotEmpty)
        'Authorization': 'Bearer $_token',
      ...?extra,
    };
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await http.get(Uri.parse('$apiBase$path'), headers: _headers());

    final data = _safeJson(res.body);
    data['_status'] = res.statusCode;
    return data;
  }

  Future<List<dynamic>> getList(String path) async {
    final res = await http.get(Uri.parse('$apiBase$path'), headers: _headers());

    final decoded = jsonDecode(utf8.decode(res.bodyBytes));
    if (decoded is List) return decoded;
    throw Exception('Expected list response');
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final res = await http.post(
      Uri.parse('$apiBase$path'),
      headers: _headers({'Content-Type': 'application/json', ...?headers}),
      body: jsonEncode(body ?? {}),
    );

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
}
