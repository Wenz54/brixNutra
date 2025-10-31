import 'package:equatable/equatable.dart';
import 'package:mobile/features/diary/models/diary_models.dart';

/// Состояния дневника питания
abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class DiaryInitial extends DiaryState {
  const DiaryInitial();

  @override
  String toString() => 'DiaryInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class DiaryLoading extends DiaryState {
  final String? message;

  const DiaryLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'DiaryLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ ====================

/// Дневник дня загружен
class DayDiaryLoaded extends DiaryState {
  final DiaryDay diaryDay;

  const DayDiaryLoaded(this.diaryDay);

  @override
  List<Object?> get props => [diaryDay];

  @override
  String toString() =>
      'DayDiaryLoaded(${diaryDay.date.toIso8601String().split('T')[0]}, ${diaryDay.meals.length} приемов)';
}

/// История дневника загружена
class DiaryHistoryLoaded extends DiaryState {
  final List<DiaryHistoryItem> history;

  const DiaryHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];

  @override
  String toString() => 'DiaryHistoryLoaded(${history.length} дней)';
}

/// Прием пищи добавлен
class MealAdded extends DiaryState {
  final DiaryMeal meal;
  final String message;

  const MealAdded({
    required this.meal,
    this.message = 'Прием пищи добавлен',
  });

  @override
  List<Object?> get props => [meal, message];

  @override
  String toString() => 'MealAdded(${meal.mealName})';
}

/// Прием пищи удален
class MealDeleted extends DiaryState {
  final String mealId;
  final String message;

  const MealDeleted({
    required this.mealId,
    this.message = 'Прием пищи удален',
  });

  @override
  List<Object?> get props => [mealId, message];

  @override
  String toString() => 'MealDeleted($mealId)';
}

/// Вода обновлена
class WaterUpdated extends DiaryState {
  final WaterLog waterLog;
  final String message;

  const WaterUpdated({
    required this.waterLog,
    this.message = 'Вода обновлена',
  });

  @override
  List<Object?> get props => [waterLog, message];

  @override
  String toString() =>
      'WaterUpdated(${waterLog.totalAmount}мл / ${waterLog.dailyGoal}мл)';
}

/// Настроение обновлено
class MoodUpdated extends DiaryState {
  final int rating;
  final String message;

  const MoodUpdated({
    required this.rating,
    this.message = 'Настроение обновлено',
  });

  @override
  List<Object?> get props => [rating, message];

  @override
  String toString() => 'MoodUpdated(rating: $rating)';
}

/// День завершен
class DayCompleted extends DiaryState {
  final DateTime date;
  final String message;

  const DayCompleted({
    required this.date,
    this.message = 'День завершен',
  });

  @override
  List<Object?> get props => [date, message];

  @override
  String toString() =>
      'DayCompleted(${date.toIso8601String().split('T')[0]})';
}

/// Цели обновлены
class DailyGoalsUpdated extends DiaryState {
  final DailyGoals goals;
  final String message;

  const DailyGoalsUpdated({
    required this.goals,
    this.message = 'Цели обновлены',
  });

  @override
  List<Object?> get props => [goals, message];

  @override
  String toString() => 'DailyGoalsUpdated(${goals.calories} ккал)';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка дневника
class DiaryError extends DiaryState {
  final String message;
  final String? code;

  const DiaryError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'DiaryError(message: $message, code: $code)';
}




