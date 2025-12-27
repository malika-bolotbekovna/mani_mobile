import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/progress_service.dart';

class LessonCardsScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final VoidCallback? onFinished;
  final ProgressService progressService;

  const LessonCardsScreen({
    super.key,
    required this.exercises,
    required this.progressService,
    this.onFinished,
  });

  @override
  State<LessonCardsScreen> createState() => _LessonCardsScreenState();
}

class _LessonCardsScreenState extends State<LessonCardsScreen> {
  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);

  int index = 0;
  String? selected;
  bool checked = false;
  bool isCorrect = false;
  bool sending = false;

  Exercise get ex => widget.exercises[index];

  Future<void> _check(String v) async {
    if (checked || sending) return;

    final ok = v == ex.correctAnswer;

    setState(() {
      selected = v;
      checked = true;
      isCorrect = ok;
      sending = true;
    });

    try {
      await widget.progressService.submitAttempt(
        exerciseId: ex.id,
        isCorrect: ok,
      );

      if (!mounted) return;
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  void _next() {
    if (index + 1 >= widget.exercises.length) {
      widget.onFinished?.call();
      return;
    }
    setState(() {
      index++;
      selected = null;
      checked = false;
      isCorrect = false;
      sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Карточки'),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ex.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              itemCount: ex.options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, i) {
                final url = ex.options[i];
                final isSelected = selected == url;
                final correct = checked && url == ex.correctAnswer;
                final wrong = checked && isSelected && url != ex.correctAnswer;

                Color border = Colors.transparent;
                if (correct) border = Colors.green;
                if (wrong) border = Colors.red;

                return GestureDetector(
                  onTap: () => _check(url),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border, width: 3),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(url, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: checked ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  sending ? 'Проверяем...' : 'Дальше',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
