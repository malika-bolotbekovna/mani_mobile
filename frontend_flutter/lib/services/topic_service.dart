import '../models/topic.dart';
import 'api_client.dart';

class TopicService {
  TopicService({ApiClient? api}) : _api = api ?? ApiClient();
  final ApiClient _api;

  Future<List<Topic>> getTopics() async {
    final list = await _api.getList('/api/topics/');
    return list.map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList();
  }
}
