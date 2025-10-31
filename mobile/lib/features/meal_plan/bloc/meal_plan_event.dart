import 'package:equatable/equatable.dart';
import 'package:mobile/features/meal_plan/models/meal_plan_models.dart';

/// События для управления планами питания
abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  List<Object?> get props => [];
}

// ==================== MEAL PLAN СОБЫТИЯ ====================

/// Загрузить текущий план питания
class LoadCurrentPlanRequested extends MealPlanEvent {
  const LoadCurrentPlanRequested();

  @override
  String toString() => 'LoadCurrentPlanRequested()';
}

/// Загрузить план на конкретный день
class LoadDayPlanRequested extends MealPlanEvent {
  final DateTime date;

  const LoadDayPlanRequested(this.date);

  @override
  List<Object?> get props => [date];

  @override
  String toString() => 'LoadDayPlanRequested(${date.toIso8601String().split('T')[0]})';
}

/// Заменить блюдо в плане
class ReplaceMealRequested extends MealPlanEvent {
  final String mealSlotId;
  final String newRecipeId;

  const ReplaceMealRequested({
    required this.mealSlotId,
    required this.newRecipeId,
  });

  @override
  List<Object?> get props => [mealSlotId, newRecipeId];

  @override
  String toString() =>
      'ReplaceMealRequested(slotId: $mealSlotId, newRecipeId: $newRecipeId)';
}

// ==================== RECIPE СОБЫТИЯ ====================

/// Загрузить детали рецепта
class LoadRecipeRequested extends MealPlanEvent {
  final String recipeId;

  const LoadRecipeRequested(this.recipeId);

  @override
  List<Object?> get props => [recipeId];

  @override
  String toString() => 'LoadRecipeRequested($recipeId)';
}

/// Загрузить альтернативные рецепты
class LoadRecipeAlternativesRequested extends MealPlanEvent {
  final String recipeId;
  final MealType? mealType;

  const LoadRecipeAlternativesRequested({
    required this.recipeId,
    this.mealType,
  });

  @override
  List<Object?> get props => [recipeId, mealType];

  @override
  String toString() =>
      'LoadRecipeAlternativesRequested(recipeId: $recipeId, mealType: $mealType)';
}

/// Загрузить список рецептов с фильтрами
class LoadRecipesRequested extends MealPlanEvent {
  final MealType? mealType;
  final bool? isVegetarian;
  final int? maxCalories;
  final int limit;

  const LoadRecipesRequested({
    this.mealType,
    this.isVegetarian,
    this.maxCalories,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [mealType, isVegetarian, maxCalories, limit];

  @override
  String toString() =>
      'LoadRecipesRequested(mealType: $mealType, veg: $isVegetarian, limit: $limit)';
}

// ==================== UI СОБЫТИЯ ====================

/// Выбрать рецепт для просмотра деталей
class SelectRecipeRequested extends MealPlanEvent {
  final Recipe recipe;

  const SelectRecipeRequested(this.recipe);

  @override
  List<Object?> get props => [recipe];

  @override
  String toString() => 'SelectRecipeRequested(${recipe.name})';
}

/// Очистить выбранный рецепт
class ClearSelectedRecipe extends MealPlanEvent {
  const ClearSelectedRecipe();

  @override
  String toString() => 'ClearSelectedRecipe()';
}

/// Сбросить состояние
class ResetMealPlanState extends MealPlanEvent {
  const ResetMealPlanState();

  @override
  String toString() => 'ResetMealPlanState()';
}




