import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/blog_notifications/bloc/blog_notifications_event.dart';
import 'package:mobile/features/blog_notifications/bloc/blog_notifications_state.dart';
import 'package:mobile/features/blog_notifications/services/blog_notifications_service.dart';

/// BLoC для управления блогом и уведомлениями
///
/// Обрабатывает все действия пользователя:
/// - Загрузка статей блога
/// - Просмотр статей
/// - Загрузка уведомлений
/// - Отметки о прочтении
/// - Удаление уведомлений
class BlogNotificationsBloc
    extends Bloc<BlogNotificationsEvent, BlogNotificationsState> {
  BlogNotificationsBloc() : super(const BlogNotificationsInitial()) {
    on<LoadBlogArticlesRequested>(_onLoadBlogArticles);
    on<LoadBlogArticleRequested>(_onLoadBlogArticle);
    on<LoadNotificationsRequested>(_onLoadNotifications);
    on<MarkAsReadRequested>(_onMarkAsRead);
    on<DeleteNotificationRequested>(_onDeleteNotification);
    on<LoadNotificationStatsRequested>(_onLoadNotificationStats);
    on<ResetBlogNotificationsState>(_onResetState);
  }

  // ==================== BLOG ====================

  /// Загрузить статьи блога
  Future<void> _onLoadBlogArticles(
    LoadBlogArticlesRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(message: 'Загрузка статей...'));

      final articles = await BlogNotificationsService.getBlogArticles(
        tag: event.tag,
        limit: event.limit,
      );

      emit(BlogArticlesLoaded(articles));
      print('✅ BlogNotificationsBloc: Статьи загружены (${articles.length})');
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось загрузить статьи: $e',
        code: 'LOAD_ARTICLES_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка загрузки статей: $e');
    }
  }

  /// Загрузить статью блога
  Future<void> _onLoadBlogArticle(
    LoadBlogArticleRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(message: 'Загрузка статьи...'));

      final article =
          await BlogNotificationsService.getBlogArticle(event.articleId);

      emit(BlogArticleLoaded(article));
      print('✅ BlogNotificationsBloc: Статья загружена: ${article.title}');
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось загрузить статью: $e',
        code: 'LOAD_ARTICLE_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка загрузки статьи: $e');
    }
  }

  // ==================== NOTIFICATIONS ====================

  /// Загрузить уведомления
  Future<void> _onLoadNotifications(
    LoadNotificationsRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(message: 'Загрузка уведомлений...'));

      final notifications =
          await BlogNotificationsService.getNotifications(limit: event.limit);

      emit(NotificationsLoaded(notifications));
      print(
          '✅ BlogNotificationsBloc: Уведомления загружены (${notifications.length})');
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось загрузить уведомления: $e',
        code: 'LOAD_NOTIFICATIONS_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка загрузки уведомлений: $e');
    }
  }

  /// Отметить как прочитанное
  Future<void> _onMarkAsRead(
    MarkAsReadRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(
          message: 'Обновление уведомления...'));

      await BlogNotificationsService.markAsRead(event.notificationId);

      emit(NotificationMarkedAsRead(
        notificationId: event.notificationId,
        message: 'Отмечено как прочитанное',
      ));
      print(
          '✅ BlogNotificationsBloc: Уведомление отмечено: ${event.notificationId}');

      // Перезагрузка уведомлений
      final notifications = await BlogNotificationsService.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось отметить уведомление: $e',
        code: 'MARK_AS_READ_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка отметки уведомления: $e');
    }
  }

  /// Удалить уведомление
  Future<void> _onDeleteNotification(
    DeleteNotificationRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(message: 'Удаление уведомления...'));

      await BlogNotificationsService.deleteNotification(event.notificationId);

      emit(NotificationDeleted(
        notificationId: event.notificationId,
        message: 'Уведомление удалено',
      ));
      print(
          '✅ BlogNotificationsBloc: Уведомление удалено: ${event.notificationId}');

      // Перезагрузка уведомлений
      final notifications = await BlogNotificationsService.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось удалить уведомление: $e',
        code: 'DELETE_NOTIFICATION_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка удаления уведомления: $e');
    }
  }

  /// Загрузить статистику уведомлений
  Future<void> _onLoadNotificationStats(
    LoadNotificationStatsRequested event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    try {
      emit(const BlogNotificationsLoading(message: 'Загрузка статистики...'));

      final stats = await BlogNotificationsService.getNotificationStats();

      emit(NotificationStatsLoaded(stats));
      print(
          '✅ BlogNotificationsBloc: Статистика загружена (непрочитанных: ${stats.unread})');
    } catch (e) {
      emit(BlogNotificationsError(
        message: 'Не удалось загрузить статистику: $e',
        code: 'LOAD_STATS_ERROR',
      ));
      print('❌ BlogNotificationsBloc: Ошибка загрузки статистики: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetBlogNotificationsState event,
    Emitter<BlogNotificationsState> emit,
  ) async {
    emit(const BlogNotificationsInitial());
    print('🔄 BlogNotificationsBloc: Состояние сброшено');
  }
}




