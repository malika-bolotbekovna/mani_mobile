import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthTokens {
  final String access;
  AuthTokens({required this.access});
}

class AuthService {
  static const _kAccess = 'access_token';

  final ApiClient api = ApiClient.instance;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    dynamic avatar, // File? (не импортируем dart:io здесь специально)
  }) async {
    final uri = Uri.parse('$apiBase/auth/register/');
    final req = http.MultipartRequest('POST', uri);

    req.fields['name'] = name.trim();
    req.fields['email'] = email.trim();
    req.fields['password'] = password;

    if (avatar != null) {
      // avatar ожидается как File из register_screen.dart
      final path = avatar.path as String;
      req.files.add(await http.MultipartFile.fromPath('avatar', path));
    }

    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      // пытаемся красиво вытянуть сообщение
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['detail'] != null) {
          throw Exception(decoded['detail'].toString());
        }
        throw Exception(decoded.toString());
      } catch (_) {
        throw Exception(body.isEmpty ? 'Ошибка регистрации' : body);
      }
    }
  }

  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$apiBase/auth/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception('Неверный логин или пароль');
    }

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    final access = (data['access'] ?? '').toString();

    if (access.isEmpty) {
      throw Exception('Сервер не вернул access токен');
    }

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kAccess, access);

    api.setToken(access);
    return AuthTokens(access: access);
  }

  Future<AppUser> getMe() async {
    final data = await api.getJson('/me/');
    final status = (data['_status'] ?? 0) as int;
    if (status != 200) {
      throw Exception('Сессия истекла');
    }
    return AppUser.fromJson(data);
  }

  Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kAccess);
  }

  Future<void> logout() async {
    await api.clearToken();
  }
}
