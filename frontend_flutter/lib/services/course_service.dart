import '../models/course.dart';
import 'api_client.dart';

class CourseService {
  CourseService({ApiClient? api}) : _api = api ?? ApiClient();
  final ApiClient _api;

  Future<List<Course>> getCoursesByTopic(int topicId) async {
    final list = await _api.getList('/api/courses/?topic=$topicId');
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
