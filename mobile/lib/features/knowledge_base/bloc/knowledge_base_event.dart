import 'package:equatable/equatable.dart';

/// События для управления базой знаний
abstract class KnowledgeBaseEvent extends Equatable {
  const KnowledgeBaseEvent();

  @override
  List<Object?> get props => [];
}

// ==================== COURSES СОБЫТИЯ ====================

/// Загрузить курсы
class LoadCoursesRequested extends KnowledgeBaseEvent {
  final String? category;
  final int limit;

  const LoadCoursesRequested({
    this.category,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [category, limit];

  @override
  String toString() => 'LoadCoursesRequested(category: $category, limit: $limit)';
}

/// Загрузить курс
class LoadCourseRequested extends KnowledgeBaseEvent {
  final String courseId;

  const LoadCourseRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() => 'LoadCourseRequested($courseId)';
}

// ==================== LESSONS СОБЫТИЯ ====================

/// Загрузить уроки курса
class LoadCourseLessonsRequested extends KnowledgeBaseEvent {
  final String courseId;

  const LoadCourseLessonsRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() => 'LoadCourseLessonsRequested($courseId)';
}

/// Загрузить урок
class LoadLessonRequested extends KnowledgeBaseEvent {
  final String lessonId;

  const LoadLessonRequested(this.lessonId);

  @override
  List<Object?> get props => [lessonId];

  @override
  String toString() => 'LoadLessonRequested($lessonId)';
}

/// Отметить урок как пройденный
class CompleteLessonRequested extends KnowledgeBaseEvent {
  final String lessonId;
  final String courseId;

  const CompleteLessonRequested({
    required this.lessonId,
    required this.courseId,
  });

  @override
  List<Object?> get props => [lessonId, courseId];

  @override
  String toString() => 'CompleteLessonRequested($lessonId)';
}

// ==================== PROGRESS СОБЫТИЯ ====================

/// Загрузить прогресс по курсу
class LoadCourseProgressRequested extends KnowledgeBaseEvent {
  final String courseId;

  const LoadCourseProgressRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() => 'LoadCourseProgressRequested($courseId)';
}

// ==================== CATEGORIES СОБЫТИЯ ====================

/// Загрузить категории
class LoadCategoriesRequested extends KnowledgeBaseEvent {
  const LoadCategoriesRequested();

  @override
  String toString() => 'LoadCategoriesRequested()';
}

// ==================== FAVORITES СОБЫТИЯ ====================

/// Загрузить избранное
class LoadFavoritesRequested extends KnowledgeBaseEvent {
  const LoadFavoritesRequested();

  @override
  String toString() => 'LoadFavoritesRequested()';
}

/// Добавить в избранное
class AddToFavoritesRequested extends KnowledgeBaseEvent {
  final String courseId;

  const AddToFavoritesRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() => 'AddToFavoritesRequested($courseId)';
}

/// Удалить из избранного
class RemoveFromFavoritesRequested extends KnowledgeBaseEvent {
  final String courseId;

  const RemoveFromFavoritesRequested(this.courseId);

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() => 'RemoveFromFavoritesRequested($courseId)';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetKnowledgeBaseState extends KnowledgeBaseEvent {
  const ResetKnowledgeBaseState();

  @override
  String toString() => 'ResetKnowledgeBaseState()';
}




