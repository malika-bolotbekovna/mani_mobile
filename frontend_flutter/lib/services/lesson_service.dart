import '../models/lesson.dart';
import 'api_client.dart';

class LessonService {
  final api = ApiClient.instance;

  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    final list = await api.getList('/api/lessons/?course=$courseId');
    return list.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
  }
}
