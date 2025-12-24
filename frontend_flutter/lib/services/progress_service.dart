import 'api_client.dart';

class SubmitAttemptResult {
  final int lessonId;
  final bool completed;
  final bool allCorrect;
  final int score;
  final String? next;

  SubmitAttemptResult({
    required this.lessonId,
    required this.completed,
    required this.allCorrect,
    required this.score,
    required this.next,
  });

  factory SubmitAttemptResult.fromJson(Map<String, dynamic> json) {
    return SubmitAttemptResult(
      lessonId: (json['lesson_id'] ?? 0) as int,
      completed: (json['completed'] ?? false) as bool,
      allCorrect: (json['all_correct'] ?? false) as bool,
      score: (json['score'] ?? 0) as int,
      next: json['next'] as String?,
    );
  }
}

class ProgressService {
  final ApiClient api;
  ProgressService(this.api);

  Future<SubmitAttemptResult> submitAttempt({
    required int exerciseId,
    required bool isCorrect,
  }) async {
    final data = await api.post(
      '/progress/submit-attempt/',
      body: {'exercise_id': exerciseId, 'is_correct': isCorrect},
    );

    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response: $data');
    }
    return SubmitAttemptResult.fromJson(data);
  }
}
