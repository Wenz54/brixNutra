import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/knowledge_base/models/knowledge_models.dart';

/// Сервис для работы с базой знаний
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class KnowledgeBaseService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== COURSES ====================

  /// Получить список курсов
  ///
  /// [category] - фильтр по категории
  /// [limit] - лимит результатов
  static Future<List<CourseWithProgress>> getCourses({
    String? category,
    int limit = 50,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetCourses(category: category, limit: limit);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
        if (category != null) 'category': category,
      };

      final response = await ApiService.get(
        ApiEndpoints.knowledgeCourses,
        queryParameters: queryParams,
      );

      return (response['data'] as List)
          .map((item) => CourseWithProgress.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getCourses error: $e');
      rethrow;
    }
  }

  /// Получить детальную информацию о курсе
  ///
  /// [courseId] - ID курса
  static Future<Course> getCourse(String courseId) async {
    try {
      if (useMockMode) {
        return _mockGetCourse(courseId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeCourse(courseId),
      );

      return Course.fromJson(response['data']);
    } catch (e) {
      print('❌ getCourse error: $e');
      rethrow;
    }
  }

  // ==================== LESSONS ====================

  /// Получить уроки курса
  ///
  /// [courseId] - ID курса
  static Future<List<Lesson>> getCourseLessons(String courseId) async {
    try {
      if (useMockMode) {
        return _mockGetCourseLessons(courseId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeCourseLessons(courseId),
      );

      return (response['data'] as List)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getCourseLessons error: $e');
      rethrow;
    }
  }

  /// Получить урок
  ///
  /// [lessonId] - ID урока
  static Future<Lesson> getLesson(String lessonId) async {
    try {
      if (useMockMode) {
        return _mockGetLesson(lessonId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeLesson(lessonId),
      );

      return Lesson.fromJson(response['data']);
    } catch (e) {
      print('❌ getLesson error: $e');
      rethrow;
    }
  }

  /// Отметить урок как пройденный
  ///
  /// [lessonId] - ID урока
  static Future<void> completeLesson(String lessonId) async {
    try {
      if (useMockMode) {
        return _mockCompleteLesson(lessonId);
      }

      // Реальный API запрос
      await ApiService.post(
        ApiEndpoints.knowledgeLessonComplete(lessonId),
        {},
      );
      print('✅ Урок отмечен как пройденный: $lessonId');
    } catch (e) {
      print('❌ completeLesson error: $e');
      rethrow;
    }
  }

  // ==================== PROGRESS ====================

  /// Получить прогресс по курсу
  ///
  /// [courseId] - ID курса
  static Future<CourseProgress> getCourseProgress(String courseId) async {
    try {
      if (useMockMode) {
        return _mockGetCourseProgress(courseId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeCourseProgress(courseId),
      );

      return CourseProgress.fromJson(response['data']);
    } catch (e) {
      print('❌ getCourseProgress error: $e');
      rethrow;
    }
  }

  // ==================== CATEGORIES ====================

  /// Получить список категорий
  static Future<List<Category>> getCategories() async {
    try {
      if (useMockMode) {
        return _mockGetCategories();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeCategories,
      );

      return (response['data'] as List)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getCategories error: $e');
      rethrow;
    }
  }

  // ==================== FAVORITES ====================

  /// Получить избранные курсы
  static Future<List<CourseWithProgress>> getFavorites() async {
    try {
      if (useMockMode) {
        return _mockGetFavorites();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.knowledgeFavorites,
      );

      return (response['data'] as List)
          .map((item) => CourseWithProgress.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getFavorites error: $e');
      rethrow;
    }
  }

  /// Добавить в избранное
  ///
  /// [courseId] - ID курса
  static Future<void> addToFavorites(String courseId) async {
    try {
      if (useMockMode) {
        return _mockAddToFavorites(courseId);
      }

      // Реальный API запрос
      await ApiService.post(
        ApiEndpoints.knowledgeFavoritesAdd,
        {'course_id': courseId},
      );
      print('✅ Курс добавлен в избранное: $courseId');
    } catch (e) {
      print('❌ addToFavorites error: $e');
      rethrow;
    }
  }

  /// Удалить из избранного
  ///
  /// [courseId] - ID курса
  static Future<void> removeFromFavorites(String courseId) async {
    try {
      if (useMockMode) {
        return _mockRemoveFromFavorites(courseId);
      }

      // Реальный API запрос
      await ApiService.delete(
        ApiEndpoints.knowledgeFavoritesDelete(courseId),
      );
      print('✅ Курс удален из избранного: $courseId');
    } catch (e) {
      print('❌ removeFromFavorites error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static final List<Course> _mockCourses = [
    Course(
      id: 'course_1',
      title: 'Основы правильного питания',
      description: 'Изучите основы нутрициологии и научитесь составлять здоровый рацион',
      imageUrl: 'https://example.com/nutrition-basics.jpg',
      category: 'Основы',
      lessonsCount: 8,
      totalDurationMinutes: 240,
      isPremium: false,
      tags: ['новичкам', 'основы', 'питание'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Course(
      id: 'course_2',
      title: 'Спортивное питание',
      description: 'Питание для достижения спортивных целей: набор массы, сушка, выносливость',
      imageUrl: 'https://example.com/sports-nutrition.jpg',
      category: 'Спорт',
      lessonsCount: 12,
      totalDurationMinutes: 360,
      isPremium: true,
      tags: ['спорт', 'масса', 'сушка'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Course(
      id: 'course_3',
      title: 'Биохимия пищеварения',
      description: 'Как работает пищеварительная система и метаболизм',
      imageUrl: 'https://example.com/biochemistry.jpg',
      category: 'Наука',
      lessonsCount: 10,
      totalDurationMinutes: 300,
      isPremium: true,
      tags: ['наука', 'метаболизм', 'продвинутый'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  static final Map<String, int> _mockCompletedLessons = {
    'course_1': 3,
    'course_2': 0,
    'course_3': 5,
  };

  static final Set<String> _mockFavorites = {'course_1'};

  static Future<List<CourseWithProgress>> _mockGetCourses({
    String? category,
    int limit = 50,
  }) async {
    print('🎭 MOCK: Получение курсов (category: $category)');
    await Future.delayed(const Duration(milliseconds: 700));

    var courses = _mockCourses;
    
    if (category != null && category.isNotEmpty) {
      courses = courses.where((c) => c.category == category).toList();
    }

    return courses.take(limit).map((course) {
      return CourseWithProgress(
        course: course,
        completedLessons: _mockCompletedLessons[course.id] ?? 0,
        totalLessons: course.lessonsCount,
        lastAccessedAt: _mockCompletedLessons[course.id] != null
            ? DateTime.now().subtract(const Duration(days: 1))
            : null,
        isFavorite: _mockFavorites.contains(course.id),
      );
    }).toList();
  }

  static Future<Course> _mockGetCourse(String courseId) async {
    print('🎭 MOCK: Получение курса: $courseId');
    await Future.delayed(const Duration(milliseconds: 600));

    final course = _mockCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => _mockCourses.first,
    );

    return course;
  }

  static Future<List<Lesson>> _mockGetCourseLessons(String courseId) async {
    print('🎭 MOCK: Получение уроков курса: $courseId');
    await Future.delayed(const Duration(milliseconds: 800));

    // Генерируем mock уроки для курса
    final course = _mockCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => _mockCourses.first,
    );

    final completedCount = _mockCompletedLessons[courseId] ?? 0;

    return List.generate(course.lessonsCount, (index) {
      return Lesson(
        id: 'lesson_${courseId}_$index',
        courseId: courseId,
        title: 'Урок ${index + 1}: ${_generateLessonTitle(index)}',
        description: 'Описание урока ${index + 1}',
        content: _generateLessonContent(index),
        orderIndex: index,
        durationMinutes: 30,
        videoUrl: index % 2 == 0 ? 'https://example.com/video_$index.mp4' : null,
        thumbnailUrl: 'https://example.com/thumb_$index.jpg',
        isFree: index == 0, // Первый урок бесплатный
        completedAt: index < completedCount
            ? DateTime.now().subtract(Duration(days: completedCount - index))
            : null,
      );
    });
  }

  static Future<Lesson> _mockGetLesson(String lessonId) async {
    print('🎭 MOCK: Получение урока: $lessonId');
    await Future.delayed(const Duration(milliseconds: 600));

    // Парсим courseId из lessonId
    final parts = lessonId.split('_');
    final courseId = parts.length >= 3 ? '${parts[1]}_${parts[2]}' : 'course_1';
    final index = parts.length >= 4 ? int.tryParse(parts[3]) ?? 0 : 0;

    return Lesson(
      id: lessonId,
      courseId: courseId,
      title: 'Урок ${index + 1}: ${_generateLessonTitle(index)}',
      description: 'Подробное описание урока ${index + 1}',
      content: _generateLessonContent(index),
      orderIndex: index,
      durationMinutes: 30,
      videoUrl: index % 2 == 0 ? 'https://example.com/video_$index.mp4' : null,
      thumbnailUrl: 'https://example.com/thumb_$index.jpg',
      isFree: index == 0,
    );
  }

  static Future<void> _mockCompleteLesson(String lessonId) async {
    print('🎭 MOCK: Завершение урока: $lessonId');
    await Future.delayed(const Duration(milliseconds: 400));

    // В реальности обновляем на сервере
  }

  static Future<CourseProgress> _mockGetCourseProgress(String courseId) async {
    print('🎭 MOCK: Получение прогресса курса: $courseId');
    await Future.delayed(const Duration(milliseconds: 500));

    final course = _mockCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => _mockCourses.first,
    );

    final completedCount = _mockCompletedLessons[courseId] ?? 0;

    return CourseProgress(
      courseId: courseId,
      completedLessons: completedCount,
      totalLessons: course.lessonsCount,
      startedAt: completedCount > 0
          ? DateTime.now().subtract(const Duration(days: 10))
          : null,
      completedAt: completedCount == course.lessonsCount
          ? DateTime.now().subtract(const Duration(days: 1))
          : null,
      lastAccessedAt: completedCount > 0
          ? DateTime.now().subtract(const Duration(hours: 12))
          : null,
    );
  }

  static Future<List<Category>> _mockGetCategories() async {
    print('🎭 MOCK: Получение категорий');
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      const Category(
        id: 'cat_1',
        name: 'Основы',
        description: 'Базовые знания о питании',
        coursesCount: 5,
      ),
      const Category(
        id: 'cat_2',
        name: 'Спорт',
        description: 'Питание для спортсменов',
        coursesCount: 8,
      ),
      const Category(
        id: 'cat_3',
        name: 'Наука',
        description: 'Научные основы нутрициологии',
        coursesCount: 6,
      ),
      const Category(
        id: 'cat_4',
        name: 'Рецепты',
        description: 'Здоровые рецепты',
        coursesCount: 12,
      ),
    ];
  }

  static Future<List<CourseWithProgress>> _mockGetFavorites() async {
    print('🎭 MOCK: Получение избранных курсов');
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockCourses
        .where((course) => _mockFavorites.contains(course.id))
        .map((course) {
      return CourseWithProgress(
        course: course,
        completedLessons: _mockCompletedLessons[course.id] ?? 0,
        totalLessons: course.lessonsCount,
        lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
        isFavorite: true,
      );
    }).toList();
  }

  static Future<void> _mockAddToFavorites(String courseId) async {
    print('🎭 MOCK: Добавление в избранное: $courseId');
    await Future.delayed(const Duration(milliseconds: 300));

    _mockFavorites.add(courseId);
  }

  static Future<void> _mockRemoveFromFavorites(String courseId) async {
    print('🎭 MOCK: Удаление из избранного: $courseId');
    await Future.delayed(const Duration(milliseconds: 300));

    _mockFavorites.remove(courseId);
  }

  // Вспомогательные методы для генерации контента
  static String _generateLessonTitle(int index) {
    const titles = [
      'Введение в нутрициологию',
      'Макронутриенты: белки, жиры, углеводы',
      'Микронутриенты и витамины',
      'Водный баланс организма',
      'Энергетический баланс и метаболизм',
      'Составление рациона',
      'Пищевые добавки',
      'Практические рекомендации',
      'Распространенные ошибки',
      'Индивидуальный подход',
    ];

    return titles[index % titles.length];
  }

  static String _generateLessonContent(int index) {
    return '''
# ${_generateLessonTitle(index)}

## Введение

В этом уроке мы рассмотрим важные аспекты правильного питания.

## Основные концепции

1. **Первый пункт**: Описание первого важного момента
2. **Второй пункт**: Описание второго важного момента
3. **Третий пункт**: Описание третьего важного момента

## Практические рекомендации

- Рекомендация 1
- Рекомендация 2
- Рекомендация 3

## Заключение

Подведение итогов урока.

---

**Длительность:** 30 минут  
**Уровень:** Базовый
''';
  }
}

