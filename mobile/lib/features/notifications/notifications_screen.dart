import 'package:flutter/material.dart';
import '../../dev_modules/ui_kit_module/theme/brix_theme.dart';

/// Экран уведомлений
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      appBar: AppBar(
        backgroundColor: BrixColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BrixColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Уведомления',
          style: TextStyle(
            color: BrixColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Mark all as read
            },
            child: const Text(
              'Прочитать все',
              style: TextStyle(
                color: BrixColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = _mockNotifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Mark as read and navigate
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Иконка
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getIconColor(notification['type']),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(notification['type']),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Контент
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                                color: BrixColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: BrixColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['body'],
                        style: TextStyle(
                          fontSize: 13,
                          color: BrixColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: BrixColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'meal_reminder':
        return const Color(0xFFCBE67B);
      case 'water_reminder':
        return Colors.blue;
      case 'achievement':
        return Colors.purple;
      case 'lesson_reminder':
        return const Color(0xFFFCCFE9);
      default:
        return BrixColors.primary;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'meal_reminder':
        return Icons.restaurant;
      case 'water_reminder':
        return Icons.water_drop;
      case 'achievement':
        return Icons.emoji_events;
      case 'lesson_reminder':
        return Icons.school;
      default:
        return Icons.notifications;
    }
  }

  // Mock data для демонстрации
  static final List<Map<String, dynamic>> _mockNotifications = [
    {
      'title': 'Время обеда!',
      'body': 'Не забудьте записать приём пищи в дневник питания',
      'type': 'meal_reminder',
      'time': '5 мин назад',
      'isRead': false,
    },
    {
      'title': 'Выпейте воды',
      'body': 'Вы выпили только 800 мл из 2000 мл сегодня',
      'type': 'water_reminder',
      'time': '1 ч назад',
      'isRead': false,
    },
    {
      'title': 'Новое достижение!',
      'body': 'Вы заполняете дневник 7 дней подряд! 🎉',
      'type': 'achievement',
      'time': '2 ч назад',
      'isRead': true,
    },
    {
      'title': 'Новая статья в блоге',
      'body': 'Как правильно читать анализы крови?',
      'type': 'info',
      'time': '3 ч назад',
      'isRead': true,
    },
    {
      'title': 'Урок доступен',
      'body': 'Новый урок "Основы нутрициологии" доступен для изучения',
      'type': 'lesson_reminder',
      'time': 'Вчера',
      'isRead': true,
    },
  ];
}

