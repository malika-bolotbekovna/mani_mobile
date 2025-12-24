class VocabularyWord {
  final int id;
  final String word;
  final String translation;
  final String example;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.translation,
    required this.example,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: (json['id'] as num).toInt(),
      word: (json['word'] ?? '').toString(),
      translation: (json['translation'] ?? '').toString(),
      example: (json['example'] ?? '').toString(),
    );
  }
}
