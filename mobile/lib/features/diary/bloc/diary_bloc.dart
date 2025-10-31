import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/diary/bloc/diary_event.dart';
import 'package:mobile/features/diary/bloc/diary_state.dart';
import 'package:mobile/features/diary/services/diary_service.dart';

/// BLoC для управления дневником питания
///
/// Обрабатывает все действия пользователя:
/// - Загрузка дневника за день
/// - Добавление/удаление приемов пищи
/// - Управление водой
/// - Обновление настроения
/// - Завершение дня
/// - Обновление целей
class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  DiaryBloc() : super(const DiaryInitial()) {
    on<LoadDayDiaryRequested>(_onLoadDayDiary);
    on<LoadDiaryHistoryRequested>(_onLoadDiaryHistory);
    on<AddMealRequested>(_onAddMeal);
    on<DeleteMealRequested>(_onDeleteMeal);
    on<AddWaterRequested>(_onAddWater);
    on<RemoveWaterRequested>(_onRemoveWater);
    on<UpdateMoodRequested>(_onUpdateMood);
    on<CompleteDayRequested>(_onCompleteDay);
    on<UpdateDailyGoalsRequested>(_onUpdateDailyGoals);
    on<ResetDiaryState>(_onResetState);
  }

  // ==================== DIARY DAY ====================

  /// Загрузить дневник за день
  Future<void> _onLoadDayDiary(
    LoadDayDiaryRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Загрузка дневника...'));
      
      final diaryDay = await DiaryService.getDayDiary(event.date);
      
      emit(DayDiaryLoaded(diaryDay));
      print('✅ DiaryBloc: Дневник загружен: ${event.date.toIso8601String().split('T')[0]}');
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось загрузить дневник: $e',
        code: 'LOAD_DAY_DIARY_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка загрузки дневника: $e');
    }
  }

  /// Загрузить историю дневника
  Future<void> _onLoadDiaryHistory(
    LoadDiaryHistoryRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Загрузка истории...'));
      
      final history = await DiaryService.getHistory(
        startDate: event.startDate,
        endDate: event.endDate,
        limit: event.limit,
      );
      
      emit(DiaryHistoryLoaded(history));
      print('✅ DiaryBloc: История загружена (${history.length} дней)');
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось загрузить историю: $e',
        code: 'LOAD_HISTORY_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка загрузки истории: $e');
    }
  }

  // ==================== MEALS ====================

  /// Добавить прием пищи
  Future<void> _onAddMeal(
    AddMealRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Добавление приема пищи...'));
      
      final meal = await DiaryService.addMeal(
        mealName: event.mealName,
        mealType: event.mealType,
        consumedAt: event.consumedAt,
        portionGrams: event.portionGrams,
        calories: event.calories,
        protein: event.protein,
        carbs: event.carbs,
        fats: event.fats,
        photo: event.photo,
        fromPlan: event.fromPlan,
        recipeId: event.recipeId,
      );
      
      emit(MealAdded(
        meal: meal,
        message: 'Прием пищи добавлен: ${meal.mealName}',
      ));
      print('✅ DiaryBloc: Прием пищи добавлен: ${meal.mealName}');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.consumedAt);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось добавить прием пищи: $e',
        code: 'ADD_MEAL_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка добавления приема пищи: $e');
    }
  }

  /// Удалить прием пищи
  Future<void> _onDeleteMeal(
    DeleteMealRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      // Сохраняем текущий день для перезагрузки
      DateTime? currentDate;
      if (state is DayDiaryLoaded) {
        currentDate = (state as DayDiaryLoaded).diaryDay.date;
      }

      emit(const DiaryLoading(message: 'Удаление приема пищи...'));
      
      await DiaryService.deleteMeal(event.mealId);
      
      emit(MealDeleted(
        mealId: event.mealId,
        message: 'Прием пищи удален',
      ));
      print('✅ DiaryBloc: Прием пищи удален: ${event.mealId}');
      
      // Перезагрузка дневника дня
      if (currentDate != null) {
        final diaryDay = await DiaryService.getDayDiary(currentDate);
        emit(DayDiaryLoaded(diaryDay));
      }
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось удалить прием пищи: $e',
        code: 'DELETE_MEAL_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка удаления приема пищи: $e');
    }
  }

  // ==================== WATER ====================

  /// Добавить воду
  Future<void> _onAddWater(
    AddWaterRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Обновление воды...'));
      
      final waterLog = await DiaryService.updateWater(
        date: event.date,
        increment: event.amount,
      );
      
      emit(WaterUpdated(
        waterLog: waterLog,
        message: 'Добавлено ${event.amount}мл воды',
      ));
      print('✅ DiaryBloc: Вода добавлена: ${event.amount}мл');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.date);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось обновить воду: $e',
        code: 'ADD_WATER_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка добавления воды: $e');
    }
  }

  /// Убавить воду
  Future<void> _onRemoveWater(
    RemoveWaterRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Обновление воды...'));
      
      final waterLog = await DiaryService.updateWater(
        date: event.date,
        increment: -event.amount,
      );
      
      emit(WaterUpdated(
        waterLog: waterLog,
        message: 'Убрано ${event.amount}мл воды',
      ));
      print('✅ DiaryBloc: Вода убрана: ${event.amount}мл');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.date);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось обновить воду: $e',
        code: 'REMOVE_WATER_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка уменьшения воды: $e');
    }
  }

  // ==================== MOOD ====================

  /// Обновить настроение
  Future<void> _onUpdateMood(
    UpdateMoodRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Обновление настроения...'));
      
      await DiaryService.updateMood(
        date: event.date,
        rating: event.rating,
      );
      
      emit(MoodUpdated(
        rating: event.rating,
        message: 'Настроение обновлено',
      ));
      print('✅ DiaryBloc: Настроение обновлено: ${event.rating}');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.date);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось обновить настроение: $e',
        code: 'UPDATE_MOOD_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка обновления настроения: $e');
    }
  }

  // ==================== DAY УПРАВЛЕНИЕ ====================

  /// Завершить день
  Future<void> _onCompleteDay(
    CompleteDayRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Завершение дня...'));
      
      await DiaryService.completeDay(event.date);
      
      emit(DayCompleted(
        date: event.date,
        message: 'День завершен',
      ));
      print('✅ DiaryBloc: День завершен: ${event.date.toIso8601String().split('T')[0]}');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.date);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось завершить день: $e',
        code: 'COMPLETE_DAY_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка завершения дня: $e');
    }
  }

  /// Обновить дневные цели
  Future<void> _onUpdateDailyGoals(
    UpdateDailyGoalsRequested event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      emit(const DiaryLoading(message: 'Обновление целей...'));
      
      final goals = await DiaryService.updateDailyGoals(
        date: event.date,
        goals: event.goals,
      );
      
      emit(DailyGoalsUpdated(
        goals: goals,
        message: 'Цели обновлены',
      ));
      print('✅ DiaryBloc: Цели обновлены: ${goals.calories} ккал');
      
      // Перезагрузка дневника дня
      final diaryDay = await DiaryService.getDayDiary(event.date);
      emit(DayDiaryLoaded(diaryDay));
    } catch (e) {
      emit(DiaryError(
        message: 'Не удалось обновить цели: $e',
        code: 'UPDATE_GOALS_ERROR',
      ));
      print('❌ DiaryBloc: Ошибка обновления целей: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetDiaryState event,
    Emitter<DiaryState> emit,
  ) async {
    emit(const DiaryInitial());
    print('🔄 DiaryBloc: Состояние сброшено');
  }
}




