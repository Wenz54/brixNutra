# Auth Module

Модуль авторизации и регистрации пользователей для Supply Diets приложения.

## 📦 Содержание

- **services/** - Сервисы авторизации
- **screens/** - Экраны (login, register, forgot password, email verification)
- **widgets/** - Вспомогательные виджеты для auth flow
- **models/** - Модели данных пользователя

## 🚀 Использование

### AuthService

```dart
import 'package:supply_diets_app/dev_modules/auth_module/services/auth_service.dart';

// Регистрация
final response = await AuthService.register(
  name: 'Иван Иванов',
  email: 'ivan@example.com',
  password: 'SecurePass123!',
);

// Вход
final loginResponse = await AuthService.login(
  email: 'ivan@example.com',
  password: 'SecurePass123!',
);

// Верификация email
final verifyResponse = await AuthService.verifyEmail(
  email: 'ivan@example.com',
  code: '123456',
);

// Проверка авторизации
bool isAuth = await AuthService.isAuthenticated();

// Выход
await AuthService.logout();
```

### Навигация между экранами

```dart
// Переход на экран входа
Navigator.pushNamed(context, '/login');

// Переход на экран регистрации
Navigator.pushNamed(context, '/register');

// Переход на верификацию email
Navigator.pushNamed(context, '/email-verification', arguments: {
  'email': 'user@example.com',
  'isRegistration': true,
});

// Переход на восстановление пароля
Navigator.pushNamed(context, '/forgot-password');
```

## 📡 API Endpoints

Все endpoints настроены на `http://localhost:3001/api`:

- `POST /auth/register` - Регистрация нового пользователя
- `POST /auth/login` - Вход в систему
- `POST /auth/verify-email` - Верификация email кода
- `POST /auth/resend-verification` - Повторная отправка кода
- `POST /auth/forgot-password` - Запрос на восстановление пароля
- `POST /auth/reset-password` - Сброс пароля с кодом

## 🔐 Валидация

### Email
- Формат: `example@domain.com`
- Регулярное выражение: `^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$`

### Password
- Минимум 8 символов
- Должен содержать:
  - Минимум 1 строчную букву (a-z)
  - Минимум 1 заглавную букву (A-Z)
  - Минимум 1 цифру (0-9)
  - Минимум 1 спецсимвол (%^&*()_+-=<>/?)

## 📱 Экраны

### LoginScreen
Экран входа в систему с полями email и password.

### RegisterScreen
Экран регистрации с полями name, email, password, confirm password.

### EmailVerificationScreen
Экран ввода 6-значного кода верификации email.

### ForgotPasswordScreen
Экран восстановления пароля (ввод email).

### ResetPasswordVerificationScreen
Экран ввода кода для восстановления пароля.

### NewPasswordScreen
Экран ввода нового пароля.

### WelcomeScreen
Стартовый экран с кнопками "Войти" и "Зарегистрироваться".

### SuccessScreen
Экран успешного завершения регистрации/восстановления.

## 🔄 Auth Flow

### Регистрация
1. WelcomeScreen → RegisterScreen
2. Ввод данных (name, email, password)
3. → EmailVerificationScreen
4. Ввод кода верификации
5. → SuccessScreen
6. → HomeScreen (авторизованный пользователь)

### Вход
1. WelcomeScreen → LoginScreen
2. Ввод credentials (email, password)
3. → HomeScreen (если email подтвержден)
4. → EmailVerificationScreen (если email не подтвержден)

### Восстановление пароля
1. LoginScreen → ForgotPasswordScreen
2. Ввод email
3. → ResetPasswordVerificationScreen
4. Ввод кода
5. → NewPasswordScreen
6. Ввод нового пароля
7. → SuccessScreen
8. → LoginScreen

## 📚 Зависимости

```yaml
dependencies:
  # Из core_module
  dio: ^5.0.0
  shared_preferences: ^2.0.0
  
  # Локализация
  easy_localization: ^3.0.0
```

## ⚙️ Конфигурация

### Изменить API URL

Отредактируйте `core_module/config/api_config.dart`:

```dart
static const String baseUrl = 'http://your-api-url.com/api';
```

## 🎨 Кастомизация UI

Все экраны используют компоненты из `ui_kit_module`:
- `SupplyButton` - Кнопки
- `SupplyInput` - Поля ввода
- `SupplyAlert` - Алерты/уведомления

Для изменения дизайна отредактируйте тему в `core_module/theme/app_theme.dart`.

## 💾 Хранение токенов

Токены хранятся локально с помощью `TokenManager` из `core_module`:
- JWT токен авторизации
- User ID
- Email пользователя

Токен автоматически добавляется ко всем API запросам через interceptor.

## 📝 Примечания

- При успешной авторизации токен сохраняется автоматически
- Токен автоматически добавляется к защищенным API запросам
- При выходе все данные авторизации удаляются
- Поддержка локализации (ru, en)





