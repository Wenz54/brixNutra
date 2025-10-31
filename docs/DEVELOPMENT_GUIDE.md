# 🛠️ Руководство по разработке Brix Nutritional App

Полное руководство для разработчиков, работающих над Brix Nutritional App.

## 📋 Содержание

1. [Требования](#1-требования)
2. [Настройка окружения](#2-настройка-окружения)
3. [Структура проекта](#3-структура-проекта)
4. [Workflow разработки](#4-workflow-разработки)
5. [Backend разработка (Strapi)](#5-backend-разработка-strapi)
6. [Frontend разработка (Flutter)](#6-frontend-разработка-flutter)
7. [Admin Web разработка (Next.js)](#7-admin-web-разработка-nextjs)
8. [Тестирование](#8-тестирование)
9. [Деплой](#9-деплой)
10. [Best Practices](#10-best-practices)

---

## 1. Требования

### Software

```yaml
Required:
  - Node.js: >= 18.0.0
  - npm: >= 9.0.0
  - PostgreSQL: >= 14.0
  - Redis: >= 7.0
  - Flutter: >= 3.24.0
  - Dart: >= 3.0.0
  - Git: >= 2.30

Optional:
  - Docker: >= 24.0
  - Docker Compose: >= 2.0
```

### IDE / Editors

- **Backend**: VS Code, WebStorm, Cursor
- **Flutter**: VS Code + Flutter extension, Android Studio, Cursor

### Учетные записи

- [ ] GitHub account
- [ ] OpenAI API key (для AI консультанта)
- [ ] Twilio account (для SMS)
- [ ] Stripe account (для платежей)
- [ ] AWS S3 / Supabase (для медиа)

---

## 2. Настройка окружения

### 2.1 Clone Repository

```bash
git clone https://github.com/your-org/brix-nutrition.git
cd brix-nutrition
```

### 2.2 Backend Setup

#### Вариант A: Local Setup

```bash
cd backend

# 1. Создать Strapi приложение
npx create-strapi-app@latest strapi --quickstart --no-run

cd strapi

# 2. Установить дополнительные зависимости
npm install --save \
  @strapi/plugin-users-permissions \
  bcrypt \
  jsonwebtoken \
  twilio \
  openai \
  stripe \
  nodemailer \
  redis \
  ioredis

# 3. Создать .env
cat > .env << EOF
HOST=0.0.0.0
PORT=1337

# Database
DATABASE_CLIENT=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=brix_nutrition
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_SSL=false

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=$(openssl rand -base64 32)
API_TOKEN_SALT=$(openssl rand -base64 32)
ADMIN_JWT_SECRET=$(openssl rand -base64 32)

# OpenAI
OPENAI_API_KEY=sk-...

# Twilio
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1...

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# AWS S3
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
AWS_S3_BUCKET=brix-nutrition

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply@brix-nutrition.com
SMTP_PASS=...
EOF

# 4. Создать БД
createdb brix_nutrition

# 5. Запустить миграции
npm run strapi generate

# 6. Запустить сервер
npm run develop
```

Admin panel будет доступен по адресу: http://localhost:1337/admin

#### Вариант B: Docker Setup

```bash
cd backend

# 1. Создать docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:14-alpine
    container_name: brix_postgres
    environment:
      POSTGRES_DB: brix_nutrition
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    container_name: brix_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  strapi:
    build: ./strapi
    container_name: brix_strapi
    environment:
      DATABASE_CLIENT: postgres
      DATABASE_HOST: postgres
      DATABASE_PORT: 5432
      DATABASE_NAME: brix_nutrition
      DATABASE_USERNAME: postgres
      DATABASE_PASSWORD: postgres
      REDIS_HOST: redis
      REDIS_PORT: 6379
    ports:
      - "1337:1337"
    volumes:
      - ./strapi:/app
      - /app/node_modules
    depends_on:
      - postgres
      - redis

volumes:
  postgres_data:
  redis_data:
EOF

# 2. Запустить
docker-compose up -d

# 3. Проверить логи
docker-compose logs -f strapi
```

### 2.3 Flutter Setup

```bash
cd mobile

# 1. Создать Flutter проект
flutter create .

# 2. Копировать dev_modules
cp -r ../dev_modules lib/

# 3. Обновить pubspec.yaml
cat >> pubspec.yaml << 'EOF'

dependencies:
  # State Management
  flutter_bloc: ^8.1.0
  provider: ^6.0.0
  
  # Network
  dio: ^5.4.0
  http: ^1.2.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  
  # UI
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^3.0.0
  
  # Utils
  intl: ^0.18.1
  url_launcher: ^6.2.4
  share_plus: ^7.2.1
  permission_handler: ^11.2.0
  
  # Media
  image_picker: ^1.0.7
  video_player: ^2.8.2
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^17.0.0
  firebase_analytics: ^10.8.0
  
  # Payments
  in_app_purchase: ^3.1.11
EOF

# 4. Установить зависимости
flutter pub get

# 5. Настроить API URL
# Отредактировать lib/dev_modules/core_module/config/api_config.dart
sed -i '' 's/localhost:3001/localhost:1337/g' lib/dev_modules/core_module/config/api_config.dart

# 6. Запустить
flutter run
```

---

## 3. Структура проекта

### Backend (Strapi)

```
backend/strapi/
├── config/
│   ├── database.js          # PostgreSQL config
│   ├── server.js            # Server config
│   ├── middlewares.js       # Custom middlewares
│   └── plugins.js           # Plugins config
│
├── src/
│   ├── api/                 # API endpoints
│   │   ├── auth/
│   │   │   ├── controllers/
│   │   │   │   └── auth.js  # Custom auth logic
│   │   │   ├── routes/
│   │   │   │   └── custom-auth.js
│   │   │   └── services/
│   │   │       └── auth.js
│   │   │
│   │   ├── user/
│   │   ├── meal-plan/
│   │   ├── recipe/
│   │   ├── diary/
│   │   ├── ai-chat/
│   │   ├── lab-test/
│   │   ├── course/
│   │   ├── lesson/
│   │   ├── blog-article/
│   │   ├── notification/
│   │   └── subscription/
│   │
│   ├── extensions/          # Strapi extensions
│   │   └── users-permissions/
│   │
│   ├── middlewares/         # Custom middlewares
│   │   ├── rateLimit.js
│   │   └── authContext.js
│   │
│   └── plugins/             # Custom plugins
│       └── ai-assistant/
│
├── public/
│   └── uploads/             # Media files
│
├── database/
│   └── migrations/
│
├── .env
├── package.json
└── tsconfig.json
```

### Frontend (Flutter)

```
mobile/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart         # MaterialApp config
│   │   ├── routes.dart      # Navigation routes
│   │   └── theme.dart       # Theme overrides
│   │
│   ├── dev_modules/         # Существующие модули
│   │   ├── core_module/
│   │   ├── ui_kit_module/
│   │   ├── auth_module/
│   │   ├── diary_module/
│   │   └── ...
│   │
│   ├── features/            # Новые фичи для Brix
│   │   ├── sms_auth/
│   │   │   ├── screens/
│   │   │   │   ├── phone_input_screen.dart
│   │   │   │   └── sms_verification_screen.dart
│   │   │   ├── services/
│   │   │   │   └── sms_service.dart
│   │   │   └── widgets/
│   │   │       └── code_input_widget.dart
│   │   │
│   │   ├── meal_plan/
│   │   │   ├── screens/
│   │   │   │   ├── meal_plan_screen.dart
│   │   │   │   └── meal_plan_day_screen.dart
│   │   │   ├── services/
│   │   │   │   └── meal_plan_service.dart
│   │   │   ├── models/
│   │   │   │   ├── meal_plan_model.dart
│   │   │   │   └── meal_slot_model.dart
│   │   │   └── widgets/
│   │   │       ├── meal_card.dart
│   │   │       └── meal_slot_widget.dart
│   │   │
│   │   ├── recipe/
│   │   ├── blog/
│   │   └── notifications/
│   │
│   └── shared/
│       ├── utils/
│       ├── constants/
│       └── extensions/
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 4. Workflow разработки

### Git Flow

```bash
# 1. Создать ветку от develop
git checkout develop
git pull origin develop
git checkout -b feature/sms-auth

# 2. Разработка
# ... coding ...

# 3. Commit
git add .
git commit -m "feat(auth): add SMS authentication"

# 4. Push
git push origin feature/sms-auth

# 5. Create Pull Request
# через GitHub UI

# 6. Code Review
# После одобрения → Merge в develop
```

### Commit Convention

```
feat: новая функциональность
fix: исправление бага
docs: изменения в документации
style: форматирование кода
refactor: рефакторинг
test: добавление тестов
chore: обновление зависимостей, конфигов

Примеры:
feat(auth): add phone number authentication
fix(diary): fix water tracking calculation
docs(readme): update installation instructions
```

### Branches

- `main` — production
- `develop` — разработка
- `feature/*` — новые фичи
- `fix/*` — исправления багов
- `hotfix/*` — критические исправления для production

---

## 5. Backend разработка

### 5.0 Выбор Backend Framework

**Option A: Fastify + TypeScript + backend_modules (Рекомендуется) ⭐**

Преимущества:
- ✅ **13 готовых модулей** с реализованной бизнес-логикой
- ✅ **~100+ API endpoints** из коробки
- ✅ **27 готовых миграций БД**
- ✅ Полная типизация TypeScript
- ✅ Высокая производительность (Fastify)
- ✅ Zod валидация

**Option B: Strapi 4.x (Альтернатива)**

Преимущества:
- ✅ Готовая админ-панель
- ✅ Content-Type Builder
- ❌ Требует разработки кастомных контроллеров

---

### 5.A Backend с Fastify + backend_modules

#### 5.A.1 Быстрый старт

```bash
# 1. Создать проект
mkdir backend && cd backend
npm init -y

# 2. Установить зависимости
npm install fastify @fastify/jwt @fastify/cors @fastify/swagger \
  @fastify/multipart typescript zod bcryptjs pg openai resend

npm install --save-dev @types/node @types/bcryptjs tsx jest

# 3. Скопировать модули
mkdir -p src/modules
cp -r ../backend_modules/* src/modules/

# 4. Создать .env
cat > .env << EOF
DATABASE_URL=postgresql://user:password@localhost:5432/brix_nutrition
JWT_SECRET=your-secret-key
OPENAI_API_KEY=sk-...
RESEND_API_KEY=re_...
EOF

# 5. Создать index.ts
cat > src/index.ts << 'EOF'
import Fastify from 'fastify'
import { authRoutes } from './modules/auth_module'

const fastify = Fastify({ logger: true })

await fastify.register(authRoutes, { prefix: '/api/auth' })

await fastify.listen({ port: 3000, host: '0.0.0.0' })
EOF

# 6. Запустить миграции
npm run db:migrate

# 7. Запустить dev сервер
npm run dev
```

#### 5.A.2 Структура backend_modules

```
backend/src/modules/
├── core_module/           # Middleware, utils, типы
├── database_module/       # PostgreSQL + миграции
├── auth_module/           # JWT, регистрация
├── users_module/          # Профили пользователей
├── nutrition_module/      # Планы питания
├── knowledge_module/      # Курсы, уроки
├── diary_module/          # Дневник питания
├── lab_module/            # Анализы
├── survey_module/         # Опросники
├── ai_chat_module/        # OpenAI интеграция
├── subscription_module/   # Подписки
├── files_module/          # Загрузка файлов
└── analytics_module/      # Статистика
```

#### 5.A.3 Использование модуля

```typescript
// src/index.ts
import Fastify from 'fastify'
import { authRoutes } from './modules/auth_module'
import { nutritionRoutes } from './modules/nutrition_module'
import { diaryRoutes } from './modules/diary_module'

const fastify = Fastify({ logger: true })

// Регистрация модулей
await fastify.register(authRoutes, { prefix: '/api/auth' })
await fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })
await fastify.register(diaryRoutes, { prefix: '/api/diary' })

await fastify.listen({ port: 3000, host: '0.0.0.0' })
```

#### 5.A.4 Создание нового endpoint

```typescript
// src/modules/nutrition_module/routes/index.ts
import { FastifyInstance } from 'fastify'
import { z } from 'zod'

const CreatePlanSchema = z.object({
  name: z.string(),
  description: z.string(),
  duration_days: z.number(),
})

export async function nutritionRoutes(fastify: FastifyInstance) {
  // GET /api/nutrition/plans
  fastify.get('/plans', async (request, reply) => {
    const plans = await fastify.db.query(
      'SELECT * FROM nutrition_plans WHERE is_active = true'
    )
    return { data: plans.rows }
  })

  // POST /api/nutrition/plans
  fastify.post('/plans', {
    schema: {
      body: CreatePlanSchema
    }
  }, async (request, reply) => {
    const data = request.body
    const result = await fastify.db.query(
      'INSERT INTO nutrition_plans (name, description, duration_days) VALUES ($1, $2, $3) RETURNING *',
      [data.name, data.description, data.duration_days]
    )
    return { data: result.rows[0] }
  })
}
```

#### 5.A.5 Миграции БД

27 готовых миграций создают все необходимые таблицы:

```bash
# Запустить все миграции
npm run db:migrate

# Создать новую миграцию
npm run db:migrate:create add_new_column

# Откатить последнюю миграцию
npm run db:migrate:rollback
```

---

### 5.B Backend с Strapi (Альтернатива)

#### 5.B.1 Создание Content Type

```bash
# CLI
npm run strapi generate

# Выбрать:
# ? Strapi Generators
#   > content-type - Create a new content type
# ? Content type display name: Recipe
# ? Content type singular name: recipe
# ? Content type plural name: recipes
```

**Или через Admin UI:**
1. Открыть http://localhost:1337/admin
2. Content-Type Builder → Create new collection type
3. Добавить поля

**Пример: Recipe**

```javascript
// src/api/recipe/content-types/recipe/schema.json
{
  "kind": "collectionType",
  "collectionName": "recipes",
  "info": {
    "singularName": "recipe",
    "pluralName": "recipes",
    "displayName": "Recipe"
  },
  "options": {
    "draftAndPublish": true
  },
  "attributes": {
    "name": {
      "type": "string",
      "required": true
    },
    "description": {
      "type": "text"
    },
    "image": {
      "type": "media",
      "multiple": false,
      "allowedTypes": ["images"]
    },
    "prepTime": {
      "type": "integer"
    },
    "calories": {
      "type": "integer"
    },
    "protein": {
      "type": "decimal"
    },
    "carbs": {
      "type": "decimal"
    },
    "fats": {
      "type": "decimal"
    },
    "ingredients": {
      "type": "json"
    },
    "instructions": {
      "type": "json"
    },
    "tags": {
      "type": "json"
    }
  }
}
```

#### 5.B.2 Custom Controller

```javascript
// src/api/recipe/controllers/recipe.js
module.exports = {
  async findAlternatives(ctx) {
    const { id } = ctx.params;
    
    try {
      // Получить рецепт
      const recipe = await strapi.entityService.findOne(
        'api::recipe.recipe',
        id,
        { populate: ['tags'] }
      );
      
      if (!recipe) {
        return ctx.notFound('Recipe not found');
      }
      
      // Найти похожие по тегам
      const alternatives = await strapi.db.query('api::recipe.recipe').findMany({
        where: {
          id: { $ne: id },
          tags: { $contains: recipe.tags }
        },
        limit: 5
      });
      
      return alternatives;
    } catch (error) {
      ctx.throw(500, error);
    }
  }
};
```

### 5.3 Custom Route

```javascript
// src/api/recipe/routes/custom-recipe.js
module.exports = {
  routes: [
    {
      method: 'GET',
      path: '/recipes/:id/alternatives',
      handler: 'recipe.findAlternatives',
      config: {
        auth: true
      }
    }
  ]
};
```

### 5.4 Custom Service

```javascript
// src/api/ai-chat/services/ai-chat.js
const OpenAI = require('openai');

module.exports = {
  async generateResponse(userId, message, context) {
    const openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY
    });
    
    // Получить контекст пользователя
    const userProfile = await strapi.entityService.findMany('plugin::users-permissions.user', {
      filters: { id: userId },
      populate: ['goal', 'birthDate']
    });
    
    let systemPrompt = `Ты — AI-консультант по питанию для Brix Nutrition.`;
    
    if (context.includeDiary) {
      const diary = await strapi.db.query('api::diary-day.diary-day').findMany({
        where: { user: userId },
        orderBy: { date: 'desc' },
        limit: 7
      });
      
      systemPrompt += `\nДневник пользователя за последние 7 дней: ${JSON.stringify(diary)}`;
    }
    
    // ... остальная логика
    
    const response = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: message }
      ],
      temperature: 0.7
    });
    
    return response.choices[0].message.content;
  }
};
```

### 5.5 Middleware

```javascript
// src/middlewares/rateLimit.js
const rateLimit = require('express-rate-limit');

module.exports = (config, { strapi }) => {
  return async (ctx, next) => {
    const limiter = rateLimit({
      windowMs: 15 * 60 * 1000, // 15 минут
      max: config.max || 5,
      message: 'Too many requests'
    });
    
    return limiter(ctx.request, ctx.response, next);
  };
};
```

---

## 6. Frontend разработка (Flutter)

### 6.1 Создание нового модуля

```bash
# Структура модуля
mkdir -p lib/features/meal_plan/{screens,services,models,widgets}
```

**Service:**

```dart
// lib/features/meal_plan/services/meal_plan_service.dart
import 'package:dio/dio.dart';
import '../../../dev_modules/core_module/services/api_service.dart';
import '../models/meal_plan_model.dart';

class MealPlanService {
  static Future<MealPlan> getCurrentPlan() async {
    try {
      final response = await ApiService.get('/meal-plan/current');
      return MealPlan.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load meal plan: $e');
    }
  }
  
  static Future<bool> replaceMeal({
    required String mealSlotId,
    required String newRecipeId,
  }) async {
    try {
      await ApiService.post('/meal-plan/replace', {
        'mealSlotId': mealSlotId,
        'newRecipeId': newRecipeId,
      });
      return true;
    } catch (e) {
      print('Error replacing meal: $e');
      return false;
    }
  }
}
```

**Model:**

```dart
// lib/features/meal_plan/models/meal_plan_model.dart
class MealPlan {
  final String id;
  final String name;
  final String description;
  final List<MealSlot> meals;
  
  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.meals,
  });
  
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      meals: (json['meals'] as List)
          .map((m) => MealSlot.fromJson(m))
          .toList(),
    );
  }
}

class MealSlot {
  final String id;
  final String type;
  final String time;
  final Recipe recipe;
  final int portion;
  final int calories;
  
  MealSlot({
    required this.id,
    required this.type,
    required this.time,
    required this.recipe,
    required this.portion,
    required this.calories,
  });
  
  factory MealSlot.fromJson(Map<String, dynamic> json) {
    return MealSlot(
      id: json['id'],
      type: json['type'],
      time: json['time'],
      recipe: Recipe.fromJson(json['recipe']),
      portion: json['portion'],
      calories: json['calories'],
    );
  }
}
```

**Screen:**

```dart
// lib/features/meal_plan/screens/meal_plan_screen.dart
import 'package:flutter/material.dart';
import '../services/meal_plan_service.dart';
import '../models/meal_plan_model.dart';
import '../widgets/meal_slot_widget.dart';

class MealPlanScreen extends StatefulWidget {
  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  MealPlan? _mealPlan;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }
  
  Future<void> _loadMealPlan() async {
    setState(() => _isLoading = true);
    
    try {
      final plan = await MealPlanService.getCurrentPlan();
      setState(() {
        _mealPlan = plan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рацион'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _mealPlan == null
              ? Center(child: Text('План не найден'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _mealPlan!.meals.length,
                  itemBuilder: (context, index) {
                    final meal = _mealPlan!.meals[index];
                    return MealSlotWidget(
                      mealSlot: meal,
                      onReplace: () => _handleReplace(meal),
                    );
                  },
                ),
    );
  }
  
  Future<void> _handleReplace(MealSlot meal) async {
    // Показать альтернативы
    // ...
  }
}
```

### 6.2 BLoC Pattern

```dart
// lib/features/meal_plan/blocs/meal_plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/meal_plan_service.dart';
import '../models/meal_plan_model.dart';

// Events
abstract class MealPlanEvent {}

class LoadMealPlan extends MealPlanEvent {}

class ReplaceMeal extends MealPlanEvent {
  final String mealSlotId;
  final String newRecipeId;
  
  ReplaceMeal(this.mealSlotId, this.newRecipeId);
}

// States
abstract class MealPlanState {}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final MealPlan mealPlan;
  
  MealPlanLoaded(this.mealPlan);
}

class MealPlanError extends MealPlanState {
  final String message;
  
  MealPlanError(this.message);
}

// BLoC
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc() : super(MealPlanInitial()) {
    on<LoadMealPlan>(_onLoadMealPlan);
    on<ReplaceMeal>(_onReplaceMeal);
  }
  
  Future<void> _onLoadMealPlan(
    LoadMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());
    
    try {
      final plan = await MealPlanService.getCurrentPlan();
      emit(MealPlanLoaded(plan));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }
  
  Future<void> _onReplaceMeal(
    ReplaceMeal event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      await MealPlanService.replaceMeal(
        mealSlotId: event.mealSlotId,
        newRecipeId: event.newRecipeId,
      );
      add(LoadMealPlan()); // Reload
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }
}
```

**Использование в Screen:**

```dart
class MealPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealPlanBloc()..add(LoadMealPlan()),
      child: Scaffold(
        appBar: AppBar(title: Text('Рацион')),
        body: BlocBuilder<MealPlanBloc, MealPlanState>(
          builder: (context, state) {
            if (state is MealPlanLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is MealPlanError) {
              return Center(child: Text(state.message));
            }
            
            if (state is MealPlanLoaded) {
              return ListView.builder(
                itemCount: state.mealPlan.meals.length,
                itemBuilder: (context, index) {
                  return MealSlotWidget(
                    mealSlot: state.mealPlan.meals[index],
                  );
                },
              );
            }
            
            return SizedBox();
          },
        ),
      ),
    );
  }
}
```

---

## 7. Admin Web разработка (Next.js)

### 7.1 Создание Admin Panel

#### Структура проекта

```bash
cd admin

# Создать Next.js проект
npm create next-app@14 . --typescript --tailwind --app --no-src-dir

# Установить зависимости
npm install @heroicons/react lucide-react react-hook-form react-hot-toast

# Скопировать admin_modules
cp -r ../admin_modules ./src/admin_modules
```

#### Структура admin проекта

```
admin/
├── src/
│   ├── app/                          # Next.js App Router
│   │   ├── layout.tsx               # Root layout
│   │   ├── page.tsx                 # Dashboard
│   │   ├── login/
│   │   │   └── page.tsx             # Login page
│   │   ├── courses/
│   │   │   ├── page.tsx             # Courses list
│   │   │   └── [id]/
│   │   │       └── page.tsx         # Course detail
│   │   ├── recipes/
│   │   │   ├── page.tsx
│   │   │   └── [id]/
│   │   │       └── page.tsx
│   │   └── ...
│   │
│   ├── admin_modules/               # Copied modules
│   │   ├── core_module/
│   │   ├── ui_components_module/
│   │   ├── dashboard_module/
│   │   └── ...
│   │
│   ├── components/                  # Custom components
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   └── ...
│   │
│   └── lib/                         # Utilities
│       ├── api.ts                   # API client
│       └── utils.ts
│
├── public/
├── .env.local
├── next.config.js
├── tailwind.config.ts
└── package.json
```

### 7.2 Настройка API клиента

#### Создать API клиент для Strapi

```typescript
// src/lib/api.ts

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:1337/api';

class ApiClient {
  private token: string | null = null;

  constructor() {
    if (typeof window !== 'undefined') {
      this.token = localStorage.getItem('token');
    }
  }

  setToken(token: string) {
    this.token = token;
    if (typeof window !== 'undefined') {
      localStorage.setItem('token', token);
    }
  }

  clearToken() {
    this.token = null;
    if (typeof window !== 'undefined') {
      localStorage.removeItem('token');
    }
  }

  private getHeaders() {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };
    if (this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }
    return headers;
  }

  async login(email: string, password: string) {
    const res = await fetch(`${API_URL}/auth/local`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identifier: email, password }),
    });

    if (!res.ok) {
      throw new Error('Login failed');
    }

    const data = await res.json();
    if (data.jwt) {
      this.setToken(data.jwt);
    }
    return data;
  }

  async get(endpoint: string) {
    const res = await fetch(`${API_URL}${endpoint}`, {
      headers: this.getHeaders(),
    });

    if (!res.ok) {
      throw new Error(`GET ${endpoint} failed`);
    }

    return res.json();
  }

  async post(endpoint: string, data: any) {
    const res = await fetch(`${API_URL}${endpoint}`, {
      method: 'POST',
      headers: this.getHeaders(),
      body: JSON.stringify(data),
    });

    if (!res.ok) {
      throw new Error(`POST ${endpoint} failed`);
    }

    return res.json();
  }

  async put(endpoint: string, data: any) {
    const res = await fetch(`${API_URL}${endpoint}`, {
      method: 'PUT',
      headers: this.getHeaders(),
      body: JSON.stringify(data),
    });

    if (!res.ok) {
      throw new Error(`PUT ${endpoint} failed`);
    }

    return res.json();
  }

  async delete(endpoint: string) {
    const res = await fetch(`${API_URL}${endpoint}`, {
      method: 'DELETE',
      headers: this.getHeaders(),
    });

    if (!res.ok) {
      throw new Error(`DELETE ${endpoint} failed`);
    }

    return res.json();
  }
}

export const apiClient = new ApiClient();
```

### 7.3 Создание Layout

#### Root Layout с авторизацией

```typescript
// src/app/layout.tsx
'use client';

import { usePathname, useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import './globals.css';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token && pathname !== '/login') {
      router.push('/login');
    } else {
      setIsAuthenticated(!!token);
    }
    setIsLoading(false);
  }, [pathname, router]);

  if (isLoading) {
    return (
      <html lang="ru">
        <body>
          <div className="flex items-center justify-center min-h-screen">
            <div className="text-xl">Загрузка...</div>
          </div>
        </body>
      </html>
    );
  }

  if (pathname === '/login') {
    return (
      <html lang="ru">
        <body>{children}</body>
      </html>
    );
  }

  return (
    <html lang="ru">
      <body>
        <div className="flex h-screen bg-gray-50">
          <Sidebar />
          <div className="flex-1 flex flex-col overflow-hidden">
            <Header />
            <main className="flex-1 overflow-y-auto p-6">
              {children}
            </main>
          </div>
        </div>
      </body>
    </html>
  );
}
```

### 7.4 Использование admin_modules

#### Пример: Dashboard

```typescript
// src/app/page.tsx
'use client';

import { useEffect, useState } from 'react';
import { apiClient } from '@/lib/api';

export default function DashboardPage() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalRecipes: 0,
    totalMealPlans: 0,
    totalCourses: 0,
    activeSubscriptions: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      // Параллельные запросы для производительности
      const [users, recipes, plans, courses, subscriptions] = await Promise.all([
        apiClient.get('/users/count'),
        apiClient.get('/recipes/count'),
        apiClient.get('/meal-plans/count'),
        apiClient.get('/courses/count'),
        apiClient.get('/subscriptions/count?filters[status][$eq]=active'),
      ]);

      setStats({
        totalUsers: users,
        totalRecipes: recipes,
        totalMealPlans: plans,
        totalCourses: courses,
        activeSubscriptions: subscriptions,
      });
    } catch (error) {
      console.error('Error fetching stats:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div>Загрузка статистики...</div>;
  }

  return (
    <div>
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StatCard title="Пользователи" value={stats.totalUsers} icon="👥" />
        <StatCard title="Рецепты" value={stats.totalRecipes} icon="🍽️" />
        <StatCard title="Планы питания" value={stats.totalMealPlans} icon="📋" />
        <StatCard title="Курсы" value={stats.totalCourses} icon="📚" />
        <StatCard title="Активные подписки" value={stats.activeSubscriptions} icon="💳" />
      </div>
    </div>
  );
}

function StatCard({ title, value, icon }: { title: string; value: number; icon: string }) {
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-3xl font-bold mt-2">{value}</p>
        </div>
        <div className="text-4xl">{icon}</div>
      </div>
    </div>
  );
}
```

#### Пример: Courses Page с admin_modules

```typescript
// src/app/courses/page.tsx
'use client';

import { useEffect, useState } from 'react';
import { apiClient } from '@/lib/api';
import Link from 'next/link';

interface Course {
  id: string;
  attributes: {
    title: string;
    description: string;
    isPaid: boolean;
    lessonsCount: number;
  };
}

export default function CoursesPage() {
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      const response = await apiClient.get('/courses?populate=*');
      setCourses(response.data || []);
    } catch (error) {
      console.error('Error fetching courses:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div>Загрузка курсов...</div>;
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold">Курсы</h1>
        <Link
          href="/courses/new"
          className="px-4 py-2 bg-lime-600 text-white rounded-lg hover:bg-lime-700"
        >
          Создать курс
        </Link>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {courses.map((course) => (
          <Link
            key={course.id}
            href={`/courses/${course.id}`}
            className="bg-white rounded-lg shadow p-6 hover:shadow-lg transition"
          >
            <h3 className="text-xl font-semibold mb-2">
              {course.attributes.title}
            </h3>
            <p className="text-gray-600 mb-4 line-clamp-2">
              {course.attributes.description}
            </p>
            <div className="flex items-center justify-between text-sm">
              <span className="text-gray-500">
                {course.attributes.lessonsCount} уроков
              </span>
              {course.attributes.isPaid && (
                <span className="px-2 py-1 bg-lime-100 text-lime-800 rounded">
                  Платный
                </span>
              )}
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
```

### 7.5 Настройка TypeScript

#### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"],
      "@/admin_modules/*": ["./src/admin_modules/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### 7.6 Создание новых модулей

#### Пример: Recipes Module

**Создать структуру:**
```bash
mkdir -p src/admin_modules/recipes_module/{pages,components,api,types}
```

**API методы:**
```typescript
// src/admin_modules/recipes_module/api/recipesApi.ts
import { apiClient } from '@/lib/api';

export const recipesApi = {
  async getAll() {
    return apiClient.get('/recipes?populate=*');
  },

  async getById(id: string) {
    return apiClient.get(`/recipes/${id}?populate=*`);
  },

  async create(data: any) {
    return apiClient.post('/recipes', { data });
  },

  async update(id: string, data: any) {
    return apiClient.put(`/recipes/${id}`, { data });
  },

  async delete(id: string) {
    return apiClient.delete(`/recipes/${id}`);
  },

  async uploadImage(file: File) {
    const formData = new FormData();
    formData.append('files', file);

    const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/upload`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`,
      },
      body: formData,
    });

    return res.json();
  },
};
```

**TypeScript типы:**
```typescript
// src/admin_modules/recipes_module/types/index.ts

export interface Recipe {
  id: string;
  attributes: {
    name: string;
    description: string;
    imageUrl?: string;
    prepTime: number;
    calories: number;
    protein: number;
    carbs: number;
    fats: number;
    ingredients: Ingredient[];
    instructions: string[];
    tags: string[];
    createdAt: string;
    updatedAt: string;
  };
}

export interface Ingredient {
  name: string;
  amount: number;
  unit: string;
}
```

---

## 8. Тестирование

### Backend Tests (Strapi)

```javascript
// tests/recipe/recipe.test.js
const request = require('supertest');

describe('Recipe API', () => {
  let jwt;
  let recipeId;

  beforeAll(async () => {
    // Login
    const res = await request(strapi.server.httpServer)
      .post('/api/auth/local')
      .send({
        identifier: 'test@example.com',
        password: 'Test1234!'
      });
    
    jwt = res.body.jwt;
  });

  it('should create a recipe', async () => {
    const res = await request(strapi.server.httpServer)
      .post('/api/recipes')
      .set('Authorization', `Bearer ${jwt}`)
      .send({
        name: 'Test Recipe',
        calories: 300,
        prepTime: 15
      });
    
    expect(res.statusCode).toBe(201);
    expect(res.body.data).toHaveProperty('id');
    recipeId = res.body.data.id;
  });

  it('should get recipe alternatives', async () => {
    const res = await request(strapi.server.httpServer)
      .get(`/api/recipes/${recipeId}/alternatives`)
      .set('Authorization', `Bearer ${jwt}`);
    
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});
```

### Flutter Tests

**Unit Test:**

```dart
// test/unit/meal_plan_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('MealPlanService', () {
    test('getCurrentPlan returns meal plan', () async {
      // Arrange
      final mockApiService = MockApiService();
      when(mockApiService.get('/meal-plan/current'))
          .thenAnswer((_) async => mockMealPlanJson);
      
      // Act
      final result = await MealPlanService.getCurrentPlan();
      
      // Assert
      expect(result, isA<MealPlan>());
      expect(result.name, equals('Mediterranean Diet'));
    });
  });
}
```

**Widget Test:**

```dart
// test/widget/meal_plan_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MealPlanScreen displays meal slots', (tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
      home: MealPlanScreen(),
    ));
    
    // Act
    await tester.pump(); // Trigger first build
    await tester.pump(Duration(seconds: 1)); // Wait for async
    
    // Assert
    expect(find.byType(MealSlotWidget), findsWidgets);
    expect(find.text('Завтрак'), findsOneWidget);
  });
}
```

**Integration Test:**

```dart
// integration_test/meal_plan_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete meal plan flow', (tester) async {
    // 1. Launch app
    await tester.pumpWidget(MyApp());
    
    // 2. Login
    await tester.enterText(find.byType(EmailInput), 'test@example.com');
    await tester.enterText(find.byType(PasswordInput), 'Test1234!');
    await tester.tap(find.text('Войти'));
    await tester.pumpAndSettle();
    
    // 3. Navigate to meal plan
    await tester.tap(find.text('Рацион'));
    await tester.pumpAndSettle();
    
    // 4. Replace meal
    await tester.tap(find.byIcon(Icons.swap_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Гречневая каша'));
    await tester.pumpAndSettle();
    
    // Assert
    expect(find.text('Гречневая каша'), findsOneWidget);
  });
}
```

---

## 9. Деплой

### Backend (Strapi)

**Docker build:**

```dockerfile
# backend/strapi/Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

ENV NODE_ENV=production
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
```

```bash
# Build
docker build -t brix-backend:latest .

# Push to registry
docker tag brix-backend:latest registry.example.com/brix-backend:latest
docker push registry.example.com/brix-backend:latest
```

**Deploy на Render / Railway:**

1. Подключить GitHub репозиторий
2. Выбрать `backend/strapi`
3. Настроить environment variables
4. Deploy

### Flutter (iOS)

```bash
# 1. Обновить версию
# Отредактировать pubspec.yaml
version: 1.0.0+1

# 2. Build
flutter build ios --release

# 3. Open Xcode
open ios/Runner.xcworkspace

# 4. В Xcode:
# - Product → Archive
# - Distribute App → App Store Connect
```

### Flutter (Android)

```bash
# 1. Создать keystore (если нет)
keytool -genkey -v -keystore ~/brix-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias brix

# 2. Создать android/key.properties
storePassword=<password>
keyPassword=<password>
keyAlias=brix
storeFile=~/brix-key.jks

# 3. Build
flutter build appbundle --release

# 4. Upload to Google Play Console
# build/app/outputs/bundle/release/app-release.aab
```

### Admin Web Panel (Next.js)

**Vercel (рекомендуется):**

```bash
cd admin

# 1. Установить Vercel CLI
npm install -g vercel

# 2. Login
vercel login

# 3. Deploy
vercel --prod
```

**Или через Vercel UI:**
1. Подключить GitHub репозиторий
2. Выбрать папку `admin/`
3. Настроить Environment Variables:
   - `NEXT_PUBLIC_API_URL=https://api.brix-nutrition.com/api`
4. Deploy

**Альтернативы:**

- **Netlify:**
  ```bash
  cd admin
  npm run build
  netlify deploy --prod --dir=.next
  ```

- **Cloudflare Pages:**
  1. Подключить GitHub repo
  2. Build command: `cd admin && npm run build`
  3. Output directory: `admin/.next`

- **Docker (self-hosted):**
  ```dockerfile
  # admin/Dockerfile
  FROM node:18-alpine AS builder
  
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci
  
  COPY . .
  RUN npm run build
  
  FROM node:18-alpine
  WORKDIR /app
  
  COPY --from=builder /app/.next ./.next
  COPY --from=builder /app/public ./public
  COPY --from=builder /app/package*.json ./
  
  RUN npm ci --only=production
  
  EXPOSE 3000
  CMD ["npm", "start"]
  ```
  
  ```bash
  # Build и deploy
  docker build -t brix-admin:latest ./admin
  docker run -p 3000:3000 \
    -e NEXT_PUBLIC_API_URL=https://api.brix-nutrition.com/api \
    brix-admin:latest
```

---

## 10. Best Practices

### Backend

#### 1. Error Handling

```javascript
// Всегда оборачивать в try-catch
async findOne(ctx) {
  try {
    const { id } = ctx.params;
    const entity = await strapi.entityService.findOne('api::recipe.recipe', id);
    
    if (!entity) {
      return ctx.notFound('Recipe not found');
    }
    
    return entity;
  } catch (error) {
    strapi.log.error('Error finding recipe:', error);
    ctx.throw(500, 'Internal server error');
  }
}
```

#### 2. Валидация

```javascript
// Использовать yup для валидации
const yup = require('yup');

const schema = yup.object({
  email: yup.string().email().required(),
  phone: yup.string().matches(/^\+[0-9]{11}$/),
});

try {
  await schema.validate(ctx.request.body);
} catch (error) {
  return ctx.badRequest(error.message);
}
```

#### 3. Pagination

```javascript
async find(ctx) {
  const { page = 1, limit = 10 } = ctx.query;
  
  const recipes = await strapi.entityService.findMany('api::recipe.recipe', {
    start: (page - 1) * limit,
    limit: parseInt(limit),
  });
  
  const total = await strapi.db.query('api::recipe.recipe').count();
  
  return {
    data: recipes,
    meta: {
      page: parseInt(page),
      limit: parseInt(limit),
      total,
      totalPages: Math.ceil(total / limit),
    },
  };
}
```

### Flutter

#### 1. Обработка ошибок

```dart
try {
  final result = await someAsyncFunction();
  // Успех
} on DioError catch (e) {
  if (e.response?.statusCode == 401) {
    // Unauthorized
    navigateToLogin();
  } else {
    // Другая ошибка
    showError(e.message);
  }
} catch (e) {
  // Общая ошибка
  showError('Unexpected error: $e');
}
```

#### 2. Loading States

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = false;
  String? _error;
  Data? _data;
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retry,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_data == null) {
      return Center(child: Text('No data'));
    }
    
    return /* actual content */;
  }
}
```

#### 3. Dependency Injection

```dart
// Использовать Provider
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ProxyProvider<ApiService, MealPlanService>(
          update: (_, api, __) => MealPlanService(api),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// В виджетах
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealPlanService = context.read<MealPlanService>();
    // ...
  }
}
```

### Admin Web (Next.js)

#### 1. Обработка ошибок

```typescript
// Централизованная обработка ошибок
async function handleApiCall<T>(
  apiCall: () => Promise<T>,
  errorMessage?: string
): Promise<T | null> {
  try {
    return await apiCall();
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.includes('401')) {
        // Redirect to login
        window.location.href = '/login';
        return null;
      }
      toast.error(errorMessage || error.message);
    }
    return null;
  }
}

// Использование
const data = await handleApiCall(
  () => apiClient.get('/recipes'),
  'Не удалось загрузить рецепты'
);
```

#### 2. Loading & Error States

```typescript
'use client';

import { useState, useEffect } from 'react';

function useApiData<T>(
  fetchFn: () => Promise<T>
): { data: T | null; loading: boolean; error: string | null; refetch: () => void } {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchData = async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await fetchFn();
      setData(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  return { data, loading, error, refetch: fetchData };
}

// Использование
export default function Page() {
  const { data, loading, error, refetch } = useApiData(() => apiClient.get('/recipes'));

  if (loading) return <div>Загрузка...</div>;
  if (error) return <div>Ошибка: {error}</div>;
  
  return <div>{/* Render data */}</div>;
}
```

#### 3. TypeScript типизация

```typescript
// Всегда типизируйте данные
interface ApiResponse<T> {
  data: T;
  meta?: {
    pagination?: {
      page: number;
      pageSize: number;
      pageCount: number;
      total: number;
    };
  };
}

// Generic функция для API calls
async function fetchCollection<T>(endpoint: string): Promise<ApiResponse<T[]>> {
  return apiClient.get(endpoint);
}

// Использование с типами
const response = await fetchCollection<Recipe>('/recipes');
```

#### 4. Кэширование данных

```typescript
// Простой кэш на стороне клиента
const cache = new Map<string, { data: any; timestamp: number }>();

async function getCached<T>(
  key: string,
  fetchFn: () => Promise<T>,
  ttl: number = 60000 // 1 минута
): Promise<T> {
  const cached = cache.get(key);
  if (cached && Date.now() - cached.timestamp < ttl) {
    return cached.data;
  }

  const data = await fetchFn();
  cache.set(key, { data, timestamp: Date.now() });
  return data;
}

// Использование
const recipes = await getCached('recipes', () => apiClient.get('/recipes'));
```

#### 5. Форм validation

```typescript
import { useForm } from 'react-hook-form';

interface RecipeForm {
  name: string;
  description: string;
  calories: number;
}

export default function RecipeForm() {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<RecipeForm>();

  const onSubmit = async (data: RecipeForm) => {
    await apiClient.post('/recipes', { data });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input
        {...register('name', { required: 'Обязательное поле' })}
        placeholder="Название рецепта"
      />
      {errors.name && <span className="text-red-500">{errors.name.message}</span>}

      <input
        {...register('calories', {
          required: 'Обязательное поле',
          min: { value: 0, message: 'Калории не могут быть отрицательными' },
        })}
        type="number"
        placeholder="Калории"
      />
      {errors.calories && <span className="text-red-500">{errors.calories.message}</span>}

      <button type="submit">Сохранить</button>
    </form>
  );
}
```

#### 6. Оптимизация производительности

```typescript
// 1. Мемоизация компонентов
import { memo } from 'react';

const RecipeCard = memo(({ recipe }: { recipe: Recipe }) => {
  return <div>{/* Render recipe */}</div>;
});

// 2. useMemo для тяжелых вычислений
const filteredRecipes = useMemo(() => {
  return recipes.filter(r => r.attributes.calories < maxCalories);
}, [recipes, maxCalories]);

// 3. useCallback для функций
const handleDelete = useCallback(async (id: string) => {
  await apiClient.delete(`/recipes/${id}`);
  refetch();
}, [refetch]);

// 4. Dynamic imports
const HeavyComponent = dynamic(() => import('@/components/HeavyComponent'), {
  loading: () => <div>Загрузка...</div>,
});
```

---

## 📚 Полезные ссылки

### Документация
- [Strapi Docs](https://docs.strapi.io/)
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)
- [Next.js Docs](https://nextjs.org/docs)
- [React Docs](https://react.dev)
- [TypeScript Docs](https://www.typescriptlang.org/docs)
- [OpenAI API](https://platform.openai.com/docs)

### Библиотеки

**Flutter:**
- [flutter_bloc](https://bloclibrary.dev/)
- [dio](https://pub.dev/packages/dio)
- [hive](https://docs.hivedb.dev/)

**Next.js/React:**
- [React Hook Form](https://react-hook-form.com)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Heroicons](https://heroicons.com)
- [Lucide React](https://lucide.dev)

---

**Версия**: 2.0.0  
**Обновлено**: 10 октября 2025 (добавлена секция Admin Web разработка)  
**Компоненты**: Backend (Strapi) + Mobile (Flutter) + Admin Web (Next.js)

