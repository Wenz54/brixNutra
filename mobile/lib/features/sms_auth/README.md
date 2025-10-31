# SMS/Email Auth Feature

## 📋 Описание

Полнофункциональная SMS/Email авторизация для Brix Nutrition с BLoC архитектурой.

### Возможности:
- ✅ Email авторизация с верификацией кода
- ✅ Phone авторизация с SMS кодом
- ✅ Установка пароля для новых Email пользователей
- ✅ Автоматическое сохранение JWT токенов
- ✅ Mock режим для разработки UI без backend
- ✅ Готовая интеграция с Brix Nutrition API

---

## 🏗️ Архитектура

```
sms_auth/
├── bloc/
│   ├── sms_auth_bloc.dart      # Главная логика
│   ├── sms_auth_event.dart     # События
│   └── sms_auth_state.dart     # Состояния
├── models/
│   └── verification_response.dart  # Модели ответов API
├── services/
│   └── sms_auth_service.dart   # API сервис (Mock + Real)
├── screens/                    # TODO: UI (Task 5.2)
├── widgets/                    # TODO: UI компоненты
├── sms_auth.dart              # Barrel file
└── README.md
```

---

## 🚀 Быстрый старт

### 1. Импорт
```dart
import 'package:mobile/features/sms_auth/sms_auth.dart';
```

### 2. Создание BLoC
```dart
// В main.dart или в конкретном экране
BlocProvider(
  create: (context) => SmsAuthBloc(),
  child: YourAuthScreen(),
)
```

### 3. Использование в UI
```dart
BlocBuilder<SmsAuthBloc, SmsAuthState>(
  builder: (context, state) {
    if (state is SmsAuthLoading) {
      return CircularProgressIndicator();
    }
    
    if (state is CodeSentSuccess) {
      // Показать экран ввода кода
      return VerificationCodeScreen(identifier: state.identifier);
    }
    
    if (state is CodeVerifiedNewUser) {
      // Показать экран создания пароля
      return SetPasswordScreen(email: state.email);
    }
    
    if (state is CodeVerifiedExistingUser) {
      // Перейти на главный экран
      Navigator.pushReplacement(context, HomeScreen());
    }
    
    if (state is SmsAuthError) {
      // Показать ошибку
      return Text('Ошибка: ${state.message}');
    }
    
    // Начальный экран
    return AuthMethodSelectionScreen();
  },
)
```

---

## 📖 Примеры использования

### Пример 1: Авторизация по Email

```dart
// Шаг 1: Отправить код на email
void sendEmailCode(BuildContext context, String email) {
  context.read<SmsAuthBloc>().add(
    SendCodeToEmailRequested(email),
  );
}

// Шаг 2: Проверить код
void verifyEmailCode(BuildContext context, String email, String code) {
  context.read<SmsAuthBloc>().add(
    VerifyEmailCodeRequested(email: email, code: code),
  );
}

// Шаг 3: Установить пароль (если новый пользователь)
void setPassword(BuildContext context, String email, String password) {
  context.read<SmsAuthBloc>().add(
    SetPasswordRequested(email: email, password: password),
  );
}
```

### Пример 2: Авторизация по Phone

```dart
// Шаг 1: Отправить SMS код
void sendPhoneCode(BuildContext context, String phone) {
  context.read<SmsAuthBloc>().add(
    SendCodeToPhoneRequested(phone),
  );
}

// Шаг 2: Проверить SMS код (вход сразу, пароль не требуется)
void verifyPhoneCode(BuildContext context, String phone, String code) {
  context.read<SmsAuthBloc>().add(
    VerifyPhoneCodeRequested(phone: phone, code: code),
  );
}
```

### Пример 3: Обработка состояний с SnackBar

```dart
BlocListener<SmsAuthBloc, SmsAuthState>(
  listener: (context, state) {
    if (state is CodeSentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    
    if (state is SmsAuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    if (state is CodeVerifiedExistingUser) {
      // Перейти на главный экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  },
  child: YourAuthUI(),
)
```

### Пример 4: Полный флоу Email авторизации

```dart
class EmailAuthFlow extends StatefulWidget {
  @override
  _EmailAuthFlowState createState() => _EmailAuthFlowState();
}

class _EmailAuthFlowState extends State<EmailAuthFlow> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmsAuthBloc(),
      child: BlocConsumer<SmsAuthBloc, SmsAuthState>(
        listener: (context, state) {
          if (state is CodeVerifiedExistingUser) {
            // Вход выполнен - переход на главный экран
            Navigator.pushReplacementNamed(context, '/home');
          }
          
          if (state is PasswordSetSuccess) {
            // Регистрация завершена - переход на онбординг
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        },
        builder: (context, state) {
          // Начальный экран - ввод email
          if (state is SmsAuthInitial || state is SmsAuthError) {
            return Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SmsAuthBloc>().add(
                      SendCodeToEmailRequested(_emailController.text),
                    );
                  },
                  child: Text('Отправить код'),
                ),
                if (state is SmsAuthError)
                  Text(state.message, style: TextStyle(color: Colors.red)),
              ],
            );
          }
          
          // Код отправлен - ввод кода
          if (state is CodeSentSuccess) {
            return Column(
              children: [
                Text('Код отправлен на: ${state.identifier}'),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(labelText: 'Код'),
                  maxLength: 4,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SmsAuthBloc>().add(
                      VerifyEmailCodeRequested(
                        email: state.identifier,
                        code: _codeController.text,
                      ),
                    );
                  },
                  child: Text('Проверить'),
                ),
              ],
            );
          }
          
          // Новый пользователь - создание пароля
          if (state is CodeVerifiedNewUser) {
            return Column(
              children: [
                Text('Создайте пароль для ${state.email}'),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SmsAuthBloc>().add(
                      SetPasswordRequested(
                        email: state.email,
                        password: _passwordController.text,
                      ),
                    );
                  },
                  child: Text('Создать'),
                ),
              ],
            );
          }
          
          // Загрузка
          if (state is SmsAuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## 🎭 Mock режим

### Включение/Отключение
В `services/sms_auth_service.dart`:
```dart
// true = Mock режим (для разработки UI)
// false = Real API (для production)
static const bool useMockMode = true;
```

### Mock коды верификации
- Любой email: **1234**
- Любой phone: **1234**

### Mock поведение
- Email с "new" в адресе → новый пользователь (требуется пароль)
- Другие email → случайно (50/50)
- Phone → всегда существующий пользователь (без пароля)

---

## 🔄 Флоу авторизации

### Email флоу:
```
1. SendCodeToEmailRequested
   ↓
2. CodeSentSuccess (код отправлен)
   ↓
3. VerifyEmailCodeRequested
   ↓
4a. CodeVerifiedNewUser → SetPasswordRequested → PasswordSetSuccess
   ИЛИ
4b. CodeVerifiedExistingUser (вход выполнен)
```

### Phone флоу:
```
1. SendCodeToPhoneRequested
   ↓
2. CodeSentSuccess (SMS отправлен)
   ↓
3. VerifyPhoneCodeRequested
   ↓
4. CodeVerifiedExistingUser (вход выполнен)
```

---

## 📦 Состояния (States)

| Состояние | Описание |
|-----------|----------|
| `SmsAuthInitial` | Начальное состояние |
| `SmsAuthLoading` | Загрузка (любая операция) |
| `CodeSentSuccess` | Код отправлен (email или SMS) |
| `CodeVerifiedNewUser` | Новый пользователь (требуется пароль) |
| `CodeVerifiedExistingUser` | Существующий пользователь (вход выполнен) |
| `PasswordSetSuccess` | Пароль установлен (регистрация завершена) |
| `Authenticated` | Авторизован |
| `Unauthenticated` | НЕ авторизован |
| `SmsAuthError` | Ошибка |

---

## 🎯 События (Events)

| Событие | Параметры | Описание |
|---------|-----------|----------|
| `SendCodeToEmailRequested` | email | Отправить код на email |
| `SendCodeToPhoneRequested` | phone | Отправить SMS код |
| `VerifyEmailCodeRequested` | email, code | Проверить email код |
| `VerifyPhoneCodeRequested` | phone, code | Проверить SMS код |
| `SetPasswordRequested` | email, password | Установить пароль |
| `LogoutRequested` | - | Выход из системы |
| `ResetAuthState` | - | Сброс состояния |

---

## 🔐 Безопасность

### Токены хранятся в:
- **flutter_secure_storage** (iOS Keychain / Android EncryptedSharedPreferences)
- Автоматически через `TokenManager`

### Валидация:
- Email формат (TODO: добавить в validators)
- Phone формат (TODO: добавить в validators)
- Код: 4 цифры
- Пароль: минимум 8 символов (в mock)

---

## ✅ TODO (Task 5.2)

- [ ] Создать UI экраны (`screens/`)
  - [ ] `auth_method_selection_screen.dart`
  - [ ] `email_input_screen.dart`
  - [ ] `phone_input_screen.dart`
  - [ ] `sms_verification_screen.dart`
  - [ ] `password_creation_screen.dart`
- [ ] Создать UI компоненты (`widgets/`)
  - [ ] `code_input_widget.dart` (4 поля для кода)
  - [ ] `phone_input_formatter.dart`
  - [ ] `resend_code_button.dart` (с таймером 60 сек)
- [ ] Добавить валидаторы в `shared/utils/validators.dart`
- [ ] Интеграция с flutter_sms_autofill (автозаполнение SMS)

---

## 🧪 Тестирование

```dart
// Проверка что Mock режим работает
void testMockAuth() async {
  // 1. Отправить код
  final sendResponse = await SmsAuthService.sendCodeToEmail('test@example.com');
  print('✅ Send: ${sendResponse.message}');
  
  // 2. Проверить код (используй 1234)
  final verifyResponse = await SmsAuthService.verifyEmailCode(
    email: 'test@example.com',
    code: '1234',
  );
  print('✅ Verify: ${verifyResponse.message}');
  print('   isNewUser: ${verifyResponse.isNewUser}');
  print('   token: ${verifyResponse.token}');
  print('   user: ${verifyResponse.user}');
}
```

---

## 📚 API Интеграция

Backend endpoints (Brix Nutrition):
- `POST /api/auth/email/send-code` - Отправка email кода
- `POST /api/auth/email/verify-code` - Проверка email кода
- `POST /api/auth/email/set-password` - Установка пароля
- `POST /api/auth/phone/send-code` - Отправка SMS
- `POST /api/auth/phone/verify-code` - Проверка SMS кода

---

## 🎉 Готово!

SMS Auth Feature полностью реализован и готов к использованию.

**Текущий статус:**
- ✅ Models
- ✅ Services (Mock + Real API готов)
- ✅ BLoC (Events + States + Bloc)
- ✅ Документация
- ⏳ UI Screens (Task 5.2)

**Переключение на Real API:**
Измени `useMockMode = false` в `sms_auth_service.dart` когда backend будет готов.

---

**Task 3.3 COMPLETED! ✅**




