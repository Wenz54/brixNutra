/// Перечисление вкладок нижнего таб-бара
/// 
/// Определяет доступные вкладки навигации в приложении
enum TabItem {
  /// Главный экран (Home)
  home,
  
  /// AI чат ассистент
  aiChat,
  
  /// Дневник питания
  diary,
  
  /// База знаний (курсы, статьи)
  knowledgeBase,
}

/// Расширение для TabItem с утилитами
extension TabItemExtension on TabItem {
  /// Получить название вкладки (для отладки)
  String get name {
    switch (this) {
      case TabItem.home:
        return 'Home';
      case TabItem.aiChat:
        return 'AI Chat';
      case TabItem.diary:
        return 'Diary';
      case TabItem.knowledgeBase:
        return 'Knowledge Base';
    }
  }

  /// Получить route name для навигации
  String get routeName {
    switch (this) {
      case TabItem.home:
        return '/home';
      case TabItem.aiChat:
        return '/ai-chat';
      case TabItem.diary:
        return '/diary';
      case TabItem.knowledgeBase:
        return '/knowledge-base';
    }
  }
}





