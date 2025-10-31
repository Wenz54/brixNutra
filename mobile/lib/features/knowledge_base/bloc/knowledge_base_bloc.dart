import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/knowledge_base/bloc/knowledge_base_event.dart';
import 'package:mobile/features/knowledge_base/bloc/knowledge_base_state.dart';
import 'package:mobile/features/knowledge_base/services/knowledge_base_service.dart';

/// BLoC для управления базой знаний
///
/// Обрабатывает все действия пользователя:
/// - Загрузка курсов и уроков
/// - Прохождение уроков
/// - Отслеживание прогресса
/// - Управление избранным
class KnowledgeBaseBloc extends Bloc<KnowledgeBaseEvent, KnowledgeBaseState> {
  KnowledgeBaseBloc() : super(const KnowledgeBaseInitial()) {
    on<LoadCoursesRequested>(_onLoadCourses);
    on<LoadCourseRequested>(_onLoadCourse);
    on<LoadCourseLessonsRequested>(_onLoadCourseLessons);
    on<LoadLessonRequested>(_onLoadLesson);
    on<CompleteLessonRequested>(_onCompleteLesson);
    on<LoadCourseProgressRequested>(_onLoadCourseProgress);
    on<LoadCategoriesRequested>(_onLoadCategories);
    on<LoadFavoritesRequested>(_onLoadFavorites);
    on<AddToFavoritesRequested>(_onAddToFavorites);
    on<RemoveFromFavoritesRequested>(_onRemoveFromFavorites);
    on<ResetKnowledgeBaseState>(_onResetState);
  }

  // ==================== COURSES ====================

  /// Загрузить курсы
  Future<void> _onLoadCourses(
    LoadCoursesRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка курсов...'));
      
      final courses = await KnowledgeBaseService.getCourses(
        category: event.category,
        limit: event.limit,
      );
      
      emit(CoursesLoaded(courses));
      print('✅ KnowledgeBaseBloc: Курсы загружены (${courses.length})');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить курсы: $e',
        code: 'LOAD_COURSES_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки курсов: $e');
    }
  }

  /// Загрузить курс
  Future<void> _onLoadCourse(
    LoadCourseRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка курса...'));
      
      final course = await KnowledgeBaseService.getCourse(event.courseId);
      
      emit(CourseLoaded(course));
      print('✅ KnowledgeBaseBloc: Курс загружен: ${course.title}');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить курс: $e',
        code: 'LOAD_COURSE_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки курса: $e');
    }
  }

  // ==================== LESSONS ====================

  /// Загрузить уроки курса
  Future<void> _onLoadCourseLessons(
    LoadCourseLessonsRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка уроков...'));
      
      final lessons = await KnowledgeBaseService.getCourseLessons(event.courseId);
      
      emit(CourseLessonsLoaded(
        courseId: event.courseId,
        lessons: lessons,
      ));
      print('✅ KnowledgeBaseBloc: Уроки загружены (${lessons.length})');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить уроки: $e',
        code: 'LOAD_LESSONS_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки уроков: $e');
    }
  }

  /// Загрузить урок
  Future<void> _onLoadLesson(
    LoadLessonRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка урока...'));
      
      final lesson = await KnowledgeBaseService.getLesson(event.lessonId);
      
      emit(LessonLoaded(lesson));
      print('✅ KnowledgeBaseBloc: Урок загружен: ${lesson.title}');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить урок: $e',
        code: 'LOAD_LESSON_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки урока: $e');
    }
  }

  /// Завершить урок
  Future<void> _onCompleteLesson(
    CompleteLessonRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Сохранение прогресса...'));
      
      await KnowledgeBaseService.completeLesson(event.lessonId);
      
      emit(LessonCompleted(
        lessonId: event.lessonId,
        courseId: event.courseId,
        message: 'Урок завершен! 🎉',
      ));
      print('✅ KnowledgeBaseBloc: Урок завершен: ${event.lessonId}');
      
      // Перезагрузка уроков курса для обновления статусов
      final lessons = await KnowledgeBaseService.getCourseLessons(event.courseId);
      emit(CourseLessonsLoaded(
        courseId: event.courseId,
        lessons: lessons,
      ));
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось завершить урок: $e',
        code: 'COMPLETE_LESSON_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка завершения урока: $e');
    }
  }

  // ==================== PROGRESS ====================

  /// Загрузить прогресс по курсу
  Future<void> _onLoadCourseProgress(
    LoadCourseProgressRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка прогресса...'));
      
      final progress = await KnowledgeBaseService.getCourseProgress(event.courseId);
      
      emit(CourseProgressLoaded(progress));
      print('✅ KnowledgeBaseBloc: Прогресс загружен: ${progress.progressPercent}%');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить прогресс: $e',
        code: 'LOAD_PROGRESS_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки прогресса: $e');
    }
  }

  // ==================== CATEGORIES ====================

  /// Загрузить категории
  Future<void> _onLoadCategories(
    LoadCategoriesRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка категорий...'));
      
      final categories = await KnowledgeBaseService.getCategories();
      
      emit(CategoriesLoaded(categories));
      print('✅ KnowledgeBaseBloc: Категории загружены (${categories.length})');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить категории: $e',
        code: 'LOAD_CATEGORIES_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки категорий: $e');
    }
  }

  // ==================== FAVORITES ====================

  /// Загрузить избранное
  Future<void> _onLoadFavorites(
    LoadFavoritesRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Загрузка избранного...'));
      
      final favorites = await KnowledgeBaseService.getFavorites();
      
      emit(FavoritesLoaded(favorites));
      print('✅ KnowledgeBaseBloc: Избранное загружено (${favorites.length})');
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось загрузить избранное: $e',
        code: 'LOAD_FAVORITES_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка загрузки избранного: $e');
    }
  }

  /// Добавить в избранное
  Future<void> _onAddToFavorites(
    AddToFavoritesRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Добавление в избранное...'));
      
      await KnowledgeBaseService.addToFavorites(event.courseId);
      
      emit(AddedToFavorites(
        courseId: event.courseId,
        message: 'Добавлено в избранное',
      ));
      print('✅ KnowledgeBaseBloc: Добавлено в избранное: ${event.courseId}');
      
      // Перезагрузка списка курсов
      final courses = await KnowledgeBaseService.getCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось добавить в избранное: $e',
        code: 'ADD_TO_FAVORITES_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка добавления в избранное: $e');
    }
  }

  /// Удалить из избранного
  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesRequested event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    try {
      emit(const KnowledgeBaseLoading(message: 'Удаление из избранного...'));
      
      await KnowledgeBaseService.removeFromFavorites(event.courseId);
      
      emit(RemovedFromFavorites(
        courseId: event.courseId,
        message: 'Удалено из избранного',
      ));
      print('✅ KnowledgeBaseBloc: Удалено из избранного: ${event.courseId}');
      
      // Перезагрузка списка курсов
      final courses = await KnowledgeBaseService.getCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(KnowledgeBaseError(
        message: 'Не удалось удалить из избранного: $e',
        code: 'REMOVE_FROM_FAVORITES_ERROR',
      ));
      print('❌ KnowledgeBaseBloc: Ошибка удаления из избранного: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetKnowledgeBaseState event,
    Emitter<KnowledgeBaseState> emit,
  ) async {
    emit(const KnowledgeBaseInitial());
    print('🔄 KnowledgeBaseBloc: Состояние сброшено');
  }
}




