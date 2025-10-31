import 'package:equatable/equatable.dart';
import 'package:mobile/features/blog_notifications/models/blog_notification_models.dart';

/// Состояния блога и уведомлений
abstract class BlogNotificationsState extends Equatable {
  const BlogNotificationsState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class BlogNotificationsInitial extends BlogNotificationsState {
  const BlogNotificationsInitial();

  @override
  String toString() => 'BlogNotificationsInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class BlogNotificationsLoading extends BlogNotificationsState {
  final String? message;

  const BlogNotificationsLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'BlogNotificationsLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ - BLOG ====================

/// Статьи блога загружены
class BlogArticlesLoaded extends BlogNotificationsState {
  final List<BlogArticlePreview> articles;

  const BlogArticlesLoaded(this.articles);

  @override
  List<Object?> get props => [articles];

  @override
  String toString() => 'BlogArticlesLoaded(${articles.length} статей)';
}

/// Статья блога загружена
class BlogArticleLoaded extends BlogNotificationsState {
  final BlogArticle article;

  const BlogArticleLoaded(this.article);

  @override
  List<Object?> get props => [article];

  @override
  String toString() => 'BlogArticleLoaded(${article.title})';
}

// ==================== SUCCESS СОСТОЯНИЯ - NOTIFICATIONS ====================

/// Уведомления загружены
class NotificationsLoaded extends BlogNotificationsState {
  final List<AppNotification> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];

  @override
  String toString() => 'NotificationsLoaded(${notifications.length} уведомлений)';
}

/// Уведомление отмечено как прочитанное
class NotificationMarkedAsRead extends BlogNotificationsState {
  final String notificationId;
  final String message;

  const NotificationMarkedAsRead({
    required this.notificationId,
    this.message = 'Отмечено как прочитанное',
  });

  @override
  List<Object?> get props => [notificationId, message];

  @override
  String toString() => 'NotificationMarkedAsRead($notificationId)';
}

/// Уведомление удалено
class NotificationDeleted extends BlogNotificationsState {
  final String notificationId;
  final String message;

  const NotificationDeleted({
    required this.notificationId,
    this.message = 'Уведомление удалено',
  });

  @override
  List<Object?> get props => [notificationId, message];

  @override
  String toString() => 'NotificationDeleted($notificationId)';
}

/// Статистика уведомлений загружена
class NotificationStatsLoaded extends BlogNotificationsState {
  final NotificationStats stats;

  const NotificationStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];

  @override
  String toString() =>
      'NotificationStatsLoaded(total: ${stats.total}, unread: ${stats.unread})';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка блога/уведомлений
class BlogNotificationsError extends BlogNotificationsState {
  final String message;
  final String? code;

  const BlogNotificationsError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() =>
      'BlogNotificationsError(message: $message, code: $code)';
}




