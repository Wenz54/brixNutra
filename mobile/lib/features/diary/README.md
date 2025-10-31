# 📔 Diary Feature

Модуль дневника питания для Brix Nutrition App.

## 📋 Описание

Diary Feature предоставляет полный функционал для ведения дневника питания:
- 📊 Отслеживание приемов пищи с полными КБЖУ
- 💧 Учет потребления воды
- 😊 Отметки настроения
- 🎯 Управление дневными целями
- 📈 История за прошлые дни
- ✅ Завершение дней

## 🗂️ Структура

```
features/diary/
├── models/
│   └── diary_models.dart          # Модели данных
├── services/
│   └── diary_service.dart         # API сервис (Mock + Real)
├── bloc/
│   ├── diary_event.dart           # События BLoC
│   ├── diary_state.dart           # Состояния BLoC
│   └── diary_bloc.dart            # Основной BLoC
├── diary.dart                     # Barrel file (экспорты)
└── README.md                      # Документация
```

## 📦 Models

### DiaryDay
Полная информация о дне дневника:
```dart
class DiaryDay {
  final DateTime date;
  final List<DiaryMeal> meals;          // Список приемов пищи
  final WaterLog waterLog;              // Вода за день
  final DailyGoals goals;               // Цели дня
  final DailyStats stats;               // Текущая статистика
  final int? moodRating;                // Настроение (1-5)
  final bool isCompleted;               // Завершен ли день
  final String? notes;                  // Заметки
}
```

**Доп. методы:**
- `caloriesProgress` - прогресс по калориям (0.0 - 1.0+)
- `proteinProgress`, `carbsProgress`, `fatsProgress` - прогресс по БЖУ
- `getMealsByType(String)` - приемы пищи по типу
- `mealsFromPlan` - приемы из плана питания
- `manualMeals` - ручные приемы

### DiaryMeal
Прием пищи:
```dart
class DiaryMeal {
  final String id;
  final String mealName;
  final String mealType;               // breakfast, lunch, dinner, snack
  final DateTime consumedAt;           // Время приема
  final int portionGrams;              // Порция
  final int calories;                  // Калории
  final double protein, carbs, fats;   // КБЖУ
  final String? photoUrl;              // Фото блюда
  final bool fromPlan;                 // Из плана?
  final String? recipeId;              // ID рецепта
}
```

### WaterLog
Вода за день:
```dart
class WaterLog {
  final DateTime date;
  final int totalAmount;               // мл
  final int dailyGoal;                 // цель (мл)
  
  double get progress;                 // 0.0 - 1.0
  double get liters;                   // в литрах
  int get percentComplete;             // 0-100%
}
```

### DailyGoals
Цели дня:
```dart
class DailyGoals {
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
}
```

### DailyStats
Текущая статистика:
```dart
class DailyStats {
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final int mealsCount;
  
  // Подсчет из приемов пищи
  factory DailyStats.fromMeals(List<DiaryMeal> meals);
}
```

### DiaryHistoryItem
Краткая информация о дне (для списка):
```dart
class DiaryHistoryItem {
  final DateTime date;
  final int totalCalories;
  final int goalCalories;
  final int mealsCount;
  final bool isCompleted;
  final int? moodRating;
}
```

## 🔌 Service API

### DiaryService

**Режим работы:**
```dart
static const bool useMockMode = true; // Mock режим для разработки
```

**Методы:**

#### Дневник дня
```dart
// Получить дневник за день
Future<DiaryDay> getDayDiary(DateTime date)

// Получить историю
Future<List<DiaryHistoryItem>> getHistory({
  DateTime? startDate,
  DateTime? endDate,
  int limit = 30,
})
```

#### Приемы пищи
```dart
// Добавить прием пищи
Future<DiaryMeal> addMeal({
  required String mealName,
  required String mealType,
  required DateTime consumedAt,
  required int portionGrams,
  int? calories,
  double? protein,
  double? carbs,
  double? fats,
  File? photo,
  bool fromPlan = false,
  String? recipeId,
})

// Удалить прием пищи
Future<void> deleteMeal(String mealId)
```

#### Вода
```dart
// Обновить воду (increment может быть отрицательным)
Future<WaterLog> updateWater({
  required DateTime date,
  required int increment, // +250мл или -100мл
})
```

#### Настроение и цели
```dart
// Обновить настроение
Future<void> updateMood({
  required DateTime date,
  required int rating, // 1-5
})

// Завершить день
Future<void> completeDay(DateTime date)

// Обновить цели
Future<DailyGoals> updateDailyGoals({
  required DateTime date,
  required DailyGoals goals,
})
```

## 🧠 BLoC Architecture

### Events

```dart
// Загрузка данных
LoadDayDiaryRequested(DateTime date)
LoadDiaryHistoryRequested({startDate, endDate, limit})

// Приемы пищи
AddMealRequested({mealName, mealType, ...})
DeleteMealRequested(String mealId)

// Вода
AddWaterRequested({date, amount})
RemoveWaterRequested({date, amount})

// Настроение и день
UpdateMoodRequested({date, rating})
CompleteDayRequested(DateTime date)
UpdateDailyGoalsRequested({date, goals})

// Утилиты
ResetDiaryState()
```

### States

```dart
// Начальное
DiaryInitial()

// Загрузка
DiaryLoading({message})

// Успех - Дневник дня
DayDiaryLoaded(DiaryDay diaryDay)

// Успех - История
DiaryHistoryLoaded(List<DiaryHistoryItem> history)

// Успех - Действия
MealAdded({meal, message})
MealDeleted({mealId, message})
WaterUpdated({waterLog, message})
MoodUpdated({rating, message})
DayCompleted({date, message})
DailyGoalsUpdated({goals, message})

// Ошибка
DiaryError({message, code})
```

## 💡 Использование

### Базовое использование

```dart
import 'package:mobile/features/diary/diary.dart';

// 1. Создать BLoC
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiaryBloc>(
      create: (context) => DiaryBloc()
        ..add(LoadDayDiaryRequested(DateTime.now())),
      child: MyWidget(),
    );
  }
}

// 2. Использовать в виджете
class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryBloc, DiaryState>(
      builder: (context, state) {
        if (state is DiaryLoading) {
          return CircularProgressIndicator();
        }
        
        if (state is DayDiaryLoaded) {
          final day = state.diaryDay;
          return Column(
            children: [
              Text('Калории: ${day.stats.totalCalories}/${day.goals.calories}'),
              Text('Вода: ${day.waterLog.totalAmount}мл'),
              Text('Приемов пищи: ${day.meals.length}'),
            ],
          );
        }
        
        if (state is DiaryError) {
          return Text('Ошибка: ${state.message}');
        }
        
        return SizedBox.shrink();
      },
    );
  }
}
```

### Добавить прием пищи

```dart
// Ручное добавление
context.read<DiaryBloc>().add(AddMealRequested(
  mealName: 'Овсянка с ягодами',
  mealType: 'breakfast',
  consumedAt: DateTime.now(),
  portionGrams: 300,
  calories: 350,
  protein: 12.0,
  carbs: 55.0,
  fats: 8.0,
));

// Из плана питания
context.read<DiaryBloc>().add(AddMealRequested(
  mealName: 'Куриная грудка',
  mealType: 'lunch',
  consumedAt: DateTime.now(),
  portionGrams: 200,
  fromPlan: true,
  recipeId: 'recipe_123',
));
```

### Управление водой

```dart
// Добавить стакан воды (250мл)
context.read<DiaryBloc>().add(AddWaterRequested(
  date: DateTime.now(),
  amount: 250,
));

// Убрать 100мл (ошибочно добавили)
context.read<DiaryBloc>().add(RemoveWaterRequested(
  date: DateTime.now(),
  amount: 100,
));
```

### Обновить настроение

```dart
context.read<DiaryBloc>().add(UpdateMoodRequested(
  date: DateTime.now(),
  rating: 5, // 😄 отличное настроение
));
```

### История дневника

```dart
// Загрузить последние 7 дней
context.read<DiaryBloc>().add(LoadDiaryHistoryRequested(
  limit: 7,
));

// Обработка
BlocBuilder<DiaryBloc, DiaryState>(
  builder: (context, state) {
    if (state is DiaryHistoryLoaded) {
      return ListView.builder(
        itemCount: state.history.length,
        itemBuilder: (context, index) {
          final item = state.history[index];
          return ListTile(
            title: Text(item.date.toString().split(' ')[0]),
            subtitle: Text('${item.totalCalories}/${item.goalCalories} ккал'),
            trailing: item.isCompleted 
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.pending, color: Colors.grey),
          );
        },
      );
    }
    return SizedBox.shrink();
  },
)
```

## 🎭 Mock данные

Mock режим включает:
- **Приемы пищи:**
  - Овсяная каша с ягодами (350 ккал)
  - Греческий йогурт с орехами (250 ккал)
- **Вода:** 1200мл / 2000мл
- **Цели:** 1800 ккал, 120г белка, 180г углеводов, 60г жиров
- **История:** 7 дней с разными данными

## 🔄 Переключение в Real API

В файле `diary_service.dart`:
```dart
static const bool useMockMode = false; // Переключить на false
```

Backend endpoints:
- `GET /api/diary/day/:date` - дневник за день
- `GET /api/diary/history` - история
- `POST /api/diary/meal` - добавить прием
- `DELETE /api/diary/meal/:id` - удалить
- `POST /api/diary/water` - обновить воду
- `PATCH /api/diary/mood` - настроение
- `PUT /api/diary/day-status` - завершить день
- `PUT /api/diary/goals/:date` - обновить цели

## ✅ Features

- ✅ Полная BLoC архитектура
- ✅ Mock режим для UI разработки
- ✅ Real API интеграция готова
- ✅ Все модели с Equatable
- ✅ fromJson/toJson для всех моделей
- ✅ Подробное логирование
- ✅ Обработка ошибок
- ✅ Автоматический подсчет статистики
- ✅ Прогресс по всем метрикам
- ✅ Фильтрация приемов пищи
- ✅ История дней
- ✅ Настроение дня
- ✅ Завершение дней
- ✅ Обновление целей

## 🎨 UI Примеры

### Карточка дня
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        // Прогресс калорий
        LinearProgressIndicator(
          value: day.caloriesProgress,
        ),
        Text('${day.stats.totalCalories} / ${day.goals.calories} ккал'),
        
        // Прогресс БЖУ
        Row(
          children: [
            _MacroProgress('Белки', day.proteinProgress),
            _MacroProgress('Углеводы', day.carbsProgress),
            _MacroProgress('Жиры', day.fatsProgress),
          ],
        ),
        
        // Вода
        Row(
          children: [
            Icon(Icons.water_drop),
            Text('${day.waterLog.totalAmount}мл'),
            LinearProgressIndicator(value: day.waterLog.progress),
          ],
        ),
      ],
    ),
  ),
)
```

## 📝 TODO

- [ ] UI экраны (будут в Task 4.x)
- [ ] Фото загрузка для приемов пищи
- [ ] Автоматическое добавление из плана
- [ ] Push уведомления о времени приема
- [ ] Графики статистики
- [ ] Экспорт данных

## 🔗 Связанные модули

- `meal_plan` - интеграция с планами питания
- `core_module` - ApiService
- `auth_module` - авторизация пользователя

---

**Создано:** 14 октября 2025  
**Версия:** 1.0.0  
**Task:** 3.5




