# Backend Modules - Модульный backend

Модульная структура backend API Supply Diets для разработки и переиспользования в других проектах.

## 📋 Структура модулей

### Core Module
**Папка:** `core_module`  
**Описание:** Ядро backend - middleware, общие утилиты, типы, конфигурация

### Database Module
**Папка:** `database_module`  
**Описание:** Подключение к БД, миграции, инициализация

### Auth Module
**Папка:** `auth_module`  
**Описание:** Аутентификация, регистрация, JWT, сброс пароля

### Users Module
**Папка:** `users_module`  
**Описание:** Управление профилями пользователей, аватары, настройки

### Nutrition Module
**Папка:** `nutrition_module`  
**Описание:** Планы питания, продукты, приемы пищи, КБЖУ

### Knowledge Module
**Папка:** `knowledge_module`  
**Описание:** База знаний (курсы, уроки, категории)

### Diary Module
**Папка:** `diary_module`  
**Описание:** Дневник питания, трекинг еды и воды

### Lab Module
**Папка:** `lab_module`  
**Описание:** Лабораторные анализы и результаты

### Survey Module
**Папка:** `survey_module`  
**Описание:** Опросники и анкеты

### AI Chat Module
**Папка:** `ai_chat_module`  
**Описание:** AI чат с OpenAI интеграцией

### Subscription Module
**Папка:** `subscription_module`  
**Описание:** Подписки, платежи, премиум доступ

### Files Module
**Папка:** `files_module`  
**Описание:** Загрузка файлов (изображения, видео, аудио)

### Analytics Module
**Папка:** `analytics_module`  
**Описание:** Аналитика, статистика, метрики

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
cd backend_modules
npm install
```

### 2. Использование модуля

Каждый модуль содержит:
- `README.md` - описание модуля
- `routes/` - маршруты API (Fastify)
- `services/` - бизнес-логика
- `models/` - модели данных (SQL)
- `types/` - TypeScript типы
- `tests/` - тесты

### 3. Интеграция модуля

```typescript
// Пример: импорт маршрутов из модуля
import { authRoutes } from '@/backend_modules/auth_module'
import { nutritionRoutes } from '@/backend_modules/nutrition_module'

// Регистрация в Fastify
fastify.register(authRoutes, { prefix: '/api/auth' })
fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })
```

## 📦 Технологический стек

### Backend Framework
- **Fastify** 4.24.3 - быстрый web framework
- **TypeScript** 5.2.2 - типизация
- **PostgreSQL** - база данных

### Основные библиотеки
- **@fastify/jwt** - JWT аутентификация
- **@fastify/cors** - CORS поддержка
- **@fastify/swagger** - API документация
- **bcryptjs** - хеширование паролей
- **zod** - валидация данных
- **pg** - PostgreSQL клиент
- **openai** - OpenAI API
- **resend** - отправка email

### Dev зависимости
- **jest** - тестирование
- **tsx** - TypeScript execution
- **eslint** - линтинг

## 🏗️ Архитектура

### Принципы модульности

1. **Независимость** - каждый модуль может работать отдельно
2. **Слабая связанность** - модули взаимодействуют через четкие интерфейсы
3. **Высокая когезия** - связанная функциональность в одном модуле
4. **Переиспользование** - модули можно использовать в других проектах
5. **Тестируемость** - каждый модуль покрыт тестами

### Структура модуля

```
module_name/
├── README.md              # Описание модуля
├── routes/               # API маршруты (Fastify)
│   └── index.ts
├── services/             # Бизнес-логика
│   └── service.ts
├── models/               # SQL модели и запросы
│   └── model.ts
├── types/                # TypeScript типы
│   └── index.ts
├── validators/           # Zod схемы валидации
│   └── schemas.ts
└── tests/                # Unit и интеграционные тесты
    └── service.test.ts
```

## 🔧 Конфигурация

### Переменные окружения

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# JWT
JWT_SECRET=your-secret-key

# OpenAI
OPENAI_API_KEY=sk-...

# Email
RESEND_API_KEY=re_...
USE_MOCK_EMAIL=false

# Server
PORT=3000
NODE_ENV=development
```

## 📚 Документация модулей

Подробная документация по каждому модулю:

- [Core Module](./core_module/README.md)
- [Database Module](./database_module/README.md)
- [Auth Module](./auth_module/README.md)
- [Users Module](./users_module/README.md)
- [Nutrition Module](./nutrition_module/README.md)
- [Knowledge Module](./knowledge_module/README.md)
- [Diary Module](./diary_module/README.md)
- [Lab Module](./lab_module/README.md)
- [Survey Module](./survey_module/README.md)
- [AI Chat Module](./ai_chat_module/README.md)
- [Subscription Module](./subscription_module/README.md)
- [Files Module](./files_module/README.md)
- [Analytics Module](./analytics_module/README.md)

## 🤝 Вклад в разработку

При добавлении нового модуля:

1. Создайте папку `module_name`
2. Добавьте структуру (routes, services, models, types)
3. Напишите README.md
4. Добавьте тесты
5. Обновите этот README

## 📝 Примеры использования

### Создание нового API

```typescript
// server.ts
import Fastify from 'fastify'
import { authRoutes } from '@/backend_modules/auth_module'
import { nutritionRoutes } from '@/backend_modules/nutrition_module'

const fastify = Fastify({ logger: true })

// Регистрация модулей
await fastify.register(authRoutes, { prefix: '/api/auth' })
await fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })

// Запуск сервера
await fastify.listen({ port: 3000, host: '0.0.0.0' })
```

### Использование сервиса

```typescript
import { AuthService } from '@/backend_modules/auth_module'

const authService = new AuthService()

// Регистрация пользователя
const user = await authService.register({
  email: 'user@example.com',
  password: 'securepassword',
  name: 'John Doe'
})

// Вход
const { token, user: loggedUser } = await authService.login({
  email: 'user@example.com',
  password: 'securepassword'
})
```

## 🎯 Best Practices

1. **RESTful API** - следуйте REST принципам
2. **Валидация** - используйте Zod для валидации
3. **Ошибки** - обрабатывайте все ошибки
4. **Типизация** - используйте TypeScript типы
5. **Тестирование** - пишите тесты для каждого модуля
6. **Документация** - документируйте API с Swagger
7. **Безопасность** - используйте JWT, helmet, CORS
8. **Логирование** - логируйте важные события

## 📄 Лицензия

MIT License - используйте свободно в ваших проектах

---

**Версия:** 1.0.0  
**Дата:** October 2025  
**Автор:** Supply Diets Team

