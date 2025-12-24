import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/topic_service.dart';
import 'topic_courses_screen.dart';

class CourseMapScreen extends StatefulWidget {
  const CourseMapScreen({super.key});

  @override
  State<CourseMapScreen> createState() => _CourseMapScreenState();
}

class _CourseMapScreenState extends State<CourseMapScreen> {
  final service = TopicService();

  static const bg = Color(0xFFF6EEDF);
  static const textMain = Color(0xFF2B2B2B);
  static const accent = Color(0xFFE9A0B2);

  bool loading = true;
  String errorText = '';
  List<Topic> topics = [];

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
      final data = await service.getTopics();
      setState(() {
        topics = data;
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
                'Карта курса',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 16),

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
                  child: GridView.builder(
                    itemCount: topics.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.35, // как на скрине
                        ),
                    itemBuilder: (context, i) {
                      final t = topics[i];
                      return _TopicCard(
                        title: t.title,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TopicCoursesScreen(topic: t),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      // если у тебя уже есть нижнее меню — сюда подключим позже.
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  static const accent = Color(0xFFE9A0B2);

  const _TopicCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('📍', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
