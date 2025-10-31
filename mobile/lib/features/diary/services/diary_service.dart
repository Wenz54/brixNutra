import 'dart:io';
import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/diary/models/diary_models.dart';

/// Сервис для работы с дневником питания
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class DiaryService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== DIARY DAY ====================

  /// Получить дневник за конкретный день
  ///
  /// [date] - дата дня
  static Future<DiaryDay> getDayDiary(DateTime date) async {
    try {
      if (useMockMode) {
        return _mockGetDayDiary(date);
      }

      // Реальный API запрос
      final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD
      final response = await ApiService.get(
        ApiEndpoints.diaryDay(dateStr),
      );
      
      // Backend возвращает {stats: {...}, entries: [...]}
      // Преобразуем в формат DiaryDay
      final data = response['data'] as Map<String, dynamic>;
      return DiaryDay.fromJson({
        'date': dateStr,
        'meals': data['entries'] ?? [],
        'stats': data['stats'],
        'water_log': null, // TODO: добавить в backend
        'goals': null, // TODO: добавить в backend
        'is_completed': false,
      });
    } catch (e) {
      print('❌ getDayDiary error: $e');
      rethrow;
    }
  }

  /// Получить историю дневника
  ///
  /// [startDate] - дата начала
  /// [endDate] - дата окончания
  /// [limit] - лимит результатов
  static Future<List<DiaryHistoryItem>> getHistory({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 30,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetHistory(startDate: startDate, endDate: endDate, limit: limit);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await ApiService.get(
        ApiEndpoints.diaryHistory,
        queryParameters: queryParams,
      );
      
      return (response['data'] as List)
          .map((item) => DiaryHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getHistory error: $e');
      rethrow;
    }
  }

  // ==================== MEALS ====================

  /// Добавить прием пищи в дневник
  ///
  /// [mealName] - название блюда
  /// [mealType] - тип приема пищи
  /// [consumedAt] - время приема
  /// [portionGrams] - порция в граммах
  /// [calories] - калории
  /// [protein, carbs, fats] - БЖУ
  /// [photo] - фото блюда (опционально)
  /// [fromPlan] - из плана питания?
  /// [recipeId] - ID рецепта (если из плана)
  static Future<DiaryMeal> addMeal({
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
  }) async {
    try {
      if (useMockMode) {
        return _mockAddMeal(
          mealName: mealName,
          mealType: mealType,
          consumedAt: consumedAt,
          portionGrams: portionGrams,
          calories: calories ?? 300,
          protein: protein ?? 20.0,
          carbs: carbs ?? 30.0,
          fats: fats ?? 10.0,
          fromPlan: fromPlan,
          recipeId: recipeId,
        );
      }

      // TODO: Загрузка фото если есть
      String? photoUrl;
      if (photo != null) {
        // photoUrl = await FileService.uploadFile(photo);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.diaryMeal,
        {
          'meal_name': mealName,
          'meal_type': mealType,
          'consumed_at': consumedAt.toIso8601String(),
          'portion_grams': portionGrams,
          'calories': calories,
          'protein': protein,
          'carbs': carbs,
          'fats': fats,
          'photo_url': photoUrl,
          'from_plan': fromPlan,
          'recipe_id': recipeId,
        },
      );

      return DiaryMeal.fromJson(response['data']);
    } catch (e) {
      print('❌ addMeal error: $e');
      rethrow;
    }
  }

  /// Удалить прием пищи
  ///
  /// [mealId] - ID приема пищи
  static Future<void> deleteMeal(String mealId) async {
    try {
      if (useMockMode) {
        return _mockDeleteMeal(mealId);
      }

      // Реальный API запрос
      await ApiService.delete(
        ApiEndpoints.diaryMealDelete(mealId),
      );
      print('✅ Прием пищи удален: $mealId');
    } catch (e) {
      print('❌ deleteMeal error: $e');
      rethrow;
    }
  }

  // ==================== WATER ====================

  /// Обновить количество воды
  ///
  /// [date] - дата
  /// [increment] - на сколько увеличить/уменьшить (мл)
  static Future<WaterLog> updateWater({
    required DateTime date,
    required int increment,
  }) async {
    try {
      if (useMockMode) {
        return _mockUpdateWater(date: date, increment: increment);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.diaryWater,
        {
          'date': date.toIso8601String().split('T')[0],
          'increment': increment,
        },
      );

      return WaterLog.fromJson(response['data']);
    } catch (e) {
      print('❌ updateWater error: $e');
      rethrow;
    }
  }

  // ==================== MOOD ====================

  /// Обновить настроение дня
  ///
  /// [date] - дата
  /// [rating] - оценка настроения (1-5)
  static Future<void> updateMood({
    required DateTime date,
    required int rating,
  }) async {
    try {
      if (useMockMode) {
        return _mockUpdateMood(date: date, rating: rating);
      }

      // Реальный API запрос
      await ApiService.patch(
        ApiEndpoints.diaryMood,
        {
          'date': date.toIso8601String().split('T')[0],
          'rating': rating,
        },
      );
      print('✅ Настроение обновлено: $rating');
    } catch (e) {
      print('❌ updateMood error: $e');
      rethrow;
    }
  }

  /// Завершить день
  ///
  /// [date] - дата
  static Future<void> completeDay(DateTime date) async {
    try {
      if (useMockMode) {
        return _mockCompleteDay(date);
      }

      // Реальный API запрос
      await ApiService.put(
        ApiEndpoints.diaryDayStatus,
        {
          'date': date.toIso8601String().split('T')[0],
          'is_completed': true,
        },
      );
      print('✅ День завершен: ${date.toIso8601String().split('T')[0]}');
    } catch (e) {
      print('❌ completeDay error: $e');
      rethrow;
    }
  }

  /// Обновить дневные цели
  ///
  /// [date] - дата
  /// [goals] - новые цели
  static Future<DailyGoals> updateDailyGoals({
    required DateTime date,
    required DailyGoals goals,
  }) async {
    try {
      if (useMockMode) {
        return _mockUpdateDailyGoals(date: date, goals: goals);
      }

      // Реальный API запрос
      final response = await ApiService.put(
        ApiEndpoints.diaryGoals(date.toIso8601String().split('T')[0]),
        goals.toJson(),
      );

      return DailyGoals.fromJson(response['data']);
    } catch (e) {
      print('❌ updateDailyGoals error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static int _mockWaterAmount = 1200; // мл
  static final List<DiaryMeal> _mockMeals = [
    DiaryMeal(
      id: 'meal_1',
      mealName: 'Овсяная каша с ягодами',
      mealType: 'breakfast',
      consumedAt: DateTime.now().subtract(const Duration(hours: 2)),
      portionGrams: 300,
      calories: 350,
      protein: 12.0,
      carbs: 55.0,
      fats: 8.0,
      fromPlan: true,
      recipeId: 'recipe_1',
    ),
    DiaryMeal(
      id: 'meal_2',
      mealName: 'Греческий йогурт с орехами',
      mealType: 'snack',
      consumedAt: DateTime.now().subtract(const Duration(hours: 1)),
      portionGrams: 150,
      calories: 250,
      protein: 18.0,
      carbs: 22.0,
      fats: 10.0,
      fromPlan: false,
    ),
  ];

  static Future<DiaryDay> _mockGetDayDiary(DateTime date) async {
    print('🎭 MOCK: Получение дневника за ${date.toIso8601String().split('T')[0]}');
    await Future.delayed(const Duration(milliseconds: 600));

    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    final meals = isToday ? _mockMeals : <DiaryMeal>[];
    final stats = DailyStats.fromMeals(meals);

    return DiaryDay(
      date: date,
      meals: meals,
      waterLog: WaterLog(
        date: date,
        totalAmount: isToday ? _mockWaterAmount : 0,
        dailyGoal: 2000,
      ),
      goals: const DailyGoals(
        calories: 1800,
        protein: 120.0,
        carbs: 180.0,
        fats: 60.0,
      ),
      stats: stats,
      moodRating: isToday ? null : 4,
      isCompleted: !isToday,
      notes: isToday ? null : 'Хороший день!',
    );
  }

  static Future<List<DiaryHistoryItem>> _mockGetHistory({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 30,
  }) async {
    print('🎭 MOCK: Получение истории дневника');
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final items = <DiaryHistoryItem>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      items.add(DiaryHistoryItem(
        date: date,
        totalCalories: 1500 + (i * 100),
        goalCalories: 1800,
        mealsCount: 3 + (i % 3),
        isCompleted: i > 0,
        moodRating: 3 + (i % 3),
      ));
    }

    return items;
  }

  static Future<DiaryMeal> _mockAddMeal({
    required String mealName,
    required String mealType,
    required DateTime consumedAt,
    required int portionGrams,
    required int calories,
    required double protein,
    required double carbs,
    required double fats,
    bool fromPlan = false,
    String? recipeId,
  }) async {
    print('🎭 MOCK: Добавление приема пищи: $mealName');
    await Future.delayed(const Duration(milliseconds: 700));

    final meal = DiaryMeal(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      mealName: mealName,
      mealType: mealType,
      consumedAt: consumedAt,
      portionGrams: portionGrams,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      fromPlan: fromPlan,
      recipeId: recipeId,
    );

    _mockMeals.add(meal);
    return meal;
  }

  static Future<void> _mockDeleteMeal(String mealId) async {
    print('🎭 MOCK: Удаление приема пищи: $mealId');
    await Future.delayed(const Duration(milliseconds: 400));

    _mockMeals.removeWhere((m) => m.id == mealId);
  }

  static Future<WaterLog> _mockUpdateWater({
    required DateTime date,
    required int increment,
  }) async {
    print('🎭 MOCK: Обновление воды: $increment мл');
    await Future.delayed(const Duration(milliseconds: 300));

    _mockWaterAmount = (_mockWaterAmount + increment).clamp(0, 5000);

    return WaterLog(
      date: date,
      totalAmount: _mockWaterAmount,
      dailyGoal: 2000,
    );
  }

  static Future<void> _mockUpdateMood({
    required DateTime date,
    required int rating,
  }) async {
    print('🎭 MOCK: Обновление настроения: $rating');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> _mockCompleteDay(DateTime date) async {
    print('🎭 MOCK: Завершение дня: ${date.toIso8601String().split('T')[0]}');
    await Future.delayed(const Duration(milliseconds: 400));
  }

  static Future<DailyGoals> _mockUpdateDailyGoals({
    required DateTime date,
    required DailyGoals goals,
  }) async {
    print('🎭 MOCK: Обновление дневных целей: ${goals.calories} ккал');
    await Future.delayed(const Duration(milliseconds: 500));
    return goals;
  }
}

