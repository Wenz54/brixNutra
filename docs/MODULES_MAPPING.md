# Маппинг Backend Modules → Brix Requirements

Детальное сопоставление существующих модулей из `backend_modules/` с требованиями Brix Nutritional App из `TECHNICAL_SPECIFICATION.md`.

## 📊 Сводная таблица

| Требование Brix | Модуль | Статус | Что нужно сделать |
|----------------|--------|--------|-------------------|
| **Auth: Email + Password** | `auth_module` | ✅ Готов | Использовать как есть |
| **Auth: Phone + SMS** | `auth_module` | ⚠️ Нужно добавить | Добавить SMS верификацию (Twilio) |
| **Пользователи (birth_date, goal)** | `users_module` | ✅ Готов | Проверить поля, адаптировать |
| **Планы питания (meal plans)** | `nutrition_module` | ✅ Готов | Использовать как есть |
| **Рецепты (recipes)** | `nutrition_module` | ⚠️ Расширить | Добавить: instructions, tags, alternatives |
| **Дневник питания (meals)** | `diary_module` | ⚠️ Расширить | Добавить: mood, isCompleted, photo |
| **Трекинг воды** | `diary_module` | ✅ Готов | Использовать как есть |
| **Лабораторные анализы** | `lab_module` | ⚠️ Расширить | Добавить: интерпретации, рекомендации |
| **Курсы и уроки** | `knowledge_module` | ✅ Готов | Использовать как есть |
| **AI консультант** | `ai_chat_module` | ⚠️ Адаптировать | Добавить контекст из БД (дневник, анализы) |
| **Блог/Новости** | ❌ НЕТ | 🆕 Создать | Новый модуль: blog_module |
| **Уведомления** | ❌ НЕТ | 🆕 Создать | Новый модуль: notifications_module |
| **Подписки (Stripe)** | `subscription_module` | ✅ Готов | Интегрировать Stripe |
| **Загрузка медиа (S3)** | `files_module` | ✅ Готов | Настроить S3 |
| **Аналитика (Dashboard)** | `analytics_module` | ✅ Готов | Адаптировать метрики Brix |

**Итого:**
- ✅ **Готово:** 7 модулей (54%)
- ⚠️ **Требует адаптации:** 5 модулей (38%)
- 🆕 **Нужно создать:** 2 модуля (8%)

---

## 📋 Детальный анализ по модулям

### 1. ✅ Core Module
**Статус:** Готов, без изменений

**Что есть:**
- ✅ Auth middleware (JWT)
- ✅ Валидация (Zod schemas)
- ✅ Стандартизация ответов
- ✅ Общие утилиты

**Действия:** Использовать как есть

---

### 2. ✅ Database Module
**Статус:** Готов, нужны миграции

**Что есть:**
- ✅ PostgreSQL подключение
- ✅ Connection pooling
- ✅ 27 миграций (из Supply Diets)

**Действия:**
1. Запустить существующие миграции
2. Создать дополнительные миграции для Brix:
   - `verification_codes` (для SMS)
   - `recipes` (расширенная структура)
   - `blog_articles`
   - `notifications`

---

### 3. ⚠️ Auth Module
**Статус:** Требует расширения (SMS)

**Что есть (✅):**
- ✅ POST `/auth/register` (Email + Password)
- ✅ POST `/auth/login`
- ✅ POST `/auth/verify-email`
- ✅ POST `/auth/request-reset`
- ✅ POST `/auth/reset-password`
- ✅ JWT токены

**Что нужно добавить (⚠️):**
- ⚠️ POST `/auth/email/send-code` - отправка 4-значного кода
- ⚠️ POST `/auth/email/verify-code` - проверка кода
- ⚠️ POST `/auth/phone/send-code` - SMS код (Twilio)
- ⚠️ POST `/auth/phone/verify-code` - проверка SMS
- ⚠️ Таблица `verification_codes`
- ⚠️ Интеграция с Twilio

**Приоритет:** 🔥 Высокий (критично для Brix)

**Файлы:**
```
auth_module/
├── routes/
│   ├── auth.ts (существующий)
│   └── sms-verification.ts (НОВЫЙ)
├── services/
│   ├── authService.ts (существующий)
│   └── smsService.ts (НОВЫЙ - Twilio)
└── models/
    └── verification-codes.sql (НОВЫЙ)
```

---

### 4. ✅ Users Module
**Статус:** Готов, проверить поля

**Что есть:**
- ✅ GET `/users/me`
- ✅ PUT `/users/me`
- ✅ Аватары
- ✅ Профили

**Проверить поля:**
- `birth_date` (дата рождения)
- `goal` (цель: weight_loss, weight_gain, maintenance, health)
- `gender` (пол)

**Действия:** Убедиться что поля есть в модели, если нет - добавить миграцию

---

### 5. ⚠️ Nutrition Module
**Статус:** Требует расширения (рецепты)

**Что есть (✅):**
- ✅ Планы питания (meal plans)
- ✅ Продукты (products)
- ✅ КБЖУ калькулятор
- ✅ Фильтрация (вегетарианское, веганское)

**Что нужно добавить (⚠️):**
- ⚠️ Рецепты с детальной структурой:
  ```typescript
  {
    id, name, description, imageUrl,
    prepTime, calories, protein, carbs, fats,
    instructions: string[],      // Шаги приготовления
    ingredients: Ingredient[],   // Детальные ингредиенты
    tags: string[],              // ['breakfast', 'vegan']
    mealType: 'breakfast' | ...
  }
  ```
- ⚠️ GET `/recipes/:id/alternatives` - альтернативные рецепты
- ⚠️ POST `/meal-plan/replace` - замена блюда в плане
- ⚠️ GET `/meal-plan/current` - текущий план пользователя
- ⚠️ GET `/meal-plan/day/:date` - план на день

**Приоритет:** 🔥 Высокий

**Файлы для создания:**
```
nutrition_module/
├── routes/
│   ├── recipes.ts (НОВЫЙ)
│   └── meal-plans.ts (расширить)
├── services/
│   ├── recipeService.ts (НОВЫЙ)
│   └── mealPlanService.ts (расширить)
└── models/
    └── recipes.sql (НОВЫЙ)
```

---

### 6. ⚠️ Diary Module
**Статус:** Требует расширения (mood, photo)

**Что есть (✅):**
- ✅ Дневник питания (diary days)
- ✅ Приемы пищи (meals)
- ✅ Трекинг воды (water logs)
- ✅ КБЖУ анализ

**Что нужно добавить (⚠️):**
- ⚠️ `mood_rating` (1-5 звезд) в DiaryDay
- ⚠️ `is_completed` (завершение дня) в DiaryDay
- ⚠️ `photo_url` для каждого приема пищи
- ⚠️ Связь с рецептами (`recipe_id`)
- ⚠️ PUT `/diary/mood` - обновление настроения
- ⚠️ PUT `/diary/day-status` - завершить день
- ⚠️ POST `/diary/water` - обновление воды (increment)

**Приоритет:** 🟡 Средний

**Файлы для расширения:**
```
diary_module/
├── models/
│   └── diary-day.sql (добавить поля)
└── services/
    └── diaryService.ts (добавить методы)
```

---

### 7. ⚠️ Lab Module
**Статус:** Требует расширения (интерпретации)

**Что есть (✅):**
- ✅ Лабораторные анализы
- ✅ Результаты тестов
- ✅ Референсные значения
- ✅ История

**Что нужно добавить (⚠️):**
- ⚠️ Таблица `lab_parameters` (справочник показателей):
  ```sql
  id, name, category, units[],
  reference_ranges (по полу/возрасту),
  description, low_causes, high_causes,
  recommendations
  ```
- ⚠️ GET `/lab-tests/interpretation/:id` - интерпретация
- ⚠️ Логика сравнения с референсами
- ⚠️ Seed data (20-30 основных показателей)

**Приоритет:** 🟢 Низкий (можно позже)

---

### 8. ✅ Knowledge Module
**Статус:** Готов

**Что есть:**
- ✅ Курсы (courses)
- ✅ Уроки (lessons) - видео, текст, аудио
- ✅ Категории
- ✅ Прогресс пользователя (user_lesson_progress)

**Действия:** Использовать как есть, возможно добавить материалы для скачивания

---

### 9. ⚠️ AI Chat Module
**Статус:** Требует адаптации (контекст)

**Что есть (✅):**
- ✅ OpenAI интеграция
- ✅ История чата
- ✅ Streaming ответов

**Что нужно добавить (⚠️):**
- ⚠️ Контекст из БД:
  ```typescript
  {
    includeDiary: boolean,      // Дневник за 7 дней
    includeLabTests: boolean,   // Анализы
    includePlan: boolean        // Текущий план
  }
  ```
- ⚠️ Обогащенный system prompt с данными пользователя
- ⚠️ RAG (Retrieval-Augmented Generation) для точности

**Приоритет:** 🟡 Средний

---

### 10. ✅ Subscription Module
**Статус:** Готов, нужна интеграция Stripe

**Что есть:**
- ✅ Подписки (plans)
- ✅ Управление подписками
- ✅ Премиум доступ

**Действия:**
1. Интегрировать Stripe SDK
2. Настроить Webhooks
3. Тестировать с Stripe Test Mode

---

### 11. ✅ Files Module
**Статус:** Готов, настроить S3

**Что есть:**
- ✅ Загрузка изображений
- ✅ Загрузка видео/аудио
- ✅ Валидация файлов

**Действия:**
1. Настроить AWS S3 credentials в `.env`
2. Или использовать Supabase Storage (бесплатный вариант)

---

### 12. ✅ Analytics Module
**Статус:** Готов, адаптировать метрики

**Что есть:**
- ✅ Статистика пользователей
- ✅ Метрики контента
- ✅ Daily stats

**Действия:**
Адаптировать метрики под Brix:
- Количество пользователей
- Активные подписки
- Популярные рецепты
- Завершенные дни дневника
- AI чаты

---

### 13. ✅ Survey Module
**Статус:** Готов

**Что есть:**
- ✅ Опросники (surveys)
- ✅ Вопросы и ответы
- ✅ Результаты

**Использование в Brix:**
- Онбординг опрос (3 шага: цель, имя, дата рождения)

---

## 🆕 Модули для создания

### 14. 🆕 Blog Module
**Статус:** Нужно создать

**Требования:**
- GET `/blog/articles` - список статей
- GET `/blog/articles/:id` - детали статьи
- POST `/blog/articles` (admin) - создание
- PUT `/blog/articles/:id` (admin) - редактирование

**Модель:**
```typescript
{
  id, title, slug, content (Markdown),
  preview, imageUrl, author, category,
  publishedAt, isPublished
}
```

**Приоритет:** 🟢 Низкий (можно после MVP)

**Файлы:**
```
blog_module/
├── README.md
├── routes/
│   └── blog.ts
├── services/
│   └── blogService.ts
└── models/
    └── blog-articles.sql
```

---

### 15. 🆕 Notifications Module
**Статус:** Нужно создать

**Требования:**
- GET `/notifications` - список уведомлений
- PATCH `/notifications/:id/read` - отметить прочитанным
- DELETE `/notifications/:id` - удалить
- POST `/notifications/send` (internal) - отправка

**Модель:**
```typescript
{
  id, userId, title, message,
  type: 'info' | 'reminder' | 'alert',
  isRead, action: { type, target },
  createdAt
}
```

**Приоритет:** 🟡 Средний

**Файлы:**
```
notifications_module/
├── README.md
├── routes/
│   └── notifications.ts
├── services/
│   ├── notificationService.ts
│   └── pushService.ts (Firebase)
└── models/
    └── notifications.sql
```

---

## 🎯 План действий (Roadmap)

### Фаза 2.1: Критичные адаптации (Неделя 3-4)
1. ✅ Завершить Task 2.1 (этот маппинг) ✅
2. ⚠️ **Task 2.2:** Добавить SMS верификацию в `auth_module`
3. ⚠️ **Task 2.3:** Расширить `nutrition_module` для рецептов
4. ⚠️ **Task 2.4:** Расширить `diary_module` (mood, photo)

### Фаза 2.2: Новые модули (Неделя 5)
5. 🆕 **Task 2.5:** Создать `blog_module`
6. 🆕 **Task 2.6:** Создать `notifications_module`

### Фаза 2.3: Интеграции (Неделя 6)
7. ⚙️ **Task 2.7:** Интегрировать Twilio (SMS)
8. ⚙️ **Task 2.8:** Интегрировать OpenAI (AI Chat)
9. ⚙️ **Task 2.9:** Интегрировать Stripe (Подписки)
10. ⚙️ **Task 2.10:** Настроить AWS S3 (Медиа)

### Фаза 2.4: Регистрация routes (Неделя 7)
11. 🔗 Зарегистрировать все модули в `src/index.ts`
12. 🔗 Настроить Swagger документацию
13. ✅ Тестирование всех endpoints

---

## 📦 Экономия времени

**Благодаря готовым backend_modules:**

| Модуль | Без модулей | С модулями | Экономия |
|--------|-------------|------------|----------|
| Auth | 1.5 недели | 0.5 недели | 1 неделя |
| Users | 1 неделя | 0 недель | 1 неделя |
| Nutrition | 2 недели | 1 неделя | 1 неделя |
| Diary | 1.5 недели | 0.5 недели | 1 неделя |
| Knowledge | 2 недели | 0 недель | 2 недели |
| Lab Tests | 1.5 недели | 0.5 недели | 1 неделя |
| AI Chat | 1 неделя | 0.5 недели | 0.5 недели |
| Subscriptions | 1.5 недели | 0 недель | 1.5 недели |
| Files | 1 неделя | 0 недель | 1 неделя |
| Analytics | 1 неделя | 0 недель | 1 неделя |

**Итого экономия: ~10 недель (2.5 месяца)!** 🚀

---

## 🔗 Следующие шаги

См. **Task 2.2** в `tasks.md` - начать адаптацию Auth Module для SMS верификации.

---

**Дата:** 10 октября 2025  
**Версия:** 1.0.0  
**Автор:** AI Assistant (Claude Sonnet 4.5)





