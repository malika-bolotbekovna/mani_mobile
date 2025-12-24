import 'package:flutter/material.dart';
import 'package:frontend_flutter/screens/lesson_start_screen.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

class LessonListScreen extends StatefulWidget {
  final int courseId;
  final String? courseTitle;

  const LessonListScreen({super.key, required this.courseId, this.courseTitle});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  final service = LessonService();

  static const bg = Color(0xFFF6EEDF);

  bool loading = true;
  String errorText = '';
  List<Lesson> lessons = [];

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
      final data = await service.getLessonsByCourse(widget.courseId);
      setState(() {
        lessons = data;
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
        title: Text(widget.courseTitle ?? 'Уроки'),
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
                itemCount: lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final l = lessons[i];
                  final title = l.title.isNotEmpty
                      ? l.title
                      : 'Урок ${l.orderNum}';
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonStartScreen(
                            lessonId: l.id,
                            lessonTitle: title,
                          ),
                        ),
                      );
                    },
                    child: _LessonCard(
                      title: title,
                      isCompleted: l.isCompleted,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final bool isCompleted;
  static const Color textMain = Color(0xFF2B2B2B);
  const _LessonCard({required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textMain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isCompleted ? 'Завершён' : 'Не завершён',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _CheckIcon(isCompleted: isCompleted),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.chevron_right,
            color: Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool isCompleted;
  const _CheckIcon({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFF2ECC71)
            : Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.check,
        size: 18,
        color: isCompleted
            ? Colors.white
            : Colors.black.withValues(alpha: 0.25),
      ),
    );
  }
}
