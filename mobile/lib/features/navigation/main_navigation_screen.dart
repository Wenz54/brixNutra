import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/home/home_screen.dart';
import 'package:mobile/features/profile/profile_screen.dart';
import 'package:mobile/features/meal_plan/meal_plan.dart';
import 'package:mobile/features/meal_plan/screens/meal_plan_screen.dart';
import 'package:mobile/features/diary/diary.dart';
import 'package:mobile/features/diary/screens/diary_screen.dart';
import 'package:mobile/features/ai_chat/ai_chat.dart';
import 'package:mobile/features/ai_chat/screens/ai_chat_screen.dart';

/// Главный экран с Bottom Navigation Bar
///
/// Содержит 5 основных разделов:
/// - Главная
/// - Рацион
/// - AI-чат
/// - Дневник
/// - Профиль
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      BlocProvider(
        create: (context) => MealPlanBloc(),
        child: const MealPlanScreen(),
      ),
      BlocProvider(
        create: (context) => AiChatBloc(),
        child: const AiChatScreen(),
      ),
      BlocProvider(
        create: (context) => DiaryBloc(),
        child: const DiaryScreen(),
      ),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined),
              activeIcon: Icon(Icons.restaurant),
              label: 'Рацион',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'AI-чат',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Дневник',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}

