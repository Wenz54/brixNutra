import 'package:equatable/equatable.dart';

// ==================== BLOG ARTICLE ====================

/// Статья блога
class BlogArticle extends Equatable {
  final String id;
  final String title;
  final String? excerpt;          // Краткое описание
  final String content;            // Полный контент (Markdown/HTML)
  final String? imageUrl;          // Обложка статьи
  final String author;             // Автор
  final List<String> tags;         // Теги
  final DateTime publishedAt;      // Дата публикации
  final int readTimeMinutes;       // Время чтения
  final int viewsCount;            // Просмотры
  final bool isBookmarked;         // В закладках?

  const BlogArticle({
    required this.id,
    required this.title,
    this.excerpt,
    required this.content,
    this.imageUrl,
    required this.author,
    required this.tags,
    required this.publishedAt,
    required this.readTimeMinutes,
    this.viewsCount = 0,
    this.isBookmarked = false,
  });

  factory BlogArticle.fromJson(Map<String, dynamic> json) {
    return BlogArticle(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      excerpt: json['excerpt'],
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      author: json['author'] ?? 'Автор',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      publishedAt: DateTime.parse(json['published_at']),
      readTimeMinutes: json['read_time_minutes'] ?? 5,
      viewsCount: json['views_count'] ?? 0,
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'image_url': imageUrl,
      'author': author,
      'tags': tags,
      'published_at': publishedAt.toIso8601String(),
      'read_time_minutes': readTimeMinutes,
      'views_count': viewsCount,
      'is_bookmarked': isBookmarked,
    };
  }

  /// Дата в читаемом формате
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(publishedAt);

    if (diff.inHours < 1) {
      return '${diff.inMinutes} мин назад';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} дн назад';
    } else {
      return '${publishedAt.day}.${publishedAt.month}.${publishedAt.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        excerpt,
        content,
        imageUrl,
        author,
        tags,
        publishedAt,
        readTimeMinutes,
        viewsCount,
        isBookmarked,
      ];

  @override
  String toString() => 'BlogArticle($title, $author)';
}

// ==================== BLOG ARTICLE PREVIEW ====================

/// Краткая информация о статье (для списка)
class BlogArticlePreview extends Equatable {
  final String id;
  final String title;
  final String? excerpt;
  final String? imageUrl;
  final String author;
  final List<String> tags;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final int viewsCount;
  final bool isBookmarked;

  const BlogArticlePreview({
    required this.id,
    required this.title,
    this.excerpt,
    this.imageUrl,
    required this.author,
    required this.tags,
    required this.publishedAt,
    required this.readTimeMinutes,
    this.viewsCount = 0,
    this.isBookmarked = false,
  });

  factory BlogArticlePreview.fromJson(Map<String, dynamic> json) {
    return BlogArticlePreview(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      excerpt: json['excerpt'],
      imageUrl: json['image_url'],
      author: json['author'] ?? 'Автор',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      publishedAt: DateTime.parse(json['published_at']),
      readTimeMinutes: json['read_time_minutes'] ?? 5,
      viewsCount: json['views_count'] ?? 0,
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'image_url': imageUrl,
      'author': author,
      'tags': tags,
      'published_at': publishedAt.toIso8601String(),
      'read_time_minutes': readTimeMinutes,
      'views_count': viewsCount,
      'is_bookmarked': isBookmarked,
    };
  }

  /// Дата в читаемом формате
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(publishedAt);

    if (diff.inHours < 1) {
      return '${diff.inMinutes} мин назад';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} дн назад';
    } else {
      return '${publishedAt.day}.${publishedAt.month}.${publishedAt.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        excerpt,
        imageUrl,
        author,
        tags,
        publishedAt,
        readTimeMinutes,
        viewsCount,
        isBookmarked,
      ];

  @override
  String toString() => 'BlogArticlePreview($title)';
}

// ==================== NOTIFICATION ====================

/// Уведомление
class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;              // 'info', 'success', 'warning', 'meal_reminder', etc.
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data; // Дополнительные данные

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'info',
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'data': data,
    };
  }

  /// Иконка уведомления
  String get icon {
    switch (type) {
      case 'success':
        return '✅';
      case 'warning':
        return '⚠️';
      case 'meal_reminder':
        return '🍽️';
      case 'water_reminder':
        return '💧';
      case 'achievement':
        return '🏆';
      case 'lesson_reminder':
        return '📚';
      default:
        return 'ℹ️';
    }
  }

  /// Дата в читаемом формате
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) {
      return 'Только что';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} мин назад';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} дн назад';
    } else {
      return '${createdAt.day}.${createdAt.month}.${createdAt.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        createdAt,
        isRead,
        data,
      ];

  @override
  String toString() => 'AppNotification($title, $type, isRead: $isRead)';
}

// ==================== NOTIFICATION STATS ====================

/// Статистика уведомлений
class NotificationStats extends Equatable {
  final int total;
  final int unread;

  const NotificationStats({
    required this.total,
    required this.unread,
  });

  factory NotificationStats.fromJson(Map<String, dynamic> json) {
    return NotificationStats(
      total: json['total'] ?? 0,
      unread: json['unread'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'unread': unread,
    };
  }

  /// Есть ли непрочитанные
  bool get hasUnread => unread > 0;

  @override
  List<Object?> get props => [total, unread];

  @override
  String toString() => 'NotificationStats(total: $total, unread: $unread)';
}




