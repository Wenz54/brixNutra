# Как использовать Dev Modules

Руководство по работе с модульной архитектурой Supply Diets.

## 📋 Содержание

1. [Быстрый старт](#быстрый-старт)
2. [Структура модулей](#структура-модулей)
3. [Подключение модулей](#подключение-модулей)
4. [Примеры использования](#примеры-использования)
5. [Кастомизация](#кастомизация)

## 🚀 Быстрый старт

### Шаг 1: Скопируйте нужные модули

```bash
# Скопируйте папку dev_modules в ваш проект
cp -r dev_modules /path/to/your/project/lib/
```

### Шаг 2: Подключите зависимости

Добавьте в `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Сеть
  dio: ^5.0.0
  http: ^1.0.0
  
  # Локальное хранилище
  shared_preferences: ^2.0.0
  hive: ^2.0.0
  hive_flutter: ^1.1.0
  
  # UI
  easy_localization: ^3.0.0
  
  # State management
  flutter_bloc: ^8.1.0
  
  # Даты
  intl: ^0.18.0
  
  # Изображения
  image_picker: ^1.0.0
```

### Шаг 3: Настройте API

Отредактируйте `dev_modules/core_module/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:3001/api';
```

### Шаг 4: Инициализация в main.dart

```dart
import 'dev_modules/core_module/services/token_manager.dart';
import 'dev_modules/core_module/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация TokenManager
  await TokenManager.init();
  
  // Инициализация API Service
  ApiService.initializeInterceptors();
  
  runApp(MyApp());
}
```

## 📦 Структура модулей

```
dev_modules/
├── README.md                    # Общее описание
├── HOW_TO_USE.md               # Это руководство
│
├── core_module/                # Базовые сервисы
│   ├── config/                 # Конфигурация
│   ├── services/               # API, токены
│   └── theme/                  # Тема приложения
│
├── ui_kit_module/              # UI компоненты
│   ├── buttons/
│   ├── inputs/
│   ├── cards/
│   ├── alerts/
│   └── README.md
│
└── [feature]_module/           # Feature модули
    ├── services/               # Бизнес логика
    ├── models/                 # Модели данных
    ├── screens/                # Экраны (опционально)
    ├── widgets/                # Виджеты (опционально)
    └── README.md               # Документация
```

## 🔌 Подключение модулей

### Минимальный набор (Обязательно)

1. **core_module** - Базовые сервисы, API, тема
2. **ui_kit_module** - UI компоненты

### Feature модули (По необходимости)

3. **auth_module** - Авторизация
4. **tab_bar_module** - Навигация
5. **home_module** - Главный экран
6. И другие по мере необходимости...

### Пример подключения

```dart
// В вашем файле импортируйте нужные модули:
import 'dev_modules/core_module/services/api_service.dart';
import 'dev_modules/ui_kit_module/buttons/supply_button.dart';
import 'dev_modules/auth_module/services/auth_service.dart';
```

## 💡 Примеры использования

### Пример 1: Простое приложение с авторизацией

```dart
// main.dart
import 'package:flutter/material.dart';
import 'dev_modules/core_module/services/token_manager.dart';
import 'dev_modules/core_module/services/api_service.dart';
import 'dev_modules/core_module/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await TokenManager.init();
  ApiService.initializeInterceptors();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}

// login_screen.dart
import 'package:flutter/material.dart';
import 'dev_modules/ui_kit_module/buttons/supply_button.dart';
import 'dev_modules/ui_kit_module/inputs/supply_input.dart';
import 'dev_modules/auth_module/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await AuthService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      if (response['success']) {
        // Переход на главный экран
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SupplyInput(
              label: 'Email',
              controller: _emailController,
              type: SupplyInputType.email,
            ),
            SizedBox(height: 16),
            SupplyInput(
              label: 'Пароль',
              controller: _passwordController,
              type: SupplyInputType.password,
            ),
            SizedBox(height: 24),
            SupplyButton.primary(
              text: 'Войти',
              onPressed: _handleLogin,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Пример 2: Главный экран с Tab Bar

```dart
import 'package:flutter/material.dart';
import 'dev_modules/tab_bar_module/widgets/supply_tab_bar.dart';
import 'dev_modules/tab_bar_module/models/tab_item.dart';

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
        padding: const EdgeInsets.all(16),
        child: SupplyTabBar(
          selectedTab: _selectedTab,
          onTabSelected: (tab) {
            setState(() => _selectedTab = tab);
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
        return AIChatScreen();
      case TabItem.diary:
        return DiaryScreen();
      case TabItem.knowledgeBase:
        return KnowledgeScreen();
    }
  }
}
```

### Пример 3: Дневник питания

```dart
import 'package:flutter/material.dart';
import 'dev_modules/diary_module/services/diary_service.dart';
import 'dev_modules/diary_module/models/diary_models.dart';

class DiaryScreen extends StatefulWidget {
  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DiaryDay? _diaryDay;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    final day = await DiaryService.getDiaryDay(DateTime.now());
    setState(() {
      _diaryDay = day;
      _isLoading = false;
    });
  }

  Future<void> _addMeal() async {
    final meal = await DiaryService.addMeal(
      mealName: 'Овсянка',
      mealType: MealType.breakfast,
      consumedAt: DateTime.now(),
      portionGrams: 200,
    );
    
    if (meal != null) {
      _loadDiary(); // Перезагрузить дневник
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Дневник питания')),
      body: ListView.builder(
        itemCount: _diaryDay?.meals.length ?? 0,
        itemBuilder: (context, index) {
          final meal = _diaryDay!.meals[index];
          return ListTile(
            title: Text(meal.mealName),
            subtitle: Text(meal.mealTypeLabel),
            trailing: Text('${meal.portionGrams}г'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeal,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## 🎨 Кастомизация

### Изменить цвета и дизайн

Отредактируйте `dev_modules/core_module/theme/app_theme.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFFYOUR_COLOR);
  static const Color secondary = Color(0xFFYOUR_COLOR);
  // ...
}
```

### Изменить API URL

Отредактируйте `dev_modules/core_module/config/api_config.dart`:

```dart
static const String baseUrl = 'https://your-api.com/api';
```

### Добавить свои UI компоненты

Создайте новые файлы в `dev_modules/ui_kit_module/`:

```dart
// dev_modules/ui_kit_module/dialogs/my_dialog.dart
class MyDialog extends StatelessWidget {
  // Ваш кастомный компонент
}
```

## 🔄 Соединение модулей

### Модули легко соединяются между собой:

```dart
// auth_module использует core_module
import '../core_module/services/api_service.dart';
import '../core_module/services/token_manager.dart';

// diary_module использует core_module
import '../core_module/services/api_service.dart';

// Любой экран использует ui_kit_module
import '../ui_kit_module/buttons/supply_button.dart';
```

## 📝 Рекомендации

### Порядок разработки

1. **Начните с core_module** - настройте API и тему
2. **Добавьте ui_kit_module** - получите готовые UI компоненты
3. **Подключайте feature модули** по мере необходимости
4. **Кастомизируйте** под ваш дизайн

### Best Practices

- ✅ Используйте TypeScript/Dart типизацию
- ✅ Обрабатывайте ошибки API
- ✅ Добавляйте loading состояния
- ✅ Используйте локализацию
- ✅ Тестируйте модули независимо

### Частые вопросы

**Q: Можно ли использовать только некоторые модули?**
A: Да! Модули независимы. Минимум - core_module + ui_kit_module.

**Q: Как обновить localhost на production URL?**
A: Измените `baseUrl` в `core_module/config/api_config.dart`.

**Q: Можно ли изменить дизайн?**
A: Да! Все цвета и стили в `core_module/theme/app_theme.dart`.

**Q: Где хранятся иконки?**
A: В `assets/ICONS/`. Не забудьте добавить в `pubspec.yaml`.

## 🚀 Готовые шаблоны

### Минимальное приложение

Модули: `core_module` + `ui_kit_module` + `auth_module`

### Приложение с дневником

Модули: `core_module` + `ui_kit_module` + `auth_module` + `diary_module` + `tab_bar_module`

### Полное приложение

Все модули из папки `dev_modules/`

## 📞 Поддержка

Каждый модуль содержит свой `README.md` с подробной документацией:
- API endpoints
- Примеры использования
- Модели данных
- Экраны и виджеты

Читайте документацию конкретного модуля для детальной информации!

---

**Удачи в разработке! 🎉**





