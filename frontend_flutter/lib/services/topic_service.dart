import '../models/topic.dart';
import 'api_client.dart';

class TopicService {
  final api = ApiClient.instance;

  Future<List<Topic>> getTopics() async {
    final list = await api.getList('/api/topics/');
    return list.map((e) => Topic.fromJson(e)).toList();
  }
}
