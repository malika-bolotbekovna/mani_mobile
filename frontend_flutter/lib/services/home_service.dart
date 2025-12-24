import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeStats {
  final int topics;
  final int courses;
  final int words;

  HomeStats({required this.topics, required this.courses, required this.words});
}

class HomeService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<HomeStats> getStats() async {
    final topicsReq = http.get(Uri.parse('$baseUrl/api/topics/'));
    final coursesReq = http.get(Uri.parse('$baseUrl/api/courses/'));
    final wordsReq = http.get(Uri.parse('$baseUrl/api/vocabulary/'));

    final res = await Future.wait([topicsReq, coursesReq, wordsReq]);

    if (res[0].statusCode != 200) throw Exception('Не загрузились темы');
    if (res[1].statusCode != 200) throw Exception('Не загрузились курсы');
    if (res[2].statusCode != 200) throw Exception('Не загрузился словарь');

    final topics = (jsonDecode(res[0].body) as List).length;
    final courses = (jsonDecode(res[1].body) as List).length;
    final words = (jsonDecode(res[2].body) as List).length;

    return HomeStats(topics: topics, courses: courses, words: words);
  }
}
