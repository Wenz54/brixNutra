import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/blog_notifications/models/blog_notification_models.dart';

/// Сервис для работы с блогом и уведомлениями
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class BlogNotificationsService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== BLOG ====================

  /// Получить список статей блога
  ///
  /// [tag] - фильтр по тегу
  /// [limit] - лимит результатов
  static Future<List<BlogArticlePreview>> getBlogArticles({
    String? tag,
    int limit = 20,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetBlogArticles(tag: tag, limit: limit);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
        if (tag != null) 'tag': tag,
      };

      final response = await ApiService.get(
        ApiEndpoints.blogArticles,
        queryParameters: queryParams,
      );

      return (response['data'] as List)
          .map((item) => BlogArticlePreview.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getBlogArticles error: $e');
      rethrow;
    }
  }

  /// Получить статью блога
  ///
  /// [articleId] - ID статьи
  static Future<BlogArticle> getBlogArticle(String articleId) async {
    try {
      if (useMockMode) {
        return _mockGetBlogArticle(articleId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.blogArticle(articleId),
      );

      return BlogArticle.fromJson(response['data']);
    } catch (e) {
      print('❌ getBlogArticle error: $e');
      rethrow;
    }
  }

  // ==================== NOTIFICATIONS ====================

  /// Получить список уведомлений
  ///
  /// [limit] - лимит результатов
  static Future<List<AppNotification>> getNotifications({
    int limit = 50,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetNotifications(limit: limit);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      final response = await ApiService.get(
        ApiEndpoints.notifications,
        queryParameters: queryParams,
      );

      return (response['data'] as List)
          .map((item) => AppNotification.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getNotifications error: $e');
      rethrow;
    }
  }

  /// Отметить уведомление как прочитанное
  ///
  /// [notificationId] - ID уведомления
  static Future<void> markAsRead(String notificationId) async {
    try {
      if (useMockMode) {
        return _mockMarkAsRead(notificationId);
      }

      // Реальный API запрос
      await ApiService.post(
        ApiEndpoints.notificationRead(notificationId),
        {},
      );
      print('✅ Уведомление отмечено как прочитанное: $notificationId');
    } catch (e) {
      print('❌ markAsRead error: $e');
      rethrow;
    }
  }

  /// Удалить уведомление
  ///
  /// [notificationId] - ID уведомления
  static Future<void> deleteNotification(String notificationId) async {
    try {
      if (useMockMode) {
        return _mockDeleteNotification(notificationId);
      }

      // Реальный API запрос
      await ApiService.delete(
        ApiEndpoints.notificationDelete(notificationId),
      );
      print('✅ Уведомление удалено: $notificationId');
    } catch (e) {
      print('❌ deleteNotification error: $e');
      rethrow;
    }
  }

  /// Получить статистику уведомлений
  static Future<NotificationStats> getNotificationStats() async {
    try {
      if (useMockMode) {
        return _mockGetNotificationStats();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        '${ApiEndpoints.notifications}/stats',
      );

      return NotificationStats.fromJson(response['data']);
    } catch (e) {
      print('❌ getNotificationStats error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static final List<BlogArticle> _mockArticles = [
    BlogArticle(
      id: 'article_1',
      title: '10 правил здорового питания',
      excerpt: 'Основные принципы правильного питания, которые помогут вам достичь ваших целей',
      content: '''
# 10 правил здорового питания

## Введение

Правильное питание - это основа здоровья и хорошего самочувствия.

## Правила

1. **Пейте достаточно воды** - минимум 2 литра в день
2. **Ешьте больше овощей** - они содержат клетчатку и витамины
3. **Контролируйте порции** - переедание вредит здоровью
4. **Регулярное питание** - 4-5 приемов пищи в день
5. **Белок в каждом приеме** - для мышц и насыщения
6. **Сложные углеводы** - энергия надолго
7. **Здоровые жиры** - омега-3, орехи, авокадо
8. **Минимум сахара** - не более 25г в день
9. **Готовьте дома** - контроль ингредиентов
10. **Слушайте свое тело** - ешьте когда голодны

## Заключение

Следуя этим простым правилам, вы улучшите свое здоровье и самочувствие!
''',
      imageUrl: 'https://example.com/healthy-eating.jpg',
      author: 'Анна Иванова',
      tags: ['питание', 'здоровье', 'советы'],
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      readTimeMinutes: 5,
      viewsCount: 1248,
      isBookmarked: true,
    ),
    BlogArticle(
      id: 'article_2',
      title: 'Спортивное питание для начинающих',
      excerpt: 'Все что нужно знать о спортивном питании, если вы только начинаете тренироваться',
      content: '''
# Спортивное питание для начинающих

## Что такое спортивное питание?

Спортивное питание - это добавки, которые помогают достичь спортивных целей быстрее.

## Основные виды

### Протеин
- Для роста мышц
- 1.6-2.2г на кг массы тела

### Креатин
- Увеличивает силу
- 5г в день

### BCAA
- Для восстановления
- Во время тренировки

## Рекомендации

Начинающим достаточно обычного питания + протеин при необходимости.
''',
      imageUrl: 'https://example.com/sports-nutrition.jpg',
      author: 'Петр Сидоров',
      tags: ['спорт', 'добавки', 'новичкам'],
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      readTimeMinutes: 7,
      viewsCount: 856,
    ),
    BlogArticle(
      id: 'article_3',
      title: 'Витамины: что нужно знать',
      excerpt: 'Полный гид по витаминам и минералам для вашего здоровья',
      content: '''
# Витамины: что нужно знать

## Жирорастворимые витамины

### Витамин D
- Для костей и иммунитета
- 2000-4000 МЕ в день

### Витамин A
- Для зрения и кожи
- Из моркови, тыквы

## Водорастворимые витамины

### Витамин C
- Антиоксидант
- 500-1000 мг в день

### Витамины группы B
- Для энергии
- Из круп, мяса
''',
      imageUrl: 'https://example.com/vitamins.jpg',
      author: 'Мария Петрова',
      tags: ['витамины', 'здоровье', 'наука'],
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      readTimeMinutes: 10,
      viewsCount: 2341,
    ),
  ];

  static final List<AppNotification> _mockNotifications = [
    AppNotification(
      id: 'notif_1',
      title: 'Время обеда!',
      body: 'Не забудьте пообедать согласно вашему плану питания',
      type: 'meal_reminder',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      data: {'meal_type': 'lunch'},
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Выпейте воды',
      body: 'Вы еще не выпили 2 литра воды сегодня. Осталось 500 мл',
      type: 'water_reminder',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      data: {'remaining_ml': 500},
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Достижение разблокировано! 🏆',
      body: 'Вы завершили 7 дней подряд ведения дневника питания!',
      type: 'achievement',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      data: {'achievement_id': 'streak_7'},
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Новая статья в блоге',
      body: '10 правил здорового питания - прочитайте прямо сейчас!',
      type: 'info',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      data: {'article_id': 'article_1'},
    ),
    AppNotification(
      id: 'notif_5',
      title: 'Продолжите обучение',
      body: 'У вас есть непройденные уроки в курсе "Основы питания"',
      type: 'lesson_reminder',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      data: {'course_id': 'course_1'},
    ),
  ];

  static Future<List<BlogArticlePreview>> _mockGetBlogArticles({
    String? tag,
    int limit = 20,
  }) async {
    print('🎭 MOCK: Получение статей блога (tag: $tag)');
    await Future.delayed(const Duration(milliseconds: 600));

    var articles = _mockArticles;

    if (tag != null && tag.isNotEmpty) {
      articles = articles.where((a) => a.tags.contains(tag)).toList();
    }

    return articles.take(limit).map((article) {
      return BlogArticlePreview(
        id: article.id,
        title: article.title,
        excerpt: article.excerpt,
        imageUrl: article.imageUrl,
        author: article.author,
        tags: article.tags,
        publishedAt: article.publishedAt,
        readTimeMinutes: article.readTimeMinutes,
        viewsCount: article.viewsCount,
        isBookmarked: article.isBookmarked,
      );
    }).toList();
  }

  static Future<BlogArticle> _mockGetBlogArticle(String articleId) async {
    print('🎭 MOCK: Получение статьи: $articleId');
    await Future.delayed(const Duration(milliseconds: 700));

    final article = _mockArticles.firstWhere(
      (a) => a.id == articleId,
      orElse: () => _mockArticles.first,
    );

    return article;
  }

  static Future<List<AppNotification>> _mockGetNotifications({
    int limit = 50,
  }) async {
    print('🎭 MOCK: Получение уведомлений');
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockNotifications.take(limit).toList();
  }

  static Future<void> _mockMarkAsRead(String notificationId) async {
    print('🎭 MOCK: Отметка как прочитанное: $notificationId');
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notif = _mockNotifications[index];
      _mockNotifications[index] = AppNotification(
        id: notif.id,
        title: notif.title,
        body: notif.body,
        type: notif.type,
        createdAt: notif.createdAt,
        isRead: true,
        data: notif.data,
      );
    }
  }

  static Future<void> _mockDeleteNotification(String notificationId) async {
    print('🎭 MOCK: Удаление уведомления: $notificationId');
    await Future.delayed(const Duration(milliseconds: 300));

    _mockNotifications.removeWhere((n) => n.id == notificationId);
  }

  static Future<NotificationStats> _mockGetNotificationStats() async {
    print('🎭 MOCK: Получение статистики уведомлений');
    await Future.delayed(const Duration(milliseconds: 200));

    final unread = _mockNotifications.where((n) => !n.isRead).length;

    return NotificationStats(
      total: _mockNotifications.length,
      unread: unread,
    );
  }
}

