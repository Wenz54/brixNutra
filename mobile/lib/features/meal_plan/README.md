# Meal Plan Feature

## 📋 Описание

Полнофункциональная система работы с планами питания и рецептами для Brix Nutrition с BLoC архитектурой.

### Возможности:
- ✅ Просмотр текущего плана питания
- ✅ План питания на конкретный день
- ✅ Замена блюд в плане
- ✅ Просмотр деталей рецепта
- ✅ Альтернативные рецепты (для замены)
- ✅ Каталог рецептов с фильтрами
- ✅ Mock режим для разработки UI без backend
- ✅ Готовая интеграция с Brix Nutrition API

---

## 🏗️ Архитектура

```
meal_plan/
├── bloc/
│   ├── meal_plan_bloc.dart       # Главная логика
│   ├── meal_plan_event.dart      # События (11 events)
│   └── meal_plan_state.dart      # Состояния (11 states)
├── models/
│   └── meal_plan_models.dart     # Модели данных
│       ├── Ingredient            # Ингредиент
│       ├── Recipe                # Рецепт
│       ├── MealSlot              # Слот приема пищи
│       ├── Supplement            # Добавка
│       ├── MealPlan              # План питания
│       └── DayPlan               # План на день
├── services/
│   └── meal_plan_service.dart    # API сервис (Mock + Real)
├── screens/                      # TODO: UI (Task 5.5)
├── widgets/                      # TODO: UI компоненты
├── meal_plan.dart                # Barrel file
└── README.md
```

---

## 🚀 Быстрый старт

### 1. Импорт
```dart
import 'package:mobile/features/meal_plan/meal_plan.dart';
```

### 2. Создание BLoC
```dart
BlocProvider(
  create: (context) => MealPlanBloc(),
  child: YourMealPlanScreen(),
)
```

### 3. Использование в UI
```dart
BlocBuilder<MealPlanBloc, MealPlanState>(
  builder: (context, state) {
    if (state is MealPlanLoading) {
      return CircularProgressIndicator();
    }
    
    if (state is CurrentPlanLoaded) {
      final plan = state.mealPlan;
      return MealPlanView(plan: plan);
    }
    
    if (state is DayPlanLoaded) {
      final dayPlan = state.dayPlan;
      return DayMealsView(dayPlan: dayPlan);
    }
    
    if (state is RecipeSelected) {
      return RecipeDetailView(recipe: state.recipe);
    }
    
    if (state is MealPlanError) {
      return ErrorView(message: state.message);
    }
    
    return InitialView();
  },
)
```

---

## 📖 Примеры использования

### Пример 1: Загрузка текущего плана

```dart
// Загрузить текущий план питания
void loadCurrentPlan(BuildContext context) {
  context.read<MealPlanBloc>().add(
    const LoadCurrentPlanRequested(),
  );
}

// Обработка результата
BlocListener<MealPlanBloc, MealPlanState>(
  listener: (context, state) {
    if (state is CurrentPlanLoaded) {
      final plan = state.mealPlan;
      print('План: ${plan.name}');
      print('День ${plan.currentDay} из ${plan.durationDays}');
      print('Приемов пищи: ${plan.meals.length}');
      print('Калорий: ${plan.totalCalories} ккал');
    }
  },
  child: ...,
)
```

### Пример 2: План на конкретный день

```dart
// Загрузить план на завтра
void loadTomorrowPlan(BuildContext context) {
  final tomorrow = DateTime.now().add(Duration(days: 1));
  
  context.read<MealPlanBloc>().add(
    LoadDayPlanRequested(tomorrow),
  );
}

// Отобразить приемы пищи
BlocBuilder<MealPlanBloc, MealPlanState>(
  builder: (context, state) {
    if (state is DayPlanLoaded) {
      return ListView.builder(
        itemCount: state.dayPlan.meals.length,
        itemBuilder: (context, index) {
          final meal = state.dayPlan.meals[index];
          return ListTile(
            title: Text(meal.recipe.name),
            subtitle: Text(
              '${meal.mealType.displayName} в ${meal.time} • ${meal.calories} ккал'
            ),
          );
        },
      );
    }
    return SizedBox();
  },
)
```

### Пример 3: Замена блюда

```dart
// Заменить блюдо в плане
void replaceMeal(BuildContext context, String slotId, String newRecipeId) {
  context.read<MealPlanBloc>().add(
    ReplaceMealRequested(
      mealSlotId: slotId,
      newRecipeId: newRecipeId,
    ),
  );
}

// Показать результат
BlocListener<MealPlanBloc, MealPlanState>(
  listener: (context, state) {
    if (state is MealReplaced) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: ...,
)
```

### Пример 4: Альтернативные рецепты

```dart
// Получить альтернативы для замены блюда
void loadAlternatives(BuildContext context, String recipeId, MealType mealType) {
  context.read<MealPlanBloc>().add(
    LoadRecipeAlternativesRequested(
      recipeId: recipeId,
      mealType: mealType,
    ),
  );
}

// Отобразить список альтернатив
BlocBuilder<MealPlanBloc, MealPlanState>(
  builder: (context, state) {
    if (state is RecipeAlternativesLoaded) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: state.alternatives.length,
        itemBuilder: (context, index) {
          final recipe = state.alternatives[index];
          return RecipeCard(recipe: recipe);
        },
      );
    }
    return SizedBox();
  },
)
```

### Пример 5: Фильтрация рецептов

```dart
// Загрузить вегетарианские рецепты для завтрака
void loadVegetarianBreakfast(BuildContext context) {
  context.read<MealPlanBloc>().add(
    LoadRecipesRequested(
      mealType: MealType.breakfast,
      isVegetarian: true,
      maxCalories: 400,
      limit: 10,
    ),
  );
}
```

---

## 🎭 Mock режим

### Включение/Отключение
В `services/meal_plan_service.dart`:
```dart
// true = Mock режим (для разработки UI)
// false = Real API (для production)
static const bool useMockMode = true;
```

### Mock данные
- **1 план питания** (7 дней, день 3)
- **6 приемов пищи** на день
- **2 добавки** (Витамин D3, Омега-3)
- **6 мок-рецептов** разных типов
- Все с полными КБЖУ данными

### Mock рецепты:
1. Овсяная каша с ягодами (завтрак, 350 ккал)
2. Куриная грудка с овощами (обед, 450 ккал)
3. Греческий йогурт с орехами (перекус, 250 ккал)
4. Лосось с киноа (обед, 520 ккал)
5. Протеиновый коктейль (перекус, 280 ккал)
6. Индейка с овощным салатом (ужин, 400 ккал)

---

## 📦 Модели данных

### MealType (Enum)
```dart
enum MealType {
  wakeup,          // Пробуждение
  breakfast,       // Завтрак
  snack,           // Перекус
  lunch,           // Обед
  afternoonSnack,  // Полдник
  dinner,          // Ужин
  sleep,           // Перед сном
}
```

### Recipe (Рецепт)
```dart
class Recipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int prepTime;              // минуты
  final int calories;              // ккал
  final double protein, carbs, fats; // граммы
  final List<Ingredient> ingredients;
  final List<String> steps;
  final List<String> tags;
  final MealType mealType;
  final bool isVegetarian, isVegan;
  final bool isGlutenFree, isDairyFree;
}
```

### MealSlot (Слот приема пищи)
```dart
class MealSlot {
  final String id;
  final MealType mealType;
  final String time;               // "08:00"
  final Recipe recipe;
  final int portionGrams;
  final int calories;
  final double protein, carbs, fats;
  final MealImportance importance; // required/recommended/optional
  final String? notes;
}
```

### MealPlan (План питания)
```dart
class MealPlan {
  final String id;
  final String name;
  final String description;
  final int durationDays;          // длительность
  final int currentDay;            // текущий день
  final List<MealSlot> meals;
  final List<Supplement>? supplements;
  final int totalCalories;
  final double totalProtein, totalCarbs, totalFats;
  final double progress;           // % (0-100)
  final DateTime startDate;
}
```

### DayPlan (План на день)
```dart
class DayPlan {
  final DateTime date;
  final int dayNumber;
  final List<MealSlot> meals;
  final int totalCalories;
  final double totalProtein, totalCarbs, totalFats;
}
```

---

## 🎯 События (Events)

| Событие | Параметры | Описание |
|---------|-----------|----------|
| `LoadCurrentPlanRequested` | - | Загрузить текущий план |
| `LoadDayPlanRequested` | date | План на конкретный день |
| `ReplaceMealRequested` | slotId, recipeId | Заменить блюдо |
| `LoadRecipeRequested` | recipeId | Детали рецепта |
| `LoadRecipeAlternativesRequested` | recipeId, mealType | Альтернативы |
| `LoadRecipesRequested` | filters, limit | Каталог рецептов |
| `SelectRecipeRequested` | recipe | Выбрать рецепт |
| `ClearSelectedRecipe` | - | Очистить выбор |
| `ResetMealPlanState` | - | Сброс состояния |

---

## 📊 Состояния (States)

| Состояние | Описание |
|-----------|----------|
| `MealPlanInitial` | Начальное состояние |
| `MealPlanLoading` | Загрузка данных |
| `CurrentPlanLoaded` | Текущий план загружен |
| `DayPlanLoaded` | План на день загружен |
| `MealReplaced` | Блюдо заменено |
| `RecipeLoaded` | Рецепт загружен |
| `RecipeAlternativesLoaded` | Альтернативы загружены |
| `RecipesLoaded` | Список рецептов загружен |
| `RecipeSelected` | Рецепт выбран |
| `MealPlanError` | Ошибка |

---

## 🔄 Типичные флоу

### Флоу 1: Просмотр плана и замена блюда
```
1. LoadCurrentPlanRequested
   ↓
2. CurrentPlanLoaded (план + 6 приемов пищи)
   ↓
3. User выбирает прием пищи
   ↓
4. LoadRecipeAlternativesRequested
   ↓
5. RecipeAlternativesLoaded (3-5 альтернатив)
   ↓
6. User выбирает новый рецепт
   ↓
7. ReplaceMealRequested
   ↓
8. MealReplaced ✅
```

### Флоу 2: Просмотр плана на неделю
```
1. LoadDayPlanRequested(date: today)
   ↓
2. DayPlanLoaded (день 1)
   ↓
3. User свайпает влево
   ↓
4. LoadDayPlanRequested(date: tomorrow)
   ↓
5. DayPlanLoaded (день 2)
```

---

## 📚 API Интеграция

Backend endpoints (Brix Nutrition):
- ✅ `GET /api/meal-plan/current` - Текущий план
- ✅ `GET /api/meal-plan/day/:date` - План на день
- ✅ `POST /api/meal-plan/replace` - Замена блюда
- ✅ `GET /api/recipes` - Каталог рецептов
- ✅ `GET /api/recipes/:id` - Детали рецепта
- ✅ `GET /api/recipes/:id/alternatives` - Альтернативы

---

## ✅ TODO (Task 5.5)

- [ ] Создать UI экраны (`screens/`)
  - [ ] `meal_plan_screen.dart` - главный экран плана
  - [ ] `day_meals_screen.dart` - приемы пищи на день
  - [ ] `recipe_detail_screen.dart` - детали рецепта
  - [ ] `recipe_alternatives_screen.dart` - выбор альтернатив
  - [ ] `recipes_catalog_screen.dart` - каталог рецептов
- [ ] Создать UI компоненты (`widgets/`)
  - [ ] `meal_slot_card.dart` - карточка приема пищи
  - [ ] `recipe_card.dart` - карточка рецепта
  - [ ] `ingredient_list_widget.dart` - список ингредиентов
  - [ ] `cooking_steps_widget.dart` - шаги приготовления
  - [ ] `nutrition_info_widget.dart` - КБЖУ информация
  - [ ] `meal_type_filter.dart` - фильтр по типу приема пищи

---

## 🧪 Тестирование

```dart
// Проверка что Mock режим работает
void testMockMealPlan() async {
  // 1. Получить текущий план
  final plan = await MealPlanService.getCurrentPlan();
  print('✅ План: ${plan.name}');
  print('   Дней: ${plan.durationDays}');
  print('   Приемов пищи: ${plan.meals.length}');
  print('   Калорий: ${plan.totalCalories} ккал');
  
  // 2. План на сегодня
  final dayPlan = await MealPlanService.getPlanForDay(DateTime.now());
  print('✅ День ${dayPlan.dayNumber}: ${dayPlan.meals.length} приемов');
  
  // 3. Альтернативы для рецепта
  final alternatives = await MealPlanService.getRecipeAlternatives(
    recipeId: 'recipe_1',
    mealType: MealType.breakfast,
  );
  print('✅ Альтернатив: ${alternatives.length}');
}
```

---

## 💡 Полезные утилиты

### Фильтрация рецептов по калориям
```dart
final lowCalorieRecipes = recipes.where((r) => r.calories < 300).toList();
```

### Подсчет КБЖУ для дня
```dart
final totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
final totalProtein = meals.fold(0.0, (sum, meal) => sum + meal.protein);
```

### Группировка по типу приема пищи
```dart
final breakfastMeals = meals.where((m) => 
  m.mealType == MealType.breakfast
).toList();
```

---

## 🎉 Готово!

Meal Plan Feature полностью реализован и готов к использованию.

**Текущий статус:**
- ✅ Models (6 классов + 2 enums)
- ✅ Service (Mock + Real API готов)
- ✅ BLoC (11 Events + 11 States + Bloc)
- ✅ Barrel file
- ✅ Документация
- ⏳ UI Screens (Task 5.5)

**Переключение на Real API:**
Измени `useMockMode = false` в `meal_plan_service.dart` когда backend будет готов.

---

**Task 3.4 COMPLETED! ✅**




