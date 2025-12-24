import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

class ExerciseService {
  static const baseUrl = 'http://10.0.2.2:8000';

  Future<List<Exercise>> getExercisesByLesson(int lessonId) async {
    final uri = Uri.parse('$baseUrl/api/exercises/?lesson=$lessonId');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Не удалось загрузить упражнения: ${res.statusCode}');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => Exercise.fromJson(e)).toList();
  }
}
