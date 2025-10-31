# Техническое задание: Brix Nutritional App

## 📋 Оглавление

1. [Общая информация](#1-общая-информация)
2. [Технологический стек](#2-технологический-стек)
3. [Архитектура системы](#3-архитектура-системы)
4. [Функциональные требования](#4-функциональные-требования)
5. [Описание модулей](#5-описание-модулей)
6. [API Спецификация](#6-api-спецификация)
7. [База данных](#7-база-данных)
8. [Админ-панель](#8-админ-панель)
9. [Интеграции](#9-интеграции)
10. [Безопасность](#10-безопасность)
11. [Этапы разработки](#11-этапы-разработки)

---

## 1. Общая информация

### 1.1 Описание проекта

**Brix Nutritional App** — мобильное приложение для персонализированного питания, включающее:
- Персональные планы питания
- Дневник питания с AI-анализом
- Расшифровку лабораторных анализов
- AI-консультанта по питанию
- Базу знаний и образовательные курсы
- Систему подписок

### 1.2 Целевая аудитория

- Люди, стремящиеся к здоровому питанию
- Пользователи с конкретными целями (снижение веса, набор массы, ЗОЖ)
- Пользователи с медицинскими показаниями (анализы)
- Возраст: 18-55 лет

### 1.3 Платформы

**Система состоит из трёх основных компонентов:**

- **Mobile App**: iOS 14+, Android 8+ (Flutter 3.24+)
  - Мобильное приложение для конечных пользователей
  - iOS/Android нативные билды
  
- **Admin Web Panel**: Web (Next.js 14+ / React 18)
  - Веб-панель для администраторов и контент-менеджеров
  - Управление пользователями, курсами, рецептами, планами питания
  - Аналитика и статистика
  - Модульная архитектура (admin_modules/)
  
- **Backend API**: REST API (Strapi 4.x + Node.js 18+)
  - Единый backend для Mobile App и Admin Panel
  - PostgreSQL + Redis
  - Кастомные контроллеры и интеграции

---

## 2. Технологический стек

### 2.1 Frontend (Mobile)

```yaml
Фреймворк: Flutter 3.24+
Язык: Dart 3.0+

Основные зависимости:
  # State Management
  - flutter_bloc: ^8.1.0
  - provider: ^6.0.0
  
  # Сеть
  - dio: ^5.4.0
  - http: ^1.2.0
  
  # Локальное хранилище
  - hive: ^2.2.3
  - hive_flutter: ^1.1.0
  - shared_preferences: ^2.2.0
  
  # UI/UX
  - flutter_svg: ^2.0.9
  - cached_network_image: ^3.3.0
  - shimmer: ^3.0.0
  - lottie: ^3.0.0
  
  # Работа с датами
  - intl: ^0.18.1
  
  # Медиа
  - image_picker: ^1.0.7
  - video_player: ^2.8.2
  
  # Push уведомления
  - firebase_messaging: ^14.7.10
  - flutter_local_notifications: ^17.0.0
  
  # Аналитика
  - firebase_analytics: ^10.8.0
  
  # Платежи
  - stripe
  
  # Другое
  - url_launcher: ^6.2.4
  - share_plus: ^7.2.1
  - permission_handler: ^11.2.0
```

### 2.2 Admin Frontend (Web)

```yaml
Фреймворк: Next.js 14+ (App Router)
Язык: TypeScript 5+
UI Framework: React 18

Основные зависимости:
  # UI библиотеки
  - tailwindcss: ^3.3.0
  - @heroicons/react: ^2.0.18
  - lucide-react: ^0.539.0
  
  # Формы
  - react-hook-form: ^7.62.0
  
  # Уведомления
  - react-hot-toast: ^2.5.2
  
  # HTTP клиент
  - fetch API (встроенный)
  
  # TypeScript
  - typescript: ^5.0.0
  - @types/react: ^18.0.0
  - @types/node: ^20.0.0

Модули (admin_modules/):
  - core_module: Layout, API client, общие типы
  - ui_components_module: FileUpload, Modal, Forms, Buttons
  - dashboard_module: Dashboard со статистикой
  - courses_module: Управление курсами
  - lessons_module: Управление уроками
  - categories_module: Управление категориями
  - nutrition_plans_module: Управление планами питания
  - analytics_module: Аналитика и отчеты (в разработке)
```

### 2.3 Backend

**Рекомендуемые варианты:**

#### ⭐ Option A: Fastify + TypeScript + backend_modules (Рекомендуется)

**Готовые модули (backend_modules/) - 13 шт:**
- ✅ **core_module**: Middleware, utils, общие типы
- ✅ **database_module**: PostgreSQL подключение + 27 миграций
- ✅ **auth_module**: JWT, регистрация, верификация email
- ✅ **users_module**: Профили, аватары, настройки
- ✅ **nutrition_module**: Планы питания, продукты, КБЖУ
- ✅ **knowledge_module**: Курсы, уроки, категории
- ✅ **diary_module**: Дневник питания, трекинг воды
- ✅ **lab_module**: Лабораторные анализы, результаты
- ✅ **survey_module**: Опросники, анкеты
- ✅ **ai_chat_module**: OpenAI интеграция, история чатов
- ✅ **subscription_module**: Подписки, платежи
- ✅ **files_module**: Загрузка файлов (изображения, видео)
- ✅ **analytics_module**: Статистика, метрики

**Преимущества:**
- ✅ **~100+ API endpoints** готовы из коробки
- ✅ **27+ миграций БД** включены
- ✅ **~30 таблиц** уже описаны
- ✅ **Полная типизация** TypeScript 5.2+
- ✅ **Высокая производительность** (Fastify в 2-3 раза быстрее Express)
- ✅ **Zod валидация** всех входных данных
- ✅ **JWT аутентификация** из коробки
- ✅ **Модульная архитектура** - легко расширять
- ❌ Требуется создать админку (есть готовые admin_modules)

#### Option B: Strapi 4.x + Node.js 18+ (Альтернатива)
- ✅ Готовая админ-панель из коробки
- ✅ Гибкая система контент-типов
- ✅ REST API и GraphQL
- ✅ Система ролей и прав доступа
- ❌ Требует разработки кастомных контроллеров
- ❌ Менее гибкий для сложной бизнес-логики

**Наша рекомендация: Fastify + backend_modules**
```yaml
Фреймворк: Fastify 4.24+
Language: TypeScript 5.2+
Runtime: Node.js 18+
База данных: PostgreSQL 14+ (pg driver)
Validation: Zod 3.22+
Auth: @fastify/jwt
  
Основные зависимости:
  - fastify: ^4.24.3 (web framework)
  - @fastify/jwt: ^7.2.4 (JWT аутентификация)
  - @fastify/cors: ^8.4.0 (CORS)
  - @fastify/swagger: ^8.12.0 (API документация)
  - @fastify/multipart: ^7.6.0 (загрузка файлов)
  - typescript: ^5.2.2 (типизация)
  - zod: ^3.22.4 (валидация схем)
  - bcryptjs: ^2.4.3 (хеширование паролей)
  - pg: ^8.11.3 (PostgreSQL клиент)
  - openai: ^5.12.0 (AI консультант)
  - resend: ^2.0.0 (email отправка)
  - jsonwebtoken: ^9.0.2 (JWT токены)
```

### 2.4 База данных

```yaml
Основная БД:
  Тип: PostgreSQL 14+
  Назначение: Пользователи, планы, дневники, курсы
  
Кэш:
  Тип: Redis 7+
  Назначение: Сессии, кэш API, rate limiting
  
Хранилище медиа:
  Тип: AWS S3 / Supabase Storage / CloudFlare R2
  Назначение: Изображения, видео, PDF
```

### 2.5 Инфраструктура

```yaml
Контейнеризация: Docker + Docker Compose
CI/CD: GitHub Actions
Hosting (Backend):
  - Production: AWS EC2 / DigitalOcean / Render
  - Development: localhost
  
Monitoring:
  - Sentry (ошибки)
  - LogRocket (логи)
  
CDN: CloudFlare
```

---

## 3. Архитектура системы

### 3.1 Общая схема

```
┌─────────────────────────────────────────────────────────┐
│                    FRONTEND LAYER                       │
│                                                         │
│  ┌──────────────────────┐    ┌──────────────────────┐ │
│  │   Mobile App         │    │   Admin Web Panel    │ │
│  │   (Flutter)          │    │   (Next.js)          │ │
│  │   iOS + Android      │    │   React + TypeScript │ │
│  └──────────┬───────────┘    └──────────┬───────────┘ │
└─────────────┼─────────────────────────────┼────────────┘
              │                             │
              │ HTTPS (REST API)            │ HTTPS (REST API)
              │                             │
              └──────────────┬──────────────┘
                             │
┌────────────────────────────▼─────────────────────────────────┐
│              API Gateway / Backend (Strapi 4.x)              │
│                      (Node.js 18+)                            │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  Auth Service    │  │  User Service    │                 │
│  │  (JWT + SMS)     │  │  (Profile/Admin) │                 │
│  └──────────────────┘  └──────────────────┘                 │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  Diary Service   │  │  Plan Service    │                 │
│  │  (Food logs)     │  │  (Meal Plans)    │                 │
│  └──────────────────┘  └──────────────────┘                 │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  Knowledge       │  │  AI Service      │                 │
│  │  Service         │  │  (OpenAI GPT-4)  │                 │
│  └──────────────────┘  └──────────────────┘                 │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  Lab Tests       │  │  Subscription    │                 │
│  │  Service         │  │  Service (Stripe)│                 │
│  └──────────────────┘  └──────────────────┘                 │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  Blog Service    │  │  Analytics       │                 │
│  │  (Articles)      │  │  Service (Admin) │                 │
│  └──────────────────┘  └──────────────────┘                 │
└───────────────────────────┬───────────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              │                           │
┌─────────────▼──────┐   ┌───────────────▼────┐   ┌──────────┐
│   PostgreSQL 14+   │   │   Redis 7+         │   │   S3     │
│   (Main Database)  │   │   (Cache/Sessions) │   │  (Media) │
└────────────────────┘   └────────────────────┘   └──────────┘
```

**Компоненты системы:**

1. **Mobile App (Flutter)**: 
   - Мобильное приложение для конечных пользователей
   - iOS/Android нативные билды
   - Использует все API endpoints

2. **Admin Web Panel (Next.js)**:
   - Веб-панель для администраторов
   - Управление пользователями, контентом, аналитика
   - Модульная архитектура (admin_modules/)
   - Использует Admin-специфичные endpoints

3. **Backend API (Strapi)**:
   - Единый REST API для всех клиентов
   - Кастомные контроллеры для бизнес-логики
   - Интеграции с внешними сервисами

### 3.2 Архитектура Flutter приложения

```
lib/
├── main.dart
├── app/
│   ├── app.dart (MaterialApp config)
│   └── routes.dart (Navigation)
│
├── dev_modules/ (Существующие модули)
│   ├── core_module/
│   ├── ui_kit_module/
│   ├── auth_module/
│   ├── diary_module/
│   ├── knowledge_module/
│   ├── home_module/
│   ├── plans_module/
│   ├── checkup_module/
│   ├── ai_chat_module/
│   ├── profile_module/
│   ├── subscription_module/
│   ├── onboarding_module/
│   ├── survey_module/
│   └── tab_bar_module/
│
└── features/ (Новые фичи для Brix)
    ├── sms_auth/ (SMS верификация)
    │   ├── screens/
    │   ├── services/
    │   └── widgets/
    │
    ├── meal_plan/ (Рацион)
    │   ├── screens/
    │   ├── services/
    │   ├── models/
    │   └── widgets/
    │
    ├── recipe/ (Рецепты)
    │   ├── screens/
    │   ├── services/
    │   └── widgets/
    │
    ├── blog/ (Блог/Новости)
    │   ├── screens/
    │   ├── services/
    │   └── widgets/
    │
    └── notifications/ (Уведомления)
        ├── screens/
        ├── services/
        └── widgets/
```

### 3.3 Архитектура Admin Web Panel (Next.js)

```
admin/
├── src/
│   ├── app/                          # Next.js 14 App Router
│   │   ├── layout.tsx               # Root layout с авторизацией
│   │   ├── page.tsx                 # Dashboard страница (/)
│   │   ├── globals.css
│   │   │
│   │   ├── login/
│   │   │   └── page.tsx             # Login страница
│   │   │
│   │   ├── users/
│   │   │   ├── page.tsx             # Список пользователей
│   │   │   └── [id]/
│   │   │       └── page.tsx         # Детали пользователя
│   │   │
│   │   ├── courses/
│   │   │   ├── page.tsx             # Список курсов
│   │   │   ├── new/
│   │   │   │   └── page.tsx         # Создание курса
│   │   │   └── [id]/
│   │   │       ├── page.tsx         # Редактирование курса
│   │   │       └── lessons/
│   │   │           └── page.tsx     # Уроки курса
│   │   │
│   │   ├── recipes/
│   │   │   ├── page.tsx             # Список рецептов
│   │   │   ├── new/
│   │   │   │   └── page.tsx         # Создание рецепта
│   │   │   └── [id]/
│   │   │       └── page.tsx         # Редактирование рецепта
│   │   │
│   │   ├── meal-plans/
│   │   │   ├── page.tsx             # Список планов питания
│   │   │   └── [id]/
│   │   │       └── page.tsx         # Редактирование плана
│   │   │
│   │   ├── lab-tests/
│   │   │   └── page.tsx             # Управление типами анализов
│   │   │
│   │   ├── blog/
│   │   │   ├── page.tsx             # Список статей
│   │   │   ├── new/
│   │   │   │   └── page.tsx         # Создание статьи
│   │   │   └── [id]/
│   │   │       └── page.tsx         # Редактирование статьи
│   │   │
│   │   ├── subscriptions/
│   │   │   └── page.tsx             # Управление подписками
│   │   │
│   │   └── analytics/
│   │       └── page.tsx             # Аналитика и отчеты
│   │
│   ├── admin_modules/               # Copied from /admin_modules
│   │   ├── core_module/
│   │   │   ├── api/
│   │   │   │   └── apiClient.ts    # API клиент для Strapi
│   │   │   ├── components/
│   │   │   │   └── Layout.tsx      # Layout компонент
│   │   │   └── types/
│   │   │       └── index.ts        # Общие TypeScript типы
│   │   │
│   │   ├── ui_components_module/
│   │   │   └── components/
│   │   │       ├── FileUpload.tsx  # Загрузка файлов
│   │   │       ├── Modal.tsx
│   │   │       ├── Forms.tsx
│   │   │       └── Buttons.tsx
│   │   │
│   │   ├── dashboard_module/
│   │   │   └── components/
│   │   │       └── DashboardPage.tsx
│   │   │
│   │   ├── courses_module/
│   │   │   ├── pages/
│   │   │   ├── components/
│   │   │   └── api/
│   │   │
│   │   ├── lessons_module/
│   │   ├── categories_module/
│   │   ├── nutrition_plans_module/
│   │   ├── analytics_module/
│   │   ├── recipes_module/         # Новый модуль для Brix
│   │   ├── lab_tests_module/       # Новый модуль для Brix
│   │   ├── blog_module/            # Новый модуль для Brix
│   │   ├── users_module/           # Новый модуль для Brix
│   │   └── subscriptions_module/   # Новый модуль для Brix
│   │
│   ├── components/                  # Custom компоненты
│   │   ├── Sidebar.tsx             # Боковое меню
│   │   ├── Header.tsx              # Шапка админки
│   │   ├── UserMenu.tsx
│   │   └── ...
│   │
│   └── lib/                         # Утилиты
│       ├── api.ts                   # Обертка над apiClient
│       ├── utils.ts
│       └── hooks/
│           ├── useApiData.ts       # Custom hooks
│           └── useAuth.ts
│
├── public/
│   └── images/
│
├── .env.local
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

**Ключевые особенности:**

1. **Модульная архитектура**: 
   - Максимум кода переиспользуется из `admin_modules/`
   - Новые модули создаются по той же структуре

2. **Next.js App Router**:
   - File-based routing
   - Server Components + Client Components
   - Параллельные запросы данных

3. **TypeScript Strict Mode**:
   - Полная типизация всех компонентов
   - Generic функции для API calls
   - Интерфейсы для всех данных

4. **API Integration**:
   - Единый API клиент для Strapi
   - Централизованная обработка ошибок
   - Кэширование запросов

---

## 4. Функциональные требования

### 4.1 Авторизация и регистрация

#### 4.1.1 Вход по Email (Сценарий 1)

**Поток:**
1. Пользователь вводит Email
2. Система отправляет 4-значный SMS-код (симуляция, т.к. Email)
3. Пользователь вводит код
4. Система проверяет код
5. **Если новый пользователь**: → Создание пароля → Мини-опрос
6. **Если существующий**: → Главный экран

**API:**
```typescript
POST /api/auth/email/send-code
Body: { email: string }
Response: { success: boolean, message: string }

POST /api/auth/email/verify-code
Body: { email: string, code: string }
Response: { 
  success: boolean, 
  isNewUser: boolean,
  token?: string,
  user?: User 
}

POST /api/auth/email/set-password (только для новых)
Body: { email: string, password: string }
Response: { success: boolean, token: string, user: User }
```

#### 4.1.2 Вход по Телефону (Сценарий 2)

**Поток:**
1. Пользователь вводит номер телефона (+7 909 078 67 65)
2. Система отправляет 4-значный SMS-код (через Twilio/SMS.ru)
3. Пользователь вводит код
4. Система проверяет код
5. **Если новый пользователь**: → Мини-опрос (пароль НЕ нужен)
6. **Если существующий**: → Главный экран

**API:**
```typescript
POST /api/auth/phone/send-code
Body: { phone: string }
Response: { success: boolean, message: string }

POST /api/auth/phone/verify-code
Body: { phone: string, code: string }
Response: { 
  success: boolean, 
  isNewUser: boolean,
  token: string,
  user?: User 
}
```

#### 4.1.3 Создание пароля (Сценарий 4)

**Применимо только для Email**

**Валидация:**
- Минимум 8 символов
- Содержит a-z, A-Z, 0-9
- Пароли должны совпадать

#### 4.1.4 Мини-опрос (Сценарий 5)

**Шаги:**
1. **Шаг 1**: Цель (Снижение веса, Набор массы, Поддержание, ЗОЖ)
2. **Шаг 2**: Имя
3. **Шаг 3**: Дата рождения

**API:**
```typescript
POST /api/onboarding/complete
Body: { 
  goal: string,
  name: string,
  birthDate: string 
}
Response: { success: boolean }
```

### 4.2 Главный экран (Сценарий 6)

**Компоненты:**
- Приветствие (Привет, {Имя}!)
- План питания на неделю (прогресс %)
- Инструменты (Дневник, Рацион, AI-чат, Анализы)
- Блог/Новости (последние 3 статьи)
- Мои подписки (статус, дата продления)
- Уведомления (иконка колокольчика)

**API:**
```typescript
GET /api/home/dashboard
Response: {
  user: { name, avatar },
  currentPlan: { name, progress },
  tools: [...],
  blog: [{ id, title, preview, imageUrl }],
  subscription: { status, nextBilling },
  unreadNotifications: number
}
```

### 4.3 Блог и контент (Сценарий 7)

**API:**
```typescript
GET /api/blog/articles
Query: ?page=1&limit=10
Response: { articles: Article[], total: number }

GET /api/blog/article/:id
Response: { article: Article }
```

**Модель Article:**
```typescript
{
  id: string,
  title: string,
  content: string (Markdown),
  imageUrl: string,
  author: string,
  publishedAt: Date,
  category: string
}
```

### 4.4 Уведомления (Сценарий 8)

**API:**
```typescript
GET /api/notifications
Response: { notifications: Notification[] }

PATCH /api/notifications/:id/read
Response: { success: boolean }

DELETE /api/notifications/:id
Response: { success: boolean }
```

**Модель Notification:**
```typescript
{
  id: string,
  title: string,
  message: string,
  type: 'info' | 'reminder' | 'alert',
  isRead: boolean,
  createdAt: Date,
  action?: { type: string, target: string }
}
```

### 4.5 Рацион питания (Сценарий 9)

#### 4.5.1 Структура

**Приемы пищи:**
- Пробуждение (Вода)
- Завтрак
- Перекус
- Обед
- Полдник
- Ужин
- Отход ко сну

**API:**
```typescript
GET /api/meal-plan/current
Response: {
  planName: string,
  description: string,
  meals: MealSlot[],
  supplements: Supplement[]
}

GET /api/meal-plan/day/:date
Response: { meals: MealSlot[] }
```

**Модель MealSlot:**
```typescript
{
  id: string,
  type: 'wakeup' | 'breakfast' | 'snack' | 'lunch' | 'dinner' | 'sleep',
  time: string,
  recipe: Recipe,
  portion: number (граммы),
  calories: number,
  importance?: string (для инфо)
}
```

#### 4.5.2 Рецепты

**API:**
```typescript
GET /api/recipes/:id
Response: {
  id: string,
  name: string,
  description: string,
  imageUrl: string,
  prepTime: number (минуты),
  calories: number,
  ingredients: Ingredient[],
  steps: string[],
  tags: string[]
}
```

#### 4.5.3 Замена блюда

**API:**
```typescript
GET /api/recipes/:id/alternatives
Response: { alternatives: Recipe[] }

POST /api/meal-plan/replace
Body: { 
  mealSlotId: string, 
  newRecipeId: string 
}
Response: { success: boolean, updatedMeal: MealSlot }
```

### 4.6 Дневник питания (Сценарий 11)

**Используется существующий `diary_module`**

**Расширенные требования:**

#### 4.6.1 Добавление приема пищи

**Режимы:**
- Из рациона (быстрое добавление)
- Поиск блюда (БД продуктов)
- Свое блюдо (ручной ввод)

**API:**
```typescript
POST /api/diary/meal
Body: {
  mealName: string,
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack',
  consumedAt: Date,
  portionGrams: number,
  calories?: number,
  photo?: File,
  fromPlan?: boolean (из рациона)
}
Response: { meal: MealEntry }
```

#### 4.6.2 Вода

**Интерфейс:**
- Текущий объем / Цель (мл)
- Кнопки: +100мл, +200мл, +250мл, -100мл
- Прогресс-бар

**API:**
```typescript
POST /api/diary/water
Body: { date: Date, increment: number (мл) }
Response: { waterLog: WaterLog }
```

#### 4.6.3 Настроение

- 5 звезд
- Сохраняется на день

#### 4.6.4 Навигация по датам

- Стрелки ← →
- Календарь (modal)
- Возможность ввода задним числом

### 4.7 AI-консультант (Сценарий 10)

**Типы запросов:**
1. Персональный план (на основе анкеты)
2. Анализ дневника (контекст из БД)
3. Вопросы по питанию
4. Интерпретация анализов

**API:**
```typescript
POST /api/ai/chat/message
Body: {
  chatId?: string (если продолжение),
  message: string,
  context?: {
    includeDiary: boolean,
    includeLabTests: boolean,
    includePlan: boolean
  }
}
Response: {
  chatId: string,
  messageId: string,
  response: string,
  sources?: string[] (ссылки на контекст)
}

GET /api/ai/chat/history
Response: { chats: Chat[] }

DELETE /api/ai/chat/:id
Response: { success: boolean }
```

**Backend интеграция:**
```typescript
// OpenAI GPT-4 + RAG (Retrieval-Augmented Generation)
// Контекст:
// - Анкета пользователя (цель, возраст, пол)
// - Дневник за N дней
// - Анализы (если загружены)
// - Текущий план питания
```

### 4.8 Расшифровка анализов (Сценарий 12)

**Структура:**

**Разделы:**
- Клинический анализ крови
- Биохимия крови
- Гормоны
- Витамины и минералы
- Другие показатели

**API:**
```typescript
POST /api/lab-tests/upload
Body: { 
  testType: string,
  results: LabResult[]
}
Response: { testId: string }

GET /api/lab-tests/my
Response: { tests: LabTest[] }

GET /api/lab-tests/interpretation/:testId
Response: {
  test: LabTest,
  interpretations: Interpretation[]
}
```

**Модель LabResult:**
```typescript
{
  parameterId: string (например, 'HGB'),
  value: number,
  unit: string ('г/л', 'мг/дл'),
  date: Date
}
```

**Модель Interpretation:**
```typescript
{
  parameterId: string,
  parameterName: string,
  userValue: number,
  referenceRange: { min: number, max: number, unit: string },
  status: 'normal' | 'low' | 'high',
  description: string,
  causes?: { low?: string[], high?: string[] },
  recommendations?: string[]
}
```

**Справочник показателей:**
- Хранится в БД
- Создается через админ-панель
- Включает референсные значения по полу/возрасту
- Интерпретации повышения/понижения

### 4.9 База знаний (Сценарий 13)

**Используется существующий `knowledge_module` + расширения**

**Структура:**
- Курсы (платные/бесплатные)
- Уроки (видео/текст/аудио)
- Марафоны
- Материалы для скачивания

**API:**
```typescript
GET /api/courses
Query: ?category=all|free|paid
Response: { courses: Course[] }

GET /api/courses/:id
Response: { course: Course, lessons: Lesson[] }

GET /api/lessons/:id
Response: { lesson: Lesson }

POST /api/lessons/:id/complete
Response: { success: boolean, progress: number }

GET /api/courses/:id/progress
Response: { 
  completedLessons: number,
  totalLessons: number,
  progress: number (%)
}
```

**Модель Course:**
```typescript
{
  id: string,
  title: string,
  description: string,
  imageUrl: string,
  author: string,
  isPaid: boolean,
  price?: number,
  duration: string,
  lessonsCount: number,
  category: string
}
```

**Модель Lesson:**
```typescript
{
  id: string,
  courseId: string,
  title: string,
  description: string,
  order: number,
  type: 'video' | 'text' | 'audio',
  content: string (URL для видео/аудио, Markdown для текста),
  duration?: number (минуты),
  materials?: { name: string, url: string }[]
}
```

### 4.10 Подписки (Subscription)

**Используется существующий `subscription_module`**

**Тарифы:**
- Базовый (бесплатный)
- Премиум (месяц/год)
- Эксклюзив (полный доступ)

**API:**
```typescript
GET /api/subscriptions/plans
Response: { plans: SubscriptionPlan[] }

POST /api/subscriptions/subscribe
Body: { planId: string, paymentMethod: string }
Response: { subscriptionId: string, paymentUrl?: string }

GET /api/subscriptions/my
Response: { subscription: Subscription }

POST /api/subscriptions/cancel
Response: { success: boolean }
```

---

## 5. Описание модулей

### 5.1 Существующие модули (используются)

| Модуль | Назначение | Адаптация для Brix |
|--------|------------|---------------------|
| `core_module` | API сервис, токены, тема | Без изменений |
| `ui_kit_module` | UI компоненты | Адаптация цветов |
| `auth_module` | Email/Password авторизация | **Частично**: добавить SMS auth |
| `diary_module` | Дневник питания | **Расширение**: добавить связь с рационом |
| `knowledge_module` | Курсы | **Расширение**: добавить материалы |
| `home_module` | Главный экран | **Переделка** под дизайн Brix |
| `plans_module` | Планы питания | **Расширение**: рецепты, замены |
| `checkup_module` | Анализы | **Расширение**: интерпретации |
| `ai_chat_module` | AI чат | **Расширение**: контекст из БД |
| `profile_module` | Профиль | Без изменений |
| `subscription_module` | Подписки | Без изменений |
| `onboarding_module` | Онбординг | **Изменение** под опрос Brix |
| `tab_bar_module` | Навигация | Без изменений |

### 5.2 Новые модули (создать)

#### 5.2.1 `sms_auth_module`

**Цель**: SMS верификация для телефона и email

**Файлы:**
```
sms_auth_module/
├── services/
│   └── sms_service.dart
├── screens/
│   ├── phone_input_screen.dart
│   └── sms_verification_screen.dart
└── widgets/
    └── code_input_widget.dart
```

**Методы:**
```dart
class SmsService {
  static Future<bool> sendCodeToPhone(String phone);
  static Future<bool> sendCodeToEmail(String email);
  static Future<Map<String, dynamic>> verifyCode({
    required String identifier, // phone или email
    required String code
  });
}
```

#### 5.2.2 `recipe_module`

**Цель**: Рецепты и замены блюд

**Файлы:**
```
recipe_module/
├── services/
│   └── recipe_service.dart
├── models/
│   ├── recipe_model.dart
│   └── ingredient_model.dart
├── screens/
│   ├── recipe_detail_screen.dart
│   └── recipe_alternatives_screen.dart
└── widgets/
    ├── recipe_card.dart
    └── ingredient_list.dart
```

#### 5.2.3 `blog_module`

**Цель**: Блог и новости

**Файлы:**
```
blog_module/
├── services/
│   └── blog_service.dart
├── models/
│   └── article_model.dart
├── screens/
│   ├── blog_list_screen.dart
│   └── article_detail_screen.dart
└── widgets/
    └── article_card.dart
```

#### 5.2.4 `notifications_module`

**Цель**: Системные уведомления

**Файлы:**
```
notifications_module/
├── services/
│   ├── notification_service.dart
│   └── push_notification_service.dart
├── models/
│   └── notification_model.dart
├── screens/
│   └── notifications_screen.dart
└── widgets/
    └── notification_card.dart
```

---

## 6. API Спецификация

### 6.1 Базовый URL

```
Development: http://localhost:1337/api
Production: https://api.brix-nutrition.com/api
```

### 6.2 Аутентификация

**Все защищенные endpoints требуют JWT токен:**

```
Authorization: Bearer <token>
```

### 6.3 Эндпоинты

#### 6.3.1 Auth

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/auth/email/send-code` | Отправить код на email |
| POST | `/auth/email/verify-code` | Проверить код email |
| POST | `/auth/email/set-password` | Установить пароль (новый юзер) |
| POST | `/auth/phone/send-code` | Отправить SMS код |
| POST | `/auth/phone/verify-code` | Проверить SMS код |
| POST | `/auth/logout` | Выход |
| POST | `/auth/refresh` | Обновить токен |

#### 6.3.2 User

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/users/me` | Получить профиль |
| PUT | `/users/me` | Обновить профиль |
| DELETE | `/users/me` | Удалить аккаунт |

#### 6.3.3 Onboarding

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/onboarding/complete` | Завершить опрос |

#### 6.3.4 Home

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/home/dashboard` | Главный экран |

#### 6.3.5 Blog

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/blog/articles` | Список статей |
| GET | `/blog/articles/:id` | Статья |

#### 6.3.6 Notifications

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/notifications` | Список уведомлений |
| PATCH | `/notifications/:id/read` | Отметить прочитанным |
| DELETE | `/notifications/:id` | Удалить |

#### 6.3.7 Meal Plan

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/meal-plan/current` | Текущий план |
| GET | `/meal-plan/day/:date` | План на день |
| POST | `/meal-plan/replace` | Заменить блюдо |

#### 6.3.8 Recipes

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/recipes/:id` | Рецепт |
| GET | `/recipes/:id/alternatives` | Альтернативы |
| GET | `/recipes/search` | Поиск рецептов |

#### 6.3.9 Diary

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/diary/day/:date` | Дневник за день |
| POST | `/diary/meal` | Добавить прием пищи |
| DELETE | `/diary/meal/:id` | Удалить прием |
| POST | `/diary/water` | Обновить воду |
| PUT | `/diary/mood` | Обновить настроение |
| PUT | `/diary/day-status` | Завершить день |

#### 6.3.10 AI Chat

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/ai/chat/message` | Отправить сообщение |
| GET | `/ai/chat/history` | История чатов |
| GET | `/ai/chat/:id/messages` | Сообщения чата |
| DELETE | `/ai/chat/:id` | Удалить чат |

#### 6.3.11 Lab Tests

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/lab-tests/upload` | Загрузить результаты |
| GET | `/lab-tests/my` | Мои анализы |
| GET | `/lab-tests/:id` | Детали анализа |
| GET | `/lab-tests/interpretation/:id` | Интерпретация |
| GET | `/lab-tests/parameters` | Справочник показателей |

#### 6.3.12 Courses

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/courses` | Список курсов |
| GET | `/courses/:id` | Курс |
| GET | `/courses/:id/lessons` | Уроки курса |
| GET | `/lessons/:id` | Урок |
| POST | `/lessons/:id/complete` | Отметить просмотренным |
| GET | `/courses/:id/progress` | Прогресс |

#### 6.3.13 Subscriptions

| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/subscriptions/plans` | Тарифы |
| POST | `/subscriptions/subscribe` | Оформить подписку |
| GET | `/subscriptions/my` | Моя подписка |
| POST | `/subscriptions/cancel` | Отменить |

---

## 7. База данных

### 7.1 Схема (PostgreSQL)

#### 7.1.1 Таблица: users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20) UNIQUE,
  password_hash VARCHAR(255), -- NULL для phone-only auth
  birth_date DATE,
  gender VARCHAR(10),
  goal VARCHAR(50), -- 'weight_loss', 'weight_gain', 'maintenance', 'health'
  avatar_url TEXT,
  email_verified BOOLEAN DEFAULT FALSE,
  phone_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.2 Таблица: verification_codes

```sql
CREATE TABLE verification_codes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  identifier VARCHAR(255), -- email или phone
  code VARCHAR(6),
  type VARCHAR(10), -- 'email' | 'phone'
  expires_at TIMESTAMP,
  is_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_verification_codes_identifier ON verification_codes(identifier);
```

#### 7.1.3 Таблица: meal_plans

```sql
CREATE TABLE meal_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  description TEXT,
  type VARCHAR(50), -- 'mediterranean', 'low_carb', etc.
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.4 Таблица: recipes

```sql
CREATE TABLE recipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255),
  description TEXT,
  image_url TEXT,
  prep_time INT, -- минуты
  calories INT,
  protein DECIMAL(5,2),
  carbs DECIMAL(5,2),
  fats DECIMAL(5,2),
  instructions JSONB, -- ['step1', 'step2']
  ingredients JSONB, -- [{ name, amount, unit }]
  tags TEXT[], -- ['breakfast', 'vegan']
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.5 Таблица: user_meal_plans

```sql
CREATE TABLE user_meal_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  meal_plan_id UUID REFERENCES meal_plans(id),
  start_date DATE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.6 Таблица: meal_plan_days

```sql
CREATE TABLE meal_plan_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  meal_plan_id UUID REFERENCES meal_plans(id) ON DELETE CASCADE,
  day_number INT, -- 1-7 (неделя) или больше
  meals JSONB -- [{ type, recipeId, time, portion }]
);
```

#### 7.1.7 Таблица: diary_days

```sql
CREATE TABLE diary_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE,
  mood_rating INT CHECK (mood_rating >= 1 AND mood_rating <= 5),
  is_completed BOOLEAN DEFAULT FALSE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, date)
);
```

#### 7.1.8 Таблица: diary_meals

```sql
CREATE TABLE diary_meals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  diary_day_id UUID REFERENCES diary_days(id) ON DELETE CASCADE,
  meal_name VARCHAR(255),
  meal_type VARCHAR(20), -- 'breakfast', 'lunch', 'dinner', 'snack'
  consumed_at TIMESTAMP,
  portion_grams INT,
  calories INT,
  photo_url TEXT,
  from_plan BOOLEAN DEFAULT FALSE,
  recipe_id UUID REFERENCES recipes(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.9 Таблица: diary_water

```sql
CREATE TABLE diary_water (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE,
  total_amount INT, -- мл
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, date)
);
```

#### 7.1.10 Таблица: lab_tests

```sql
CREATE TABLE lab_tests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  test_type VARCHAR(100), -- 'blood_general', 'biochemistry'
  test_date DATE,
  results JSONB, -- [{ parameterId, value, unit }]
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.11 Таблица: lab_parameters

```sql
CREATE TABLE lab_parameters (
  id VARCHAR(50) PRIMARY KEY, -- 'HGB', 'RBC', etc.
  name VARCHAR(255),
  category VARCHAR(100), -- 'Клинический анализ крови'
  units TEXT[], -- ['г/л', 'мг/дл']
  reference_ranges JSONB, -- [{ gender, ageMin, ageMax, min, max, unit }]
  description TEXT,
  low_causes JSONB, -- ['причина1', 'причина2']
  high_causes JSONB,
  recommendations TEXT
);
```

#### 7.1.12 Таблица: courses

```sql
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255),
  description TEXT,
  image_url TEXT,
  author VARCHAR(255),
  is_paid BOOLEAN DEFAULT FALSE,
  price DECIMAL(10,2),
  duration VARCHAR(50), -- '4 weeks'
  category VARCHAR(100),
  order_index INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.13 Таблица: lessons

```sql
CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  title VARCHAR(255),
  description TEXT,
  order_index INT,
  type VARCHAR(20), -- 'video', 'text', 'audio'
  content TEXT, -- URL или Markdown
  duration INT, -- минуты
  materials JSONB, -- [{ name, url }]
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.14 Таблица: user_lesson_progress

```sql
CREATE TABLE user_lesson_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP,
  UNIQUE(user_id, lesson_id)
);
```

#### 7.1.15 Таблица: ai_chats

```sql
CREATE TABLE ai_chats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.16 Таблица: ai_messages

```sql
CREATE TABLE ai_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chat_id UUID REFERENCES ai_chats(id) ON DELETE CASCADE,
  role VARCHAR(20), -- 'user' | 'assistant'
  content TEXT,
  context_used JSONB, -- { diary: true, labTests: false }
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.17 Таблица: blog_articles

```sql
CREATE TABLE blog_articles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255),
  slug VARCHAR(255) UNIQUE,
  content TEXT, -- Markdown
  preview TEXT,
  image_url TEXT,
  author VARCHAR(255),
  category VARCHAR(100),
  published_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.18 Таблица: notifications

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255),
  message TEXT,
  type VARCHAR(20), -- 'info', 'reminder', 'alert'
  is_read BOOLEAN DEFAULT FALSE,
  action JSONB, -- { type: 'navigate', target: '/profile' }
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 7.1.19 Таблица: subscriptions

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan_id UUID,
  plan_name VARCHAR(100),
  status VARCHAR(20), -- 'active', 'cancelled', 'expired'
  start_date DATE,
  end_date DATE,
  next_billing_date DATE,
  payment_provider VARCHAR(50), -- 'stripe', 'apple', 'google'
  external_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7.2 Индексы

```sql
-- Performance indexes
CREATE INDEX idx_diary_days_user_date ON diary_days(user_id, date);
CREATE INDEX idx_diary_meals_day ON diary_meals(diary_day_id);
CREATE INDEX idx_lab_tests_user ON lab_tests(user_id);
CREATE INDEX idx_ai_messages_chat ON ai_messages(chat_id);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read);
CREATE INDEX idx_subscriptions_user_status ON subscriptions(user_id, status);
```

---

## 8. Админ-панель (Admin Web Panel)

### 8.1 Общая информация

**Технологический стек:**
- **Фреймворк**: Next.js 14+ (App Router)
- **Язык**: TypeScript 5+
- **UI**: React 18, Tailwind CSS 3.3
- **Модули**: admin_modules/ (готовая модульная система)

**Компоненты:**
- ✅ **7 готовых модулей** из admin_modules/
- ⏳ **5 новых модулей** для специфичных функций Brix
- ✅ Модульная архитектура для переиспользования
- ✅ API клиент для Strapi backend
- ✅ TypeScript Strict Mode
- ✅ Responsive дизайн

### 8.2 Существующие модули (admin_modules/)

#### 8.2.1 core_module ⭐
**Статус**: ✅ Готов, требует адаптации API клиента

**Что включает:**
- `Layout.tsx` - главный layout админки
- `apiClient.ts` - API клиент (нужно адаптировать под Strapi)
- `types/index.ts` - общие TypeScript типы

**Задачи:**
- Обновить apiClient для Strapi endpoints
- Настроить JWT авторизацию
- Добавить error handling

#### 8.2.2 ui_components_module 🎨
**Статус**: ✅ Готов, используется без изменений

**Что включает:**
- FileUpload компонент (изображения, видео, документы)
- Modal компоненты
- Form компоненты (Input, Select, Textarea)
- Button компоненты

#### 8.2.3 dashboard_module 🏠
**Статус**: ✅ Готов, требует адаптации метрик

**Что включает:**
- Dashboard страница со статистикой
- Виджеты метрик
- Быстрые действия

**Задачи:**
- Интегрировать метрики Brix (пользователи, рецепты, планы)
- Добавить графики (если нужно)

#### 8.2.4 courses_module 📚
**Статус**: ✅ Готов, интегрировать с Strapi

**Что включает:**
- Список курсов
- Создание/редактирование курса
- Управление модулями курса
- Удаление/деактивация

**Задачи:**
- Подключить к Strapi `/api/courses`
- Тестировать CRUD операции

#### 8.2.5 lessons_module 📝
**Статус**: ✅ Готов, интегрировать с Strapi

**Что включает:**
- Список уроков
- Создание/редактирование урока
- Фильтрация по типам (видео, текст, аудио)
- Управление типами уроков

**Задачи:**
- Подключить к Strapi `/api/lessons`

#### 8.2.6 categories_module 🏷️
**Статус**: ✅ Готов, используется без изменений

**Что включает:**
- CRUD категорий
- Цветовая индикация
- Сортировка

**Задачи:**
- Подключить к Strapi `/api/categories`

#### 8.2.7 nutrition_plans_module 🍽️
**Статус**: ✅ Готов, адаптировать под Brix

**Что включает:**
- Список планов питания
- Создание/редактирование плана
- Управление продуктами
- Управление приемами пищи

**Задачи:**
- Адаптировать под схему Brix MealPlan
- Интегрировать с рецептами

#### 8.2.8 analytics_module 📊
**Статус**: ⏳ В разработке

**Что нужно добавить:**
- Статистика пользователей
- Активность по модулям
- Популярные курсы/рецепты
- Конверсия подписок

### 8.3 Новые модули для Brix

#### 8.3.1 recipes_module 🥗
**Статус**: 🆕 Создать новый модуль

**Функционал:**
- ✅ Список рецептов с фильтрами
- ✅ Создание рецепта (название, описание, фото)
- ✅ Добавление ингредиентов
- ✅ Пошаговые инструкции
- ✅ БЖУ и калорийность
- ✅ Теги и категории
- ✅ Альтернативы рецептов

#### 8.3.2 lab_tests_module 🧪
**Статус**: 🆕 Создать новый модуль

**Функционал:**
- ✅ Справочник показателей (Глюкоза, Холестерин и т.д.)
- ✅ Референсные значения (мин/макс)
- ✅ Интерпретации (норма, повышение, понижение)
- ✅ Причины отклонений
- ✅ Рекомендации по питанию

#### 8.3.3 blog_module 📰
**Статус**: 🆕 Создать новый модуль

**Функционал:**
- ✅ Список статей
- ✅ Создание статьи (WYSIWYG редактор)
- ✅ Загрузка изображений
- ✅ Категории
- ✅ Теги
- ✅ Планирование публикаций (draft/published)

#### 8.3.4 users_module 👥
**Статус**: 🆕 Создать новый модуль

**Функционал:**
- ✅ Список пользователей с пагинацией
- ✅ Фильтрация (по подписке, статусу, датам)
- ✅ Детали профиля пользователя
- ✅ История активности
- ✅ Блокировка/разблокировка
- ✅ Статистика активности

#### 8.3.5 subscriptions_module 💳
**Статус**: 🆕 Создать новый модуль

**Функционал:**
- ✅ Список тарифов (CRUD)
- ✅ Настройка цен
- ✅ Список активных подписок
- ✅ Фильтрация (активные, отмененные, истекшие)
- ✅ Отчеты по выручке
- ✅ Экспорт данных

### 8.4 Роли и права доступа

| Роль | Описание | Доступ | Модули |
|------|----------|--------|--------|
| **Super Admin** | Полный доступ ко всем функциям | Все | Все модули |
| **Content Manager** | Управление контентом | Курсы, уроки, рецепты, планы, блог | courses, lessons, recipes, nutrition_plans, blog |
| **Nutritionist** | Планы питания и анализы | Рецепты, планы, анализы | recipes, nutrition_plans, lab_tests |
| **Support** | Поддержка пользователей | Пользователи, подписки, уведомления | users, subscriptions |
| **Analyst** | Аналитика и отчеты | Статистика, отчеты | analytics, dashboard |

### 8.5 Интеграция с Strapi API

**Аутентификация:**
```typescript
// Admin login
POST /admin/login
Body: { email, password }
Response: { jwt, user }

// Использование JWT
Authorization: Bearer <admin-jwt>
```

**Основные endpoints:**
```typescript
// Dashboard stats
GET /api/admin/stats

// Users
GET /api/admin/users?page=1&limit=20
POST /api/admin/users/{id}/block
POST /api/admin/users/{id}/unblock

// Recipes (CRUD)
GET /api/recipes?populate=*
GET /api/recipes/:id
POST /api/recipes
PUT /api/recipes/:id
DELETE /api/recipes/:id

// Courses (CRUD)
GET /api/courses?populate=*
POST /api/courses
...

// Lab Tests
GET /api/lab-test-markers
POST /api/lab-test-markers
...
```

### 8.6 Развертывание Admin Web Panel

**Vercel (рекомендуется):**
```bash
cd admin
vercel --prod
```

**Или Docker:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

**Environment Variables:**
```bash
NEXT_PUBLIC_API_URL=https://api.brix-nutrition.com/api
ADMIN_API_TOKEN=<strapi-admin-token>
```

---

## 9. Интеграции

### 9.1 SMS Provider (Twilio / SMS.ru)

**Цель:** Отправка SMS-кодов для верификации

**Twilio (рекомендуется):**
```typescript
import twilio from 'twilio';

const client = twilio(accountSid, authToken);

async function sendSMS(phone: string, code: string) {
  await client.messages.create({
    body: `Ваш код: ${code}`,
    from: '+1234567890', // Twilio number
    to: phone
  });
}
```

**SMS.ru (для РФ):**
```typescript
import axios from 'axios';

async function sendSMS(phone: string, code: string) {
  await axios.get('https://sms.ru/sms/send', {
    params: {
      api_id: 'YOUR_API_ID',
      to: phone,
      msg: `Ваш код: ${code}`,
      json: 1
    }
  });
}
```

### 9.2 Email Provider (SendGrid / Mailgun)

**Цель:** Отправка email-кодов и уведомлений

**Nodemailer + Gmail:**
```typescript
import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

async function sendEmail(to: string, code: string) {
  await transporter.sendMail({
    from: '"Brix Nutrition" <noreply@brix-nutrition.com>',
    to: to,
    subject: 'Код верификации',
    html: `<p>Ваш код: <strong>${code}</strong></p>`
  });
}
```

### 9.3 OpenAI API (AI Консультант)

**Интеграция GPT-4:**

```typescript
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

async function getAIResponse(
  message: string, 
  context: {
    userProfile: User,
    diary?: DiaryDay[],
    labTests?: LabTest[]
  }
) {
  const systemPrompt = `
    Ты — AI-консультант по питанию для приложения Brix Nutrition.
    Пользователь: ${context.userProfile.name}, ${context.userProfile.age} лет
    Цель: ${context.userProfile.goal}
    
    ${context.diary ? `Дневник за последние 7 дней: ${JSON.stringify(context.diary)}` : ''}
    ${context.labTests ? `Анализы: ${JSON.stringify(context.labTests)}` : ''}
  `;

  const response = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: message }
    ],
    temperature: 0.7,
    max_tokens: 1000
  });

  return response.choices[0].message.content;
}
```

### 9.4 Payment Provider (Stripe / Paddle)

**Stripe (рекомендуется):**

```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

async function createSubscription(
  userId: string, 
  priceId: string, 
  customerId: string
) {
  const subscription = await stripe.subscriptions.create({
    customer: customerId,
    items: [{ price: priceId }],
    payment_behavior: 'default_incomplete',
    payment_settings: { 
      save_default_payment_method: 'on_subscription' 
    },
    expand: ['latest_invoice.payment_intent']
  });

  return subscription;
}
```

### 9.5 Media Storage (AWS S3 / Supabase Storage)

**AWS S3:**

```typescript
import AWS from 'aws-sdk';

const s3 = new AWS.S3({
  accessKeyId: process.env.AWS_ACCESS_KEY,
  secretAccessKey: process.env.AWS_SECRET_KEY,
  region: process.env.AWS_REGION
});

async function uploadImage(file: Buffer, filename: string) {
  const params = {
    Bucket: 'brix-nutrition',
    Key: `uploads/${filename}`,
    Body: file,
    ContentType: 'image/jpeg',
    ACL: 'public-read'
  };

  const result = await s3.upload(params).promise();
  return result.Location; // URL
}
```

### 9.6 Push Notifications (Firebase Cloud Messaging)

**Flutter integration:**

```yaml
dependencies:
  firebase_messaging: ^14.7.10
  firebase_core: ^2.24.2
```

**Backend (Node.js):**

```typescript
import admin from 'firebase-admin';

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function sendPushNotification(
  token: string, 
  title: string, 
  body: string
) {
  await admin.messaging().send({
    token: token,
    notification: { title, body },
    data: { route: '/notifications' }
  });
}
```

---

## 10. Безопасность

### 10.1 Аутентификация

**JWT токены:**
- Access Token (15 минут)
- Refresh Token (30 дней)

**Хранение:**
- Flutter: `flutter_secure_storage`
- Backend: Redis (для Refresh Tokens)

### 10.2 Валидация

**Backend:**
- Joi / Zod для валидации входных данных
- Sanitize HTML в контенте

**Flutter:**
- Валидация форм
- Regex для email/phone

### 10.3 Rate Limiting

```typescript
// Express rate limit
import rateLimit from 'express-rate-limit';

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 минут
  max: 5, // 5 попыток
  message: 'Слишком много попыток, попробуйте позже'
});

app.post('/api/auth/login', authLimiter, loginHandler);
```

### 10.4 Защита данных

- **Пароли**: bcrypt (salt rounds: 12)
- **Sensitive data**: Шифрование в БД (PGCrypto)
- **HTTPS**: Обязательно в production
- **CORS**: Настроенный whitelist

---

## 11. Этапы разработки

### Этап 1: Инфраструктура и Backend (4 недели)

**Неделя 1-2: Настройка окружения**
- ✅ Setup Strapi 4.x + PostgreSQL
- ✅ Setup Redis
- ✅ Setup S3 (или альтернатива)
- ✅ Docker Compose для dev
- ✅ CI/CD (GitHub Actions)

**Неделя 3-4: Core API**
- ✅ Auth endpoints (email/phone + SMS)
- ✅ User management
- ✅ JWT + Refresh Token
- ✅ Roles & Permissions

### Этап 2: Контент-типы и Админка (3 недели)

**Неделя 5-6: Content Types**
- ✅ Recipes (Strapi Collection)
- ✅ Meal Plans
- ✅ Courses & Lessons
- ✅ Lab Parameters
- ✅ Blog Articles

**Неделя 7: Админ-панель**
- ✅ Настройка Strapi Admin
- ✅ Custom fields
- ✅ Роли контент-менеджеров

### Этап 3: Основные API (4 недели)

**Неделя 8-9: User-facing API**
- ✅ Diary API (meals, water, mood)
- ✅ Meal Plan API (current, day, replace)
- ✅ Recipe API (detail, alternatives)
- ✅ Home Dashboard API

**Неделя 10-11: Advanced API**
- ✅ Lab Tests API (upload, interpretation)
- ✅ AI Chat API (OpenAI integration)
- ✅ Courses API (progress tracking)
- ✅ Subscriptions API (Stripe)

### Этап 4: Flutter App - Базовый функционал (6 недель)

**Неделя 12-13: Core Setup**
- ✅ Project structure
- ✅ Интеграция dev_modules
- ✅ Навигация (go_router)
- ✅ State management (BLoC)
- ✅ API service (Dio)

**Неделя 14-15: Авторизация**
- ✅ SMS auth module
- ✅ Email auth (адаптация)
- ✅ Verification screens
- ✅ Onboarding (мини-опрос)

**Неделя 16-17: Главный экран + Навигация**
- ✅ Home screen (dashboard)
- ✅ Tab Bar navigation
- ✅ Notifications screen
- ✅ Profile screen

### Этап 5: Flutter App - Основные фичи (8 недель)

**Неделя 18-20: Рацион питания**
- ✅ Meal plan screen
- ✅ Recipe detail screen
- ✅ Recipe alternatives
- ✅ Replace meal flow

**Неделя 21-23: Дневник питания**
- ✅ Diary screen (адаптация diary_module)
- ✅ Add meal flow
- ✅ Water tracker
- ✅ Mood selector
- ✅ Calendar navigation

**Неделя 24-25: База знаний**
- ✅ Courses list (адаптация knowledge_module)
- ✅ Course detail
- ✅ Lesson screen (video/text)
- ✅ Progress tracking

### Этап 6: Flutter App - Дополнительные фичи (6 недель)

**Неделя 26-27: AI Консультант**
- ✅ Chat screen (адаптация ai_chat_module)
- ✅ Message input
- ✅ Chat history
- ✅ Context selection

**Неделя 28-29: Анализы**
- ✅ Lab tests upload (адаптация checkup_module)
- ✅ Interpretation screen
- ✅ Parameters library

**Неделя 30-31: Блог + Подписки**
- ✅ Blog list & detail
- ✅ Subscription plans (адаптация subscription_module)
- ✅ Payment flow (In-App Purchase)

### Этап 7: Полировка и Тестирование (4 недели)

**Неделя 32-33: UI/UX**
- ✅ Finalize UI (соответствие дизайну)
- ✅ Анимации и transitions
- ✅ Loading states
- ✅ Error handling

**Неделя 34-35: Тестирование**
- ✅ Unit tests (Backend)
- ✅ Widget tests (Flutter)
- ✅ Integration tests
- ✅ Manual QA

### Этап 8: Деплой и Запуск (2 недели)

**Неделя 36-37:**
- ✅ Backend deployment (Production)
- ✅ Flutter build (iOS + Android)
- ✅ App Store submission
- ✅ Google Play submission
- ✅ Beta testing (TestFlight / Internal Testing)

**Неделя 38:**
- ✅ Public launch 🚀
- ✅ Monitoring setup
- ✅ Support documentation

---

## 12. Документация

### 12.1 Для разработчиков

- **Backend API Docs**: Swagger/OpenAPI (автогенерация в Strapi)
- **Flutter Docs**: Dartdoc comments
- **Архитектура**: architecture.md
- **Deployment**: deployment.md

### 12.2 Для админов

- **Admin Guide**: Инструкция по работе с админ-панелью
- **Content Creation**: Как создавать курсы, рецепты, планы
- **User Support**: FAQ для поддержки

---

## 13. Метрики успеха

### 13.1 KPI

- **DAU/MAU**: Daily/Monthly Active Users
- **Retention**: Day 1, Day 7, Day 30
- **Conversion**: Free → Paid subscription
- **Engagement**: Meals logged per day, AI chat usage
- **Completion Rate**: Courses, meal plans

### 13.2 Monitoring

- **Uptime**: 99.9%
- **Response Time**: < 500ms (95th percentile)
- **Error Rate**: < 1%
- **Crash Rate**: < 0.1% (Flutter)

---

## 14. Дальнейшее развитие

### Фаза 2 (после запуска):

- 🔄 Синхронизация с фитнес-трекерами (Apple Health, Google Fit)
- 🏋️ Модуль тренировок
- 👥 Социальные фичи (друзья, челленджи)
- 🛒 Интеграция с доставкой продуктов
- 📊 Расширенная аналитика для пользователей
- 🌍 Локализация (английский, другие языки)

---

## 15. Заключение

Данное техническое задание описывает полный цикл разработки **Brix Nutritional App** — от инфраструктуры до запуска в сторах.

**Итого:**
- **Срок разработки**: 38 недель (~9 месяцев)
- **Команда**: 
  - 2 Backend разработчика
  - 2 Flutter разработчика
  - 1 UI/UX дизайнер
  - 1 QA инженер
  - 1 DevOps
  - 1 PM

**Технологии:**
- **Mobile**: Flutter 3.24+
- **Admin Web**: Next.js 14+ (React 18, TypeScript 5, Tailwind CSS 3.3)
- **Backend**: Strapi 4.x (Node.js 18+)
- **Database**: PostgreSQL 14+
- **Cache**: Redis 7+
- **Media**: AWS S3 / Supabase Storage
- **AI**: OpenAI GPT-4
- **Payments**: Stripe
- **Push**: Firebase (Mobile), Email (Web)

**Результат:**
Полнофункциональная экосистема для персонализированного питания, состоящая из:
- Мобильного приложения (iOS/Android) для конечных пользователей
- Веб-панели администратора для управления контентом
- Единого backend API
- Готовая к масштабированию и монетизации

---

**Версия документа**: 2.0.0
**Дата**: 10 октября 2025 (добавлена Admin Web Panel архитектура)
**Обновления**:
- Добавлена архитектура Admin Web Panel (Next.js)
- Описаны admin_modules/ (7 готовых + 5 новых)
- Обновлена общая схема системы (3 компонента)
- Добавлены Admin-специфичные endpoints
**Автор**: AI Assistant (Claude Sonnet 4.5)

