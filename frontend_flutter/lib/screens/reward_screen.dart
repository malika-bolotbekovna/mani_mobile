import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key, required this.allCorrect});

  final bool allCorrect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EEDF),
      appBar: AppBar(
        title: const Text('Награда'),
        backgroundColor: const Color(0xFFF6EEDF),
        surfaceTintColor: const Color(0xFFF6EEDF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 72),
              const SizedBox(height: 16),
              const Text(
                'Поздравляем!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Text(
                allCorrect
                    ? 'Ты выполнил все задания правильно и получил награду.'
                    : 'Урок завершён. Можно повторить, чтобы выполнить без ошибок.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9A0B2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'На главную',
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
      ),
    );
  }
}
