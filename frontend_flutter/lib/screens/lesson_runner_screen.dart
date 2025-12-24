import 'package:flutter/material.dart';
import '../models/exercise.dart';
import 'lesson_choice_screen.dart';
import 'lesson_input_screen.dart';
import 'lesson_cards_screen.dart';

class LessonRunnerScreen extends StatefulWidget {
  final String lessonTitle;
  final List<Exercise> exercises;

  const LessonRunnerScreen({
    super.key,
    required this.lessonTitle,
    required this.exercises,
  });

  @override
  State<LessonRunnerScreen> createState() => _LessonRunnerScreenState();
}

class _LessonRunnerScreenState extends State<LessonRunnerScreen> {
  late final List<Exercise> choiceList;
  late final List<Exercise> inputList;
  late final List<Exercise> cardsList;

  int step = 0; // 0-choice → 1-input → 2-cards

  @override
  void initState() {
    super.initState();

    choiceList = widget.exercises
        .where((e) => e.type == 'choice')
        .take(4)
        .toList();
    inputList = widget.exercises
        .where((e) => e.type == 'input')
        .take(4)
        .toList();
    cardsList = widget.exercises
        .where((e) => e.type == 'cards')
        .take(4)
        .toList();

    // если choice нет — начинаем с input
    if (choiceList.isEmpty && inputList.isNotEmpty) {
      step = 1;
    }
    // если нет ни choice, ни input — начинаем с cards
    if (choiceList.isEmpty && inputList.isEmpty && cardsList.isNotEmpty) {
      step = 2;
    }
  }

  void _nextBlock() {
    setState(() {
      step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1️⃣ choice
    if (step == 0 && choiceList.isNotEmpty) {
      return LessonChoiceScreen(
        lessonTitle: widget.lessonTitle,
        exercises: choiceList,
        onFinished: _nextBlock,
      );
    }

    // 2️⃣ input
    if (step == 1 && inputList.isNotEmpty) {
      return LessonInputScreen(exercises: inputList, onFinished: _nextBlock);
    }

    // 3️⃣ cards  ← ВОТ ТУТ ОНО
    if (step == 2 && cardsList.isNotEmpty) {
      return LessonCardsScreen(
        exercises: cardsList,
        onFinished: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      );
    }

    // если упражнений вообще нет
    return Scaffold(
      backgroundColor: const Color(0xFFF6EEDF),
      appBar: AppBar(
        title: const Text('Урок'),
        backgroundColor: const Color(0xFFF6EEDF),
        surfaceTintColor: const Color(0xFFF6EEDF),
      ),
      body: const Center(child: Text('В уроке пока нет упражнений')),
    );
  }
}
