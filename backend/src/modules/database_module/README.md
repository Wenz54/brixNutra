# Database Module - База данных

Модуль для подключения к БД и управления миграциями.

## 📦 Функциональность

- Подключение к PostgreSQL
- Connection pooling
- Миграции
- Инициализация таблиц
- Rollback миграций

## 🚀 Использование

### Подключение к БД

```typescript
import { getConnection } from '@/backend_modules/database_module'

const pool = getConnection()

// Выполнение запроса
const result = await pool.query(
  'SELECT * FROM users WHERE email = $1',
  ['user@example.com']
)
```

### Миграции

```bash
# Запуск миграций
npm run db:migrate

# Откат последней миграции
npm run db:rollback

# Создание новой миграции
npm run db:create-migration "add_user_avatar"
```

## 📊 Структура миграций

```sql
-- migrations/001_create_users_table.sql
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  is_email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

## 🔧 Connection Pool

```typescript
import { Pool } from 'pg'

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20, // максимум подключений
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
})
```

## 📦 Таблицы БД

- `users` - пользователи
- `nutrition_plans` - планы питания
- `products` - продукты
- `meals` - приемы пищи
- `diary_entries` - записи дневника
- `courses` - курсы
- `lessons` - уроки
- `categories` - категории
- `ai_conversations` - AI диалоги
- `ai_messages` - сообщения чата
- `subscriptions` - подписки
- `payments` - платежи
- `lab_tests` - анализы
- `survey_responses` - ответы опросов

---

**Версия:** 1.0.0

