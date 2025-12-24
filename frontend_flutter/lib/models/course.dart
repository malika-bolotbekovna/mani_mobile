import 'topic.dart';

class Course {
  final int id;
  final String title;
  final Topic topic;

  Course({required this.id, required this.title, required this.topic});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      topic: Topic.fromJson(json['topic'] as Map<String, dynamic>),
    );
  }
}
