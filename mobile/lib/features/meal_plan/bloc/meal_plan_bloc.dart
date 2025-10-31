import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/meal_plan/bloc/meal_plan_event.dart';
import 'package:mobile/features/meal_plan/bloc/meal_plan_state.dart';
import 'package:mobile/features/meal_plan/services/meal_plan_service.dart';

/// BLoC для управления планами питания и рецептами
///
/// Обрабатывает все события планов питания и управляет состоянием.
/// Использует [MealPlanService] для взаимодействия с API.
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc() : super(const MealPlanInitial()) {
    // Регистрация обработчиков событий
    on<LoadCurrentPlanRequested>(_onLoadCurrentPlan);
    on<LoadDayPlanRequested>(_onLoadDayPlan);
    on<ReplaceMealRequested>(_onReplaceMeal);
    on<LoadRecipeRequested>(_onLoadRecipe);
    on<LoadRecipeAlternativesRequested>(_onLoadRecipeAlternatives);
    on<LoadRecipesRequested>(_onLoadRecipes);
    on<SelectRecipeRequested>(_onSelectRecipe);
    on<ClearSelectedRecipe>(_onClearSelectedRecipe);
    on<ResetMealPlanState>(_onResetState);
  }

  // ==================== MEAL PLAN HANDLERS ====================

  /// Обработка загрузки текущего плана
  Future<void> _onLoadCurrentPlan(
    LoadCurrentPlanRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Загрузка плана питания...'));

      final mealPlan = await MealPlanService.getCurrentPlan();

      emit(CurrentPlanLoaded(mealPlan));
      print('✅ Текущий план загружен: ${mealPlan.name}');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось загрузить план: $e'));
      print('❌ Exception при загрузке плана: $e');
    }
  }

  /// Обработка загрузки плана на день
  Future<void> _onLoadDayPlan(
    LoadDayPlanRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Загрузка плана на день...'));

      final dayPlan = await MealPlanService.getPlanForDay(event.date);

      emit(DayPlanLoaded(dayPlan));
      print('✅ План на день загружен: ${event.date}, ${dayPlan.meals.length} приемов');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось загрузить план на день: $e'));
      print('❌ Exception при загрузке плана на день: $e');
    }
  }

  /// Обработка замены блюда
  Future<void> _onReplaceMeal(
    ReplaceMealRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Замена блюда...'));

      final updatedSlot = await MealPlanService.replaceMeal(
        mealSlotId: event.mealSlotId,
        newRecipeId: event.newRecipeId,
      );

      emit(MealReplaced(
        updatedSlot: updatedSlot,
        message: 'Блюдо "${updatedSlot.recipe.name}" добавлено в план',
      ));
      print('✅ Блюдо заменено: ${updatedSlot.recipe.name}');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось заменить блюдо: $e'));
      print('❌ Exception при замене блюда: $e');
    }
  }

  // ==================== RECIPE HANDLERS ====================

  /// Обработка загрузки рецепта
  Future<void> _onLoadRecipe(
    LoadRecipeRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Загрузка рецепта...'));

      final recipe = await MealPlanService.getRecipe(event.recipeId);

      emit(RecipeLoaded(recipe));
      print('✅ Рецепт загружен: ${recipe.name}');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось загрузить рецепт: $e'));
      print('❌ Exception при загрузке рецепта: $e');
    }
  }

  /// Обработка загрузки альтернативных рецептов
  Future<void> _onLoadRecipeAlternatives(
    LoadRecipeAlternativesRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Поиск альтернатив...'));

      final alternatives = await MealPlanService.getRecipeAlternatives(
        recipeId: event.recipeId,
        mealType: event.mealType,
      );

      emit(RecipeAlternativesLoaded(
        alternatives: alternatives,
        originalRecipeId: event.recipeId,
      ));
      print('✅ Альтернативы загружены: ${alternatives.length} рецептов');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось загрузить альтернативы: $e'));
      print('❌ Exception при загрузке альтернатив: $e');
    }
  }

  /// Обработка загрузки списка рецептов
  Future<void> _onLoadRecipes(
    LoadRecipesRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      emit(const MealPlanLoading(message: 'Загрузка рецептов...'));

      final recipes = await MealPlanService.getRecipes(
        mealType: event.mealType,
        isVegetarian: event.isVegetarian,
        maxCalories: event.maxCalories,
        limit: event.limit,
      );

      emit(RecipesLoaded(
        recipes: recipes,
        filterMealType: event.mealType,
        filterIsVegetarian: event.isVegetarian,
      ));
      print('✅ Рецепты загружены: ${recipes.length} шт');
    } catch (e) {
      emit(MealPlanError(message: 'Не удалось загрузить рецепты: $e'));
      print('❌ Exception при загрузке рецептов: $e');
    }
  }

  // ==================== UI HANDLERS ====================

  /// Обработка выбора рецепта
  Future<void> _onSelectRecipe(
    SelectRecipeRequested event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(RecipeSelected(event.recipe));
    print('✅ Рецепт выбран: ${event.recipe.name}');
  }

  /// Очистка выбранного рецепта
  Future<void> _onClearSelectedRecipe(
    ClearSelectedRecipe event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(const MealPlanInitial());
    print('🔄 Выбранный рецепт очищен');
  }

  /// Сброс состояния
  Future<void> _onResetState(
    ResetMealPlanState event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(const MealPlanInitial());
    print('🔄 Состояние MealPlan сброшено');
  }
}




