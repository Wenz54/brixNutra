# Knowledge Module

Модуль базы знаний и курсов для Supply Diets приложения.

## 📦 Функционал

- Просмотр курсов
- Просмотр уроков
- Видео и аудио контент
- Прогресс обучения
- Авторские курсы

## 🚀 Использование

```dart
// Получить все курсы
final courses = await KnowledgeService.getAllCourses();

// Получить курс по ID
final course = await KnowledgeService.getCourseById(courseId);

// Получить урок
final lesson = await KnowledgeService.getLesson(lessonId);

// Отметить урок как просмотренный
await KnowledgeService.markLessonComplete(lessonId);
```

## 📡 API Endpoints

- `GET /courses` - Получить все курсы
- `GET /courses/:id` - Получить курс по ID
- `GET /courses/:id/lessons` - Получить уроки курса
- `GET /lessons/:id` - Получить урок
- `POST /lessons/:id/complete` - Отметить урок просмотренным

## 📱 Экраны

- **KnowledgeScreen** - Список курсов
- **CourseDetailScreen** - Детали курса
- **LessonScreen** - Просмотр урока
- **FreeCoursesScreen** - Бесплатные курсы





