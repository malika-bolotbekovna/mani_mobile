import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/course.dart';
import '../models/lesson.dart';

class Api {
  Api({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<Course>> fetchCourses() async {
    // Подстрой под свой endpoint списка курсов:
    // /api/courses/
    final uri = Uri.parse('$baseUrl/api/courses/');
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Ошибка загрузки курсов: ${res.statusCode}');
    }

    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final list = body is List ? body : (body['results'] as List? ?? const []);
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Course> fetchCourse(int courseId) async {
    final uri = Uri.parse('$baseUrl/api/courses/$courseId/');
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Ошибка загрузки курса: ${res.statusCode}');
    }

    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return Course.fromJson(body);
  }

  Future<List<Lesson>> fetchLessons({required int courseId}) async {
    // Подстрой под свой endpoint уроков курса:
    final uri = Uri.parse('$baseUrl/api/courses/$courseId/lessons/');
    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Ошибка загрузки уроков: ${res.statusCode}');
    }

    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final list = body is List ? body : (body['results'] as List? ?? const []);
    return list.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
  }
}
