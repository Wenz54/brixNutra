import 'package:equatable/equatable.dart';

// ==================== DIARY MEAL ====================

/// Прием пищи в дневнике
class DiaryMeal extends Equatable {
  final String id;
  final String mealName;
  final String mealType; // breakfast, lunch, dinner, snack
  final DateTime consumedAt;
  final int portionGrams;
  final int calories;
  final double protein; // граммы
  final double carbs;
  final double fats;
  final String? photoUrl;
  final bool fromPlan; // из плана питания или добавлено вручную
  final String? recipeId; // ID рецепта (если из плана)

  const DiaryMeal({
    required this.id,
    required this.mealName,
    required this.mealType,
    required this.consumedAt,
    required this.portionGrams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.photoUrl,
    this.fromPlan = false,
    this.recipeId,
  });

  factory DiaryMeal.fromJson(Map<String, dynamic> json) {
    return DiaryMeal(
      id: json['id']?.toString() ?? '',
      mealName: json['meal_name'] ?? '',
      mealType: json['meal_type'] ?? 'snack',
      consumedAt: DateTime.parse(json['consumed_at']),
      portionGrams: json['portion_grams'] ?? 0,
      calories: json['calories'] ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      photoUrl: json['photo_url'],
      fromPlan: json['from_plan'] ?? false,
      recipeId: json['recipe_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }

  /// Получить название типа приема на русском
  String get mealTypeLabel {
    switch (mealType) {
      case 'breakfast':
        return 'Завтрак';
      case 'lunch':
        return 'Обед';
      case 'dinner':
        return 'Ужин';
      case 'snack':
        return 'Перекус';
      default:
        return 'Прием пищи';
    }
  }

  @override
  List<Object?> get props => [
        id,
        mealName,
        mealType,
        consumedAt,
        portionGrams,
        calories,
        protein,
        carbs,
        fats,
        photoUrl,
        fromPlan,
        recipeId,
      ];

  @override
  String toString() =>
      'DiaryMeal($mealName, $mealTypeLabel, ${calories}kcal)';
}

// ==================== WATER LOG ====================

/// Лог воды за день
class WaterLog extends Equatable {
  final DateTime date;
  final int totalAmount; // мл
  final int dailyGoal; // мл

  const WaterLog({
    required this.date,
    required this.totalAmount,
    this.dailyGoal = 2000,
  });

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      date: DateTime.parse(json['date']),
      totalAmount: json['total_amount'] ?? 0,
      dailyGoal: json['daily_goal'] ?? 2000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'total_amount': totalAmount,
      'daily_goal': dailyGoal,
    };
  }

  /// Получить прогресс (0.0 - 1.0)
  double get progress {
    return (totalAmount / dailyGoal).clamp(0.0, 1.0);
  }

  /// Получить количество в литрах
  double get liters {
    return totalAmount / 1000;
  }

  /// Процент выполнения
  int get percentComplete {
    return ((totalAmount / dailyGoal) * 100).round().clamp(0, 100);
  }

  @override
  List<Object?> get props => [date, totalAmount, dailyGoal];

  @override
  String toString() =>
      'WaterLog(${totalAmount}мл / ${dailyGoal}мл, ${percentComplete}%)';
}

// ==================== DAILY GOALS ====================

/// Дневные цели по КБЖУ
class DailyGoals extends Equatable {
  final int calories;
  final double protein; // граммы
  final double carbs;
  final double fats;

  const DailyGoals({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  factory DailyGoals.fromJson(Map<String, dynamic> json) {
    return DailyGoals(
      calories: json['calories'] ?? 2000,
      protein: (json['protein'] as num?)?.toDouble() ?? 150.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 200.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 70.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }

  @override
  List<Object?> get props => [calories, protein, carbs, fats];

  @override
  String toString() =>
      'DailyGoals(${calories}kcal, P:${protein}g, C:${carbs}g, F:${fats}g)';
}

// ==================== DAILY STATS ====================

/// Статистика за день (текущее потребление)
class DailyStats extends Equatable {
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final int mealsCount;

  const DailyStats({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.mealsCount,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      totalCalories: json['total_calories'] ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json['total_fats'] as num?)?.toDouble() ?? 0.0,
      mealsCount: json['meals_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbs': totalCarbs,
      'total_fats': totalFats,
      'meals_count': mealsCount,
    };
  }

  /// Подсчитать статистику из списка приемов пищи
  factory DailyStats.fromMeals(List<DiaryMeal> meals) {
    return DailyStats(
      totalCalories: meals.fold(0, (sum, meal) => sum + meal.calories),
      totalProtein: meals.fold(0.0, (sum, meal) => sum + meal.protein),
      totalCarbs: meals.fold(0.0, (sum, meal) => sum + meal.carbs),
      totalFats: meals.fold(0.0, (sum, meal) => sum + meal.fats),
      mealsCount: meals.length,
    );
  }

  @override
  List<Object?> get props => [
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFats,
        mealsCount,
      ];

  @override
  String toString() =>
      'DailyStats(${totalCalories}kcal, ${mealsCount} приемов)';
}

// ==================== DIARY DAY ====================

/// День дневника питания (полная информация)
class DiaryDay extends Equatable {
  final DateTime date;
  final List<DiaryMeal> meals;
  final WaterLog waterLog;
  final DailyGoals goals;
  final DailyStats stats;
  final int? moodRating; // 1-5 (настроение)
  final bool isCompleted;
  final String? notes;

  const DiaryDay({
    required this.date,
    required this.meals,
    required this.waterLog,
    required this.goals,
    required this.stats,
    this.moodRating,
    this.isCompleted = false,
    this.notes,
  });

  factory DiaryDay.fromJson(Map<String, dynamic> json) {
    final meals = (json['meals'] as List?)
            ?.map((m) => DiaryMeal.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];

    return DiaryDay(
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      meals: meals,
      waterLog: json['water_log'] != null
          ? WaterLog.fromJson(json['water_log'] as Map<String, dynamic>)
          : WaterLog(date: DateTime.now(), totalAmount: 0),
      goals: json['goals'] != null
          ? DailyGoals.fromJson(json['goals'] as Map<String, dynamic>)
          : const DailyGoals(
              calories: 2000,
              protein: 150,
              carbs: 200,
              fats: 65,
            ),
      stats: json['stats'] != null
          ? DailyStats.fromJson(json['stats'] as Map<String, dynamic>)
          : DailyStats.fromMeals(meals),
      moodRating: json['mood_rating'],
      isCompleted: json['is_completed'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'meals': meals.map((m) => m.toJson()).toList(),
      'water_log': waterLog.toJson(),
      'goals': goals.toJson(),
      'stats': stats.toJson(),
      'mood_rating': moodRating,
      'is_completed': isCompleted,
      'notes': notes,
    };
  }

  /// Прогресс по калориям (0.0 - 1.0+)
  double get caloriesProgress {
    return stats.totalCalories / goals.calories;
  }

  /// Прогресс по белкам (0.0 - 1.0+)
  double get proteinProgress {
    return stats.totalProtein / goals.protein;
  }

  /// Прогресс по углеводам (0.0 - 1.0+)
  double get carbsProgress {
    return stats.totalCarbs / goals.carbs;
  }

  /// Прогресс по жирам (0.0 - 1.0+)
  double get fatsProgress {
    return stats.totalFats / goals.fats;
  }

  /// Получить приемы пищи по типу
  List<DiaryMeal> getMealsByType(String mealType) {
    return meals.where((m) => m.mealType == mealType).toList();
  }

  /// Получить приемы пищи из плана
  List<DiaryMeal> get mealsFromPlan {
    return meals.where((m) => m.fromPlan).toList();
  }

  /// Получить ручные приемы пищи
  List<DiaryMeal> get manualMeals {
    return meals.where((m) => !m.fromPlan).toList();
  }

  @override
  List<Object?> get props => [
        date,
        meals,
        waterLog,
        goals,
        stats,
        moodRating,
        isCompleted,
        notes,
      ];

  @override
  String toString() =>
      'DiaryDay(${date.toIso8601String().split('T')[0]}, ${meals.length} приемов, ${stats.totalCalories}/${goals.calories}kcal)';
}

// ==================== DIARY HISTORY ITEM ====================

/// Элемент истории дневника (для списка дней)
class DiaryHistoryItem extends Equatable {
  final DateTime date;
  final int totalCalories;
  final int goalCalories;
  final int mealsCount;
  final bool isCompleted;
  final int? moodRating;

  const DiaryHistoryItem({
    required this.date,
    required this.totalCalories,
    required this.goalCalories,
    required this.mealsCount,
    this.isCompleted = false,
    this.moodRating,
  });

  factory DiaryHistoryItem.fromJson(Map<String, dynamic> json) {
    return DiaryHistoryItem(
      date: DateTime.parse(json['date']),
      totalCalories: json['total_calories'] ?? 0,
      goalCalories: json['goal_calories'] ?? 2000,
      mealsCount: json['meals_count'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      moodRating: json['mood_rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'total_calories': totalCalories,
      'goal_calories': goalCalories,
      'meals_count': mealsCount,
      'is_completed': isCompleted,
      'mood_rating': moodRating,
    };
  }

  /// Прогресс по калориям (0-100+%)
  int get caloriesPercent {
    return ((totalCalories / goalCalories) * 100).round();
  }

  @override
  List<Object?> get props => [
        date,
        totalCalories,
        goalCalories,
        mealsCount,
        isCompleted,
        moodRating,
      ];

  @override
  String toString() =>
      'DiaryHistoryItem(${date.toIso8601String().split('T')[0]}, $totalCalories/$goalCalories kcal)';
}

