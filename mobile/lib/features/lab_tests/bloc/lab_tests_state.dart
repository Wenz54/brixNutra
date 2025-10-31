import 'package:equatable/equatable.dart';
import 'package:mobile/features/lab_tests/models/lab_test_models.dart';

/// Состояния лабораторных анализов
abstract class LabTestsState extends Equatable {
  const LabTestsState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class LabTestsInitial extends LabTestsState {
  const LabTestsInitial();

  @override
  String toString() => 'LabTestsInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class LabTestsLoading extends LabTestsState {
  final String? message;

  const LabTestsLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'LabTestsLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ - TESTS ====================

/// Список анализов загружен
class MyTestsLoaded extends LabTestsState {
  final List<LabTestPreview> tests;

  const MyTestsLoaded(this.tests);

  @override
  List<Object?> get props => [tests];

  @override
  String toString() => 'MyTestsLoaded(${tests.length} анализов)';
}

/// Анализ загружен
class TestLoaded extends LabTestsState {
  final LabTest test;

  const TestLoaded(this.test);

  @override
  List<Object?> get props => [test];

  @override
  String toString() =>
      'TestLoaded(${test.title}, ${test.parameters.length} параметров)';
}

/// Анализ загружен
class TestUploaded extends LabTestsState {
  final LabTest test;
  final String message;

  const TestUploaded({
    required this.test,
    this.message = 'Анализ загружен',
  });

  @override
  List<Object?> get props => [test, message];

  @override
  String toString() => 'TestUploaded(${test.id})';
}

/// Анализ удален
class TestDeleted extends LabTestsState {
  final String testId;
  final String message;

  const TestDeleted({
    required this.testId,
    this.message = 'Анализ удален',
  });

  @override
  List<Object?> get props => [testId, message];

  @override
  String toString() => 'TestDeleted($testId)';
}

// ==================== SUCCESS СОСТОЯНИЯ - INTERPRETATION ====================

/// Интерпретация загружена
class InterpretationLoaded extends LabTestsState {
  final Interpretation interpretation;

  const InterpretationLoaded(this.interpretation);

  @override
  List<Object?> get props => [interpretation];

  @override
  String toString() =>
      'InterpretationLoaded(${interpretation.recommendations.length} рекомендаций)';
}

// ==================== SUCCESS СОСТОЯНИЯ - PARAMETERS ====================

/// Доступные параметры загружены
class AvailableParametersLoaded extends LabTestsState {
  final List<Map<String, dynamic>> parameters;

  const AvailableParametersLoaded(this.parameters);

  @override
  List<Object?> get props => [parameters];

  @override
  String toString() => 'AvailableParametersLoaded(${parameters.length} параметров)';
}

/// Тренд параметра загружен
class ParameterTrendLoaded extends LabTestsState {
  final ParameterTrend trend;

  const ParameterTrendLoaded(this.trend);

  @override
  List<Object?> get props => [trend];

  @override
  String toString() =>
      'ParameterTrendLoaded(${trend.name}, ${trend.points.length} точек)';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка лабораторных анализов
class LabTestsError extends LabTestsState {
  final String message;
  final String? code;

  const LabTestsError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'LabTestsError(message: $message, code: $code)';
}




