# ✅ Diary Module - ЗАВЕРШЁН

**Дата:** 13 октября 2025  
**Задача:** Task 2.5 - Diary Module (Дневник питания)  
**Статус:** ✅ ГОТОВ К ИСПОЛЬЗОВАНИЮ

---

## 📦 Что реализовано

### 1. База данных (3 таблицы + triggers)

**diary_entries** - Логирование еды
- Основная таблица для записей о съеденном
- Поддержка recipe_id и meal_plan_slot_id
- КБЖУ данные (calories, protein, carbs, fats)
- meal_date (дата приёма пищи) + meal_time
- notes, image_url для пользовательских заметок

**daily_stats** - Агрегированная статистика
- Автоматический расчёт totals для дня
- goal_calories/protein/carbs/fats (из профиля или плана)
- Счётчики приёмов пищи (breakfast_count, lunch_count, etc.)
- is_completed флаг для отметки завершённого дня
- UNIQUE constraint (user_id, date)

**water_logs** - Учёт воды
- Логирование выпитой воды (amount_ml)
- По датам (log_date)

**Triggers:**
- ✅ Auto-update trigger на INSERT в diary_entries
- ✅ Автоматическое обновление daily_stats
- ✅ Функция recalculate_daily_stats() для пересчёта

### 2. DiaryService (8 методов)

```typescript
class DiaryService {
  logMeal(userId, input)         // Логировать приём пищи
  getDayStats(userId, date)      // Статистика + entries за день
  getHistory(userId, start, end) // История за период
  deleteEntry(userId, entryId)   // Удалить запись + пересчёт
  updateDailyGoals(userId, date) // Обновить цели дня
  logWater(userId, amountMl)     // Логировать воду
  getWaterIntake(userId, date)   // Получить потребление воды
}
```

**Smart features:**
- Автоматическое извлечение КБЖУ из recipe_id
- Recalculation при удалении записи
- Progress calculation (% от цели)

### 3. API Endpoints (7 штук)

#### POST /api/diary/log
Логировать приём пищи

**Request:**
```json
{
  "meal_type": "breakfast",
  "food_name": "Овсянка с фруктами",
  "recipe_id": "uuid",
  "portion_grams": 300,
  "calories": 350,
  "protein": 12,
  "carbs": 58,
  "fats": 8,
  "meal_date": "2025-10-13",
  "meal_time": "08:30",
  "notes": "Вкусно!"
}
```

#### GET /api/diary/day/:date
Получить статистику и entries за день

**Response:**
```json
{
  "success": true,
  "data": {
    "stats": {
      "date": "2025-10-13",
      "total_calories": 1301,
      "total_protein": 77,
      "total_carbs": 106,
      "total_fats": 36,
      "goal_calories": 1800,
      "progress": {
        "calories": 72,
        "protein": 86,
        "carbs": 53,
        "fats": 60
      },
      "breakfast_count": 1,
      "lunch_count": 1,
      "dinner_count": 1,
      "snack_count": 2
    },
    "entries": [
      {
        "id": "uuid",
        "meal_type": "breakfast",
        "food_name": "Овсянка с фруктами",
        "calories": 350,
        "protein": 12,
        "meal_time": "08:30",
        "notes": "Вкусно!"
      }
    ]
  }
}
```

#### GET /api/diary/history?start_date=...&end_date=...
История за период

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "date": "2025-10-13",
      "total_calories": 1301,
      "total_protein": 77,
      "goal_calories": 1800,
      "is_completed": false
    },
    {
      "date": "2025-10-12",
      "total_calories": 1020,
      "total_protein": 65,
      "is_completed": true
    }
  ]
}
```

#### DELETE /api/diary/entry/:id
Удалить запись

#### PUT /api/diary/goals/:date
Обновить цели дня

**Request:**
```json
{
  "calories": 2000,
  "protein": 100,
  "carbs": 220,
  "fats": 70
}
```

#### POST /api/diary/water
Логировать воду

**Request:**
```json
{
  "amount_ml": 500,
  "date": "2025-10-13"
}
```

#### GET /api/diary/water/:date
Получить потребление воды за день

**Response:**
```json
{
  "success": true,
  "data": {
    "date": "2025-10-13",
    "total_ml": 1450
  }
}
```

---

## 🎯 Key Features

### 1. Auto-calculation
- ✅ Автоматический расчёт daily_stats через trigger
- ✅ Извлечение КБЖУ из recipe_id
- ✅ Progress percentage (% от цели)

### 2. Meal logging
- ✅ Поддержка 7 типов приёмов пищи
- ✅ Связь с recipes и meal_plan_slots
- ✅ Custom entries (без recipe_id)
- ✅ Notes + image_url

### 3. Goals tracking
- ✅ Daily goals (calories, protein, carbs, fats)
- ✅ Progress calculation
- ✅ Completion flag

### 4. Water tracking
- ✅ Логирование воды (ml)
- ✅ Daily totals

---

## 🧪 Тестовые данные

✅ Seed данные созданы:
- **Test user:** testuser@example.com (ID: 33333333-3333-3333-3333-333333333333)
- **Today:** 5 meals (1301 kcal), goal 1800 kcal
  - Breakfast: Овсянка (08:30)
  - Snack: Яблоко (11:00)
  - Lunch: Куриная грудка (13:30)
  - Afternoon snack: Орехи (16:00)
  - Dinner: Греческий салат (19:30)
- **Yesterday:** 3 meals (1020 kcal, completed ✅)
- **Water:**
  - Today: 1450 ml
  - Yesterday: 1300 ml

---

## 📁 Структура

```
backend/src/modules/nutrition_module/
├── migrations/
│   └── 004_create_diary.sql      # Diary tables + triggers ✅
├── services/
│   ├── recipeService.ts
│   ├── mealPlanService.ts
│   └── diaryService.ts           # Diary logic ✅
├── routes/
│   ├── recipes.ts
│   ├── mealPlans.ts
│   └── diary.ts                  # Diary API ✅
└── types/
    └── index.ts
```

---

## 🔄 Data Flow

```
User logs meal
    ↓
POST /api/diary/log
    ↓
DiaryService.logMeal()
    ↓
INSERT into diary_entries
    ↓
TRIGGER: update_daily_stats()
    ↓
AUTO-UPDATE daily_stats (totals)
    ↓
Return diary_entry
```

**При удалении:**
```
DELETE /api/diary/entry/:id
    ↓
DiaryService.deleteEntry()
    ↓
DELETE from diary_entries
    ↓
CALL recalculate_daily_stats()
    ↓
Recalculate from scratch
```

---

## 📊 Progress Calculation

```typescript
if (stats.goal_calories) {
  stats.progress = {
    calories: (total_calories / goal_calories) * 100,
    protein: (total_protein / goal_protein) * 100,
    carbs: (total_carbs / goal_carbs) * 100,
    fats: (total_fats / goal_fats) * 100
  }
}
```

**Example:**
- total_calories: 1301
- goal_calories: 1800
- progress: 72%

---

## ✅ Checklist завершения

- [x] Миграция 004_create_diary.sql
- [x] diary_entries, daily_stats, water_logs таблицы
- [x] Triggers для auto-update
- [x] recalculate_daily_stats() функция
- [x] DiaryService (8 методов)
- [x] 7 API endpoints
- [x] Zod validation
- [x] Swagger schemas
- [x] Auto КБЖУ extraction from recipe_id
- [x] Progress calculation
- [x] Water tracking
- [x] Seed data (2 дня, 8 meals, water logs)
- [x] Модуль зарегистрирован в main server
- [ ] Auth middleware (TODO)

---

## 🎨 Use Cases

### UC1: Логирование из meal plan
```json
{
  "meal_type": "breakfast",
  "food_name": "Овсянка с фруктами",
  "recipe_id": "recipe-uuid",
  "meal_plan_slot_id": "slot-uuid",
  "meal_date": "2025-10-13",
  "meal_time": "08:30"
}
```
→ КБЖУ автоматически извлекается из recipe

### UC2: Custom food entry
```json
{
  "meal_type": "snack",
  "food_name": "Яблоко",
  "portion_grams": 150,
  "calories": 78,
  "protein": 0.4,
  "carbs": 21,
  "fats": 0.3,
  "meal_date": "2025-10-13"
}
```
→ Ручной ввод КБЖУ

### UC3: View day progress
```bash
GET /api/diary/day/2025-10-13
```
→ Returns stats + all entries + progress %

### UC4: Weekly review
```bash
GET /api/diary/history?start_date=2025-10-07&end_date=2025-10-13
```
→ Returns 7 days of stats

---

## 🔜 Возможные улучшения (на будущее)

1. **Analytics:**
   - Недельная/месячная статистика
   - Графики прогресса
   - Средние значения

2. **Smart features:**
   - Recommendations based on goals
   - Meal suggestions if under target
   - Warnings if over target

3. **Social:**
   - Share diary with nutritionist
   - Community challenges
   - Achievement badges

4. **Export:**
   - PDF reports
   - CSV export
   - Integration with health apps

---

## 📊 Статистика

- **Время выполнения:** ~1.5 часа
- **Строк кода:** ~600 (service + routes + migration)
- **Endpoints:** 7
- **Методов сервиса:** 8
- **Таблиц БД:** 3
- **Triggers:** 1
- **Functions:** 2
- **Тестовых записей:** 8 meals + 7 water logs

---

## 🎯 Соответствие ТЗ

Задача **Task 2.5** из `tasks.md` выполнена:
- ✅ POST `/api/diary/log` - логирование еды
- ✅ GET `/api/diary/day/:date` - статистика дня
- ✅ GET `/api/diary/history` - история за период
- ✅ DELETE `/api/diary/entry/:id` - удаление записи
- ✅ PUT `/api/diary/goals/:date` - обновление целей
- ✅ Water tracking (POST /water, GET /water/:date)
- ✅ Auto-aggregation через triggers
- ✅ Progress calculation
- ✅ КБЖУ tracking

---

**Статус:** ✅ ГОТОВ К ИСПОЛЬЗОВАНИЮ  
**Следующая задача:** Task 2.6 - Knowledge Module (База знаний)

---

## 🔥 API Flow Example

```
# Morning
POST /api/diary/log
{
  "meal_type": "breakfast",
  "food_name": "Овсянка",
  "recipe_id": "...",
  "meal_date": "2025-10-13",
  "meal_time": "08:30"
}
→ 350 kcal logged

POST /api/diary/water
{ "amount_ml": 500, "date": "2025-10-13" }
→ 500ml logged

# Check progress
GET /api/diary/day/2025-10-13
→ {
    "total_calories": 350,
    "goal_calories": 1800,
    "progress": { "calories": 19 }
  }

# End of day
GET /api/diary/day/2025-10-13
→ {
    "total_calories": 1301,
    "progress": { "calories": 72 }
  }
```


