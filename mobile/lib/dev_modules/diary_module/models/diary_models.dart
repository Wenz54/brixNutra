/// Модели данных для модуля дневника питания

/// День дневника питания
class DiaryDay {
  final DateTime date;
  final String selectedPlanName;
  final List<MealEntry> meals;
  final List<WaterLog> waterLogs;
  final int? moodRating;
  final bool isCompleted;

  DiaryDay({
    required this.date,
    required this.selectedPlanName,
    required this.meals,
    required this.waterLogs,
    this.moodRating,
    this.isCompleted = false,
  });

  /// Создать DiaryDay из JSON
  factory DiaryDay.fromJson(Map<String, dynamic> json) {
    return DiaryDay(
      date: DateTime.parse(json['date']),
      selectedPlanName: json['selectedPlanName'] ?? 'Не выбран',
      meals: (json['meals'] as List?)
              ?.map((m) => MealEntry.fromJson(m))
              .toList() ??
          [],
      waterLogs: (json['waterLogs'] as List?)
              ?.map((w) => WaterLog.fromJson(w))
              .toList() ??
          [],
      moodRating: json['moodRating'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'selectedPlanName': selectedPlanName,
      'meals': meals.map((m) => m.toJson()).toList(),
      'waterLogs': waterLogs.map((w) => w.toJson()).toList(),
      'moodRating': moodRating,
      'isCompleted': isCompleted,
    };
  }

  /// Создать копию с изменениями
  DiaryDay copyWith({
    DateTime? date,
    String? selectedPlanName,
    List<MealEntry>? meals,
    List<WaterLog>? waterLogs,
    int? moodRating,
    bool? isCompleted,
  }) {
    return DiaryDay(
      date: date ?? this.date,
      selectedPlanName: selectedPlanName ?? this.selectedPlanName,
      meals: meals ?? this.meals,
      waterLogs: waterLogs ?? this.waterLogs,
      moodRating: moodRating ?? this.moodRating,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Получить общее количество воды за день
  double get totalWater {
    return waterLogs.fold(0, (sum, log) => sum + log.totalAmount);
  }

  /// Получить приемы пищи по типу
  List<MealEntry> getMealsByType(String type) {
    return meals.where((m) => m.mealType == type).toList();
  }
}

/// Прием пищи
class MealEntry {
  final String id;
  final String mealName;
  final String mealType; // breakfast, lunch, dinner, snack
  final DateTime consumedAt;
  final int? portionGrams;
  final String? photoUrl;

  MealEntry({
    required this.id,
    required this.mealName,
    required this.mealType,
    required this.consumedAt,
    this.portionGrams,
    this.photoUrl,
  });

  /// Создать MealEntry из JSON
  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id']?.toString() ?? '',
      mealName: json['mealName'] ?? '',
      mealType: json['mealType'] ?? 'snack',
      consumedAt: DateTime.parse(json['consumedAt']),
      portionGrams: json['portionGrams'],
      photoUrl: json['photoUrl'],
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealName': mealName,
      'mealType': mealType,
      'consumedAt': consumedAt.toIso8601String(),
      'portionGrams': portionGrams,
      'photoUrl': photoUrl,
    };
  }

  /// Создать копию с изменениями
  MealEntry copyWith({
    String? id,
    String? mealName,
    String? mealType,
    DateTime? consumedAt,
    int? portionGrams,
    String? photoUrl,
  }) {
    return MealEntry(
      id: id ?? this.id,
      mealName: mealName ?? this.mealName,
      mealType: mealType ?? this.mealType,
      consumedAt: consumedAt ?? this.consumedAt,
      portionGrams: portionGrams ?? this.portionGrams,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  /// Получить название типа приема на русском
  String get mealTypeLabel {
    switch (mealType) {
      case 'breakfast':
        return 'Завтрак';
      case 'lunch':
        return 'Обед';
      case 'dinner':
        return 'Ужин';
      case 'snack':
        return 'Перекус';
      default:
        return 'Прием пищи';
    }
  }
}

/// Лог воды
class WaterLog {
  final String id;
  final DateTime date;
  final double totalAmount; // в мл

  WaterLog({
    required this.id,
    required this.date,
    required this.totalAmount,
  });

  /// Создать WaterLog из JSON
  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id']?.toString() ?? '',
      date: DateTime.parse(json['date']),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'totalAmount': totalAmount,
    };
  }

  /// Создать копию с изменениями
  WaterLog copyWith({
    String? id,
    DateTime? date,
    double? totalAmount,
  }) {
    return WaterLog(
      id: id ?? this.id,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  /// Получить прогресс воды (0.0 - 1.0)
  /// 
  /// [goal] - Цель в мл (по умолчанию 2000)
  double getProgress({double goal = 2000}) {
    return (totalAmount / goal).clamp(0.0, 1.0);
  }

  /// Получить количество в литрах
  double get liters {
    return totalAmount / 1000;
  }
}

/// Константы типов приемов пищи
class MealType {
  static const String breakfast = 'breakfast';
  static const String lunch = 'lunch';
  static const String dinner = 'dinner';
  static const String snack = 'snack';

  static const List<String> all = [
    breakfast,
    lunch,
    dinner,
    snack,
  ];

  /// Получить название на русском
  static String getLabel(String type) {
    switch (type) {
      case breakfast:
        return 'Завтрак';
      case lunch:
        return 'Обед';
      case dinner:
        return 'Ужин';
      case snack:
        return 'Перекус';
      default:
        return 'Прием пищи';
    }
  }
}





