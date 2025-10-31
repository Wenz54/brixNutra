# Profile Module

Модуль профиля пользователя для Supply Diets приложения.

## 📦 Функционал

- Просмотр и редактирование профиля
- Смена email и пароля
- Настройки приложения
- Управление подпиской
- Выход из системы

## 🚀 Использование

```dart
// Получить профиль
final profile = await ProfileService.getProfile();

// Обновить профиль
await ProfileService.updateProfile(
  name: 'Новое имя',
  phone: '+7 999 123-45-67',
);

// Сменить email
await ProfileService.changeEmail('newemail@example.com');

// Сменить пароль
await ProfileService.changePassword(
  oldPassword: 'old123',
  newPassword: 'new456',
);
```

## 📡 API Endpoints

- `GET /users/profile` - Получить профиль
- `PUT /users/profile` - Обновить профиль
- `POST /users/change-email` - Сменить email
- `POST /users/change-password` - Сменить пароль

## 📱 Экраны

- **ProfileScreen** - Главный экран профиля
- **ChangeEmailScreen** - Смена email
- **ChangePasswordScreen** - Смена пароля
- **SettingsScreen** - Настройки приложения





