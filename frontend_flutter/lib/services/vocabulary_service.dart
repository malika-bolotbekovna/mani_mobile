import '../models/vocabulary.dart';
import 'api_client.dart';

class VocabularyService {
  final api = ApiClient.instance;

  Future<List<VocabularyWord>> getVocabulary() async {
    final list = await api.getList('/api/vocabulary/');
    return list.map((e) => VocabularyWord.fromJson(e)).toList();
  }
}
