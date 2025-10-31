# ✅ Flutter App - Интеграция с Backend API

**Дата:** 14 октября 2025  
**Статус:** ✅ Завершено

---

## 📋 Что сделано

### 1. ✅ Token Manager и Auth Interceptors

**Token Manager готов:**
- `TokenManager.saveAccessToken()` - сохранение JWT в secure storage
- `TokenManager.getToken()` - получение JWT
- `TokenManager.saveAuth()` - полное сохранение auth данных
- `TokenManager.clearAuth()` - logout
- `TokenManager.isAuthenticated()` - проверка статуса авторизации

**API Service с Interceptors:**
- ✅ Token Interceptor - автоматическое добавление `Bearer token` в headers
- ✅ Log Interceptor - детальное логирование запросов (debug mode)
- ✅ Error Interceptor - обработка 401, 403, 404, 500 ошибок
- ✅ Auto logout при 401 Unauthorized

---

### 2. ✅ Обновлены все сервисы

**Переключены на Real API** (mock = false):
- ✅ `MealPlanService` - планы питания и рецепты
- ✅ `DiaryService` - дневник питания
- ✅ `AiChatService` - AI консультант
- ✅ `LabTestsService` - лабораторные анализы
- ✅ `KnowledgeBaseService` - база знаний
- ✅ `BlogNotificationsService` - блог и уведомления
- ✅ `SubscriptionsService` - подписки

**Остаётся в Mock режиме** (как требовалось):
- ✅ `SmsAuthService` - SMS/Email авторизация (нет домена для Resend/Twilio)

---

### 3. ✅ Создан тестовый экран

**Файл:** `mobile/lib/app/endpoints_test_screen.dart`

**Функциональность:**
- 🎯 Кнопки для тестирования каждой группы endpoints
- 📊 Real-time логирование результатов
- ⚡ Кнопка "Тестировать ВСЕ" для массовой проверки
- 🔑 Кнопка "Set Token" для установки mock JWT токена
- 📡 Отображение статуса авторизации
- ✅ Визуальная индикация успеха/ошибок

**Тестируемые endpoints:**

1. **Meal Plan** 🍽️
   - GET `/meal-plan/current` - текущий план
   - GET `/meal-plan/day/:date` - план на день
   - GET `/recipes/:id` - детали рецепта

2. **Diary** 📔
   - GET `/diary/day/:date` - дневник за день
   - GET `/diary/history` - история дневника

3. **AI Chat** 🤖
   - GET `/ai-chat/sessions` - список сессий
   - POST `/ai-chat/message` - отправка сообщения

4. **Lab Tests** 🧪
   - GET `/lab-tests/my` - мои анализы
   - GET `/lab-tests/parameters` - доступные параметры

5. **Knowledge Base** 📚
   - GET `/knowledge/courses` - список курсов
   - GET `/knowledge/categories` - категории
   - GET `/knowledge/favorites` - избранное

6. **Blog** 📰
   - GET `/blog/articles` - статьи блога

7. **Notifications** 🔔
   - GET `/notifications` - уведомления
   - GET `/notifications/stats` - статистика

8. **Subscriptions** 💳
   - GET `/subscriptions/plans` - тарифы
   - GET `/subscriptions/my` - моя подписка

---

## 🚀 Как использовать

### 1. Запустить Backend

```bash
cd backend
npm run dev
```

Backend должен быть доступен на `http://localhost:3000`

### 2. Запустить Flutter App

```bash
cd mobile
flutter run
```

Приложение откроется на `EndpointsTestScreen`

### 3. Тестировать Endpoints

1. **Нажмите "Set Token"** - установит mock JWT токен
2. **Нажмите на любую кнопку** - протестирует конкретный endpoint
3. **Нажмите "Тестировать ВСЕ"** - протестирует все endpoints подряд
4. **Смотрите логи** внизу экрана:
   - ✅ = успешный запрос
   - ❌ = ошибка
   - ℹ️ = информация

---

## 📊 Конфигурация

### API Base URL

**Файл:** `mobile/lib/dev_modules/core_module/config/api_config.dart`

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android Emulator
```

**Для разных устройств:**
- Android Emulator: `http://10.0.2.2:3000/api`
- iOS Simulator: `http://localhost:3000/api`
- Real Device: `http://YOUR_IP:3000/api`

### Timeouts

```dart
static const int connectTimeout = 10; // 10 секунд
static const int receiveTimeout = 10; // 10 секунд
```

---

## 🔐 Auth Flow

### Автоматическое добавление токена

```dart
// Token Interceptor добавляет Bearer token ко ВСЕМ запросам
// (кроме /auth/email/send-code, /auth/phone/verify-code и т.д.)

options.headers['Authorization'] = 'Bearer $token';
```

### Обработка 401 Unauthorized

```dart
// При 401 ошибке - автоматический logout
if (statusCode == 401) {
  await TokenManager.clearAuth();
  // TODO: Navigate to login screen
}
```

---

## 📝 Пример использования

### В любом BLoC/Service:

```dart
import 'package:mobile/dev_modules/core_module/services/api_service.dart';

// GET запрос
final response = await ApiService.get('/recipes', 
  queryParameters: {'meal_type': 'breakfast', 'limit': '10'}
);

// POST запрос
final response = await ApiService.post('/diary/meal', {
  'meal_name': 'Овсянка',
  'calories': 350,
  'meal_type': 'breakfast',
});

// PUT запрос
final response = await ApiService.put('/profile', {
  'name': 'John Doe',
});

// DELETE запрос
final response = await ApiService.delete('/diary/meal/123');
```

---

## ✅ Checklist

- [x] TokenManager создан и настроен
- [x] Auth Interceptor для автоматического добавления Bearer token
- [x] Log Interceptor для отладки (только debug mode)
- [x] Error Interceptor для обработки ошибок
- [x] Все сервисы обновлены (кроме SMS Auth)
- [x] SmsAuthService остаётся в mock режиме
- [x] Тестовый экран создан
- [x] Routes обновлены
- [x] main.dart правильно инициализирует всё
- [x] Документация создана

---

## 🐛 Troubleshooting

### Ошибка "Connection error"

**Причина:** Backend не запущен или неправильный URL

**Решение:**
1. Проверьте что backend запущен: `cd backend && npm run dev`
2. Проверьте URL в `api_config.dart`
3. Для Android эмулятора используйте `10.0.2.2` вместо `localhost`

### Ошибка "HTTP 401: Unauthorized"

**Причина:** Нет JWT токена или он невалидный

**Решение:**
1. Нажмите кнопку "Set Token" в тестовом экране
2. Или сделайте реальную авторизацию через SMS Auth

### Ошибка "HTTP 404: Not Found"

**Причина:** Endpoint не существует в Backend

**Решение:**
1. Проверьте что Backend имеет этот endpoint
2. Проверьте правильность пути в `api_endpoints.dart`

---

## 🎯 Следующие шаги

1. **Создать UI экраны** для каждого модуля
2. **Интегрировать реальную SMS Auth** (когда будет домен)
3. **Добавить Supabase Storage** для загрузки файлов
4. **Создать Home Screen** с интеграцией всех модулей
5. **Добавить тесты** (unit, widget, integration)

---

**Готово!** 🎉 Flutter App полностью интегрирован с Backend API!




