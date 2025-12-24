import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/course_service.dart';
import '../models/course.dart';
import 'lesson_list_screen.dart';

class TopicCoursesScreen extends StatefulWidget {
  final Topic topic;
  const TopicCoursesScreen({super.key, required this.topic});

  @override
  State<TopicCoursesScreen> createState() => _TopicCoursesScreenState();
}

class _TopicCoursesScreenState extends State<TopicCoursesScreen> {
  final service = CourseService();

  static const bg = Color(0xFFF6EEDF);

  bool loading = true;
  String errorText = '';
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      errorText = '';
    });

    try {
      final data = await service.getCoursesByTopic(widget.topic.id);
      setState(() {
        courses = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorText = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(widget.topic.title),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : errorText.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(errorText, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _load,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final c = courses[i];

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonListScreen(
                            courseId: c.id,
                            courseTitle: c.title,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                            color: Colors.black.withValues(alpha: 0.05),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('📘', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              c.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
