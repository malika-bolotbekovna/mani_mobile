import 'package:flutter/material.dart';
import '../models/exercise.dart';

class LessonCardsScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final VoidCallback? onFinished;

  const LessonCardsScreen({
    super.key,
    required this.exercises,
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

  Exercise get ex => widget.exercises[index];

  void _check(String v) {
    if (checked) return;
    setState(() {
      selected = v;
      checked = true;
    });
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
                final isCorrect = checked && url == ex.correctAnswer;
                final isWrong =
                    checked && isSelected && url != ex.correctAnswer;

                Color border = Colors.transparent;
                if (isCorrect) border = Colors.green;
                if (isWrong) border = Colors.red;

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
                child: const Text(
                  'Дальше',
                  style: TextStyle(
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
