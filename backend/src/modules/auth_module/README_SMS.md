# Auth Module - SMS Verification Extension

Расширение auth_module для Brix Nutritional App с поддержкой SMS верификации.

## 📦 Новые возможности

### 1. Email верификация (4-значный код)
- ✅ POST `/auth/email/send-code` - отправить код на email
- ✅ POST `/auth/email/verify-code` - проверить код
- ✅ POST `/auth/email/set-password` - установить пароль (для новых пользователей)

### 2. Phone верификация (SMS)
- ✅ POST `/auth/phone/send-code` - отправить SMS код
- ✅ POST `/auth/phone/verify-code` - проверить SMS код

---

## 🚀 API Endpoints

### 1. Отправить код на Email

```http
POST /api/auth/email/send-code
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Verification code sent to email"
}
```

---

### 2. Проверить Email код

```http
POST /api/auth/email/verify-code
Content-Type: application/json

{
  "email": "user@example.com",
  "code": "1234"
}
```

**Response (существующий пользователь):**
```json
{
  "success": true,
  "isNewUser": false,
  "token": "jwt-token-here",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

**Response (новый пользователь):**
```json
{
  "success": true,
  "isNewUser": true
}
```

---

### 3. Установить пароль (для новых пользователей Email)

```http
POST /api/auth/email/set-password
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "success": true,
  "token": "jwt-token-here",
  "user": {
    "id": "uuid",
    "email": "user@example.com"
  }
}
```

---

### 4. Отправить SMS код

```http
POST /api/auth/phone/send-code
Content-Type: application/json

{
  "phone": "+79090786765"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Verification code sent to phone"
}
```

---

### 5. Проверить SMS код

```http
POST /api/auth/phone/verify-code
Content-Type: application/json

{
  "phone": "+79090786765",
  "code": "1234"
}
```

**Response (существующий или новый пользователь):**
```json
{
  "success": true,
  "isNewUser": true,
  "token": "jwt-token-here",
  "user": {
    "id": "uuid",
    "phone": "+79090786765"
  }
}
```

---

## 🛠️ Интеграция с Twilio

### Настройка

В `.env` файле добавьте:

```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-auth-token
TWILIO_PHONE_NUMBER=+1234567890
```

### Mock режим (для разработки)

Если переменные Twilio не установлены, сервис работает в mock режиме:
- SMS коды выводятся в консоль
- Email коды выводятся в консоль

---

## 📊 База данных

### Таблица verification_codes

```sql
CREATE TABLE verification_codes (
  id UUID PRIMARY KEY,
  identifier VARCHAR(255),  -- email or phone
  code VARCHAR(6),          -- 4-digit code
  type VARCHAR(10),         -- 'email' | 'phone'
  expires_at TIMESTAMP,     -- 10 minutes from creation
  is_used BOOLEAN,
  created_at TIMESTAMP,
  used_at TIMESTAMP
);
```

### Миграция

Файл: `models/verification-codes.sql`

Запустить:
```bash
psql -U postgres -d brix_nutrition -f backend/src/modules/auth_module/models/verification-codes.sql
```

---

## 🔒 Безопасность

### Генерация кодов
- 4-значный код (1000-9999)
- Криптографически стойкий генератор (crypto.randomBytes)

### Срок действия
- Email код: **10 минут**
- SMS код: **10 минут**

### Защита от брутфорса
- Rate limiting на endpoints
- Код можно использовать только 1 раз
- Автоудаление старых кодов

---

## 🧪 Тестирование

### Тестовые данные

```bash
# Email verification
curl -X POST http://localhost:3000/api/auth/email/send-code \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'

# Проверить код (будет в логах сервера)
curl -X POST http://localhost:3000/api/auth/email/verify-code \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","code":"1234"}'
```

---

## 📝 TODO

- [ ] Подключить реальный Email сервис (Resend/SendGrid)
- [ ] Реализовать database queries (сейчас mock)
- [ ] Добавить rate limiting (5 попыток / 15 минут)
- [ ] Добавить unit тесты
- [ ] Добавить логирование попыток верификации
- [ ] Автоматическая очистка старых кодов (cron job)

---

## 🔗 Связанные файлы

```
auth_module/
├── routes/
│   ├── auth.ts (существующий)
│   └── sms-verification.ts (НОВЫЙ)
├── services/
│   ├── authService.ts (существующий)
│   └── smsService.ts (НОВЫЙ)
├── models/
│   └── verification-codes.sql (НОВАЯ)
└── README_SMS.md (этот файл)
```

---

## 🎯 Пример использования во Flutter

```dart
// Send SMS code
final response = await dio.post('/auth/phone/send-code', 
  data: {'phone': '+79090786765'}
);

// Verify code
final verifyResponse = await dio.post('/auth/phone/verify-code',
  data: {
    'phone': '+79090786765',
    'code': '1234'
  }
);

if (verifyResponse.data['success']) {
  final token = verifyResponse.data['token'];
  final isNewUser = verifyResponse.data['isNewUser'];
  
  if (isNewUser) {
    // Navigate to onboarding
  } else {
    // Navigate to home
  }
}
```

---

**Версия:** 1.0.0  
**Дата:** 10 октября 2025  
**Автор:** AI Assistant (Claude Sonnet 4.5)








