import 'package:flutter/material.dart';
import 'package:frontend_flutter/screens/lesson_runner_screen.dart';
import '../services/exercise_service.dart';
import '../models/exercise.dart';

class LessonStartScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;

  const LessonStartScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<LessonStartScreen> createState() => _LessonStartScreenState();
}

class _LessonStartScreenState extends State<LessonStartScreen> {
  final service = ExerciseService();

  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  bool loading = true;
  String errorText = '';

  List<Exercise> allExercises = [];

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
      final data = await service.getExercisesByLesson(widget.lessonId);
      setState(() {
        allExercises = data;
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
    final total = allExercises.length;
    final stepText = total == 0 ? 'Урок' : 'Урок — шаг 1/4';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Урок'),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : errorText.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(backgroundColor: accent),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    stepText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textMain,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : 1 / 4,
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.55),
                      valueColor: const AlwaysStoppedAnimation(accent),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Text(
                    'Выполняй задания по очереди',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Text('🧠', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Выбор ответа: прочитай вопрос и выбери правильный вариант.',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: total == 0
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LessonRunnerScreen(
                                    lessonTitle: widget.lessonTitle,
                                    exercises: allExercises,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        disabledBackgroundColor: accent.withValues(alpha: 0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Перейти к заданиям',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}
