# 🚀 Фаза 1: Инфраструктура - Инструкции по запуску

## ✅ Выполнено

- ✅ Docker-compose.yml обновлен (PostgreSQL, Redis, PgAdmin, Redis Commander, Mailhog)
- ✅ Backend проект создан (Fastify + TypeScript)
- ✅ Backend_modules интегрированы (13 модулей скопированы)
- ✅ Конфигурация подготовлена (env.ts, index.ts, tsconfig.json)

## 📋 Что нужно сделать вручную

### 1. Создать `.env` файл для backend

```bash
cd backend
```

Создайте файл `.env` со следующим содержимым:

```env
# Server
NODE_ENV=development
HOST=0.0.0.0
PORT=3000

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=brix_nutrition
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_SSL=false

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT Secrets - ЗАМЕНИТЕ на сгенерированные!
JWT_SECRET=YOUR_GENERATED_SECRET_HERE
API_TOKEN_SALT=YOUR_GENERATED_SALT_HERE
ADMIN_JWT_SECRET=YOUR_GENERATED_ADMIN_SECRET_HERE

# Email (Mailhog для development)
SMTP_HOST=localhost
SMTP_PORT=1025
USE_MOCK_EMAIL=true

# Frontend URL
FRONTEND_URL=http://localhost:3000

# Rate Limiting
RATE_LIMIT_MAX=100
RATE_LIMIT_WINDOW_MS=60000

# Logging
LOG_LEVEL=info
```

### 2. Сгенерировать JWT секреты

**Windows PowerShell:**
```powershell
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

**macOS/Linux:**
```bash
openssl rand -base64 32
```

Выполните команду **3 раза** и вставьте результаты в `.env`:
- `JWT_SECRET`
- `API_TOKEN_SALT`
- `ADMIN_JWT_SECRET`

### 3. Запустить Docker сервисы

Из **корневой директории проекта** (brixNutra):

```bash
docker-compose up -d
```

Проверить статус:

```bash
docker-compose ps
```

Должны быть запущены:
- ✅ `brix_postgres` (PostgreSQL)
- ✅ `brix_redis` (Redis)
- ✅ `brix_pgadmin` (PgAdmin)
- ✅ `brix_redis_commander` (Redis Commander)
- ✅ `brix_mailhog` (Mailhog)

### 4. Установить зависимости backend

```bash
cd backend
npm install
```

Это установит:
- Fastify 4.24.3
- TypeScript 5.3.3
- Zod для валидации
- JWT authentication
- Swagger документацию
- И все остальные зависимости

### 5. Запустить backend сервер

**Development mode (с hot reload):**

```bash
npm run dev
```

Сервер запустится на `http://localhost:3000`

## 🔍 Проверка доступности сервисов

После запуска Docker и backend, проверьте:

| Сервис | URL | Логин/Пароль |
|--------|-----|--------------|
| **Backend API** | http://localhost:3000/api | - |
| **Swagger Docs** | http://localhost:3000/documentation | - |
| **Health Check** | http://localhost:3000/health | - |
| **PostgreSQL** | localhost:5432 | postgres / postgres |
| **PgAdmin** | http://localhost:5050 | admin@brix-nutrition.com / admin |
| **Redis** | localhost:6379 | - |
| **Redis Commander** | http://localhost:8081 | - |
| **Mailhog UI** | http://localhost:8025 | - |

### Проверка в браузере

1. **Health Check**: http://localhost:3000/health
   ```json
   {
     "status": "ok",
     "timestamp": "...",
     "uptime": 123.456,
     "environment": "development"
   }
   ```

2. **API Root**: http://localhost:3000/api
   ```json
   {
     "message": "Brix Nutritional App API",
     "version": "1.0.0",
     "documentation": "/documentation"
   }
   ```

3. **Swagger UI**: http://localhost:3000/documentation
   - Полная документация API
   - Интерактивное тестирование endpoints

### Проверка PostgreSQL

**Через PgAdmin:**
1. Откройте http://localhost:5050
2. Войдите: `admin@brix-nutrition.com` / `admin`
3. Add Server:
   - Name: Brix PostgreSQL
   - Host: postgres (или localhost если не работает)
   - Port: 5432
   - Database: brix_nutrition
   - Username: postgres
   - Password: postgres

**Через CLI:**
```bash
psql -h localhost -U postgres -d brix_nutrition
```

### Проверка Redis

**Через Redis Commander:**
1. Откройте http://localhost:8081
2. Видите интерфейс с Redis данными

**Через CLI:**
```bash
redis-cli ping
# Ответ: PONG
```

### Проверка Mailhog

1. Откройте http://localhost:8025
2. Видите интерфейс Mailhog (пустой пока нет отправленных писем)
3. Когда backend будет отправлять email, они появятся здесь

## 🐛 Troubleshooting

### Docker контейнеры не запускаются

```bash
# Остановить все контейнеры
docker-compose down

# Очистить volumes (ВНИМАНИЕ: удалит данные!)
docker-compose down -v

# Запустить заново
docker-compose up -d
```

### Порт уже занят

Если порт 3000, 5432, 6379 и т.д. уже используется:

**Windows:**
```powershell
# Найти процесс на порту
netstat -ano | findstr :3000

# Убить процесс (замените PID)
taskkill /PID <PID> /F
```

**macOS/Linux:**
```bash
# Найти процесс
lsof -i :3000

# Убить процесс
kill -9 <PID>
```

Или измените порты в `docker-compose.yml` и `.env`

### Backend не запускается

1. Проверьте `.env` файл (правильные JWT секреты?)
2. Проверьте что PostgreSQL и Redis запущены:
   ```bash
   docker-compose ps
   ```
3. Проверьте логи:
   ```bash
   cd backend
   npm run dev
   # Смотрите ошибки в консоли
   ```

### Ошибка подключения к БД

Убедитесь что:
- Docker контейнер PostgreSQL запущен
- Порт 5432 доступен
- Credentials в `.env` правильные

Попробуйте:
```bash
docker-compose restart postgres
```

## 📝 Следующие шаги (Фаза 2)

После успешного запуска инфраструктуры:

1. ✅ **Запустить миграции БД** (создать таблицы)
2. ✅ **Адаптировать auth_module** для SMS верификации
3. ✅ **Расширить nutrition_module** для рецептов Brix
4. ✅ **Создать недостающие endpoints** (blog, notifications)
5. ✅ **Интегрировать все модули** в `src/index.ts`

См. `tasks.md` → Фаза 2: Backend API - Адаптация и расширение

## ✅ Checklist

- [ ] Docker сервисы запущены (postgres, redis, mailhog)
- [ ] Backend `.env` файл создан с JWT секретами
- [ ] Backend зависимости установлены (`npm install`)
- [ ] Backend сервер запускается (`npm run dev`)
- [ ] Health check работает (http://localhost:3000/health)
- [ ] Swagger docs доступен (http://localhost:3000/documentation)
- [ ] PgAdmin подключается к PostgreSQL
- [ ] Redis Commander показывает Redis
- [ ] Mailhog UI открывается

## 🎉 Поздравляю!

Если все пункты checklist выполнены - **Фаза 1 завершена!**

Готовые компоненты:
- ✅ PostgreSQL 14 (БД)
- ✅ Redis 7 (Кэш)
- ✅ Fastify backend с 13 модулями
- ✅ Swagger документация
- ✅ Development окружение

**Экономия времени**: ~1-2 недели благодаря готовым backend_modules! 🚀

---

**Дата**: 10 октября 2025  
**Версия**: 1.0.0




