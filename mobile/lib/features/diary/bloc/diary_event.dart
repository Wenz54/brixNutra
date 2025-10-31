import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:mobile/features/diary/models/diary_models.dart';

/// События для управления дневником питания
abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object?> get props => [];
}

// ==================== DIARY DAY СОБЫТИЯ ====================

/// Загрузить дневник за конкретный день
class LoadDayDiaryRequested extends DiaryEvent {
  final DateTime date;

  const LoadDayDiaryRequested(this.date);

  @override
  List<Object?> get props => [date];

  @override
  String toString() => 'LoadDayDiaryRequested(${date.toIso8601String().split('T')[0]})';
}

/// Загрузить историю дневника
class LoadDiaryHistoryRequested extends DiaryEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int limit;

  const LoadDiaryHistoryRequested({
    this.startDate,
    this.endDate,
    this.limit = 30,
  });

  @override
  List<Object?> get props => [startDate, endDate, limit];

  @override
  String toString() => 'LoadDiaryHistoryRequested(limit: $limit)';
}

// ==================== MEAL СОБЫТИЯ ====================

/// Добавить прием пищи
class AddMealRequested extends DiaryEvent {
  final String mealName;
  final String mealType;
  final DateTime consumedAt;
  final int portionGrams;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fats;
  final File? photo;
  final bool fromPlan;
  final String? recipeId;

  const AddMealRequested({
    required this.mealName,
    required this.mealType,
    required this.consumedAt,
    required this.portionGrams,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.photo,
    this.fromPlan = false,
    this.recipeId,
  });

  @override
  List<Object?> get props => [
        mealName,
        mealType,
        consumedAt,
        portionGrams,
        calories,
        protein,
        carbs,
        fats,
        photo,
        fromPlan,
        recipeId,
      ];

  @override
  String toString() => 'AddMealRequested($mealName, $mealType)';
}

/// Удалить прием пищи
class DeleteMealRequested extends DiaryEvent {
  final String mealId;

  const DeleteMealRequested(this.mealId);

  @override
  List<Object?> get props => [mealId];

  @override
  String toString() => 'DeleteMealRequested($mealId)';
}

// ==================== WATER СОБЫТИЯ ====================

/// Добавить воду
class AddWaterRequested extends DiaryEvent {
  final DateTime date;
  final int amount; // мл (100, 200, 250)

  const AddWaterRequested({
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [date, amount];

  @override
  String toString() => 'AddWaterRequested($amount мл)';
}

/// Убавить воду
class RemoveWaterRequested extends DiaryEvent {
  final DateTime date;
  final int amount; // мл (обычно 100)

  const RemoveWaterRequested({
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [date, amount];

  @override
  String toString() => 'RemoveWaterRequested($amount мл)';
}

// ==================== MOOD СОБЫТИЯ ====================

/// Обновить настроение
class UpdateMoodRequested extends DiaryEvent {
  final DateTime date;
  final int rating; // 1-5

  const UpdateMoodRequested({
    required this.date,
    required this.rating,
  });

  @override
  List<Object?> get props => [date, rating];

  @override
  String toString() => 'UpdateMoodRequested(rating: $rating)';
}

// ==================== DAY УПРАВЛЕНИЕ ====================

/// Завершить день
class CompleteDayRequested extends DiaryEvent {
  final DateTime date;

  const CompleteDayRequested(this.date);

  @override
  List<Object?> get props => [date];

  @override
  String toString() => 'CompleteDayRequested(${date.toIso8601String().split('T')[0]})';
}

/// Обновить дневные цели
class UpdateDailyGoalsRequested extends DiaryEvent {
  final DateTime date;
  final DailyGoals goals;

  const UpdateDailyGoalsRequested({
    required this.date,
    required this.goals,
  });

  @override
  List<Object?> get props => [date, goals];

  @override
  String toString() => 'UpdateDailyGoalsRequested(${goals.calories} ккал)';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetDiaryState extends DiaryEvent {
  const ResetDiaryState();

  @override
  String toString() => 'ResetDiaryState()';
}




