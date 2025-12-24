import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vocabulary.dart';

class VocabularyService {
  // поставь свой baseUrl как в остальных сервисах
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://127.0.0.1:8000'; // iOS simulator (обычно)

  Future<List<VocabularyWord>> getVocabulary() async {
    final res = await http.get(Uri.parse('$baseUrl/api/vocabulary/'));
    if (res.statusCode != 200) {
      throw Exception('Не удалось загрузить словарь (${res.statusCode})');
    }

    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
