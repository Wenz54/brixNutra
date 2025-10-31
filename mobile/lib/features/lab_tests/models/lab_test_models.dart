import 'package:equatable/equatable.dart';

// ==================== PARAMETER RANGE ====================

/// Референсный диапазон параметра
class ParameterRange extends Equatable {
  final double? min;
  final double? max;
  final String? unit;
  final String? description;

  const ParameterRange({
    this.min,
    this.max,
    this.unit,
    this.description,
  });

  factory ParameterRange.fromJson(Map<String, dynamic> json) {
    return ParameterRange(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      unit: json['unit'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'unit': unit,
      'description': description,
    };
  }

  /// Проверить, находится ли значение в норме
  bool isInRange(double value) {
    if (min != null && value < min!) return false;
    if (max != null && value > max!) return false;
    return true;
  }

  /// Получить процент от нормы (0.0 - 1.0 = норма, >1.0 = выше, <0.0 = ниже)
  double getPercentage(double value) {
    if (min == null || max == null) return 1.0;
    final range = max! - min!;
    if (range == 0) return 1.0;
    return (value - min!) / range;
  }

  @override
  List<Object?> get props => [min, max, unit, description];

  @override
  String toString() => 'ParameterRange($min-$max $unit)';
}

// ==================== PARAMETER VALUE ====================

/// Значение параметра анализа
class ParameterValue extends Equatable {
  final String code;              // Код параметра (напр. "glucose", "cholesterol")
  final String name;              // Название (напр. "Глюкоза", "Холестерин")
  final double value;             // Значение
  final String unit;              // Единица измерения (напр. "ммоль/л", "мг/дл")
  final ParameterRange range;     // Референсный диапазон
  final bool isNormal;            // В норме ли
  final String? interpretation;   // Краткая интерпретация

  const ParameterValue({
    required this.code,
    required this.name,
    required this.value,
    required this.unit,
    required this.range,
    required this.isNormal,
    this.interpretation,
  });

  factory ParameterValue.fromJson(Map<String, dynamic> json) {
    return ParameterValue(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      range: ParameterRange.fromJson(json['range'] as Map<String, dynamic>? ?? {}),
      isNormal: json['is_normal'] ?? true,
      interpretation: json['interpretation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'value': value,
      'unit': unit,
      'range': range.toJson(),
      'is_normal': isNormal,
      'interpretation': interpretation,
    };
  }

  /// Статус параметра (низкий, норма, высокий)
  String get status {
    if (isNormal) return 'normal';
    if (range.min != null && value < range.min!) return 'low';
    if (range.max != null && value > range.max!) return 'high';
    return 'unknown';
  }

  /// Эмодзи статуса
  String get statusEmoji {
    switch (status) {
      case 'low':
        return '⬇️';
      case 'high':
        return '⬆️';
      case 'normal':
        return '✅';
      default:
        return '❓';
    }
  }

  @override
  List<Object?> get props => [
        code,
        name,
        value,
        unit,
        range,
        isNormal,
        interpretation,
      ];

  @override
  String toString() => 'ParameterValue($name: $value $unit ${statusEmoji})';
}

// ==================== LAB TEST ====================

/// Лабораторный анализ
class LabTest extends Equatable {
  final String id;
  final String title;              // Название анализа
  final DateTime testDate;         // Дата сдачи анализа
  final DateTime uploadedAt;       // Дата загрузки
  final List<ParameterValue> parameters; // Параметры
  final String? fileUrl;           // Ссылка на файл анализа
  final String? notes;             // Заметки пользователя
  final bool hasInterpretation;    // Есть ли AI интерпретация

  const LabTest({
    required this.id,
    required this.title,
    required this.testDate,
    required this.uploadedAt,
    required this.parameters,
    this.fileUrl,
    this.notes,
    this.hasInterpretation = false,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Анализ',
      testDate: DateTime.parse(json['test_date']),
      uploadedAt: DateTime.parse(json['uploaded_at']),
      parameters: (json['parameters'] as List?)
              ?.map((p) => ParameterValue.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      fileUrl: json['file_url'],
      notes: json['notes'],
      hasInterpretation: json['has_interpretation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'test_date': testDate.toIso8601String(),
      'uploaded_at': uploadedAt.toIso8601String(),
      'parameters': parameters.map((p) => p.toJson()).toList(),
      'file_url': fileUrl,
      'notes': notes,
      'has_interpretation': hasInterpretation,
    };
  }

  /// Количество параметров
  int get parametersCount => parameters.length;

  /// Количество параметров в норме
  int get normalParametersCount =>
      parameters.where((p) => p.isNormal).length;

  /// Количество параметров вне нормы
  int get abnormalParametersCount =>
      parameters.where((p) => !p.isNormal).length;

  /// Процент параметров в норме
  double get normalPercentage {
    if (parameters.isEmpty) return 1.0;
    return normalParametersCount / parametersCount;
  }

  /// Все параметры в норме?
  bool get allNormal => abnormalParametersCount == 0;

  /// Получить параметры вне нормы
  List<ParameterValue> get abnormalParameters =>
      parameters.where((p) => !p.isNormal).toList();

  /// Получить параметр по коду
  ParameterValue? getParameter(String code) {
    try {
      return parameters.firstWhere((p) => p.code == code);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        testDate,
        uploadedAt,
        parameters,
        fileUrl,
        notes,
        hasInterpretation,
      ];

  @override
  String toString() =>
      'LabTest($title, ${testDate.toIso8601String().split('T')[0]}, $parametersCount параметров)';
}

// ==================== LAB TEST PREVIEW ====================

/// Краткая информация об анализе (для списка)
class LabTestPreview extends Equatable {
  final String id;
  final String title;
  final DateTime testDate;
  final int parametersCount;
  final int abnormalCount;
  final bool hasInterpretation;

  const LabTestPreview({
    required this.id,
    required this.title,
    required this.testDate,
    required this.parametersCount,
    required this.abnormalCount,
    this.hasInterpretation = false,
  });

  factory LabTestPreview.fromJson(Map<String, dynamic> json) {
    return LabTestPreview(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Анализ',
      testDate: DateTime.parse(json['test_date']),
      parametersCount: json['parameters_count'] ?? 0,
      abnormalCount: json['abnormal_count'] ?? 0,
      hasInterpretation: json['has_interpretation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'test_date': testDate.toIso8601String(),
      'parameters_count': parametersCount,
      'abnormal_count': abnormalCount,
      'has_interpretation': hasInterpretation,
    };
  }

  /// Все параметры в норме?
  bool get allNormal => abnormalCount == 0;

  /// Статус анализа
  String get status {
    if (allNormal) return '✅ Все в норме';
    if (abnormalCount == 1) return '⚠️ 1 отклонение';
    return '⚠️ $abnormalCount отклонений';
  }

  /// Дата в читаемом формате
  String get formattedDate {
    return '${testDate.day}.${testDate.month}.${testDate.year}';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        testDate,
        parametersCount,
        abnormalCount,
        hasInterpretation,
      ];

  @override
  String toString() => 'LabTestPreview($title, $formattedDate)';
}

// ==================== INTERPRETATION ====================

/// AI интерпретация анализа
class Interpretation extends Equatable {
  final String id;
  final String testId;
  final String summary;            // Краткое резюме
  final String detailed;           // Детальная интерпретация
  final List<String> recommendations; // Рекомендации
  final List<String> warnings;     // Предупреждения
  final DateTime createdAt;

  const Interpretation({
    required this.id,
    required this.testId,
    required this.summary,
    required this.detailed,
    required this.recommendations,
    required this.warnings,
    required this.createdAt,
  });

  factory Interpretation.fromJson(Map<String, dynamic> json) {
    return Interpretation(
      id: json['id']?.toString() ?? '',
      testId: json['test_id']?.toString() ?? '',
      summary: json['summary'] ?? '',
      detailed: json['detailed'] ?? '',
      recommendations: (json['recommendations'] as List?)
              ?.map((r) => r.toString())
              .toList() ??
          [],
      warnings: (json['warnings'] as List?)
              ?.map((w) => w.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_id': testId,
      'summary': summary,
      'detailed': detailed,
      'recommendations': recommendations,
      'warnings': warnings,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Есть ли предупреждения
  bool get hasWarnings => warnings.isNotEmpty;

  /// Есть ли рекомендации
  bool get hasRecommendations => recommendations.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        testId,
        summary,
        detailed,
        recommendations,
        warnings,
        createdAt,
      ];

  @override
  String toString() => 'Interpretation($testId, ${recommendations.length} рекомендаций)';
}

// ==================== PARAMETER TREND ====================

/// Тренд параметра (динамика изменения)
class ParameterTrend extends Equatable {
  final String code;
  final String name;
  final List<TrendPoint> points;   // Точки данных
  final ParameterRange range;      // Референсный диапазон
  final String trend;              // 'up', 'down', 'stable'

  const ParameterTrend({
    required this.code,
    required this.name,
    required this.points,
    required this.range,
    required this.trend,
  });

  factory ParameterTrend.fromJson(Map<String, dynamic> json) {
    return ParameterTrend(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      points: (json['points'] as List?)
              ?.map((p) => TrendPoint.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      range: ParameterRange.fromJson(json['range'] as Map<String, dynamic>? ?? {}),
      trend: json['trend'] ?? 'stable',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'points': points.map((p) => p.toJson()).toList(),
      'range': range.toJson(),
      'trend': trend,
    };
  }

  /// Последнее значение
  double? get lastValue => points.isNotEmpty ? points.last.value : null;

  /// Изменение от первого к последнему (%)
  double? get changePercent {
    if (points.length < 2) return null;
    final first = points.first.value;
    final last = points.last.value;
    if (first == 0) return null;
    return ((last - first) / first) * 100;
  }

  /// Эмодзи тренда
  String get trendEmoji {
    switch (trend) {
      case 'up':
        return '📈';
      case 'down':
        return '📉';
      case 'stable':
        return '➡️';
      default:
        return '📊';
    }
  }

  @override
  List<Object?> get props => [code, name, points, range, trend];

  @override
  String toString() => 'ParameterTrend($name, $trend $trendEmoji)';
}

// ==================== TREND POINT ====================

/// Точка данных в тренде
class TrendPoint extends Equatable {
  final DateTime date;
  final double value;

  const TrendPoint({
    required this.date,
    required this.value,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      date: DateTime.parse(json['date']),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  @override
  List<Object?> get props => [date, value];

  @override
  String toString() =>
      'TrendPoint(${date.toIso8601String().split('T')[0]}: $value)';
}




