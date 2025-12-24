import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../services/vocabulary_service.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final service = VocabularyService();

  static const bg = Color(0xFFF6EEDF);
  static const textMain = Color(0xFF2B2B2B);
  static const accent = Color(0xFFE9A0B2);

  bool loading = true;
  String errorText = '';
  List<VocabularyWord> words = [];
  String search = '';

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
      final data = await service.getVocabulary();
      setState(() {
        words = data;
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
    final filtered = search.trim().isEmpty
        ? words
        : words.where((w) {
            final q = search.trim().toLowerCase();
            return w.word.toLowerCase().contains(q) ||
                w.translation.toLowerCase().contains(q);
          }).toList();

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
                'Словарь',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 14),

              _SearchField(
                value: search,
                onChanged: (v) => setState(() => search = v),
              ),

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
              else if (filtered.isEmpty)
                const Expanded(child: Center(child: Text('Ничего не найдено')))
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final w = filtered[i];
                        return _WordCard(word: w);
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
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
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          hintText: 'Поиск',
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final VocabularyWord word;
  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Expanded(
            flex: 4,
            child: Text(
              word.word,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              word.translation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black.withValues(alpha: 0.55),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {
              // пока просто показываем пример (если есть)
              final ex = word.example.trim().isEmpty
                  ? 'Пример отсутствует'
                  : word.example;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(word.word),
                  content: Text(ex),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ок'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.menu_book),
          ),
        ],
      ),
    );
  }
}
