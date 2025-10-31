import 'package:equatable/equatable.dart';

// ==================== LESSON ====================

/// Урок курса
class Lesson extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final String content;           // Контент урока (Markdown)
  final int orderIndex;           // Порядковый номер
  final int durationMinutes;      // Длительность в минутах
  final String? videoUrl;         // Ссылка на видео (опционально)
  final String? thumbnailUrl;     // Превью
  final bool isFree;              // Бесплатный урок?
  final DateTime? completedAt;    // Дата прохождения

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.content,
    required this.orderIndex,
    required this.durationMinutes,
    this.videoUrl,
    this.thumbnailUrl,
    this.isFree = false,
    this.completedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'] ?? '',
      orderIndex: json['order_index'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      isFree: json['is_free'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'content': content,
      'order_index': orderIndex,
      'duration_minutes': durationMinutes,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'is_free': isFree,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Пройден ли урок
  bool get isCompleted => completedAt != null;

  /// Есть ли видео
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        content,
        orderIndex,
        durationMinutes,
        videoUrl,
        thumbnailUrl,
        isFree,
        completedAt,
      ];

  @override
  String toString() => 'Lesson($title, ${durationMinutes}мин)';
}

// ==================== COURSE ====================

/// Курс базы знаний
class Course extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String category;
  final int lessonsCount;
  final int totalDurationMinutes;
  final bool isPremium;           // Требуется подписка?
  final List<String>? tags;       // Теги курса
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Course({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.category,
    required this.lessonsCount,
    required this.totalDurationMinutes,
    this.isPremium = false,
    this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      category: json['category'] ?? '',
      lessonsCount: json['lessons_count'] ?? 0,
      totalDurationMinutes: json['total_duration_minutes'] ?? 0,
      isPremium: json['is_premium'] ?? false,
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'category': category,
      'lessons_count': lessonsCount,
      'total_duration_minutes': totalDurationMinutes,
      'is_premium': isPremium,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Длительность в часах
  double get durationHours => totalDurationMinutes / 60;

  /// Форматированная длительность
  String get formattedDuration {
    if (totalDurationMinutes < 60) {
      return '$totalDurationMinutes мин';
    }
    final hours = (totalDurationMinutes / 60).floor();
    final minutes = totalDurationMinutes % 60;
    if (minutes == 0) {
      return '$hours ч';
    }
    return '$hours ч $minutes мин';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        category,
        lessonsCount,
        totalDurationMinutes,
        isPremium,
        tags,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'Course($title, $lessonsCount уроков)';
}

// ==================== COURSE WITH PROGRESS ====================

/// Курс с прогрессом пользователя
class CourseWithProgress extends Equatable {
  final Course course;
  final int completedLessons;
  final int totalLessons;
  final DateTime? lastAccessedAt;
  final bool isFavorite;

  const CourseWithProgress({
    required this.course,
    required this.completedLessons,
    required this.totalLessons,
    this.lastAccessedAt,
    this.isFavorite = false,
  });

  factory CourseWithProgress.fromJson(Map<String, dynamic> json) {
    return CourseWithProgress(
      course: Course.fromJson(json['course'] as Map<String, dynamic>),
      completedLessons: json['completed_lessons'] ?? 0,
      totalLessons: json['total_lessons'] ?? 0,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'])
          : null,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course.toJson(),
      'completed_lessons': completedLessons,
      'total_lessons': totalLessons,
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  /// Прогресс (0.0 - 1.0)
  double get progress {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  /// Процент прогресса (0-100)
  int get progressPercent {
    return (progress * 100).round();
  }

  /// Завершен ли курс
  bool get isCompleted => completedLessons == totalLessons && totalLessons > 0;

  /// Начат ли курс
  bool get isStarted => completedLessons > 0;

  @override
  List<Object?> get props => [
        course,
        completedLessons,
        totalLessons,
        lastAccessedAt,
        isFavorite,
      ];

  @override
  String toString() =>
      'CourseWithProgress(${course.title}, $progressPercent%)';
}

// ==================== CATEGORY ====================

/// Категория курсов
class Category extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int coursesCount;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    required this.coursesCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      iconUrl: json['icon_url'],
      coursesCount: json['courses_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'courses_count': coursesCount,
    };
  }

  @override
  List<Object?> get props => [id, name, description, iconUrl, coursesCount];

  @override
  String toString() => 'Category($name, $coursesCount курсов)';
}

// ==================== COURSE PROGRESS ====================

/// Прогресс по курсу
class CourseProgress extends Equatable {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;

  const CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    this.startedAt,
    this.completedAt,
    this.lastAccessedAt,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['course_id']?.toString() ?? '',
      completedLessons: json['completed_lessons'] ?? 0,
      totalLessons: json['total_lessons'] ?? 0,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'completed_lessons': completedLessons,
      'total_lessons': totalLessons,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
    };
  }

  /// Прогресс (0.0 - 1.0)
  double get progress {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  /// Процент прогресса (0-100)
  int get progressPercent {
    return (progress * 100).round();
  }

  /// Завершен ли курс
  bool get isCompleted => completedAt != null;

  /// Начат ли курс
  bool get isStarted => startedAt != null;

  @override
  List<Object?> get props => [
        courseId,
        completedLessons,
        totalLessons,
        startedAt,
        completedAt,
        lastAccessedAt,
      ];

  @override
  String toString() =>
      'CourseProgress($courseId, $completedLessons/$totalLessons)';
}




