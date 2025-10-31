# Brix Nutrition Backend API

Backend API для Brix Nutritional App, построенный на **Fastify** + **TypeScript** с использованием готовых модулей из `backend_modules`.

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
cd backend
npm install
```

### 2. Настройка environment variables

Создайте `.env` файл:

```bash
cp .env.example .env
```

Сгенерируйте JWT секреты:

```bash
# Windows PowerShell
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# macOS/Linux
openssl rand -base64 32
```

Вставьте сгенерированные секреты в `.env`:

```env
JWT_SECRET=YOUR_GENERATED_SECRET_HERE
API_TOKEN_SALT=YOUR_GENERATED_SALT_HERE
ADMIN_JWT_SECRET=YOUR_GENERATED_ADMIN_SECRET_HERE
```

### 3. Запуск Docker сервисов

Из корневой директории проекта:

```bash
docker-compose up -d postgres redis mailhog
```

Проверьте статус:

```bash
docker-compose ps
```

Доступные сервисы:
- **PostgreSQL**: `localhost:5432`
- **Redis**: `localhost:6379`
- **PgAdmin**: `http://localhost:5050` (admin@brix-nutrition.com / admin)
- **Redis Commander**: `http://localhost:8081`
- **Mailhog UI**: `http://localhost:8025` (просмотр отправленных email)

### 4. Инициализация базы данных

```bash
# Создать базу данных (если не создана Docker)
createdb brix_nutrition

# Запустить миграции (когда будут готовы)
npm run db:migrate
```

### 5. Запуск сервера

**Development mode (с hot reload):**

```bash
npm run dev
```

**Production build:**

```bash
npm run build
npm start
```

Сервер будет доступен:
- API: `http://localhost:3000/api`
- Health check: `http://localhost:3000/health`
- Swagger docs: `http://localhost:3000/documentation`

## 📁 Структура проекта

```
backend/
├── src/
│   ├── index.ts                 # Главный файл сервера
│   ├── config/
│   │   └── env.ts               # Environment config & validation
│   └── modules/                 # Backend modules (copied from backend_modules/)
│       ├── core_module/
│       ├── database_module/
│       ├── auth_module/
│       ├── users_module/
│       ├── nutrition_module/
│       ├── diary_module/
│       ├── knowledge_module/
│       ├── lab_module/
│       ├── ai_chat_module/
│       ├── subscription_module/
│       ├── files_module/
│       ├── analytics_module/
│       └── survey_module/
├── scripts/                     # Database migration scripts
├── dist/                        # Compiled TypeScript (generated)
├── .env.example                 # Environment variables template
├── package.json
├── tsconfig.json
└── README.md
```

## 🔧 Доступные команды

```bash
# Development
npm run dev          # Запуск с hot reload (tsx watch)

# Production
npm run build        # Компиляция TypeScript
npm start            # Запуск production сервера

# Database
npm run db:migrate              # Применить миграции
npm run db:migrate:create       # Создать новую миграцию
npm run db:migrate:rollback     # Откатить последнюю миграцию

# Code Quality
npm run lint         # ESLint проверка
npm test             # Запуск тестов
```

## 📦 Backend Modules

Проект использует готовые модули из `backend_modules/`:

| Модуль | Описание | Статус |
|--------|----------|--------|
| `core_module` | Middleware, utils, общие типы | ✅ Готов |
| `database_module` | PostgreSQL подключение + миграции | ✅ Готов |
| `auth_module` | JWT, регистрация, верификация | ⚠️ Требует адаптации (SMS) |
| `users_module` | Профили пользователей | ✅ Готов |
| `nutrition_module` | Планы питания, рецепты | ⚠️ Требует расширения |
| `diary_module` | Дневник питания | ⚠️ Требует расширения |
| `knowledge_module` | Курсы, уроки | ✅ Готов |
| `lab_module` | Анализы | ⚠️ Требует расширения |
| `ai_chat_module` | OpenAI интеграция | ⚠️ Требует адаптации |
| `subscription_module` | Подписки, Stripe | ✅ Готов |
| `files_module` | Загрузка медиа | ✅ Готов |
| `analytics_module` | Статистика | ✅ Готов |
| `survey_module` | Опросники | ✅ Готов |

### Что нужно добавить/адаптировать:

1. **SMS Authentication** (auth_module)
   - Добавить endpoints для SMS верификации
   - Интегрировать Twilio

2. **Recipes API** (nutrition_module)
   - Расширить модель рецептов
   - Добавить альтернативы блюд

3. **Blog Module** (создать новый)
   - CRUD для статей блога
   - Markdown поддержка

4. **Notifications API** (создать новый)
   - Push уведомления
   - Системные уведомления

## 🔐 Безопасность

### Environment Variables
- ⚠️ **Никогда не коммитьте `.env` файл**
- Используйте `.env.example` как шаблон
- Генерируйте сильные секреты для JWT

### JWT Authentication
- Access Token: 7 дней (настраивается)
- Подписывается с `JWT_SECRET`
- Включает: userId, email, role

### Rate Limiting
- По умолчанию: 100 запросов / минута
- Настраивается через `RATE_LIMIT_*` в `.env`

### CORS
- Разрешен только `FRONTEND_URL` из `.env`
- В production настройте правильный домен

## 🧪 Тестирование

```bash
# Unit tests
npm test

# Coverage
npm run test:coverage
```

## 📚 API Documentation

После запуска сервера:

**Swagger UI**: http://localhost:3000/documentation

Документация генерируется автоматически из кода с помощью `@fastify/swagger`.

## 🐳 Docker

### Development

```bash
# Из корневой директории
docker-compose up -d postgres redis mailhog
```

### Production

TODO: Добавить Dockerfile для production деплоя

## 🔗 Полезные ссылки

- [Fastify Documentation](https://www.fastify.io/)
- [TypeScript Docs](https://www.typescriptlang.org/)
- [Zod Validation](https://github.com/colinhacks/zod)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Docs](https://redis.io/docs/)

## 📝 Changelog

### Version 1.0.0 (Current)

- ✅ Fastify 4.24.3 setup
- ✅ TypeScript 5.3.3 configuration
- ✅ Environment validation (Zod)
- ✅ Backend modules integrated
- ✅ Swagger documentation
- ✅ Health check endpoint
- ⏳ Database migrations (pending)
- ⏳ Module routes registration (pending)
- ⏳ SMS authentication (pending)

## 🤝 Contributing

### Добавление нового модуля

1. Создайте структуру в `src/modules/module_name/`
2. Следуйте архитектуре существующих модулей:
   ```
   module_name/
   ├── README.md
   ├── routes/
   ├── services/
   ├── models/
   ├── types/
   └── validators/
   ```
3. Зарегистрируйте routes в `src/index.ts`
4. Обновите документацию

### Code Style

- TypeScript strict mode
- ESLint + Prettier
- Async/await вместо callbacks
- Try-catch для всех async операций
- Zod валидация входных данных

## 📄 License

MIT

---

**Version**: 1.0.0  
**Last Updated**: October 10, 2025








