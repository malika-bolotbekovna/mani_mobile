import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lesson.dart';

class LessonService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    final uri = Uri.parse('$baseUrl/api/lessons/?course=$courseId');
    final res = await http.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Ошибка загрузки уроков: ${res.statusCode}');
    }

    final body = jsonDecode(utf8.decode(res.bodyBytes));

    if (body is! List) {
      throw Exception('Неожиданный формат ответа: ожидался List');
    }

    return body.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
  }
}
