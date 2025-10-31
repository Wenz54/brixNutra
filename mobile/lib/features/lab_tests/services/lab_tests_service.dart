import 'dart:io';
import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/lab_tests/models/lab_test_models.dart';

/// Сервис для работы с лабораторными анализами
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class LabTestsService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== LAB TESTS ====================

  /// Получить список всех анализов пользователя
  ///
  /// [limit] - лимит результатов
  static Future<List<LabTestPreview>> getMyTests({
    int limit = 50,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetMyTests(limit: limit);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };

      final response = await ApiService.get(
        ApiEndpoints.labTestsMy,
        queryParameters: queryParams,
      );

      return (response['data'] as List)
          .map((item) => LabTestPreview.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getMyTests error: $e');
      rethrow;
    }
  }

  /// Получить детальную информацию об анализе
  ///
  /// [testId] - ID анализа
  static Future<LabTest> getTest(String testId) async {
    try {
      if (useMockMode) {
        return _mockGetTest(testId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.labTest(testId),
      );

      return LabTest.fromJson(response['data']);
    } catch (e) {
      print('❌ getTest error: $e');
      rethrow;
    }
  }

  /// Загрузить новый анализ
  ///
  /// [file] - файл анализа (PDF, JPG, PNG)
  /// [testDate] - дата сдачи анализа
  /// [title] - название анализа
  /// [notes] - заметки (опционально)
  static Future<LabTest> uploadTest({
    required File file,
    required DateTime testDate,
    String? title,
    String? notes,
  }) async {
    try {
      if (useMockMode) {
        return _mockUploadTest(
          file: file,
          testDate: testDate,
          title: title,
          notes: notes,
        );
      }

      // TODO: Загрузка файла
      // final fileUrl = await FileService.uploadFile(file);

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.labTestsUpload,
        {
          'file_path': file.path, // В реальности будет URL
          'test_date': testDate.toIso8601String(),
          if (title != null) 'title': title,
          if (notes != null) 'notes': notes,
        },
      );

      return LabTest.fromJson(response['data']);
    } catch (e) {
      print('❌ uploadTest error: $e');
      rethrow;
    }
  }

  /// Удалить анализ
  ///
  /// [testId] - ID анализа
  static Future<void> deleteTest(String testId) async {
    try {
      if (useMockMode) {
        return _mockDeleteTest(testId);
      }

      // Реальный API запрос
      await ApiService.delete(
        ApiEndpoints.labTestDelete(testId),
      );
      print('✅ Анализ удален: $testId');
    } catch (e) {
      print('❌ deleteTest error: $e');
      rethrow;
    }
  }

  // ==================== INTERPRETATION ====================

  /// Получить AI интерпретацию анализа
  ///
  /// [testId] - ID анализа
  static Future<Interpretation> getInterpretation(String testId) async {
    try {
      if (useMockMode) {
        return _mockGetInterpretation(testId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.labTestInterpretation(testId),
      );

      return Interpretation.fromJson(response['data']);
    } catch (e) {
      print('❌ getInterpretation error: $e');
      rethrow;
    }
  }

  // ==================== PARAMETERS ====================

  /// Получить список доступных параметров
  static Future<List<Map<String, dynamic>>> getAvailableParameters() async {
    try {
      if (useMockMode) {
        return _mockGetAvailableParameters();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.labTestsParameters,
      );

      return (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('❌ getAvailableParameters error: $e');
      rethrow;
    }
  }

  /// Получить тренд параметра
  ///
  /// [code] - код параметра
  static Future<ParameterTrend> getParameterTrend(String code) async {
    try {
      if (useMockMode) {
        return _mockGetParameterTrend(code);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.labTestParameterTrend(code),
      );

      return ParameterTrend.fromJson(response['data']);
    } catch (e) {
      print('❌ getParameterTrend error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static final List<LabTest> _mockTests = [
    LabTest(
      id: 'test_1',
      title: 'Общий анализ крови',
      testDate: DateTime.now().subtract(const Duration(days: 7)),
      uploadedAt: DateTime.now().subtract(const Duration(days: 6)),
      parameters: [
        ParameterValue(
          code: 'hemoglobin',
          name: 'Гемоглобин',
          value: 145.0,
          unit: 'г/л',
          range: const ParameterRange(min: 120.0, max: 160.0, unit: 'г/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
        ParameterValue(
          code: 'erythrocytes',
          name: 'Эритроциты',
          value: 4.8,
          unit: '×10¹²/л',
          range: const ParameterRange(min: 4.0, max: 5.5, unit: '×10¹²/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
        ParameterValue(
          code: 'leukocytes',
          name: 'Лейкоциты',
          value: 8.5,
          unit: '×10⁹/л',
          range: const ParameterRange(min: 4.0, max: 9.0, unit: '×10⁹/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
      ],
      hasInterpretation: true,
    ),
    LabTest(
      id: 'test_2',
      title: 'Биохимический анализ крови',
      testDate: DateTime.now().subtract(const Duration(days: 30)),
      uploadedAt: DateTime.now().subtract(const Duration(days: 29)),
      parameters: [
        ParameterValue(
          code: 'glucose',
          name: 'Глюкоза',
          value: 6.2,
          unit: 'ммоль/л',
          range: const ParameterRange(min: 3.3, max: 5.5, unit: 'ммоль/л'),
          isNormal: false,
          interpretation: 'Повышен - рекомендуется контроль углеводов',
        ),
        ParameterValue(
          code: 'cholesterol',
          name: 'Холестерин общий',
          value: 5.8,
          unit: 'ммоль/л',
          range: const ParameterRange(min: 3.0, max: 5.2, unit: 'ммоль/л'),
          isNormal: false,
          interpretation: 'Повышен - рекомендуется диета',
        ),
        ParameterValue(
          code: 'alt',
          name: 'АЛТ',
          value: 32.0,
          unit: 'Ед/л',
          range: const ParameterRange(min: 0.0, max: 40.0, unit: 'Ед/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
        ParameterValue(
          code: 'ast',
          name: 'АСТ',
          value: 28.0,
          unit: 'Ед/л',
          range: const ParameterRange(min: 0.0, max: 40.0, unit: 'Ед/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
      ],
      hasInterpretation: true,
    ),
  ];

  static Future<List<LabTestPreview>> _mockGetMyTests({
    int limit = 50,
  }) async {
    print('🎭 MOCK: Получение списка анализов');
    await Future.delayed(const Duration(milliseconds: 600));

    return _mockTests.take(limit).map((test) {
      return LabTestPreview(
        id: test.id,
        title: test.title,
        testDate: test.testDate,
        parametersCount: test.parametersCount,
        abnormalCount: test.abnormalParametersCount,
        hasInterpretation: test.hasInterpretation,
      );
    }).toList();
  }

  static Future<LabTest> _mockGetTest(String testId) async {
    print('🎭 MOCK: Получение анализа: $testId');
    await Future.delayed(const Duration(milliseconds: 700));

    final test = _mockTests.firstWhere(
      (t) => t.id == testId,
      orElse: () => _mockTests.first,
    );

    return test;
  }

  static Future<LabTest> _mockUploadTest({
    required File file,
    required DateTime testDate,
    String? title,
    String? notes,
  }) async {
    print('🎭 MOCK: Загрузка анализа: ${file.path}');
    await Future.delayed(const Duration(milliseconds: 1500));

    final test = LabTest(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: title ?? 'Новый анализ',
      testDate: testDate,
      uploadedAt: DateTime.now(),
      parameters: [
        ParameterValue(
          code: 'glucose',
          name: 'Глюкоза',
          value: 5.2,
          unit: 'ммоль/л',
          range: const ParameterRange(min: 3.3, max: 5.5, unit: 'ммоль/л'),
          isNormal: true,
          interpretation: 'Норма',
        ),
      ],
      fileUrl: file.path,
      notes: notes,
      hasInterpretation: false,
    );

    _mockTests.insert(0, test);
    return test;
  }

  static Future<void> _mockDeleteTest(String testId) async {
    print('🎭 MOCK: Удаление анализа: $testId');
    await Future.delayed(const Duration(milliseconds: 400));

    _mockTests.removeWhere((t) => t.id == testId);
  }

  static Future<Interpretation> _mockGetInterpretation(String testId) async {
    print('🎭 MOCK: Получение интерпретации: $testId');
    await Future.delayed(const Duration(milliseconds: 1000));

    final test = _mockTests.firstWhere(
      (t) => t.id == testId,
      orElse: () => _mockTests.first,
    );

    if (test.id == 'test_2') {
      // Биохимия с отклонениями
      return Interpretation(
        id: 'interp_${testId}',
        testId: testId,
        summary: 'Выявлены отклонения в 2 параметрах из 4',
        detailed: '📊 Анализ результатов биохимического анализа крови:\n\n'
            '⚠️ **Глюкоза**: 6.2 ммоль/л (норма: 3.3-5.5)\n'
            'Уровень глюкозы повышен. Это может указывать на нарушение углеводного обмена. '
            'Рекомендуется контроль потребления простых углеводов и консультация эндокринолога.\n\n'
            '⚠️ **Холестерин**: 5.8 ммоль/л (норма: 3.0-5.2)\n'
            'Общий холестерин повышен. Рекомендуется скорректировать диету: '
            'увеличить потребление омега-3, клетчатки, снизить насыщенные жиры.\n\n'
            '✅ **АЛТ и АСТ**: В пределах нормы\n'
            'Показатели функции печени в норме.',
        recommendations: [
          'Снизить потребление простых углеводов (сахар, сладости)',
          'Увеличить физическую активность (30 мин/день)',
          'Добавить в рацион: овсянку, орехи, жирную рыбу',
          'Ограничить насыщенные жиры (сливочное масло, жирное мясо)',
          'Повторить анализ через 1-2 месяца',
        ],
        warnings: [
          'Обратитесь к эндокринологу для исключения диабета',
          'Контролируйте уровень глюкозы натощак',
        ],
        createdAt: DateTime.now(),
      );
    } else {
      // Общий анализ крови - норма
      return Interpretation(
        id: 'interp_${testId}',
        testId: testId,
        summary: 'Все показатели в пределах нормы',
        detailed: '📊 Анализ результатов общего анализа крови:\n\n'
            '✅ **Гемоглобин**: 145 г/л (норма: 120-160)\n'
            'Уровень гемоглобина в норме. Достаточный перенос кислорода к тканям.\n\n'
            '✅ **Эритроциты**: 4.8 ×10¹²/л (норма: 4.0-5.5)\n'
            'Количество эритроцитов в норме.\n\n'
            '✅ **Лейкоциты**: 8.5 ×10⁹/л (норма: 4.0-9.0)\n'
            'Количество лейкоцитов в норме. Иммунная система функционирует нормально.',
        recommendations: [
          'Продолжайте придерживаться здорового образа жизни',
          'Поддерживайте сбалансированное питание',
          'Регулярные профилактические осмотры (раз в год)',
        ],
        warnings: [],
        createdAt: DateTime.now(),
      );
    }
  }

  static Future<List<Map<String, dynamic>>> _mockGetAvailableParameters() async {
    print('🎭 MOCK: Получение доступных параметров');
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      {'code': 'glucose', 'name': 'Глюкоза', 'unit': 'ммоль/л'},
      {'code': 'cholesterol', 'name': 'Холестерин', 'unit': 'ммоль/л'},
      {'code': 'hemoglobin', 'name': 'Гемоглобин', 'unit': 'г/л'},
      {'code': 'erythrocytes', 'name': 'Эритроциты', 'unit': '×10¹²/л'},
      {'code': 'leukocytes', 'name': 'Лейкоциты', 'unit': '×10⁹/л'},
      {'code': 'alt', 'name': 'АЛТ', 'unit': 'Ед/л'},
      {'code': 'ast', 'name': 'АСТ', 'unit': 'Ед/л'},
    ];
  }

  static Future<ParameterTrend> _mockGetParameterTrend(String code) async {
    print('🎭 MOCK: Получение тренда параметра: $code');
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    if (code == 'glucose') {
      return ParameterTrend(
        code: 'glucose',
        name: 'Глюкоза',
        points: [
          TrendPoint(date: now.subtract(const Duration(days: 90)), value: 5.8),
          TrendPoint(date: now.subtract(const Duration(days: 60)), value: 6.0),
          TrendPoint(date: now.subtract(const Duration(days: 30)), value: 6.2),
        ],
        range: const ParameterRange(min: 3.3, max: 5.5, unit: 'ммоль/л'),
        trend: 'up',
      );
    } else if (code == 'cholesterol') {
      return ParameterTrend(
        code: 'cholesterol',
        name: 'Холестерин',
        points: [
          TrendPoint(date: now.subtract(const Duration(days: 90)), value: 6.2),
          TrendPoint(date: now.subtract(const Duration(days: 60)), value: 6.0),
          TrendPoint(date: now.subtract(const Duration(days: 30)), value: 5.8),
        ],
        range: const ParameterRange(min: 3.0, max: 5.2, unit: 'ммоль/л'),
        trend: 'down',
      );
    } else {
      // По умолчанию - стабильный тренд
      return ParameterTrend(
        code: code,
        name: 'Параметр',
        points: [
          TrendPoint(date: now.subtract(const Duration(days: 90)), value: 5.0),
          TrendPoint(date: now.subtract(const Duration(days: 60)), value: 5.1),
          TrendPoint(date: now.subtract(const Duration(days: 30)), value: 5.0),
        ],
        range: const ParameterRange(min: 4.0, max: 6.0),
        trend: 'stable',
      );
    }
  }
}

