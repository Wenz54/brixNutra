/// Blog & Notifications Feature
///
/// Модуль для работы с блогом и уведомлениями
///
/// Включает:
/// - Models: BlogArticle, AppNotification, NotificationStats
/// - Service: BlogNotificationsService (Mock + Real API)
/// - BLoC: BlogNotificationsBloc, BlogNotificationsEvent, BlogNotificationsState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/blog_notifications/blog_notifications.dart';
///
/// // В BlocProvider
/// BlocProvider<BlogNotificationsBloc>(
///   create: (context) => BlogNotificationsBloc()
///     ..add(LoadBlogArticlesRequested()),
///   child: MyWidget(),
/// )
///
/// // Загрузить статьи
/// context.read<BlogNotificationsBloc>().add(
///   LoadBlogArticlesRequested(tag: 'питание'),
/// );
///
/// // Отметить уведомление
/// context.read<BlogNotificationsBloc>().add(
///   MarkAsReadRequested('notif_123'),
/// );
/// ```
library;

export 'models/blog_notification_models.dart';
export 'services/blog_notifications_service.dart';
export 'bloc/blog_notifications_bloc.dart';
export 'bloc/blog_notifications_event.dart';
export 'bloc/blog_notifications_state.dart';




