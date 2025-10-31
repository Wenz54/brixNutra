# Core Module - Ядро Backend

Базовый модуль с общими компонентами, middleware, утилитами и типами.

## 📦 Состав модуля

### Middleware
- `auth.ts` - JWT аутентификация
- `errorHandler.ts` - обработка ошибок
- `logging.ts` - логирование запросов

### Utils
- `validation.ts` - Zod схемы валидации
- `crypto.ts` - хеширование и шифрование
- `response.ts` - стандартизация ответов API

### Types
- `common.ts` - общие TypeScript типы
- `fastify.ts` - расширение Fastify типов

### Config
- `index.ts` - конфигурация приложения
- `constants.ts` - константы

## 🚀 Использование

### Auth Middleware

```typescript
import { authMiddleware } from '@/backend_modules/core_module/middleware/auth'

// Защита маршрута
fastify.get('/protected', {
  preHandler: authMiddleware
}, async (request, reply) => {
  const userId = request.user.id
  return { message: 'Protected data' }
})
```

### Валидация

```typescript
import { emailSchema, passwordSchema } from '@/backend_modules/core_module/utils/validation'

// Валидация email
const email = emailSchema.parse('user@example.com')

// Валидация пароля
const password = passwordSchema.parse('SecurePass123!')
```

### Стандартные ответы

```typescript
import { successResponse, errorResponse } from '@/backend_modules/core_module/utils/response'

// Успешный ответ
return successResponse(data, 'User created successfully')

// Ответ с ошибкой
return errorResponse('User not found', 404)
```

## 🔧 API

### Auth Middleware

```typescript
interface AuthMiddleware {
  (request: FastifyRequest, reply: FastifyReply): Promise<void>
}
```

**Добавляет в request:**
- `request.user` - данные авторизованного пользователя
- `request.token` - JWT токен

**Выбрасывает:**
- `401 Unauthorized` - токен отсутствует или невалиден
- `403 Forbidden` - токен истек

### Validation Schemas

```typescript
// Email
const emailSchema: z.ZodString

// Password (min 8 символов, буквы и цифры)
const passwordSchema: z.ZodString

// UUID
const uuidSchema: z.ZodString

// Пагинация
const paginationSchema: z.ZodObject<{
  page: z.ZodNumber
  limit: z.ZodNumber
}>
```

### Response Helpers

```typescript
// Успешный ответ
function successResponse<T>(
  data: T,
  message?: string,
  meta?: Record<string, any>
): ApiResponse<T>

// Ответ с ошибкой
function errorResponse(
  message: string,
  statusCode?: number,
  details?: any
): ApiErrorResponse

// Ответ с пагинацией
function paginatedResponse<T>(
  data: T[],
  total: number,
  page: number,
  limit: number
): PaginatedApiResponse<T>
```

## 📊 Типы

### ApiResponse

```typescript
interface ApiResponse<T = any> {
  success: boolean
  data: T
  message?: string
  meta?: Record<string, any>
}
```

### ApiErrorResponse

```typescript
interface ApiErrorResponse {
  success: false
  error: string
  message: string
  statusCode: number
  details?: any
}
```

### PaginatedApiResponse

```typescript
interface PaginatedApiResponse<T> {
  success: boolean
  data: T[]
  pagination: {
    total: number
    page: number
    limit: number
    pages: number
  }
}
```

### User (в request после auth middleware)

```typescript
interface User {
  id: string
  email: string
  name: string
  role?: string
  isEmailVerified: boolean
}
```

## 🎨 Константы

```typescript
// HTTP статус коды
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_SERVER_ERROR: 500,
}

// Роли пользователей
export const USER_ROLES = {
  USER: 'user',
  ADMIN: 'admin',
  MODERATOR: 'moderator',
}

// Лимиты
export const LIMITS = {
  PAGE_SIZE_DEFAULT: 20,
  PAGE_SIZE_MAX: 100,
  FILE_SIZE_MAX: 10 * 1024 * 1024, // 10 MB
}
```

## 🔐 Конфигурация

### Environment Variables

```env
# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d

# Database
DATABASE_URL=postgresql://...

# Server
PORT=3000
NODE_ENV=development
LOG_LEVEL=info
```

### Config Object

```typescript
interface Config {
  port: number
  nodeEnv: 'development' | 'production' | 'test'
  databaseUrl: string
  jwt: {
    secret: string
    expiresIn: string
  }
  cors: {
    origin: string | string[]
    credentials: boolean
  }
  upload: {
    maxFileSize: number
    allowedMimeTypes: string[]
  }
}
```

## 🛠️ Утилиты

### Crypto

```typescript
// Хеширование пароля
async function hashPassword(password: string): Promise<string>

// Проверка пароля
async function comparePassword(
  password: string, 
  hash: string
): Promise<boolean>

// Генерация случайного токена
function generateToken(length?: number): string
```

### Date Helpers

```typescript
// Форматирование даты
function formatDate(date: Date): string

// Добавление дней
function addDays(date: Date, days: number): Date

// Проверка истечения
function isExpired(date: Date): boolean
```

## 📦 Зависимости

```json
{
  "fastify": "^4.24.3",
  "@fastify/jwt": "^7.2.4",
  "bcryptjs": "^2.4.3",
  "zod": "^3.22.4"
}
```

## 🔗 Связанные модули

- Используется во всех модулях backend
- Базовый модуль без зависимостей от других модулей

## 💡 Примеры

### Создание защищенного маршрута

```typescript
import { authMiddleware } from '@/backend_modules/core_module'
import { successResponse } from '@/backend_modules/core_module'

fastify.get('/api/profile', {
  preHandler: authMiddleware
}, async (request, reply) => {
  const user = request.user
  
  // Получаем данные пользователя
  const profile = await getUserProfile(user.id)
  
  return successResponse(profile, 'Profile retrieved')
})
```

### Валидация данных в маршруте

```typescript
import { z } from 'zod'
import { errorResponse, successResponse } from '@/backend_modules/core_module'

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
  password: z.string().min(8),
})

fastify.post('/api/users', async (request, reply) => {
  try {
    const validated = createUserSchema.parse(request.body)
    
    const user = await createUser(validated)
    
    return successResponse(user, 'User created', { statusCode: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return errorResponse('Validation failed', 400, error.errors)
    }
    throw error
  }
})
```

### Обработка ошибок

```typescript
import { errorResponse } from '@/backend_modules/core_module'

fastify.setErrorHandler((error, request, reply) => {
  // Логирование
  request.log.error(error)
  
  // JWT ошибки
  if (error.statusCode === 401) {
    return reply.status(401).send(
      errorResponse('Unauthorized', 401)
    )
  }
  
  // Другие ошибки
  return reply.status(error.statusCode || 500).send(
    errorResponse(
      error.message || 'Internal Server Error',
      error.statusCode || 500
    )
  )
})
```

---

**Версия:** 1.0.0  
**Обновлено:** October 2025

