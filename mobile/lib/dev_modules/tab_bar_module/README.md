# Tab Bar Module

Модуль нижнего таб-бара навигации для Supply Diets приложения.

## 📦 Содержание

- **widgets/** - Компонент SupplyTabBar
- **models/** - Модели навигации (TabItem enum)

## 🚀 Использование

### SupplyTabBar

```dart
import 'package:supply_diets_app/dev_modules/tab_bar_module/widgets/supply_tab_bar.dart';
import 'package:supply_diets_app/dev_modules/tab_bar_module/models/tab_item.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TabItem _selectedTab = TabItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SupplyTabBar(
          selectedTab: _selectedTab,
          onTabSelected: (tab) {
            setState(() {
              _selectedTab = tab;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case TabItem.home:
        return HomeScreen();
      case TabItem.aiChat:
        return AiChatScreen();
      case TabItem.diary:
        return DiaryScreen();
      case TabItem.knowledgeBase:
        return KnowledgeBaseScreen();
    }
  }
}
```

## 📱 Вкладки

Модуль поддерживает 4 основных вкладки:

1. **Home** - Главный экран
   - Иконка: `assets/ICONS/home.png`
   - Текст: "Главная"

2. **AI Chat** - AI чат ассистент
   - Иконка: `assets/ICONS/ai_chat.png`
   - Текст: "AI Чат"

3. **Diary** - Дневник питания
   - Иконка: `assets/ICONS/diary.png`
   - Текст: "Дневник"

4. **Knowledge Base** - База знаний
   - Иконка: `assets/ICONS/base.png`
   - Текст: "База знаний"

## 🎨 Дизайн

### Анимации
- Плавное появление текста при выборе вкладки
- Анимация расширения/сжатия кнопки
- Transition duration: 300ms
- Curve: easeInOut

### Цвета
- Активная вкладка: `#F1F3DB` (светло-салатовый фон)
- Иконка и текст: `#8B4513` (коричневый)
- Неактивная вкладка: прозрачный фон

### Размеры
- Высота таб-бара: 80px
- Размер иконки: 36x36px
- Radius: 20px
- Padding между элементами: 12px

## ✨ Особенности

1. **Анимированный текст** - Текст появляется только у выбранной вкладки
2. **Плавные переходы** - Smooth анимация между вкладками
3. **Иконки из assets** - Используются PNG иконки из assets
4. **Локализация** - Поддержка нескольких языков

## 🌍 Локализация

Тексты вкладок локализуются через `easy_localization`:

```json
{
  "home.main": "Главная",
  "home.ai_chat": "AI Чат",
  "home.diary": "Дневник",
  "home.knowledge_base": "База знаний"
}
```

## 🔧 Кастомизация

### Изменить количество вкладок

Отредактируйте `models/tab_item.dart`:

```dart
enum TabItem {
  home,
  aiChat,
  diary,
  knowledgeBase,
  // Добавьте новую вкладку
  newTab,
}
```

Затем обновите `widgets/supply_tab_bar.dart`:

```dart
String _getTabIcon(TabItem tab) {
  switch (tab) {
    case TabItem.newTab:
      return 'assets/ICONS/new_icon.png';
    // ...
  }
}

String _getTabText(TabItem tab) {
  switch (tab) {
    case TabItem.newTab:
      return 'Новая вкладка';
    // ...
  }
}
```

### Изменить дизайн

Цвета и размеры настраиваются в `widgets/supply_tab_bar.dart`:

```dart
// Цвет активной вкладки
backgroundColor: const Color(0xFFF1F3DB)

// Цвет иконки и текста
color: const Color(0xFF8B4513)

// Размер иконки
width: 36, height: 36

// Radius
borderRadius: BorderRadius.circular(20)
```

## 📚 Зависимости

```yaml
dependencies:
  flutter:
    sdk: flutter
  easy_localization: ^3.0.0
```

## 💡 Примеры использования

### С навигацией через PageView

```dart
final PageController _pageController = PageController();

SupplyTabBar(
  selectedTab: _selectedTab,
  onTabSelected: (tab) {
    setState(() => _selectedTab = tab);
    _pageController.jumpToPage(tab.index);
  },
)
```

### С сохранением состояния

```dart
class _MainScreenState extends State<MainScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  
  // ... rest of code
}
```

## 📝 Требования к assets

Убедитесь, что у вас есть иконки в `assets/ICONS/`:
- `home.png`
- `ai_chat.png`
- `diary.png`
- `base.png`

Добавьте в `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/ICONS/
```





