import 'dart:io';
// Импортируйте из core_module:
// import 'package:supply_diets_app/dev_modules/core_module/services/api_service.dart';
import '../models/diary_models.dart';

/// Сервис работы с дневником питания
/// 
/// Предоставляет методы для:
/// - Получения данных дневника за день
/// - Добавления/удаления приемов пищи
/// - Отслеживания воды
/// - Отслеживания настроения
/// - AI анализа питания
class DiaryService {
  
  // NOTE: В реальном приложении замените на актуальные импорты
  
  /// Получить данные дневника за день
  /// 
  /// [date] - Дата для получения дневника
  /// 
  /// Возвращает DiaryDay с приемами пищи, водой и настроением
  static Future<DiaryDay> getDiaryDay(DateTime date) async {
    try {
      final dateStr = _formatDate(date);
      // final response = await ApiService.get('/diary/day/$dateStr');
      final response = await _mockGetDay(date);
      
      return DiaryDay.fromJson(response);
    } catch (e) {
      print('Error getting diary day: $e');
      // Возвращаем пустой день при ошибке
      return DiaryDay(
        date: date,
        selectedPlanName: 'Не выбран',
        meals: [],
        waterLogs: [],
      );
    }
  }

  /// Добавить прием пищи
  /// 
  /// [mealName] - Название блюда
  /// [mealType] - Тип приема (breakfast, lunch, dinner, snack)
  /// [consumedAt] - Время приема
  /// [portionGrams] - Порция в граммах (опционально)
  /// [photo] - Фото блюда (опционально)
  /// 
  /// Возвращает созданный MealEntry или null при ошибке
  static Future<MealEntry?> addMeal({
    required String mealName,
    required String mealType,
    required DateTime consumedAt,
    int? portionGrams,
    File? photo,
  }) async {
    try {
      String? photoUrl;
      
      // Загрузка фото если есть
      if (photo != null) {
        photoUrl = await _uploadPhoto(photo);
      }

      // final response = await ApiService.post('/diary/meal', {
      //   'mealName': mealName,
      //   'mealType': mealType,
      //   'consumedAt': consumedAt.toIso8601String(),
      //   'portionGrams': portionGrams,
      //   'photoUrl': photoUrl,
      // });
      
      final response = await _mockAddMeal(
        mealName: mealName,
        mealType: mealType,
        consumedAt: consumedAt,
        portionGrams: portionGrams,
        photoUrl: photoUrl,
      );

      return MealEntry.fromJson(response);
    } catch (e) {
      print('Error adding meal: $e');
      return null;
    }
  }

  /// Удалить прием пищи
  /// 
  /// [mealId] - ID приема пищи
  /// 
  /// Возвращает true если успешно удалено
  static Future<bool> deleteMeal(String mealId) async {
    try {
      // await ApiService.delete('/diary/meal/$mealId');
      await Future.delayed(const Duration(milliseconds: 500));
      print('Meal deleted: $mealId');
      return true;
    } catch (e) {
      print('Error deleting meal: $e');
      return false;
    }
  }

  /// Обновить количество воды
  /// 
  /// [date] - Дата
  /// [totalAmount] - Общее количество воды в мл
  /// 
  /// Возвращает обновленный WaterLog
  static Future<WaterLog?> updateWater({
    required DateTime date,
    required double totalAmount,
  }) async {
    try {
      final dateStr = _formatDate(date);
      
      // final response = await ApiService.post('/diary/water', {
      //   'date': dateStr,
      //   'totalAmount': totalAmount,
      // });
      
      final response = await _mockUpdateWater(date, totalAmount);

      return WaterLog.fromJson(response);
    } catch (e) {
      print('Error updating water: $e');
      return null;
    }
  }

  /// Обновить настроение
  /// 
  /// [date] - Дата
  /// [rating] - Оценка настроения (1-5)
  /// 
  /// Возвращает обновленный DiaryDay
  static Future<DiaryDay?> updateMood({
    required DateTime date,
    required int rating,
  }) async {
    try {
      final dateStr = _formatDate(date);
      
      // final response = await ApiService.put('/diary/mood', {
      //   'date': dateStr,
      //   'rating': rating,
      // });
      
      final response = await _mockUpdateMood(date, rating);

      return DiaryDay.fromJson(response);
    } catch (e) {
      print('Error updating mood: $e');
      return null;
    }
  }

  /// Получить данные для AI анализа
  /// 
  /// [days] - Количество дней для анализа (по умолчанию 7)
  /// 
  /// Возвращает агрегированные данные за период
  static Future<Map<String, dynamic>?> getAIData({int days = 7}) async {
    try {
      // final response = await ApiService.get('/diary/ai-data?days=$days');
      final response = await _mockGetAIData(days);
      return response;
    } catch (e) {
      print('Error getting AI data: $e');
      return null;
    }
  }

  /// Обновить статус завершения дня
  /// 
  /// [date] - Дата
  /// [isCompleted] - Завершен ли день
  /// 
  /// Возвращает true если успешно обновлено
  static Future<bool> updateDayStatus(DateTime date, bool isCompleted) async {
    try {
      // await ApiService.put('/diary/day-status', {
      //   'date': _formatDate(date),
      //   'isCompleted': isCompleted,
      // });
      
      await Future.delayed(const Duration(milliseconds: 300));
      print('Day status updated: $date - $isCompleted');
      return true;
    } catch (e) {
      print('Error updating day status: $e');
      return false;
    }
  }

  // Утилиты

  /// Форматировать дату в строку (YYYY-MM-DD)
  static String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  /// Загрузить фото (заглушка)
  static Future<String?> _uploadPhoto(File photo) async {
    // TODO: Реализовать загрузку в Supabase Storage или другое хранилище
    await Future.delayed(const Duration(seconds: 1));
    return 'https://example.com/photo.jpg';
  }

  // Mock данные для демонстрации

  static Future<Map<String, dynamic>> _mockGetDay(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'date': date.toIso8601String(),
      'selectedPlanName': 'Средиземноморская диета',
      'meals': [],
      'waterLogs': [
        {
          'id': '1',
          'date': _formatDate(date),
          'totalAmount': 1000.0,
        }
      ],
      'moodRating': null,
      'isCompleted': false,
    };
  }

  static Future<Map<String, dynamic>> _mockAddMeal({
    required String mealName,
    required String mealType,
    required DateTime consumedAt,
    int? portionGrams,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'mealName': mealName,
      'mealType': mealType,
      'consumedAt': consumedAt.toIso8601String(),
      'portionGrams': portionGrams,
      'photoUrl': photoUrl,
    };
  }

  static Future<Map<String, dynamic>> _mockUpdateWater(
    DateTime date,
    double totalAmount,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'id': '1',
      'date': _formatDate(date),
      'totalAmount': totalAmount,
    };
  }

  static Future<Map<String, dynamic>> _mockUpdateMood(
    DateTime date,
    int rating,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'date': date.toIso8601String(),
      'selectedPlanName': 'Средиземноморская диета',
      'meals': [],
      'waterLogs': [],
      'moodRating': rating,
      'isCompleted': false,
    };
  }

  static Future<Map<String, dynamic>> _mockGetAIData(int days) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'period': days,
      'totalMeals': 21,
      'averageWater': 1800.0,
      'averageMood': 4.2,
      'mealsByType': {
        'breakfast': 7,
        'lunch': 7,
        'dinner': 7,
      },
    };
  }
}





