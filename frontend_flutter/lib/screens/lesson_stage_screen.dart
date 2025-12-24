import 'package:flutter/material.dart';

class LessonStageScreen extends StatelessWidget {
  final String title; // например "Урок — шаг 1/4" или "Урок — шаг 1/4"
  final double progress; // 0..1
  final String hint; // "Выполняй задания по очереди"
  final String stageTitle; // "Выбор ответа" / "Ввод слова"
  final String stageDescription; // текст объяснения
  final String emoji; // 🧠 / ✍️
  final VoidCallback onStart;

  const LessonStageScreen({
    super.key,
    required this.title,
    required this.progress,
    required this.hint,
    required this.stageTitle,
    required this.stageDescription,
    required this.emoji,
    required this.onStart,
  });

  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);
  static const textMain = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Урок'),
        backgroundColor: bg,
        surfaceTintColor: bg,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              title,
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
                value: progress.clamp(0, 1),
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.55),
                valueColor: const AlwaysStoppedAnimation(accent),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              hint,
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
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$stageTitle: $stageDescription',
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
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
