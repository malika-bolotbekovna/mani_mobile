import '../services/api_client.dart';

class HomeStats {
  final int topics;
  final int courses;
  final int words;

  HomeStats({required this.topics, required this.courses, required this.words});
}

class HomeService {
  final api = ApiClient.instance;

  Future<HomeStats> getStats() async {
    final topics = await api.getList('/api/topics/');
    final courses = await api.getList('/api/courses/');
    final words = await api.getList('/api/vocabulary/');

    return HomeStats(
      topics: topics.length,
      courses: courses.length,
      words: words.length,
    );
  }
}
