# 📚 Knowledge Base Feature

Модуль базы знаний (курсы и уроки) для Brix Nutrition App.

## 📋 Описание

Knowledge Base Feature предоставляет полный функционал для обучения:
- 📚 Каталог курсов по категориям
- 📖 Уроки с текстом и видео
- 📊 Отслеживание прогресса
- ⭐ Избранные курсы
- ✅ Отметки о прохождении

## 📦 Models

### Course
```dart
class Course {
  final String id;
  final String title;
  final String category;
  final int lessonsCount;
  final int totalDurationMinutes;
  final bool isPremium;
}
```

### Lesson
```dart
class Lesson {
  final String id;
  final String title;
  final String content;  // Markdown
  final int durationMinutes;
  final String? videoUrl;
  final bool isFree;
  final DateTime? completedAt;
}
```

### CourseWithProgress
```dart
class CourseWithProgress {
  final Course course;
  final int completedLessons;
  final int totalLessons;
  final bool isFavorite;
  
  double get progress;  // 0.0 - 1.0
  int get progressPercent;  // 0-100
}
```

## 🔌 Service API

```dart
// Курсы
Future<List<CourseWithProgress>> getCourses({category, limit})
Future<Course> getCourse(String courseId)

// Уроки
Future<List<Lesson>> getCourseLessons(String courseId)
Future<Lesson> getLesson(String lessonId)
Future<void> completeLesson(String lessonId)

// Прогресс
Future<CourseProgress> getCourseProgress(String courseId)

// Категории
Future<List<Category>> getCategories()

// Избранное
Future<List<CourseWithProgress>> getFavorites()
Future<void> addToFavorites(String courseId)
Future<void> removeFromFavorites(String courseId)
```

## 💡 Использование

### Загрузить курсы
```dart
context.read<KnowledgeBaseBloc>().add(
  LoadCoursesRequested(category: 'Основы'),
);
```

### Просмотр урока
```dart
context.read<KnowledgeBaseBloc>().add(
  LoadLessonRequested('lesson_123'),
);
```

### Завершить урок
```dart
context.read<KnowledgeBaseBloc>().add(
  CompleteLessonRequested(
    lessonId: 'lesson_123',
    courseId: 'course_1',
  ),
);
```

## 🎭 Mock данные

- **3 курса:**
  1. Основы правильного питания (8 уроков, 4 часа)
  2. Спортивное питание (12 уроков, 6 часов) 💎
  3. Биохимия пищеварения (10 уроков, 5 часов) 💎

- **4 категории:** Основы, Спорт, Наука, Рецепты

- **Уроки:** Генерируются динамически для каждого курса с Markdown контентом

---

**Создано:** 14 октября 2025  
**Версия:** 1.0.0  
**Task:** 3.8




