# Быстрый старт с Dev Modules

## 🎯 За 5 минут

### 1. Скопируйте модули (30 сек)

```bash
cp -r dev_modules /path/to/your/project/lib/
```

### 2. Добавьте зависимости (1 мин)

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.0.0
  shared_preferences: ^2.0.0
  easy_localization: ^3.0.0
  flutter_bloc: ^8.1.0
```

```bash
flutter pub get
```

### 3. Настройте API (30 сек)

```dart
// dev_modules/core_module/config/api_config.dart
static const String baseUrl = 'http://localhost:3001/api'; // ✅ Уже настроено на localhost!
```

### 4. Инициализация (1 мин)

```dart
// main.dart
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
      theme: AppTheme.lightTheme, // Готовая тема!
      home: MyHomeScreen(),
    );
  }
}
```

### 5. Используйте компоненты (2 мин)

```dart
import 'dev_modules/ui_kit_module/buttons/supply_button.dart';
import 'dev_modules/ui_kit_module/inputs/supply_input.dart';
import 'dev_modules/auth_module/services/auth_service.dart';

// Готовая кнопка
SupplyButton.primary(
  text: 'Войти',
  onPressed: () async {
    await AuthService.login(
      email: 'test@example.com',
      password: 'password123',
    );
  },
)

// Готовое поле ввода
SupplyInput(
  label: 'Email',
  type: SupplyInputType.email,
  controller: _emailController,
)
```

## ✅ Готово! 

Теперь у вас есть:
- ✨ Готовая тема и UI компоненты
- 🔐 Модуль авторизации
- 📱 Модуль дневника питания
- 🏠 Модуль главного экрана
- И еще 10+ модулей!

## 📚 Что дальше?

1. Читайте `HOW_TO_USE.md` для детальных примеров
2. Смотрите `README.md` каждого модуля
3. Кастомизируйте дизайн в `core_module/theme/app_theme.dart`

## 🎨 Модули на выбор

### Обязательные
- ✅ `core_module` - API, токены, тема
- ✅ `ui_kit_module` - UI компоненты

### По необходимости
- 🔐 `auth_module` - Авторизация
- 📊 `diary_module` - Дневник питания
- 👤 `profile_module` - Профиль
- 📱 `tab_bar_module` - Навигация
- 🏠 `home_module` - Главный экран
- 📚 `knowledge_module` - Курсы
- 🤖 `ai_chat_module` - AI чат
- 🔬 `checkup_module` - Анализы
- 🎯 `plans_module` - Планы питания
- И другие...

**Все модули независимы - используйте что нужно!**





