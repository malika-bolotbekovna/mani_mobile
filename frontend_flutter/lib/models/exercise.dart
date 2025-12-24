import 'dart:convert';

class Exercise {
  final int id;
  final String type; // choice | input | cards
  final String question;
  final String correctAnswer;
  final List<String> options; // для choice и cards
  final int lessonId;

  Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.lessonId,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      type: json['type'],
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      options: _parseOptions(json['options_json']),
      lessonId: json['lesson'],
    );
  }

  static List<String> _parseOptions(dynamic raw) {
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return [];
  }
}
