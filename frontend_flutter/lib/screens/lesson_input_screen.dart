import 'package:flutter/material.dart';
import '../models/exercise.dart';

class LessonInputScreen extends StatefulWidget {
  final List<Exercise> exercises; // только type=input
  final int startIndex;
  final VoidCallback? onFinished;

  const LessonInputScreen({
    super.key,
    required this.exercises,
    this.startIndex = 0,
    this.onFinished,
  });

  @override
  State<LessonInputScreen> createState() => _LessonInputScreenState();
}

class _LessonInputScreenState extends State<LessonInputScreen> {
  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  late int index;
  final ctrl = TextEditingController();

  bool checked = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Exercise get ex => widget.exercises[index];

  String _norm(String s) => s.trim().toLowerCase();

  void _check() {
    final user = _norm(ctrl.text);
    final right = _norm(ex.correctAnswer);

    setState(() {
      checked = true;
      isCorrect = user.isNotEmpty && user == right;
    });
  }

  void _next() {
    if (index + 1 >= widget.exercises.length) {
      if (widget.onFinished != null) {
        widget.onFinished!();
      } else {
        Navigator.of(context).popUntil((r) => r.isFirst);
      }

      return;
    }
    setState(() {
      index++;
      ctrl.clear();
      checked = false;
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.exercises.length;
    final step = index + 1;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Ввод слова'),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            const Text(
              'Ввод слова',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: textMain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Шаг $step/$total',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.6),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              ex.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: TextField(
                controller: ctrl,
                enabled: !checked,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) {
                  if (!checked) _check();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введи ответ',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),

            const SizedBox(height: 14),

            if (checked)
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.close,
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isCorrect
                            ? 'Верно! Отлично!'
                            : 'Почти! Правильный ответ: "${ex.correctAnswer}"',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: checked
                    ? _next
                    : (ctrl.text.trim().isEmpty ? null : _check),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  disabledBackgroundColor: accent.withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  checked ? 'Дальше' : 'Ответить',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
