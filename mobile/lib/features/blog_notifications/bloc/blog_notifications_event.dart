import 'package:equatable/equatable.dart';

/// События для управления блогом и уведомлениями
abstract class BlogNotificationsEvent extends Equatable {
  const BlogNotificationsEvent();

  @override
  List<Object?> get props => [];
}

// ==================== BLOG СОБЫТИЯ ====================

/// Загрузить статьи блога
class LoadBlogArticlesRequested extends BlogNotificationsEvent {
  final String? tag;
  final int limit;

  const LoadBlogArticlesRequested({
    this.tag,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [tag, limit];

  @override
  String toString() => 'LoadBlogArticlesRequested(tag: $tag, limit: $limit)';
}

/// Загрузить статью блога
class LoadBlogArticleRequested extends BlogNotificationsEvent {
  final String articleId;

  const LoadBlogArticleRequested(this.articleId);

  @override
  List<Object?> get props => [articleId];

  @override
  String toString() => 'LoadBlogArticleRequested($articleId)';
}

// ==================== NOTIFICATIONS СОБЫТИЯ ====================

/// Загрузить уведомления
class LoadNotificationsRequested extends BlogNotificationsEvent {
  final int limit;

  const LoadNotificationsRequested({this.limit = 50});

  @override
  List<Object?> get props => [limit];

  @override
  String toString() => 'LoadNotificationsRequested(limit: $limit)';
}

/// Отметить как прочитанное
class MarkAsReadRequested extends BlogNotificationsEvent {
  final String notificationId;

  const MarkAsReadRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];

  @override
  String toString() => 'MarkAsReadRequested($notificationId)';
}

/// Удалить уведомление
class DeleteNotificationRequested extends BlogNotificationsEvent {
  final String notificationId;

  const DeleteNotificationRequested(this.notificationId);

  @override
  List<Object?> get props => [notificationId];

  @override
  String toString() => 'DeleteNotificationRequested($notificationId)';
}

/// Загрузить статистику уведомлений
class LoadNotificationStatsRequested extends BlogNotificationsEvent {
  const LoadNotificationStatsRequested();

  @override
  String toString() => 'LoadNotificationStatsRequested()';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetBlogNotificationsState extends BlogNotificationsEvent {
  const ResetBlogNotificationsState();

  @override
  String toString() => 'ResetBlogNotificationsState()';
}




