# Core Module

Базовый модуль с основными сервисами, утилитами и конфигурацией.

## 📦 Содержание

- **config/** - Конфигурация API и констант
- **services/** - Базовые сервисы (API, токены)
- **theme/** - Тема приложения (цвета, типографика)
- **utils/** - Утилиты (парсеры, хелперы)

## 🚀 Использование

### API Service

```dart
import 'package:supply_diets_app/core_module/services/api_service.dart';

// GET запрос
final response = await ApiService.get('/endpoint');

// POST запрос
final response = await ApiService.post('/endpoint', {'key': 'value'});
```

### Token Manager

```dart
import 'package:supply_diets_app/core_module/services/token_manager.dart';

// Сохранить токен
await TokenManager.saveToken('your_token', userId: '123', email: 'user@example.com');

// Получить токен
String? token = await TokenManager.getToken();

// Проверить авторизацию
bool isAuth = await TokenManager.isAuthenticated();

// Очистить токен
await TokenManager.clearAuth();
```

### Тема

```dart
import 'package:supply_diets_app/core_module/theme/app_theme.dart';

// Использование цветов
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: AppTypography.titleLarge,
  ),
)
```

## ⚙️ Конфигурация

### API URL

По умолчанию: `http://localhost:3001/api`

Для изменения отредактируйте `config/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'http://your-api-url.com/api';
}
```

## 🎨 Дизайн система

### Цвета
- **Primary**: `#D9E74C` - Ярко-салатовый
- **Secondary**: `#00FF7F` - Зеленый
- **Background**: `#FFFFFF` - Белый

### Типографика
- **Font Family**: Urbanist, InterDisplay
- **Размеры**: 9px - 28px

### Отступы
- XS: 4px
- SM: 8px
- MD: 16px
- LG: 24px
- XL: 32px
- XXL: 40px

## 📚 Зависимости

```yaml
dependencies:
  dio: ^5.0.0
  shared_preferences: ^2.0.0
```

## 🔧 Инициализация

В `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация TokenManager
  await TokenManager.init();
  
  // Инициализация API Service
  ApiService.initializeInterceptors();
  
  runApp(MyApp());
}
```





