# Документация проекта Brix Nutrition

## Содержание

1. [Описание проекта](#описание-проекта)
2. [Структура проекта](#структура-проекта)
3. [Технологии](#технологии)
4. [Настройка окружения](#настройка-окружения)
5. [Запуск проекта](#запуск-проекта)
6. [Структура базы данных](#структура-базы-данных)
7. [API Endpoints](#api-endpoints)
8. [Модули Backend](#модули-backend)
9. [Модули Mobile](#модули-mobile)
10. [Admin Panel](#admin-panel)
11. [Тестирование](#тестирование)
12. [Внешние сервисы](#внешние-сервисы)

---

## Описание проекта

Brix Nutrition — приложение для персонализированного питания и здоровья. Состоит из трех основных компонентов:

- **Backend API** (Fastify + TypeScript + PostgreSQL)
- **Mobile App** (Flutter + Dart)
- **Admin Panel** (Next.js + React + TypeScript)

### Основной функционал

- Авторизация через SMS/Email
- Планы питания и рецепты
- Дневник питания с фото
- AI-консультант (OpenAI GPT-4)
- Расшифровка лабораторных анализов
- База знаний и курсы
- Блог
- Система подписок
- Уведомления

---

## Структура проекта

```
brixNutra/
├── backend/              # API сервер (Fastify)
│   ├── src/
│   │   ├── config/       # Конфигурация env переменных
│   │   ├── modules/      # Бизнес-логика по модулям
│   │   └── index.ts      # Точка входа сервера
│   ├── scripts/          # Скрипты миграций БД
│   ├── uploads/          # Загруженные файлы (локально)
│   └── package.json
│
├── mobile/               # Flutter приложение
│   ├── lib/
│   │   ├── app/          # Конфигурация приложения
│   │   ├── features/     # Функциональные модули
│   │   ├── shared/       # Общие компоненты
│   │   └── main.dart     # Точка входа
│   ├── android/          # Android конфигурация
│   ├── ios/              # iOS конфигурация
│   └── pubspec.yaml
│
├── admin/                # Next.js админ-панель
│   ├── app/              # Страницы (App Router)
│   │   ├── blog/
│   │   ├── courses/
│   │   ├── lab-tests/
│   │   ├── recipes/
│   │   └── users/
│   ├── components/       # React компоненты
│   ├── lib/              # API клиент и типы
│   └── package.json
│
├── docs/                 # Документация
│   ├── API_SPECIFICATION.yaml
│   ├── TECHNICAL_SPECIFICATION.md
│   ├── DEVELOPMENT_GUIDE.md
│   └── modules/          # Документация по модулям
│
├── test_scripts/         # Тестовые скрипты и seed данные
│   ├── api/              # API тесты
│   └── db/               # SQL скрипты для БД
│
├── start/                # Скрипты запуска
│   ├── dev/              # Для разработки
│   └── test/             # Для тестирования
│
├── docker-compose.yml    # PostgreSQL + Redis + pgAdmin + Redis Commander
└── env.example.txt       # Шаблон переменных окружения
```

---

## Технологии

### Backend

| Компонент | Технология | Версия |
|-----------|-----------|--------|
| Runtime | Node.js | 18+ |
| Framework | Fastify | 4.24+ |
| Language | TypeScript | 5.3+ |
| Database | PostgreSQL | 14+ |
| Cache | Redis | 7+ |
| Validation | Zod | 3.22+ |
| Auth | JWT (jsonwebtoken) | 9.0+ |
| AI | OpenAI GPT-4 | 5.23+ |
| SMS | Twilio | 4.19+ |
| Email | Resend | 2.0+ |
| Storage | Supabase | 2.75+ |

### Mobile

| Компонент | Технология | Версия |
|-----------|-----------|--------|
| Framework | Flutter | 3.24+ |
| Language | Dart | 3.8+ |
| State Management | flutter_bloc | 8.1+ |
| HTTP Client | Dio | 5.4+ |
| Local Storage | Hive | 2.2+ |
| Secure Storage | flutter_secure_storage | 9.0+ |
| Images | cached_network_image | 3.3+ |

### Admin Panel

| Компонент | Технология | Версия |
|-----------|-----------|--------|
| Framework | Next.js | 14 |
| Language | TypeScript | 5+ |
| UI Framework | Tailwind CSS | 3.4+ |
| Forms | React Hook Form | 7.65+ |
| HTTP Client | Axios | 1.12+ |
| Notifications | react-hot-toast | 2.6+ |

---

## Настройка окружения

### Требования

- **Node.js** 18+
- **npm** 9+
- **Docker** и **Docker Compose**
- **Flutter** 3.24+ (для mobile)
- **PostgreSQL** 14+ (через Docker)
- **Redis** 7+ (через Docker)

### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd brixNutra
```

### 2. Настройка переменных окружения

#### Backend

Создайте файл `backend/.env` на основе `backend/ENV_TEMPLATE.txt`:

```bash
cd backend
cp ENV_TEMPLATE.txt .env
```

Ключевые переменные:

```env
# База данных (Docker)
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/brix_nutrition

# Redis (Docker)
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT (сгенерируйте новые для production)
JWT_SECRET=<минимум-32-символа>
JWT_REFRESH_SECRET=<минимум-32-символа>

# OpenAI (для AI Chat)
OPENAI_API_KEY=sk-proj-...

# SMS/Email (для разработки используется mock)
USE_MOCK_SMS=true
USE_MOCK_EMAIL=true

# Twilio (для production)
# TWILIO_ACCOUNT_SID=ACxxxxx
# TWILIO_AUTH_TOKEN=xxxxx
# TWILIO_PHONE_NUMBER=+1234567890

# Приложение
NODE_ENV=development
PORT=3000
HOST=0.0.0.0

# CORS
FRONTEND_URL=http://localhost:3001
```

#### Mobile

В Flutter переменные задаются в коде. API URL настраивается в:
- `mobile/lib/shared/api_service.dart`
- По умолчанию: `http://localhost:3000/api`

Для работы с реальным устройством замените `localhost` на IP вашего компьютера в локальной сети.

#### Admin

Создайте файл `admin/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:3000/api
```

### 3. Запуск Docker контейнеров

Запустите PostgreSQL, Redis и дополнительные инструменты:

```bash
# Из корня проекта
docker-compose up -d
```

Это запустит:
- **PostgreSQL** на порту 5432
- **Redis** на порту 7000 (внутри 6379)
- **pgAdmin** на http://localhost:5050 (admin@brix-nutrition.com / admin)
- **Redis Commander** на http://localhost:8081
- **MailHog** на http://localhost:8025 (для тестирования email)

Проверка статуса контейнеров:

```bash
docker-compose ps
```

---

## Запуск проекта

### Backend

```bash
cd backend

# Установка зависимостей
npm install

# Запуск в режиме разработки (с hot-reload)
npm run dev
```

Backend будет доступен на **http://localhost:3000**

API документация (Swagger): **http://localhost:3000/documentation**

#### Миграции базы данных

При первом запуске нужно применить миграции:

```bash
cd backend
node scripts/run-migration.js
```

Миграции находятся в:
- `backend/src/modules/database_module/migrations/` (основные схемы)
- `backend/src/modules/*/migrations/` (модульные миграции)

#### Seed данные

Для тестирования можно загрузить тестовые данные:

```bash
# Из корня проекта
cd test_scripts/db
node run-seed.cjs
```

Или SQL скрипты вручную:
```bash
psql -U postgres -h localhost -d brix_nutrition -f backend/seed-test-user.sql
psql -U postgres -h localhost -d brix_nutrition -f backend/seed-meal-plan-data.sql
```

### Mobile

```bash
cd mobile

# Установка зависимостей
flutter pub get

# Запуск на эмуляторе/устройстве
flutter run
```

Для iOS:
```bash
cd ios
pod install
cd ..
flutter run
```

**Важно:** Если запускаете на физическом устройстве, измените API URL в коде с `localhost` на IP вашего компьютера.

### Admin Panel

```bash
cd admin

# Установка зависимостей
npm install

# Запуск в режиме разработки
npm run dev
```

Admin panel будет доступен на **http://localhost:3001**

---

## Структура базы данных

### Основные таблицы

База данных PostgreSQL содержит следующие таблицы:

#### Пользователи и авторизация

- `users` — пользователи приложения
- `verification_codes` — коды верификации для SMS/Email
- `user_profiles` — расширенный профиль пользователя
- `user_goals` — цели пользователя (вес, активность и т.д.)
- `user_measurements` — замеры пользователя (вес, объемы)

#### Питание

- `recipes` — рецепты
- `recipe_ingredients` — ингредиенты рецептов
- `meal_plans` — планы питания
- `meal_plan_days` — дни в плане питания
- `meal_plan_meals` — приемы пищи в плане
- `meal_plan_recipes` — рецепты в приеме пищи

#### Дневник

- `diary_entries` — записи дневника питания
- `diary_meals` — приемы пищи в дневнике
- `water_intake` — потребление воды
- `mood_entries` — записи настроения

#### База знаний

- `courses` — курсы
- `lessons` — уроки в курсах
- `user_course_progress` — прогресс пользователя по курсам
- `user_lesson_progress` — прогресс пользователя по урокам

#### Лабораторные анализы

- `lab_tests` — загруженные анализы
- `lab_test_parameters` — параметры анализов
- `lab_test_interpretations` — расшифровки параметров

#### AI Chat

- `chat_sessions` — сессии чатов с AI
- `chat_messages` — сообщения в чатах

#### Блог и уведомления

- `blog_posts` — статьи блога
- `blog_categories` — категории блога
- `notifications` — уведомления для пользователей

### Миграции

Миграции применяются через скрипт:

```bash
cd backend
node scripts/run-migration.js
```

Список миграций:
1. `001_initial_schema.sql` — основная схема БД
2. `002_add_verification_fields.sql` — поля верификации
3. `003_create_recipes.sql` — рецепты и планы питания
4. `004_create_diary.sql` — дневник питания
5. `005_create_knowledge.sql` — курсы и уроки
6. `006_create_lab_tests.sql` — лабораторные анализы
7. `007_create_user_profile.sql` — профили пользователей
8. `008_create_chat_sessions.sql` — AI чат
9. `009_create_blog_notifications.sql` — блог и уведомления

### Триггеры и функции

БД использует PostgreSQL функции для:
- Автоматический расчет BMI/BMR/TDEE при изменении замеров
- Обновление timestamps (`updated_at`)
- Расчет прогресса курсов

---

## API Endpoints

Полная спецификация: `docs/API_SPECIFICATION.yaml` (OpenAPI 3.0)

### Авторизация (5 endpoints)

```
POST   /api/auth/email/send-code         # Отправить код на email
POST   /api/auth/email/verify-code       # Проверить код из email
POST   /api/auth/phone/send-sms          # Отправить SMS код
POST   /api/auth/phone/verify-sms        # Проверить SMS код
POST   /api/auth/refresh-token           # Обновить токен
```

### Профиль (7 endpoints)

```
GET    /api/profile                      # Получить профиль
PUT    /api/profile                      # Обновить профиль
GET    /api/profile/goals                # Получить цели
PUT    /api/profile/goals                # Обновить цели
GET    /api/profile/measurements         # Получить замеры
POST   /api/profile/measurements         # Добавить замер
GET    /api/profile/metrics              # Получить метрики (BMI/BMR/TDEE)
```

### Рецепты (3 endpoints)

```
GET    /api/recipes                      # Список рецептов
GET    /api/recipes/:id                  # Детали рецепта
GET    /api/recipes/:id/alternatives     # Альтернативные рецепты
```

### Планы питания (3 endpoints)

```
GET    /api/meal-plans                   # Список планов
GET    /api/meal-plans/:id               # Детали плана
POST   /api/meal-plans/:id/swap-recipe   # Заменить рецепт
```

### Дневник (7 endpoints)

```
GET    /api/diary/entries                # Записи дневника
POST   /api/diary/entries                # Создать запись
GET    /api/diary/entries/:id            # Детали записи
PUT    /api/diary/entries/:id            # Обновить запись
DELETE /api/diary/entries/:id            # Удалить запись
POST   /api/diary/water                  # Добавить воду
POST   /api/diary/mood                   # Добавить настроение
```

### Курсы (8 endpoints)

```
GET    /api/courses                      # Список курсов
GET    /api/courses/:id                  # Детали курса
GET    /api/courses/:id/lessons          # Уроки курса
POST   /api/courses/:id/enroll           # Записаться на курс
GET    /api/courses/progress             # Прогресс по курсам
POST   /api/lessons/:id/complete         # Завершить урок
GET    /api/lessons/:id                  # Детали урока
PUT    /api/lessons/:id/progress         # Обновить прогресс
```

### Лабораторные анализы (6 endpoints)

```
GET    /api/lab-tests                    # Список анализов
POST   /api/lab-tests                    # Загрузить анализ
GET    /api/lab-tests/:id                # Детали анализа
POST   /api/lab-tests/:id/analyze        # Расшифровать анализ
GET    /api/lab-tests/:id/parameters     # Параметры анализа
GET    /api/lab-tests/:id/recommendations # Рекомендации
```

### AI Chat (5 endpoints)

```
POST   /api/ai-chat/sessions             # Создать сессию
GET    /api/ai-chat/sessions             # Список сессий
GET    /api/ai-chat/sessions/:id         # Детали сессии
POST   /api/ai-chat/sessions/:id/message # Отправить сообщение
DELETE /api/ai-chat/sessions/:id         # Удалить сессию
```

### Блог (5 endpoints)

```
GET    /api/blog/posts                   # Список статей
GET    /api/blog/posts/:id               # Детали статьи
GET    /api/blog/categories              # Категории
GET    /api/blog/posts/category/:id      # Статьи категории
POST   /api/blog/posts/:id/like          # Лайк статьи
```

### Уведомления (4 endpoints)

```
GET    /api/notifications                # Список уведомлений
PUT    /api/notifications/:id/read       # Отметить прочитанным
PUT    /api/notifications/read-all       # Отметить все прочитанными
DELETE /api/notifications/:id            # Удалить уведомление
```

### Admin CRUD (12 endpoints)

```
POST   /api/admin/courses                # Создать курс
PUT    /api/admin/courses/:id            # Обновить курс
DELETE /api/admin/courses/:id            # Удалить курс

POST   /api/admin/recipes                # Создать рецепт
PUT    /api/admin/recipes/:id            # Обновить рецепт
DELETE /api/admin/recipes/:id            # Удалить рецепт

POST   /api/admin/blog-posts             # Создать статью
PUT    /api/admin/blog-posts/:id         # Обновить статью
DELETE /api/admin/blog-posts/:id         # Удалить статью

GET    /api/admin/users                  # Список пользователей
PUT    /api/admin/users/:id              # Обновить пользователя
DELETE /api/admin/users/:id              # Удалить пользователя
```

### Файлы (2 endpoints)

```
POST   /api/files/upload                 # Загрузить файл
DELETE /api/files/:id                    # Удалить файл
```

---

## Модули Backend

Backend разделен на модули в директории `backend/src/modules/`:

### auth_module

**Функционал:**
- SMS верификация (через Twilio или mock)
- Email верификация (через Resend или mock)
- Генерация и проверка кодов
- JWT токены (access + refresh)

**Файлы:**
- `routes/auth.ts` — роуты авторизации
- `routes/sms-verification.ts` — SMS верификация
- `services/authService.ts` — бизнес-логика
- `services/smsService.ts` — отправка SMS

**Таблицы:**
- `users`
- `verification_codes`

### nutrition_module

**Функционал:**
- Рецепты с ингредиентами
- Планы питания с днями и приемами пищи
- Альтернативные рецепты
- Замена рецептов в плане
- Дневник питания с фото
- Потребление воды
- Настроение

**Файлы:**
- `routes/recipes.ts`
- `routes/mealPlans.ts`
- `routes/diary.ts`
- `services/recipeService.ts`
- `services/mealPlanService.ts`
- `services/diaryService.ts`

**Таблицы:**
- `recipes`, `recipe_ingredients`
- `meal_plans`, `meal_plan_days`, `meal_plan_meals`, `meal_plan_recipes`
- `diary_entries`, `diary_meals`, `water_intake`, `mood_entries`

### knowledge_module

**Функционал:**
- Курсы (бесплатные и платные)
- Уроки с контентом
- Прогресс по курсам и урокам
- Запись на курсы

**Файлы:**
- `routes/knowledge.ts`
- `services/knowledgeService.ts`

**Таблицы:**
- `courses`
- `lessons`
- `user_course_progress`
- `user_lesson_progress`

### lab_module

**Функционал:**
- Загрузка лабораторных анализов
- Расшифровка 21 параметра
- Интерпретация результатов
- Рекомендации

**Файлы:**
- `routes/labTests.ts`
- `services/labTestService.ts`

**Таблицы:**
- `lab_tests`
- `lab_test_parameters`
- `lab_test_interpretations`

### ai_chat_module

**Функционал:**
- Создание чат-сессий
- Общение с OpenAI GPT-4
- Контекст из БД (профиль, замеры, дневник)
- История сообщений

**Файлы:**
- `routes/aiChat.ts`
- `services/aiChatService.ts`

**Таблицы:**
- `chat_sessions`
- `chat_messages`

**Зависимости:**
- OpenAI API key в `.env`

### users_module

**Функционал:**
- Профиль пользователя
- Цели (вес, активность)
- Замеры (вес, рост, объемы)
- Расчет BMI, BMR, TDEE

**Файлы:**
- `routes/profile.ts`
- `services/userProfileService.ts`

**Таблицы:**
- `user_profiles`
- `user_goals`
- `user_measurements`

### blog_module

**Функционал:**
- Статьи блога
- Категории
- Лайки
- Уведомления

**Файлы:**
- `routes/blog.ts`
- `services/blogService.ts`

**Таблицы:**
- `blog_posts`
- `blog_categories`
- `notifications`

### files_module

**Функционал:**
- Загрузка файлов на Supabase Storage
- Поддержка изображений, PDF, документов
- Удаление файлов

**Файлы:**
- `routes/files.ts`
- `services/fileUploadService.ts`
- `services/supabaseClient.ts`

**Зависимости:**
- Supabase URL и API key (нужно настроить в `.env` или коде)

### admin_module

**Функционал:**
- CRUD операции для админ-панели
- Управление курсами
- Управление рецептами
- Управление пользователями
- Управление статьями блога

**Файлы:**
- `routes/admin.ts`

### core_module

**Вспомогательные функции:**
- JWT middleware
- Валидация
- Стандартизированные ответы

**Файлы:**
- `middleware/jwtAuth.ts` — проверка JWT токена
- `utils/validation.ts` — валидация с Zod
- `utils/response.ts` — форматирование ответов

### database_module

**Функционал:**
- Подключение к PostgreSQL
- Pool connections
- Миграции

**Файлы:**
- `connection.ts` — подключение к БД
- `migrations/` — SQL файлы миграций

---

## Модули Mobile

Mobile приложение разделено на фичи в `mobile/lib/features/`:

### sms_auth

**Функционал:**
- Экран авторизации
- Отправка и проверка SMS кода
- Сохранение JWT токена

**Файлы:**
- `screens/auth_screen.dart`
- `services/sms_auth_service.dart`
- `bloc/` — состояние BLoC

### home

**Функционал:**
- Главный экран с виджетами

**Файлы:**
- `home_screen.dart`

### meal_plan

**Функционал:**
- Список планов питания
- Детали плана на неделю
- Детали рецепта
- Альтернативные рецепты

**Файлы:**
- `screens/meal_plan_screen.dart`
- `screens/recipe_detail_screen.dart`
- `screens/recipe_alternatives_screen.dart`
- `services/meal_plan_service.dart`
- `bloc/` — состояние BLoC

### diary

**Функционал:**
- Дневник питания с календарем
- Добавление приема пищи с фото
- Потребление воды
- Настроение

**Файлы:**
- `screens/diary_screen.dart`
- `screens/add_meal_screen.dart`
- `services/diary_service.dart`
- `bloc/` — состояние BLoC

### knowledge_base

**Функционал:**
- Список курсов
- Детали курса с уроками
- Прогресс

**Файлы:**
- `screens/knowledge_base_screen.dart`
- `services/knowledge_base_service.dart`
- `bloc/` — состояние BLoC

### lab_tests

**Функционал:**
- Загрузка анализов
- Просмотр расшифровки
- Рекомендации

**Файлы:**
- `screens/lab_tests_screen.dart`
- `services/lab_tests_service.dart`
- `bloc/` — состояние BLoC

### ai_chat

**Функционал:**
- Чат с AI консультантом
- История сообщений
- Создание новых сессий

**Файлы:**
- `screens/ai_chat_screen.dart`
- `services/ai_chat_service.dart`
- `bloc/` — состояние BLoC

### blog_notifications

**Функционал:**
- Список статей блога
- Уведомления

**Файлы:**
- `services/blog_notifications_service.dart`
- `bloc/` — состояние BLoC

### subscriptions

**Функционал:**
- Управление подписками
- Покупки (интеграция с платежами)

**Файлы:**
- `services/subscriptions_service.dart`
- `bloc/` — состояние BLoC

### navigation

**Функционал:**
- Bottom navigation bar
- Роутинг между экранами

**Файлы:**
- `main_navigation_screen.dart`

### profile

**Функционал:**
- Профиль пользователя
- Настройки

**Файлы:**
- `profile_screen.dart`

### Shared модули

Общие компоненты находятся в `mobile/lib/shared/`:
- `api_service.dart` — HTTP клиент (Dio)
- `theme.dart` — темы приложения
- `constants.dart` — константы

---

## Admin Panel

Next.js приложение в `admin/`:

### Структура (App Router)

```
admin/app/
├── page.tsx              # Главная (дашборд)
├── layout.tsx            # Layout с сайдбаром
├── globals.css           # Стили
│
├── blog/
│   ├── page.tsx          # Список статей
│   ├── [id]/page.tsx     # Редактирование статьи
│   └── new/page.tsx      # Создание статьи
│
├── courses/
│   ├── page.tsx          # Список курсов
│   ├── [id]/
│   │   ├── page.tsx      # Редактирование курса
│   │   └── lessons/page.tsx  # Уроки курса
│   └── new/page.tsx      # Создание курса
│
├── recipes/
│   ├── page.tsx          # Список рецептов
│   ├── [id]/page.tsx     # Редактирование рецепта
│   └── new/page.tsx      # Создание рецепта
│
├── lab-tests/
│   ├── page.tsx          # Список анализов
│   ├── [id]/page.tsx     # Детали анализа
│   └── new/page.tsx      # Создание анализа
│
└── users/
    ├── page.tsx          # Список пользователей
    └── [id]/page.tsx     # Детали пользователя
```

### Компоненты

```
admin/components/
├── Header.tsx            # Шапка с навигацией
└── Sidebar.tsx           # Боковое меню
```

### API клиент

```
admin/lib/
├── api.ts                # Axios клиент
└── types.ts              # TypeScript типы
```

**Настройка:**
- API URL настраивается в `lib/api.ts`
- По умолчанию: `http://localhost:3000/api`

---

## Тестирование

### API тесты

PowerShell скрипт для быстрого тестирования API:

```bash
cd test_scripts/api
.\quick-test.ps1
```

Этот скрипт тестирует основные endpoints:
- Health check
- Авторизация
- Рецепты
- Планы питания
- И другие

### База данных

Диагностика БД:

```bash
cd test_scripts/db
node diagnose-db.cjs
```

Показывает:
- Статус подключения
- Список таблиц
- Количество записей
- Индексы

### Seed данные

Для загрузки тестовых данных:

```bash
# Тестовый пользователь
psql -U postgres -h localhost -d brix_nutrition -f backend/seed-test-user.sql

# Планы питания и рецепты
psql -U postgres -h localhost -d brix_nutrition -f backend/seed-meal-plan-data.sql
```

### Flutter тесты

```bash
cd mobile
flutter test
```

---

## Внешние сервисы

### PostgreSQL (Docker)

**Подключение:**
- Host: `localhost`
- Port: `5432`
- Database: `brix_nutrition`
- User: `postgres`
- Password: `postgres`

**Управление через pgAdmin:**
- URL: http://localhost:5050
- Email: `admin@brix-nutrition.com`
- Password: `admin`

### Redis (Docker)

**Подключение:**
- Host: `localhost`
- Port: `7000` (внешний), `6379` (внутри Docker)

**Управление через Redis Commander:**
- URL: http://localhost:8081

Используется для:
- Кэширование
- Хранение временных кодов верификации

### OpenAI (опционально)

Для AI Chat модуля требуется OpenAI API key.

**Настройка:**
```env
OPENAI_API_KEY=sk-proj-...
```

**Модель:** GPT-4

**Эндпоинты используют:**
- Chat completions
- Контекст из БД пользователя

### Twilio (опционально)

Для отправки SMS кодов. В режиме разработки используется mock.

**Настройка для production:**
```env
USE_MOCK_SMS=false
TWILIO_ACCOUNT_SID=ACxxxxx
TWILIO_AUTH_TOKEN=xxxxx
TWILIO_PHONE_NUMBER=+1234567890
```

### Resend (опционально)

Для отправки email. В режиме разработки используется mock (или MailHog).

**MailHog (локально):**
- SMTP: `localhost:1025`
- Web UI: http://localhost:8025

### Supabase (опционально)

Для хранения файлов (изображения, документы).

**Настройка:**
В `backend/src/modules/files_module/services/supabaseClient.ts` нужно указать:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Или использовать локальное хранилище (директория `backend/uploads/`).

### Stripe (не реализовано)

Для платежей и подписок. Заготовки есть в коде, но требуется интеграция.

---

## Полезные команды

### Docker

```bash
# Запуск контейнеров
docker-compose up -d

# Остановка контейнеров
docker-compose down

# Логи
docker-compose logs -f

# Перезапуск
docker-compose restart

# Очистка volumes (удалит данные!)
docker-compose down -v
```

### Backend

```bash
# Разработка
npm run dev

# Сборка
npm run build

# Production
npm run start

# Миграции
node scripts/run-migration.js

# Тесты
npm test
```

### Mobile

```bash
# Установка зависимостей
flutter pub get

# Запуск
flutter run

# Сборка APK (Android)
flutter build apk

# Сборка iOS
flutter build ios

# Очистка
flutter clean
```

### Admin

```bash
# Разработка
npm run dev

# Сборка
npm run build

# Production
npm run start
```

### База данных

```bash
# Подключение через psql
psql -U postgres -h localhost -d brix_nutrition

# Дамп БД
pg_dump -U postgres -h localhost brix_nutrition > backup.sql

# Восстановление
psql -U postgres -h localhost -d brix_nutrition < backup.sql
```

---

## Известные проблемы и заметки

### Backend

- **Mock режим SMS/Email:** По умолчанию включен для разработки. Для production нужно настроить реальные сервисы.
- **Supabase Storage:** Требует настройки ключей. Альтернатива — локальное хранилище в `backend/uploads/`.
- **JWT Secret:** Для production обязательно сгенерируйте новые секреты.

### Mobile

- **API URL:** При запуске на физическом устройстве `localhost` не работает. Нужно использовать IP компьютера в локальной сети.
- **iOS:** Требуется Mac и Xcode для разработки и сборки.
- **Supabase:** Если используется для файлов, нужно настроить в коде.

### Admin

- **Авторизация:** В текущей версии нет авторизации для админ-панели. Требуется реализация.
- **CORS:** Backend должен разрешать запросы с `http://localhost:3001`.

### База данных

- **Порт PostgreSQL:** Использует стандартный порт 5432. Если уже занят, измените в `docker-compose.yml`.
- **Миграции:** Применяются вручную через скрипт. Автоматическая миграция при запуске не реализована.

---

## Дополнительная документация

В директории `docs/` находятся детальные документы:

- `API_SPECIFICATION.yaml` — Полная OpenAPI спецификация (2112 строк)
- `TECHNICAL_SPECIFICATION.md` — Техническое задание (2236 строк)
- `DEVELOPMENT_GUIDE.md` — Гайд разработчика (2174 строки)
- `user_scenaries.md` — Пользовательские сценарии
- `modules/` — Документация по модулям

---

## Контакты и поддержка

При возникновении вопросов:
1. Проверьте документацию в `docs/`
2. Изучите README в модулях (`*/README.md`)
3. Проверьте код — комментарии присутствуют в ключевых местах

---

**Последнее обновление:** 2025-10-31

