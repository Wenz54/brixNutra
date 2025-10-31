/// Сервис работы с планами питания
class PlansService {
  /// Получить все планы
  static Future<List<Map<String, dynamic>>> getAllPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'name': 'Средиземноморская диета',
        'description': 'Здоровое питание на основе традиций Средиземноморья',
        'duration': 30,
        'difficulty': 'medium',
        'imageUrl': 'https://example.com/mediterranean.jpg',
      },
      {
        'id': 2,
        'name': 'Кето диета',
        'description': 'Низкоуглеводный план питания',
        'duration': 21,
        'difficulty': 'hard',
        'imageUrl': 'https://example.com/keto.jpg',
      },
    ];
  }

  /// Получить план по ID
  static Future<Map<String, dynamic>?> getPlanById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': id,
      'name': 'Средиземноморская диета',
      'description': 'Здоровое питание',
      'duration': 30,
      'difficulty': 'medium',
    };
  }

  /// Активировать план
  static Future<bool> activatePlan(int planId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Получить активный план
  static Future<Map<String, dynamic>?> getActivePlan() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': 1,
      'name': 'Средиземноморская диета',
      'startDate': DateTime.now().toIso8601String(),
    };
  }
}





