import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_client.dart';

import 'home_screen.dart';
import 'course_map_screen.dart';
import 'vocabulary_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  final AppUser me;
  final String access;

  const RootScreen({super.key, required this.me, required this.access});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int index = 1;

  static const bg = Color(0xFFF6EEDF);
  static const accent = Color(0xFFE9A0B2);

  late final ApiClient apiClient;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    apiClient = ApiClient.instance;
    apiClient.setToken(widget.access);

    pages = [
      const HomeScreen(),
      const CourseMapScreen(),
      const VocabularyScreen(),
      ProfileScreen(me: widget.me, access: widget.access),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        backgroundColor: Colors.white,
        selectedItemColor: accent,
        unselectedItemColor: Colors.black.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Дом'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Курсы'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Словарь'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
