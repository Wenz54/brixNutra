import 'package:equatable/equatable.dart';

// ==================== ENUMS ====================

/// Тип приема пищи
enum MealType {
  wakeup('wakeup', 'Пробуждение'),
  breakfast('breakfast', 'Завтрак'),
  snack('snack', 'Перекус'),
  lunch('lunch', 'Обед'),
  afternoonSnack('afternoon_snack', 'Полдник'),
  dinner('dinner', 'Ужин'),
  sleep('sleep', 'Перед сном');

  const MealType(this.value, this.displayName);
  
  final String value;
  final String displayName;

  static MealType fromString(String value) {
    return MealType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MealType.breakfast,
    );
  }
}

/// Важность приема пищи
enum MealImportance {
  required('required', 'Обязательный'),
  recommended('recommended', 'Рекомендуемый'),
  optional('optional', 'Опциональный');

  const MealImportance(this.value, this.displayName);
  
  final String value;
  final String displayName;

  static MealImportance fromString(String value) {
    return MealImportance.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MealImportance.recommended,
    );
  }
}

// ==================== INGREDIENT ====================

/// Ингредиент рецепта
class Ingredient extends Equatable {
  final String name;
  final double amount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
    };
  }

  @override
  List<Object?> get props => [name, amount, unit];

  @override
  String toString() => '$amount $unit $name';
}

// ==================== RECIPE ====================

/// Рецепт блюда
class Recipe extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int prepTime; // минуты
  final int calories;
  final double protein; // граммы
  final double carbs;
  final double fats;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final List<String> tags;
  final MealType mealType;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isDairyFree;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.prepTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.ingredients,
    required this.steps,
    required this.tags,
    required this.mealType,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isDairyFree = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      prepTime: json['prep_time'] ?? 0,
      calories: json['calories'] ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List?)
              ?.map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['instructions'] as List?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      mealType: MealType.fromString(json['meal_type'] ?? 'breakfast'),
      isVegetarian: json['is_vegetarian'] ?? false,
      isVegan: json['is_vegan'] ?? false,
      isGlutenFree: json['is_gluten_free'] ?? false,
      isDairyFree: json['is_dairy_free'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'prep_time': prepTime,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': steps,
      'tags': tags,
      'meal_type': mealType.value,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'is_gluten_free': isGlutenFree,
      'is_dairy_free': isDairyFree,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        prepTime,
        calories,
        protein,
        carbs,
        fats,
        ingredients,
        steps,
        tags,
        mealType,
        isVegetarian,
        isVegan,
        isGlutenFree,
        isDairyFree,
      ];

  @override
  String toString() => 'Recipe($name, ${calories}kcal)';
}

// ==================== MEAL SLOT ====================

/// Слот приема пищи в плане питания
class MealSlot extends Equatable {
  final String id;
  final MealType mealType;
  final String time; // формат: "08:00"
  final Recipe recipe;
  final int portionGrams;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final MealImportance importance;
  final String? notes;

  const MealSlot({
    required this.id,
    required this.mealType,
    required this.time,
    required this.recipe,
    required this.portionGrams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.importance = MealImportance.recommended,
    this.notes,
  });

  factory MealSlot.fromJson(Map<String, dynamic> json) {
    return MealSlot(
      id: json['id']?.toString() ?? '',
      mealType: MealType.fromString(json['meal_type'] ?? 'breakfast'),
      time: json['time'] ?? '12:00',
      recipe: Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
      portionGrams: json['portion_grams'] ?? 0,
      calories: json['calories'] ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      importance: MealImportance.fromString(json['importance'] ?? 'recommended'),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_type': mealType.value,
      'time': time,
      'recipe': recipe.toJson(),
      'portion_grams': portionGrams,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'importance': importance.value,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        mealType,
        time,
        recipe,
        portionGrams,
        calories,
        protein,
        carbs,
        fats,
        importance,
        notes,
      ];

  @override
  String toString() => 'MealSlot(${mealType.displayName}, $time, ${recipe.name})';
}

// ==================== SUPPLEMENT ====================

/// Добавка (витамины, БАДы)
class Supplement extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String? notes;

  const Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.notes,
  });

  factory Supplement.fromJson(Map<String, dynamic> json) {
    return Supplement(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      time: json['time'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, name, dosage, time, notes];

  @override
  String toString() => 'Supplement($name, $dosage)';
}

// ==================== MEAL PLAN ====================

/// План питания
class MealPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final int durationDays;
  final int currentDay;
  final List<MealSlot> meals;
  final List<Supplement>? supplements;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;
  final double progress; // процент выполнения (0-100)
  final DateTime startDate;

  const MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.durationDays,
    required this.currentDay,
    required this.meals,
    this.supplements,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    required this.progress,
    required this.startDate,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      durationDays: json['duration_days'] ?? 7,
      currentDay: json['current_day'] ?? 1,
      meals: (json['meals'] as List?)
              ?.map((m) => MealSlot.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      supplements: (json['supplements'] as List?)
          ?.map((s) => Supplement.fromJson(s as Map<String, dynamic>))
          .toList(),
      totalCalories: json['total_calories'] ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json['total_fats'] as num?)?.toDouble() ?? 0.0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration_days': durationDays,
      'current_day': currentDay,
      'meals': meals.map((m) => m.toJson()).toList(),
      'supplements': supplements?.map((s) => s.toJson()).toList(),
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbs': totalCarbs,
      'total_fats': totalFats,
      'progress': progress,
      'start_date': startDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        durationDays,
        currentDay,
        meals,
        supplements,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFats,
        progress,
        startDate,
      ];

  @override
  String toString() =>
      'MealPlan($name, день $currentDay/$durationDays, $totalCalories ккал)';
}

// ==================== DAY PLAN ====================

/// План питания на конкретный день
class DayPlan extends Equatable {
  final DateTime date;
  final int dayNumber;
  final List<MealSlot> meals;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFats;

  const DayPlan({
    required this.date,
    required this.dayNumber,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      dayNumber: json['day_number'] ?? 1,
      meals: (json['meals'] as List?)
              ?.map((m) => MealSlot.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      totalCalories: json['total_calories'] ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFats: (json['total_fats'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'day_number': dayNumber,
      'meals': meals.map((m) => m.toJson()).toList(),
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbs': totalCarbs,
      'total_fats': totalFats,
    };
  }

  @override
  List<Object?> get props => [
        date,
        dayNumber,
        meals,
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFats,
      ];

  @override
  String toString() =>
      'DayPlan(день $dayNumber, ${meals.length} приемов, $totalCalories ккал)';
}




