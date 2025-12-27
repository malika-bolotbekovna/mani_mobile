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
    int asInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return SubmitAttemptResult(
      lessonId: asInt(json['lesson_id']),
      completed: (json['completed'] ?? false) as bool,
      allCorrect: (json['all_correct'] ?? false) as bool,
      score: asInt(json['score']),
      next: json['next'] as String?,
    );
  }
}

class ProgressService {
  ProgressService({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient.instance;

  final ApiClient apiClient;

  Future<SubmitAttemptResult> submitAttempt({
    required int exerciseId,
    required bool isCorrect,
  }) async {
    final data = await apiClient.postJson(
      '/api/progress/submit-attempt/',
      body: {'exercise_id': exerciseId, 'is_correct': isCorrect},
    );

    final status = (data['_status'] ?? 0) as int;
    if (status < 200 || status >= 300) {
      throw Exception(data['detail'] ?? 'Request failed: $status');
    }

    return SubmitAttemptResult.fromJson(data);
  }
}
