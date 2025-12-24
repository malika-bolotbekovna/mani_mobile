import 'package:flutter/material.dart';
import '../services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = HomeService();

  static const bg = Color(0xFFF6EEDF);
  static const textMain = Color(0xFF2B2B2B);
  static const accent = Color(0xFFE9A0B2);

  bool loading = true;
  String errorText = '';
  HomeStats? stats;

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
      final s = await service.getStats();
      setState(() {
        stats = s;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),
              const Text(
                'Дом',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              Center(child: Image.asset('assets/hedgehog.webp', height: 110)),

              const SizedBox(height: 14),

              if (loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (errorText.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorText,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _load,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                          ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _StatsRow(
                          topics: stats!.topics,
                          courses: stats!.courses,
                          words: stats!.words,
                        ),
                        const SizedBox(height: 14),
                        _BigCard(
                          title: 'Продолжить обучение',
                          subtitle: 'Выбери тему и начни урок',
                          icon: Icons.play_arrow,
                          onTap: () {
                            // ничего не делаем: переключение табов — это в RootScreen (по желанию можем сделать через callback)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Открой вкладку "Курсы"'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _BigCard(
                          title: 'Повторить слова',
                          subtitle: 'Открой словарь и повторяй',
                          icon: Icons.menu_book,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Открой вкладку "Словарь"'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Совет дня',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          child: Text(
                            'Лучше 5 минут каждый день, чем 1 час раз в неделю.',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
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

class _StatsRow extends StatelessWidget {
  final int topics;
  final int courses;
  final int words;

  const _StatsRow({
    required this.topics,
    required this.courses,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(title: 'Темы', value: topics.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(title: 'Курсы', value: courses.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(title: 'Слова', value: words.toString()),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _BigCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _BigCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE9A0B2).withValues(alpha: 0.25),
              child: Image.asset(
                'assets/hedgehog.webp',
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
