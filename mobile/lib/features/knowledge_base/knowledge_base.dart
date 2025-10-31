/// Knowledge Base Feature
///
/// Модуль для работы с базой знаний (курсы и уроки)
///
/// Включает:
/// - Models: Course, Lesson, Category, CourseProgress
/// - Service: KnowledgeBaseService (Mock + Real API)
/// - BLoC: KnowledgeBaseBloc, KnowledgeBaseEvent, KnowledgeBaseState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/knowledge_base/knowledge_base.dart';
///
/// // В BlocProvider
/// BlocProvider<KnowledgeBaseBloc>(
///   create: (context) => KnowledgeBaseBloc()
///     ..add(LoadCoursesRequested()),
///   child: MyWidget(),
/// )
///
/// // Загрузить курсы
/// context.read<KnowledgeBaseBloc>().add(
///   LoadCoursesRequested(category: 'Основы'),
/// );
///
/// // Завершить урок
/// context.read<KnowledgeBaseBloc>().add(
///   CompleteLessonRequested(
///     lessonId: 'lesson_123',
///     courseId: 'course_1',
///   ),
/// );
/// ```
library;

export 'models/knowledge_models.dart';
export 'services/knowledge_base_service.dart';
export 'bloc/knowledge_base_bloc.dart';
export 'bloc/knowledge_base_event.dart';
export 'bloc/knowledge_base_state.dart';




