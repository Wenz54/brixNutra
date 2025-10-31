# 🥗 Brix Nutrition - Full Stack Application

<div align="center">

**Персонализированное питание и здоровье с AI**

[![Backend](https://img.shields.io/badge/Backend-Fastify%20%2B%20TypeScript-green)](./backend)
[![Mobile](https://img.shields.io/badge/Mobile-Flutter%20%2B%20Dart-blue)](./mobile)
[![Admin](https://img.shields.io/badge/Admin-Next.js%20%2B%20React-black)](./admin)
[![DB](https://img.shields.io/badge/Database-PostgreSQL-blue)](./docs)
[![AI](https://img.shields.io/badge/AI-OpenAI%20GPT--4-purple)](./backend)

[Документация](./docs/README.md) | [Quick Start](./docs/QUICK_START.md) | [API Spec](./docs/API_SPECIFICATION.yaml)

</div>

---

## 📦 Компоненты Проекта

| Компонент | Технологии | Статус | Путь |
|-----------|-----------|--------|------|
| **Backend API** | Fastify, TypeScript, PostgreSQL, Redis | ✅ 100% | [`backend/`](./backend) |
| **Mobile App** | Flutter, Dart | 🚧 В разработке | [`mobile/`](./mobile) |
| **Admin Panel** | Next.js, React, TypeScript | 🚧 В разработке | [`admin/`](./admin) |
| **Modules** | 35+ переиспользуемых модулей | ✅ Готово | [`modules/`](./modules) |

---

## 🚀 Быстрый Старт

### 1. Клонируйте репозиторий

```bash
git clone https://github.com/your-org/brix-nutrition.git
cd brix-nutrition
```

### 2. Настройте окружение

**Windows:**
```powershell
cd start/dev
.\setup-env.ps1
```

**Linux/Mac:**
```bash
cd start/dev
chmod +x setup-env.sh
./setup-env.sh
```

### 3. Запустите Docker (PostgreSQL + Redis)

```bash
docker-compose up -d
```

### 4. Запустите Backend

```bash
cd backend
npm install
npm run dev
```

Backend доступен: **http://localhost:3000**

### 5. Запустите Mobile (опционально)

```bash
cd mobile
flutter pub get
flutter run
```

### 6. Запустите Admin (опционально)

```bash
cd admin
npm install
npm run dev
```

Admin доступен: **http://localhost:3001**

Полные инструкции: [`docs/QUICK_START.md`](./docs/QUICK_START.md)

---

## 🏗️ Архитектура

```
brixNutra/
├── 📦 backend/           # Fastify Backend API (TypeScript)
│   ├── src/
│   │   ├── config/
│   │   ├── modules/      # Backend модули (auth, nutrition, diary, etc.)
│   │   └── server.ts
│   ├── uploads/
│   └── package.json
│
├── 📦 modules/           # Переиспользуемые модули
│   ├── admin/            # 8 React/Next.js модулей
│   ├── backend/          # 13 Fastify модулей
│   └── mobile/           # 14 Flutter модулей
│
├── 📱 mobile/            # Flutter приложение (iOS + Android)
│   ├── lib/
│   │   ├── features/
│   │   └── shared/
│   └── pubspec.yaml
│
├── 💻 admin/             # Next.js Admin Panel
│   ├── src/
│   │   ├── app/
│   │   └── components/
│   └── package.json
│
├── 🧪 test_scripts/      # Тестовые скрипты и seed данные
│   ├── api/
│   └── db/
│
├── 🚀 start/             # Скрипты запуска и деплоя
│   ├── dev/
│   ├── test/
│   └── deploy/
│
├── 📚 docs/              # Документация
│   ├── modules/
│   ├── mobile/
│   ├── API_SPECIFICATION.yaml
│   ├── TECHNICAL_SPECIFICATION.md
│   └── DEVELOPMENT_GUIDE.md
│
├── docker-compose.yml
├── env.example.txt
└── tasks.md
```

---

## ✨ Основные Возможности

### Backend (56 Endpoints)

| Модуль | Endpoints | Статус |
|--------|-----------|--------|
| 🔐 **Auth** | 5 | ✅ SMS/Email верификация, JWT |
| 🍽️ **Recipes** | 3 | ✅ Каталог рецептов, альтернативы |
| 📅 **Meal Plans** | 3 | ✅ Планы питания, замена блюд |
| 📖 **Diary** | 7 | ✅ Дневник питания, вода, настроение |
| 📚 **Knowledge** | 8 | ✅ Курсы (free/paid), прогресс |
| 🧪 **Lab Tests** | 6 | ✅ Расшифровка анализов (21 параметр) |
| 👤 **Profile** | 7 | ✅ Профиль, цели, замеры (BMI/BMR/TDEE) |
| 🤖 **AI Chat** | 5 | ✅ OpenAI GPT-4, контекст из БД |
| 📰 **Blog** | 5 | ✅ Статьи, категории |
| 🔔 **Notifications** | 4 | ✅ Уведомления |
| 📁 **Files** | 2 | ✅ Загрузка файлов |
| 👮 **Admin CRUD** | 12 | ✅ Управление контентом |

### Mobile App (14 Модулей)

- ✅ **Core**: API service, темы, локализация
- ✅ **UI Kit**: Кнопки, карточки, инпуты, алерты
- ✅ **Auth**: SMS/Email авторизация
- ✅ **Diary**: Дневник питания с фото
- ✅ **Plans**: Планы питания, рецепты
- ✅ **Knowledge**: База знаний, курсы
- ✅ **Checkup**: Расшифровка анализов
- ✅ **AI Chat**: AI-консультант
- ✅ **Profile**: Профиль, цели
- ✅ **Subscription**: Подписки
- ✅ **Onboarding**: Опросник
- ✅ **Survey**: Анкеты
- ✅ **Home**: Главный экран
- ✅ **Tab Bar**: Навигация

### Admin Panel (8 Модулей)

- ✅ **Dashboard**: Аналитика и метрики
- ✅ **Courses**: Управление курсами
- ✅ **Lessons**: Управление уроками
- ✅ **Nutrition Plans**: Управление планами питания
- ✅ **Categories**: Управление категориями
- ✅ **Analytics**: Статистика пользователей
- ✅ **Core**: API клиент, типы
- ✅ **UI Components**: Переиспользуемые компоненты

---

## 🗄️ База Данных

- **PostgreSQL 14+**: 38 таблиц
- **Redis 7+**: Кэширование
- **Миграции**: 13 SQL миграций
- **Triggers**: 6 автоматических триггеров
- **Functions**: 6 PostgreSQL функций

См. [`backend/src/modules/database_module/migrations/`](./backend/src/modules/database_module/migrations/)

---

## 🧪 Тестирование

```bash
# API тесты
cd test_scripts/api
.\quick-test.ps1

# Seed данные
cd backend
npm run db:seed

# Диагностика БД
node ../test_scripts/db/diagnose-db.cjs
```

См. [`test_scripts/README.md`](./test_scripts/README.md)

---

## 🚢 Деплой

Скрипты для деплоя находятся в [`start/deploy/`](./start/deploy/)

**Backend:**
- Railway / Render / Strapi Cloud
- PostgreSQL managed database
- Redis managed cache

**Mobile:**
- iOS: TestFlight → App Store
- Android: Internal Testing → Google Play

**Admin:**
- Vercel / Netlify / Cloudflare Pages

---

## 📚 Документация

| Документ | Описание |
|----------|----------|
| [TECHNICAL_SPECIFICATION.md](./docs/TECHNICAL_SPECIFICATION.md) | Полное ТЗ (2236 строк) |
| [API_SPECIFICATION.yaml](./docs/API_SPECIFICATION.yaml) | OpenAPI 3.0 спецификация |
| [DEVELOPMENT_GUIDE.md](./docs/DEVELOPMENT_GUIDE.md) | Гайд разработчика (2174 строки) |
| [user_scenaries.md](./docs/user_scenaries.md) | 13 сценариев использования |
| [MIGRATION_PLAN.md](./docs/MIGRATION_PLAN.md) | План адаптации модулей |
| [COMPLETE_100_PERCENT.md](./docs/COMPLETE_100_PERCENT.md) | Сводка по завершению |
| [FILE_MANAGEMENT_REORGANIZATION.md](./docs/FILE_MANAGEMENT_REORGANIZATION.md) | Реорганизация файловой структуры |

---

## 🛠️ Технологический Стек

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Fastify 4.24+
- **Language**: TypeScript 5.2+
- **Database**: PostgreSQL 14+
- **Cache**: Redis 7+
- **Validation**: Zod
- **Auth**: JWT (jsonwebtoken)
- **AI**: OpenAI GPT-4
- **SMS**: Twilio
- **Email**: Resend
- **Storage**: AWS S3 / Supabase

### Mobile
- **Framework**: Flutter 3.24+
- **Language**: Dart 3.0+
- **State**: flutter_bloc
- **HTTP**: Dio
- **Storage**: Hive, flutter_secure_storage
- **Images**: cached_network_image
- **Push**: Firebase Cloud Messaging

### Admin
- **Framework**: Next.js 14
- **Language**: TypeScript
- **UI**: Tailwind CSS
- **Forms**: React Hook Form
- **Data**: TanStack Query
- **Validation**: Zod

---

## 👥 Контакты и Поддержка

- **Документация**: [`docs/`](./docs)
- **Issues**: [GitHub Issues](https://github.com/your-org/brix-nutrition/issues)
- **Wiki**: [GitHub Wiki](https://github.com/your-org/brix-nutrition/wiki)

---

## 📄 Лицензия

MIT License - см. [LICENSE](./LICENSE)

---

<div align="center">

**Сделано с ❤️ для здорового образа жизни**

[⬆ Вернуться наверх](#-brix-nutrition---full-stack-application)

</div>

