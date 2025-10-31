import 'package:equatable/equatable.dart';
import 'package:mobile/features/meal_plan/models/meal_plan_models.dart';

/// Состояния для планов питания
abstract class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class MealPlanInitial extends MealPlanState {
  const MealPlanInitial();

  @override
  String toString() => 'MealPlanInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class MealPlanLoading extends MealPlanState {
  final String? message;

  const MealPlanLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'MealPlanLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ ====================

/// Текущий план загружен
class CurrentPlanLoaded extends MealPlanState {
  final MealPlan mealPlan;

  const CurrentPlanLoaded(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];

  @override
  String toString() => 'CurrentPlanLoaded(${mealPlan.name})';
}

/// План на день загружен
class DayPlanLoaded extends MealPlanState {
  final DayPlan dayPlan;

  const DayPlanLoaded(this.dayPlan);

  @override
  List<Object?> get props => [dayPlan];

  @override
  String toString() =>
      'DayPlanLoaded(день ${dayPlan.dayNumber}, ${dayPlan.meals.length} приемов)';
}

/// Блюдо успешно заменено
class MealReplaced extends MealPlanState {
  final MealSlot updatedSlot;
  final String message;

  const MealReplaced({
    required this.updatedSlot,
    this.message = 'Блюдо успешно заменено',
  });

  @override
  List<Object?> get props => [updatedSlot, message];

  @override
  String toString() => 'MealReplaced(${updatedSlot.recipe.name})';
}

/// Рецепт загружен
class RecipeLoaded extends MealPlanState {
  final Recipe recipe;

  const RecipeLoaded(this.recipe);

  @override
  List<Object?> get props => [recipe];

  @override
  String toString() => 'RecipeLoaded(${recipe.name})';
}

/// Альтернативные рецепты загружены
class RecipeAlternativesLoaded extends MealPlanState {
  final List<Recipe> alternatives;
  final String originalRecipeId;

  const RecipeAlternativesLoaded({
    required this.alternatives,
    required this.originalRecipeId,
  });

  @override
  List<Object?> get props => [alternatives, originalRecipeId];

  @override
  String toString() =>
      'RecipeAlternativesLoaded(${alternatives.length} альтернатив)';
}

/// Список рецептов загружен
class RecipesLoaded extends MealPlanState {
  final List<Recipe> recipes;
  final MealType? filterMealType;
  final bool? filterIsVegetarian;

  const RecipesLoaded({
    required this.recipes,
    this.filterMealType,
    this.filterIsVegetarian,
  });

  @override
  List<Object?> get props => [recipes, filterMealType, filterIsVegetarian];

  @override
  String toString() =>
      'RecipesLoaded(${recipes.length} рецептов, тип: $filterMealType)';
}

/// Рецепт выбран для просмотра
class RecipeSelected extends MealPlanState {
  final Recipe recipe;

  const RecipeSelected(this.recipe);

  @override
  List<Object?> get props => [recipe];

  @override
  String toString() => 'RecipeSelected(${recipe.name})';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка при работе с планом питания
class MealPlanError extends MealPlanState {
  final String message;
  final String? code;

  const MealPlanError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'MealPlanError(message: $message, code: $code)';
}




