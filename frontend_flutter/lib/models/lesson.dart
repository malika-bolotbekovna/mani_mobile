class Lesson {
  final int id;
  final String title;
  final int orderNum;
  final int xpReward;
  final int courseId;

  // пока прогресс не подключили — завершённость считаем по умолчанию false
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.orderNum,
    required this.xpReward,
    required this.courseId,
    required this.isCompleted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      orderNum: (json['order_num'] as num?)?.toInt() ?? 1,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 10,
      courseId: (json['course'] as num?)?.toInt() ?? 0,
      isCompleted: false,
    );
  }
}
