# Auth Module - Аутентификация

Модуль для аутентификации, регистрации и управления сессиями.

## 📦 Состав модуля

### Routes
- `POST /auth/register` - регистрация пользователя
- `POST /auth/login` - вход в систему
- `POST /auth/verify-email` - подтверждение email
- `POST /auth/request-reset` - запрос сброса пароля
- `POST /auth/reset-password` - сброс пароля
- `POST /auth/refresh-token` - обновление JWT токена
- `POST /auth/logout` - выход из системы

### Services
- `AuthService` - бизнес-логика аутентификации
- `TokenService` - управление JWT токенами
- `EmailVerificationService` - подтверждение email

### Models
- SQL запросы для работы с пользователями и токенами

## 🚀 API Endpoints

### Регистрация

```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "name": "John Doe"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "John Doe",
      "isEmailVerified": false
    },
    "token": "jwt-token"
  },
  "message": "User registered successfully"
}
```

### Вход

```http
POST /api/auth/login
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
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "John Doe"
    },
    "token": "jwt-token"
  }
}
```

### Подтверждение Email

```http
POST /api/auth/verify-email
Content-Type: application/json

{
  "token": "verification-token"
}
```

### Запрос сброса пароля

```http
POST /api/auth/request-reset
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### Сброс пароля

```http
POST /api/auth/reset-password
Content-Type: application/json

{
  "token": "reset-token",
  "newPassword": "NewSecurePass123!"
}
```

## 🔧 Использование

### AuthService

```typescript
import { AuthService } from '@/backend_modules/auth_module'

const authService = new AuthService()

// Регистрация
const { user, token } = await authService.register({
  email: 'user@example.com',
  password: 'SecurePass123!',
  name: 'John Doe'
})

// Вход
const { user, token } = await authService.login({
  email: 'user@example.com',
  password: 'SecurePass123!'
})

// Верификация email
await authService.verifyEmail(verificationToken)

// Запрос сброса пароля
await authService.requestPasswordReset('user@example.com')

// Сброс пароля
await authService.resetPassword(resetToken, 'NewPassword123!')
```

## 📊 Типы

### RegisterRequest

```typescript
interface RegisterRequest {
  email: string
  password: string
  name: string
}
```

### LoginRequest

```typescript
interface LoginRequest {
  email: string
  password: string
}
```

### AuthResponse

```typescript
interface AuthResponse {
  user: {
    id: string
    email: string
    name: string
    isEmailVerified: boolean
  }
  token: string
}
```

## 🔐 Безопасность

### Хеширование паролей
- Используется bcryptjs с salt rounds = 10
- Пароли никогда не хранятся в открытом виде

### JWT токены
- Подписываются секретным ключом из .env
- Срок действия: 7 дней (настраивается)
- Включают: userId, email, role

### Email верификация
- Генерируется случайный токен
- Токен действителен 24 часа
- Отправляется на email через Resend API

### Сброс пароля
- Генерируется уникальный токен
- Токен действителен 1 час
- Токен удаляется после использования

## 📦 Зависимости

```json
{
  "bcryptjs": "^2.4.3",
  "jsonwebtoken": "^9.0.2",
  "@fastify/jwt": "^7.2.4",
  "resend": "^2.0.0",
  "zod": "^3.22.4"
}
```

## 🔗 Связанные модули

- Зависит от `core_module` для middleware и utils
- Зависит от `database_module` для подключения к БД
- Используется в `users_module` для проверки аутентификации

---

**Версия:** 1.0.0  
**Обновлено:** October 2025

