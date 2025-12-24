import 'package:flutter/material.dart';
import 'reward_screen.dart';

class TranslationCardsScreen extends StatelessWidget {
  const TranslationCardsScreen({super.key, required this.allCorrect});

  final bool allCorrect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EEDF),
      appBar: AppBar(
        title: const Text('Карточки перевода'),
        backgroundColor: const Color(0xFFF6EEDF),
        surfaceTintColor: const Color(0xFFF6EEDF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Повтори слова перед наградой',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // TODO: сюда позже подставишь реальные слова урока
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.8,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  _Card(word: 'дом', translation: 'house'),
                  _Card(word: 'кот', translation: 'cat'),
                  _Card(word: 'мир', translation: 'world'),
                  _Card(word: 'язык', translation: 'language'),
                ],
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RewardScreen(allCorrect: allCorrect),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9A0B2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Готово',
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

class _Card extends StatelessWidget {
  const _Card({required this.word, required this.translation});

  final String word;
  final String translation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(translation, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
