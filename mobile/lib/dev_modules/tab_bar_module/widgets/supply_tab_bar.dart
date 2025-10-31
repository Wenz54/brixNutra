import 'package:flutter/material.dart';
// Импортируйте локализацию если нужна:
// import 'package:easy_localization/easy_localization.dart';
import '../models/tab_item.dart';

/// Нижний таб-бар навигации Supply Diets
/// 
/// Анимированный таб-бар с 4 вкладками:
/// - Home (Главная)
/// - AI Chat (AI Чат)
/// - Diary (Дневник)
/// - Knowledge Base (База знаний)
/// 
/// При выборе вкладки показывается текст с анимацией
class SupplyTabBar extends StatefulWidget {
  final TabItem selectedTab;
  final Function(TabItem) onTabSelected;

  const SupplyTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  State<SupplyTabBar> createState() => _SupplyTabBarState();
}

class _SupplyTabBarState extends State<SupplyTabBar> with TickerProviderStateMixin {
  // Создаем отдельный контроллер анимации для каждого таба
  late Map<TabItem, AnimationController> _animationControllers;
  late Map<TabItem, Animation<double>> _expandAnimations;

  @override
  void initState() {
    super.initState();
    _animationControllers = {};
    _expandAnimations = {};
    
    // Инициализируем анимации для каждого таба
    for (final tab in TabItem.values) {
      _animationControllers[tab] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _expandAnimations[tab] = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationControllers[tab]!,
        curve: Curves.easeInOut,
      ));
    }
    
    // Запускаем анимацию для выбранного таба
    _animationControllers[widget.selectedTab]?.forward();
  }

  @override
  void didUpdateWidget(SupplyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTab != widget.selectedTab) {
      // Останавливаем анимацию старого таба
      _animationControllers[oldWidget.selectedTab]?.reverse();
      // Запускаем анимацию нового таба
      _animationControllers[widget.selectedTab]?.forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTap(TabItem tab) {
    // Всегда вызываем onTabSelected
    widget.onTabSelected(tab);
  }

  /// Получить путь к иконке таба
  String _getTabIcon(TabItem tab) {
    switch (tab) {
      case TabItem.home:
        return 'assets/ICONS/home.png';
      case TabItem.aiChat:
        return 'assets/ICONS/ai_chat.png';
      case TabItem.diary:
        return 'assets/ICONS/diary.png';
      case TabItem.knowledgeBase:
        return 'assets/ICONS/base.png';
    }
  }

  /// Получить текст таба
  /// 
  /// Для локализации используйте:
  /// return AppLocalizations.homeMain.tr();
  String _getTabText(TabItem tab) {
    switch (tab) {
      case TabItem.home:
        return 'Главная'; // AppLocalizations.homeMain.tr()
      case TabItem.aiChat:
        return 'AI Чат'; // AppLocalizations.homeAiChat.tr()
      case TabItem.diary:
        return 'Дневник'; // AppLocalizations.homeDiary.tr()
      case TabItem.knowledgeBase:
        return 'База знаний'; // AppLocalizations.homeKnowledgeBase.tr()
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TabItem.values.map((tab) {
          final isSelected = tab == widget.selectedTab;
          final animation = _expandAnimations[tab]!;
          
          return GestureDetector(
            onTap: () => _onTabTap(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF1F3DB) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Иконка (36x36)
                  _buildTabIcon(tab),
                  
                  // Текст появляется только при выборе с анимацией
                  if (isSelected) ...[
                    const SizedBox(width: 12),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animation.value,
                          child: Transform.scale(
                            scale: 0.8 + (animation.value * 0.2),
                            child: Text(
                              _getTabText(tab),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8B4513),
                                fontFamily: 'Urbanist',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Построить иконку таба
  /// 
  /// Использует PNG из assets
  /// Если иконка не найдена, показывает placeholder
  Widget _buildTabIcon(TabItem tab) {
    final iconPath = _getTabIcon(tab);
    
    return Image.asset(
      iconPath,
      width: 36,
      height: 36,
      color: const Color(0xFF8B4513),
      errorBuilder: (context, error, stackTrace) {
        // Fallback: показать иконку Material Design
        return Icon(
          _getFallbackIcon(tab),
          size: 36,
          color: const Color(0xFF8B4513),
        );
      },
    );
  }

  /// Fallback иконки если PNG не найдена
  IconData _getFallbackIcon(TabItem tab) {
    switch (tab) {
      case TabItem.home:
        return Icons.home;
      case TabItem.aiChat:
        return Icons.chat_bubble;
      case TabItem.diary:
        return Icons.book;
      case TabItem.knowledgeBase:
        return Icons.library_books;
    }
  }
}





