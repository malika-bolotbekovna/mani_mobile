import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthTokens {
  final String access;
  AuthTokens({required this.access});
}

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static const _kAccess = 'access_token';

  // ===== TOKEN =====
  Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kAccess);
  }

  // ===== LOGIN =====
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception('Неверный логин или пароль');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final access = data['access']?.toString();
    if (access == null || access.isEmpty) {
      throw Exception('Токен не получен');
    }

    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kAccess, access);

    return AuthTokens(access: access);
  }

  // ===== REGISTER =====
  Future<void> register({
    required String name,
    required String email,
    required String password,
    File? avatar,
  }) async {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/auth/register/'),
    );

    req.fields['name'] = name;
    req.fields['email'] = email;
    req.fields['password'] = password;

    if (avatar != null) {
      req.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    final res = await req.send();

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Ошибка регистрации');
    }
  }

  // ===== ME =====
  Future<AppUser> getMe(String access) async {
    final res = await http.get(
      Uri.parse('$baseUrl/me/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (res.statusCode != 200) {
      throw Exception('Сессия истекла');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return AppUser.fromJson(data);
  }

  // ===== LOGOUT =====
  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kAccess);
  }
}
