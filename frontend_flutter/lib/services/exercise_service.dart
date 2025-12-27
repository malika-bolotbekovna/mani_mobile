import '../models/exercise.dart';
import 'api_client.dart';

class ExerciseService {
  final api = ApiClient.instance;

  Future<List<Exercise>> getExercisesByLesson(int lessonId) async {
    final list = await api.getList('/api/exercises/?lesson=$lessonId');
    return list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
