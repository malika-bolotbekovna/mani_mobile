import 'package:flutter/material.dart';
import '../models/exercise.dart';

class LessonChoiceScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Exercise> exercises;
  final int startIndex;
  final VoidCallback? onFinished;

  const LessonChoiceScreen({
    super.key,
    required this.lessonTitle,
    required this.exercises,
    this.startIndex = 0,
    this.onFinished,
  });

  @override
  State<LessonChoiceScreen> createState() => _LessonChoiceScreenState();
}

class _LessonChoiceScreenState extends State<LessonChoiceScreen> {
  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  late int index;
  String? selected;
  bool checked = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
  }

  Exercise get ex => widget.exercises[index];

  void _select(String v) {
    if (checked) return;
    setState(() => selected = v);
  }

  void _check() {
    if (selected == null) return;
    final ok = selected == ex.correctAnswer;
    setState(() {
      checked = true;
      isCorrect = ok;
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
      selected = null;
      checked = false;
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.exercises.length;
    final step = index + 1;

    // гарантируем 4 варианта
    final opts = ex.options.take(4).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Выбор ответа'),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text(
              'Выбор ответа',
              style: const TextStyle(
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

            const SizedBox(height: 18),

            ...opts.map(
              (o) => _OptionTile(
                text: o,
                selected: selected == o,
                checked: checked,
                isCorrectOption: checked && (o == ex.correctAnswer),
                isWrongSelected:
                    checked && (selected == o) && (o != ex.correctAnswer),
                onTap: () => _select(o),
              ),
            ),

            const SizedBox(height: 16),

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
                    Text(
                      isCorrect ? 'Верно!' : 'Неверно',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isCorrect ? Colors.green : Colors.red,
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
                onPressed: selected == null ? null : (checked ? _next : _check),
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

class _OptionTile extends StatelessWidget {
  final String text;
  final bool selected;
  final bool checked;
  final bool isCorrectOption;
  final bool isWrongSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.selected,
    required this.checked,
    required this.isCorrectOption,
    required this.isWrongSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white.withValues(alpha: 0.85);

    if (selected && !checked) {
      bg = const Color(0xFFF2D7DD); // лёгкая розовая подсветка как на скрине
    }
    if (isCorrectOption) {
      bg = const Color(0xFFDFF3E3);
    }
    if (isWrongSelected) {
      bg = const Color(0xFFF6DADA);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: checked ? null : onTap,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
