# Quick Start - Быстрый старт Backend

## ⚡ 10-минутная установка

### Шаг 1: Клонируйте модули

```bash
cd your-backend-project
mkdir src/modules
cp -r backend_modules/* src/modules/
```

### Шаг 2: Установите зависимости

```bash
npm install fastify @fastify/cors @fastify/jwt @fastify/multipart
npm install pg bcryptjs jsonwebtoken openai resend zod dotenv
npm install -D @types/pg @types/bcryptjs @types/jsonwebtoken typescript tsx
```

### Шаг 3: Настройте .env

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/supply_diets

# JWT
JWT_SECRET=your-super-secret-key-change-this-in-production
JWT_EXPIRES_IN=7d

# OpenAI
OPENAI_API_KEY=sk-...

# Email
RESEND_API_KEY=re_...
USE_MOCK_EMAIL=false

# Server
PORT=3000
NODE_ENV=development
```

### Шаг 4: Инициализируйте БД

```bash
# Создайте БД
createdb supply_diets

# Запустите миграции
npm run db:migrate
```

### Шаг 5: Создайте сервер

```typescript
// src/index.ts
import Fastify from 'fastify'
import cors from '@fastify/cors'
import jwt from '@fastify/jwt'

// Import modules
import { authRoutes } from './modules/auth_module'
import { nutritionRoutes } from './modules/nutrition_module'

const fastify = Fastify({ logger: true })

// Plugins
await fastify.register(cors, { origin: true })
await fastify.register(jwt, { secret: process.env.JWT_SECRET! })

// Routes
await fastify.register(authRoutes, { prefix: '/api/auth' })
await fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })

// Start
await fastify.listen({ 
  port: Number(process.env.PORT) || 3000, 
  host: '0.0.0.0' 
})

console.log('🚀 Server running on http://localhost:3000')
```

### Шаг 6: Запустите

```bash
npm run dev
```

## 🎯 Тестирование API

### Регистрация

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123!",
    "name": "Test User"
  }'
```

### Вход

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123!"
  }'
```

### Получение планов

```bash
curl http://localhost:3000/api/nutrition/plans
```

## 📦 package.json

```json
{
  "name": "your-backend",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "db:migrate": "tsx src/modules/database_module/migrate.ts"
  },
  "dependencies": {
    "fastify": "^4.24.3",
    "@fastify/cors": "^8.4.0",
    "@fastify/jwt": "^7.2.4",
    "@fastify/multipart": "^7.6.0",
    "pg": "^8.11.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "openai": "^5.12.0",
    "resend": "^2.0.0",
    "zod": "^3.22.4",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/pg": "^8",
    "@types/bcryptjs": "^2",
    "@types/jsonwebtoken": "^9",
    "typescript": "^5",
    "tsx": "^4"
  }
}
```

## ✅ Checklist

- [ ] PostgreSQL установлен и запущен
- [ ] База данных создана
- [ ] .env файл настроен
- [ ] Зависимости установлены
- [ ] Миграции выполнены
- [ ] Сервер запускается без ошибок
- [ ] API отвечает на запросы

## 🚀 Готово!

Ваш backend работает на `http://localhost:3000`

---

**Время установки:** ~10 минут  
**Версия:** 1.0.0

