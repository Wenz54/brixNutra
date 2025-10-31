import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/meal_plan/models/meal_plan_models.dart';

/// Сервис для работы с планами питания и рецептами
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class MealPlanService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== MEAL PLAN ====================

  /// Получить текущий активный план питания пользователя
  static Future<MealPlan> getCurrentPlan() async {
    try {
      if (useMockMode) {
        return _mockGetCurrentPlan();
      }

      // Реальный API запрос
      final response = await ApiService.get(ApiEndpoints.mealPlanCurrent);
      return MealPlan.fromJson(response['data']);
    } catch (e) {
      print('❌ getCurrentPlan error: $e');
      rethrow;
    }
  }

  /// Получить план питания на конкретный день
  ///
  /// [date] - дата в формате DateTime
  static Future<DayPlan> getPlanForDay(DateTime date) async {
    try {
      if (useMockMode) {
        return _mockGetPlanForDay(date);
      }

      // Реальный API запрос
      final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD
      final response = await ApiService.get(
        ApiEndpoints.mealPlanDay(dateStr),
      );
      return DayPlan.fromJson(response['data']);
    } catch (e) {
      print('❌ getPlanForDay error: $e');
      rethrow;
    }
  }

  /// Заменить блюдо в плане питания
  ///
  /// [mealSlotId] - ID слота приема пищи
  /// [newRecipeId] - ID нового рецепта
  ///
  /// Возвращает обновленный MealSlot
  static Future<MealSlot> replaceMeal({
    required String mealSlotId,
    required String newRecipeId,
  }) async {
    try {
      if (useMockMode) {
        return _mockReplaceMeal(mealSlotId: mealSlotId, newRecipeId: newRecipeId);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.mealPlanReplace,
        {
          'meal_slot_id': mealSlotId,
          'new_recipe_id': newRecipeId,
        },
      );
      return MealSlot.fromJson(response['data']);
    } catch (e) {
      print('❌ replaceMeal error: $e');
      rethrow;
    }
  }

  // ==================== RECIPES ====================

  /// Получить рецепт по ID
  ///
  /// [recipeId] - ID рецепта
  static Future<Recipe> getRecipe(String recipeId) async {
    try {
      if (useMockMode) {
        return _mockGetRecipe(recipeId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.recipe(recipeId),
      );
      return Recipe.fromJson(response['data']);
    } catch (e) {
      print('❌ getRecipe error: $e');
      rethrow;
    }
  }

  /// Получить альтернативные рецепты (для замены блюда)
  ///
  /// [recipeId] - ID текущего рецепта
  /// [mealType] - тип приема пищи (опционально)
  ///
  /// Возвращает список похожих рецептов (по meal_type, калориям ±20%)
  static Future<List<Recipe>> getRecipeAlternatives({
    required String recipeId,
    MealType? mealType,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetRecipeAlternatives(recipeId: recipeId, mealType: mealType);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.recipeAlternatives(recipeId),
        queryParameters: mealType != null ? {'meal_type': mealType.value} : null,
      );
      return (response['data'] as List)
          .map((r) => Recipe.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getRecipeAlternatives error: $e');
      rethrow;
    }
  }

  /// Получить список рецептов с фильтрами
  ///
  /// [mealType] - тип приема пищи
  /// [isVegetarian] - вегетарианские рецепты
  /// [maxCalories] - максимальная калорийность
  /// [limit] - лимит результатов
  static Future<List<Recipe>> getRecipes({
    MealType? mealType,
    bool? isVegetarian,
    int? maxCalories,
    int limit = 20,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetRecipes(
          mealType: mealType,
          isVegetarian: isVegetarian,
          maxCalories: maxCalories,
          limit: limit,
        );
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      
      if (mealType != null) {
        queryParams['meal_type'] = mealType.value;
      }
      if (isVegetarian != null) {
        queryParams['is_vegetarian'] = isVegetarian.toString();
      }
      if (maxCalories != null) {
        queryParams['max_calories'] = maxCalories.toString();
      }

      final response = await ApiService.get(
        ApiEndpoints.recipes,
        queryParameters: queryParams,
      );
      
      return (response['data'] as List)
          .map((r) => Recipe.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getRecipes error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  static Future<MealPlan> _mockGetCurrentPlan() async {
    print('🎭 MOCK: Получение текущего плана питания');
    await Future.delayed(const Duration(milliseconds: 800));

    return MealPlan(
      id: 'plan_1',
      name: 'Здоровое питание на неделю',
      description: 'Сбалансированный план на 7 дней для похудения',
      durationDays: 7,
      currentDay: 3,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      meals: _mockMealsForToday(),
      supplements: [
        const Supplement(
          id: 'sup_1',
          name: 'Витамин D3',
          dosage: '2000 МЕ',
          time: '08:00',
          notes: 'С завтраком',
        ),
        const Supplement(
          id: 'sup_2',
          name: 'Омега-3',
          dosage: '1 капсула',
          time: '20:00',
          notes: 'С ужином',
        ),
      ],
      totalCalories: 1800,
      totalProtein: 120.0,
      totalCarbs: 180.0,
      totalFats: 60.0,
      progress: 42.86, // 3/7 дней
    );
  }

  static Future<DayPlan> _mockGetPlanForDay(DateTime date) async {
    print('🎭 MOCK: Получение плана на день: ${date.toIso8601String().split('T')[0]}');
    await Future.delayed(const Duration(milliseconds: 600));

    final dayNumber = date.difference(DateTime.now()).inDays + 3;

    return DayPlan(
      date: date,
      dayNumber: dayNumber > 0 ? dayNumber : 1,
      meals: _mockMealsForToday(),
      totalCalories: 1800,
      totalProtein: 120.0,
      totalCarbs: 180.0,
      totalFats: 60.0,
    );
  }

  static Future<MealSlot> _mockReplaceMeal({
    required String mealSlotId,
    required String newRecipeId,
  }) async {
    print('🎭 MOCK: Замена блюда: slot=$mealSlotId, новый рецепт=$newRecipeId');
    await Future.delayed(const Duration(milliseconds: 800));

    // Создаем новый slot с замененным рецептом
    return MealSlot(
      id: mealSlotId,
      mealType: MealType.lunch,
      time: '13:00',
      recipe: _mockRecipes[1], // Новый рецепт
      portionGrams: 300,
      calories: 450,
      protein: 35.0,
      carbs: 45.0,
      fats: 18.0,
      importance: MealImportance.required,
      notes: 'Замененное блюдо',
    );
  }

  static Future<Recipe> _mockGetRecipe(String recipeId) async {
    print('🎭 MOCK: Получение рецепта: $recipeId');
    await Future.delayed(const Duration(milliseconds: 500));

    // Возвращаем первый мок-рецепт
    return _mockRecipes.first;
  }

  static Future<List<Recipe>> _mockGetRecipeAlternatives({
    required String recipeId,
    MealType? mealType,
  }) async {
    print('🎭 MOCK: Получение альтернатив для рецепта: $recipeId, type: $mealType');
    await Future.delayed(const Duration(milliseconds: 700));

    // Возвращаем 3-5 похожих рецептов
    return _mockRecipes.take(3).toList();
  }

  static Future<List<Recipe>> _mockGetRecipes({
    MealType? mealType,
    bool? isVegetarian,
    int? maxCalories,
    int limit = 20,
  }) async {
    print('🎭 MOCK: Получение рецептов: type=$mealType, veg=$isVegetarian, limit=$limit');
    await Future.delayed(const Duration(milliseconds: 600));

    // Фильтрация по типу приема пищи
    var filtered = _mockRecipes;
    if (mealType != null) {
      filtered = filtered.where((r) => r.mealType == mealType).toList();
    }
    if (isVegetarian == true) {
      filtered = filtered.where((r) => r.isVegetarian).toList();
    }
    if (maxCalories != null) {
      filtered = filtered.where((r) => r.calories <= maxCalories).toList();
    }

    return filtered.take(limit).toList();
  }

  // ==================== MOCK DATA ====================

  static List<MealSlot> _mockMealsForToday() {
    return [
      MealSlot(
        id: 'slot_1',
        mealType: MealType.wakeup,
        time: '07:00',
        recipe: _mockRecipes[0],
        portionGrams: 200,
        calories: 150,
        protein: 5.0,
        carbs: 30.0,
        fats: 2.0,
        importance: MealImportance.recommended,
      ),
      MealSlot(
        id: 'slot_2',
        mealType: MealType.breakfast,
        time: '08:30',
        recipe: _mockRecipes[1],
        portionGrams: 350,
        calories: 450,
        protein: 25.0,
        carbs: 55.0,
        fats: 15.0,
        importance: MealImportance.required,
      ),
      MealSlot(
        id: 'slot_3',
        mealType: MealType.snack,
        time: '11:00',
        recipe: _mockRecipes[2],
        portionGrams: 150,
        calories: 200,
        protein: 15.0,
        carbs: 20.0,
        fats: 8.0,
        importance: MealImportance.optional,
      ),
      MealSlot(
        id: 'slot_4',
        mealType: MealType.lunch,
        time: '13:30',
        recipe: _mockRecipes[3],
        portionGrams: 400,
        calories: 550,
        protein: 40.0,
        carbs: 50.0,
        fats: 20.0,
        importance: MealImportance.required,
      ),
      MealSlot(
        id: 'slot_5',
        mealType: MealType.afternoonSnack,
        time: '16:00',
        recipe: _mockRecipes[4],
        portionGrams: 100,
        calories: 150,
        protein: 8.0,
        carbs: 15.0,
        fats: 6.0,
        importance: MealImportance.recommended,
      ),
      MealSlot(
        id: 'slot_6',
        mealType: MealType.dinner,
        time: '19:00',
        recipe: _mockRecipes[5],
        portionGrams: 350,
        calories: 400,
        protein: 35.0,
        carbs: 30.0,
        fats: 15.0,
        importance: MealImportance.required,
      ),
    ];
  }

  static final List<Recipe> _mockRecipes = [
    Recipe(
      id: 'recipe_1',
      name: 'Овсяная каша с ягодами',
      description: 'Полезный завтрак с овсянкой, свежими ягодами и медом',
      imageUrl: 'https://via.placeholder.com/300x200?text=Oatmeal',
      prepTime: 10,
      calories: 350,
      protein: 12.0,
      carbs: 55.0,
      fats: 8.0,
      ingredients: const [
        Ingredient(name: 'Овсяные хлопья', amount: 60, unit: 'г'),
        Ingredient(name: 'Молоко', amount: 200, unit: 'мл'),
        Ingredient(name: 'Ягоды микс', amount: 80, unit: 'г'),
        Ingredient(name: 'Мед', amount: 10, unit: 'г'),
      ],
      steps: const [
        'Залить овсянку молоком',
        'Варить 5-7 минут',
        'Добавить ягоды и мед',
        'Подавать теплой',
      ],
      tags: const ['завтрак', 'полезно', 'быстро'],
      mealType: MealType.breakfast,
      isVegetarian: true,
    ),
    Recipe(
      id: 'recipe_2',
      name: 'Куриная грудка с овощами',
      description: 'Запеченная куриная грудка с сезонными овощами',
      imageUrl: 'https://via.placeholder.com/300x200?text=Chicken',
      prepTime: 35,
      calories: 450,
      protein: 45.0,
      carbs: 25.0,
      fats: 18.0,
      ingredients: const [
        Ingredient(name: 'Куриная грудка', amount: 200, unit: 'г'),
        Ingredient(name: 'Брокколи', amount: 150, unit: 'г'),
        Ingredient(name: 'Морковь', amount: 100, unit: 'г'),
        Ingredient(name: 'Оливковое масло', amount: 10, unit: 'мл'),
      ],
      steps: const [
        'Нарезать курицу и овощи',
        'Приправить специями',
        'Запекать 30 минут при 180°C',
        'Подавать горячим',
      ],
      tags: const ['обед', 'белок', 'полезно'],
      mealType: MealType.lunch,
    ),
    Recipe(
      id: 'recipe_3',
      name: 'Греческий йогурт с орехами',
      description: 'Легкий перекус с греческим йогуртом, орехами и медом',
      imageUrl: 'https://via.placeholder.com/300x200?text=Yogurt',
      prepTime: 5,
      calories: 250,
      protein: 18.0,
      carbs: 22.0,
      fats: 10.0,
      ingredients: const [
        Ingredient(name: 'Греческий йогурт', amount: 150, unit: 'г'),
        Ingredient(name: 'Грецкие орехи', amount: 20, unit: 'г'),
        Ingredient(name: 'Мед', amount: 10, unit: 'г'),
      ],
      steps: const [
        'Выложить йогурт в миску',
        'Добавить измельченные орехи',
        'Полить медом',
      ],
      tags: const ['перекус', 'быстро', 'белок'],
      mealType: MealType.snack,
      isVegetarian: true,
    ),
    Recipe(
      id: 'recipe_4',
      name: 'Лосось с киноа',
      description: 'Запеченный лосось с гарниром из киноа и зелени',
      imageUrl: 'https://via.placeholder.com/300x200?text=Salmon',
      prepTime: 25,
      calories: 520,
      protein: 42.0,
      carbs: 38.0,
      fats: 22.0,
      ingredients: const [
        Ingredient(name: 'Лосось', amount: 180, unit: 'г'),
        Ingredient(name: 'Киноа', amount: 80, unit: 'г'),
        Ingredient(name: 'Шпинат', amount: 100, unit: 'г'),
        Ingredient(name: 'Лимон', amount: 0.5, unit: 'шт'),
      ],
      steps: const [
        'Отварить киноа',
        'Запечь лосось с лимоном 15 минут',
        'Потушить шпинат',
        'Сервировать вместе',
      ],
      tags: const ['обед', 'рыба', 'омега-3'],
      mealType: MealType.lunch,
    ),
    Recipe(
      id: 'recipe_5',
      name: 'Протеиновый коктейль',
      description: 'Домашний протеиновый коктейль с бананом и арахисовой пастой',
      imageUrl: 'https://via.placeholder.com/300x200?text=Smoothie',
      prepTime: 5,
      calories: 280,
      protein: 25.0,
      carbs: 30.0,
      fats: 8.0,
      ingredients: const [
        Ingredient(name: 'Протеин', amount: 30, unit: 'г'),
        Ingredient(name: 'Банан', amount: 1, unit: 'шт'),
        Ingredient(name: 'Молоко', amount: 250, unit: 'мл'),
        Ingredient(name: 'Арахисовая паста', amount: 10, unit: 'г'),
      ],
      steps: const [
        'Смешать все ингредиенты в блендере',
        'Взбить до однородности',
        'Подавать охлажденным',
      ],
      tags: const ['перекус', 'белок', 'быстро'],
      mealType: MealType.snack,
      isVegetarian: true,
    ),
    Recipe(
      id: 'recipe_6',
      name: 'Индейка с овощным салатом',
      description: 'Легкий ужин: запеченная индейка с свежим салатом',
      imageUrl: 'https://via.placeholder.com/300x200?text=Turkey',
      prepTime: 30,
      calories: 400,
      protein: 38.0,
      carbs: 25.0,
      fats: 16.0,
      ingredients: const [
        Ingredient(name: 'Филе индейки', amount: 180, unit: 'г'),
        Ingredient(name: 'Салат микс', amount: 150, unit: 'г'),
        Ingredient(name: 'Помидоры черри', amount: 100, unit: 'г'),
        Ingredient(name: 'Оливковое масло', amount: 10, unit: 'мл'),
      ],
      steps: const [
        'Запечь индейку со специями',
        'Нарезать овощи для салата',
        'Заправить оливковым маслом',
        'Подавать вместе',
      ],
      tags: const ['ужин', 'легкий', 'белок'],
      mealType: MealType.dinner,
    ),
  ];
}

