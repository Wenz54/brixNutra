# Task 3.2: Core Module - API Service ✅

## Выполнено

### 1. API Endpoints (shared/constants/api_endpoints.dart)
Создан централизованный класс `ApiEndpoints` со всеми endpoints для Brix Nutrition API:

**Модули:**
- ✅ Auth (8 endpoints): email/phone send-code, verify-code, set-password, refresh, logout
- ✅ Profile (7 endpoints): me, update, goals, measurements, activities
- ✅ Recipes (3 endpoints): list, detail, alternatives
- ✅ Meal Plan (3 endpoints): current, day, replace
- ✅ Diary (8 endpoints): day, meal CRUD, water, mood, day-status, history
- ✅ Knowledge Base (8 endpoints): courses, lessons, progress, categories, favorites
- ✅ Lab Tests (6 endpoints): upload, my, detail, interpretation, parameters, trend
- ✅ AI Chat (5 endpoints): message, sessions, messages, delete, new
- ✅ Blog (2 endpoints): articles list, article detail
- ✅ Notifications (3 endpoints): list, read, delete
- ✅ Files (2 endpoints): upload single/multiple
- ✅ Subscriptions (4 endpoints): plans, my, subscribe, cancel
- ✅ Home Dashboard (1 endpoint): dashboard data

**Всего: 60+ endpoints для всех модулей Brix Nutrition!**

### 2. API Service (dev_modules/core_module/services/api_service.dart)
Полностью обновлен с улучшенными interceptors:

#### Interceptors:
1. **Token Interceptor** ✅
   - Автоматически добавляет `Bearer ${token}` ко всем запросам
   - Исключает auth endpoints (они не требуют токена)
   - Использует `flutter_secure_storage` через TokenManager

2. **Log Interceptor** ✅ (только debug режим)
   - Красивое форматированное логирование запросов/ответов
   - Показывает: Method, URL, Headers, Body, Query params
   - Детальные логи ошибок
   - Автоматически отключается в release mode

3. **Error Interceptor** ✅
   - 401 Unauthorized → автоматический logout + очистка токена
   - 403 Forbidden → логирование
   - 404 Not Found → логирование
   - 500+ Server Error → логирование
   - Удобные сообщения об ошибках

#### HTTP Methods:
- ✅ `GET` - с поддержкой query parameters
- ✅ `POST` - отправка данных
- ✅ `PUT` - полное обновление
- ✅ `PATCH` - частичное обновление ⭐ (добавлен!)
- ✅ `DELETE` - удаление

#### Error Handling:
Умная обработка ошибок с понятными сообщениями:
- Connection timeout
- Send/Receive timeout
- Bad response (извлекает message/error из JSON)
- Connection error (подсказывает проверить localhost:3000)
- SSL/Certificate errors

### 3. Token Manager (dev_modules/core_module/services/token_manager.dart)
Полностью переписан для безопасного хранения:

#### Используемые технологии:
- ✅ **flutter_secure_storage** для JWT токенов (Access + Refresh)
  - Android: encryptedSharedPreferences
  - iOS: Keychain с accessibility first_unlock
- ✅ **SharedPreferences** для user metadata (userId, email, name)

#### Методы:
**Access Token:**
- `saveAccessToken(token)` - сохранить JWT
- `getToken()` - получить JWT
- `isAuthenticated()` - проверка авторизации

**Refresh Token:**
- `saveRefreshToken(token)` - для обновления access token
- `getRefreshToken()` - получить refresh token

**User Metadata:**
- `saveUserData(userId, email, name)` - сохранить данные пользователя
- `getUserId()` - получить ID
- `getUserEmail()` - получить email
- `getUserName()` - получить имя

**Auth Management:**
- `saveAuth(...)` - сохранить всё после логина (универсальный метод)
- `clearAuth()` - полная очистка при logout

### 4. Инициализация (lib/main.dart)
```dart
await TokenManager.init();          // Инициализация хранилищ
ApiService.initializeInterceptors(); // Настройка Dio interceptors
```

### 5. API Configuration
**BaseUrl для Android эмулятора:** `http://10.0.2.2:3000/api` ✅

## Структура файлов

```
mobile/lib/
├── main.dart                                    # ✅ Инициализация API Service
├── app/
│   └── app.dart                                 # ✅ Убран unused import
├── shared/
│   └── constants/
│       └── api_endpoints.dart                   # ⭐ НОВЫЙ: Все endpoints
└── dev_modules/core_module/
    ├── config/
    │   └── api_config.dart                      # ✅ Обновлен baseUrl
    └── services/
        ├── api_service.dart                     # ✅ Улучшен с interceptors
        └── token_manager.dart                   # ✅ Переписан на secure storage
```

## Примеры использования

### Пример 1: GET с query params
```dart
import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';

// Получить рецепты с фильтрами
final response = await ApiService.get(
  ApiEndpoints.recipes,
  queryParameters: {
    'meal_type': 'breakfast',
    'is_vegetarian': 'true',
    'limit': '10',
  },
);
```

### Пример 2: POST для логина
```dart
// Отправить SMS код
final response = await ApiService.post(
  ApiEndpoints.authPhoneSendCode,
  {'phone': '+79991234567'},
);

// Проверить код
final verifyResponse = await ApiService.post(
  ApiEndpoints.authPhoneVerifyCode,
  {
    'phone': '+79991234567',
    'code': '1234',
  },
);

// Сохранить токен
if (verifyResponse['success']) {
  await TokenManager.saveAuth(
    accessToken: verifyResponse['token'],
    userId: verifyResponse['user']['id'],
    email: verifyResponse['user']['email'],
  );
}
```

### Пример 3: Защищенный запрос (с токеном)
```dart
// TokenManager автоматически добавит Bearer token
final profile = await ApiService.get(ApiEndpoints.profileMe);
print('User: ${profile['name']}');
```

### Пример 4: PATCH для обновления
```dart
// Обновить настроение в дневнике
await ApiService.patch(
  ApiEndpoints.diaryMood,
  {
    'date': '2025-10-13',
    'rating': 5,
  },
);
```

## Тестирование

### Проверить подключение к backend:
```dart
try {
  final response = await ApiService.get('/health');
  print('✅ Backend доступен: $response');
} catch (e) {
  print('❌ Ошибка: $e');
  // Проверьте что backend запущен на localhost:3000
}
```

### Логи в debug режиме:
```
┌─────── DIO REQUEST ───────
│ GET http://10.0.2.2:3000/api/recipes
│ Headers: {Authorization: Bearer eyJhbG...}
│ Query: {meal_type: breakfast, limit: 10}
└───────────────────────────

┌─────── DIO RESPONSE ──────
│ 200 http://10.0.2.2:3000/api/recipes
│ Data: {success: true, data: [...]}
└───────────────────────────
```

## Следующий шаг

**Task 3.3**: Feature - SMS Auth (логика)
- Создать models для auth responses
- Создать SmsAuthService с методами для email/phone auth
- Настроить интеграцию с backend API

## Готово! 🚀

Core Module настроен и готов к использованию:
- ✅ API Service с interceptors
- ✅ TokenManager с secure storage
- ✅ ApiEndpoints со всеми 60+ endpoints
- ✅ Инициализация в main.dart
- ✅ Error handling
- ✅ Логирование в debug режиме
- ✅ Android эмулятор конфигурация (10.0.2.2:3000)

