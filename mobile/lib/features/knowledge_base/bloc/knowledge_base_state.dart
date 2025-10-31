import 'package:equatable/equatable.dart';
import 'package:mobile/features/knowledge_base/models/knowledge_models.dart';

/// Состояния базы знаний
abstract class KnowledgeBaseState extends Equatable {
  const KnowledgeBaseState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class KnowledgeBaseInitial extends KnowledgeBaseState {
  const KnowledgeBaseInitial();

  @override
  String toString() => 'KnowledgeBaseInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class KnowledgeBaseLoading extends KnowledgeBaseState {
  final String? message;

  const KnowledgeBaseLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'KnowledgeBaseLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ - COURSES ====================

/// Курсы загружены
class CoursesLoaded extends KnowledgeBaseState {
  final List<CourseWithProgress> courses;

  const CoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];

  @override
  String toString() => 'CoursesLoaded(${courses.length} курсов)';
}

/// Курс загружен
class CourseLoaded extends KnowledgeBaseState {
  final Course course;

  const CourseLoaded(this.course);

  @override
  List<Object?> get props => [course];

  @override
  String toString() => 'CourseLoaded(${course.title})';
}

// ==================== SUCCESS СОСТОЯНИЯ - LESSONS ====================

/// Уроки курса загружены
class CourseLessonsLoaded extends KnowledgeBaseState {
  final String courseId;
  final List<Lesson> lessons;

  const CourseLessonsLoaded({
    required this.courseId,
    required this.lessons,
  });

  @override
  List<Object?> get props => [courseId, lessons];

  @override
  String toString() => 'CourseLessonsLoaded($courseId, ${lessons.length} уроков)';
}

/// Урок загружен
class LessonLoaded extends KnowledgeBaseState {
  final Lesson lesson;

  const LessonLoaded(this.lesson);

  @override
  List<Object?> get props => [lesson];

  @override
  String toString() => 'LessonLoaded(${lesson.title})';
}

/// Урок завершен
class LessonCompleted extends KnowledgeBaseState {
  final String lessonId;
  final String courseId;
  final String message;

  const LessonCompleted({
    required this.lessonId,
    required this.courseId,
    this.message = 'Урок завершен',
  });

  @override
  List<Object?> get props => [lessonId, courseId, message];

  @override
  String toString() => 'LessonCompleted($lessonId)';
}

// ==================== SUCCESS СОСТОЯНИЯ - PROGRESS ====================

/// Прогресс загружен
class CourseProgressLoaded extends KnowledgeBaseState {
  final CourseProgress progress;

  const CourseProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];

  @override
  String toString() =>
      'CourseProgressLoaded(${progress.courseId}, ${progress.progressPercent}%)';
}

// ==================== SUCCESS СОСТОЯНИЯ - CATEGORIES ====================

/// Категории загружены
class CategoriesLoaded extends KnowledgeBaseState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];

  @override
  String toString() => 'CategoriesLoaded(${categories.length} категорий)';
}

// ==================== SUCCESS СОСТОЯНИЯ - FAVORITES ====================

/// Избранное загружено
class FavoritesLoaded extends KnowledgeBaseState {
  final List<CourseWithProgress> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];

  @override
  String toString() => 'FavoritesLoaded(${favorites.length} курсов)';
}

/// Добавлено в избранное
class AddedToFavorites extends KnowledgeBaseState {
  final String courseId;
  final String message;

  const AddedToFavorites({
    required this.courseId,
    this.message = 'Добавлено в избранное',
  });

  @override
  List<Object?> get props => [courseId, message];

  @override
  String toString() => 'AddedToFavorites($courseId)';
}

/// Удалено из избранного
class RemovedFromFavorites extends KnowledgeBaseState {
  final String courseId;
  final String message;

  const RemovedFromFavorites({
    required this.courseId,
    this.message = 'Удалено из избранного',
  });

  @override
  List<Object?> get props => [courseId, message];

  @override
  String toString() => 'RemovedFromFavorites($courseId)';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка базы знаний
class KnowledgeBaseError extends KnowledgeBaseState {
  final String message;
  final String? code;

  const KnowledgeBaseError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'KnowledgeBaseError(message: $message, code: $code)';
}




