import 'dart:io';
import 'package:equatable/equatable.dart';

/// События для управления лабораторными анализами
abstract class LabTestsEvent extends Equatable {
  const LabTestsEvent();

  @override
  List<Object?> get props => [];
}

// ==================== LAB TESTS СОБЫТИЯ ====================

/// Загрузить список анализов
class LoadMyTestsRequested extends LabTestsEvent {
  final int limit;

  const LoadMyTestsRequested({this.limit = 50});

  @override
  List<Object?> get props => [limit];

  @override
  String toString() => 'LoadMyTestsRequested(limit: $limit)';
}

/// Загрузить конкретный анализ
class LoadTestRequested extends LabTestsEvent {
  final String testId;

  const LoadTestRequested(this.testId);

  @override
  List<Object?> get props => [testId];

  @override
  String toString() => 'LoadTestRequested($testId)';
}

/// Загрузить новый анализ
class UploadTestRequested extends LabTestsEvent {
  final File file;
  final DateTime testDate;
  final String? title;
  final String? notes;

  const UploadTestRequested({
    required this.file,
    required this.testDate,
    this.title,
    this.notes,
  });

  @override
  List<Object?> get props => [file, testDate, title, notes];

  @override
  String toString() => 'UploadTestRequested(${file.path})';
}

/// Удалить анализ
class DeleteTestRequested extends LabTestsEvent {
  final String testId;

  const DeleteTestRequested(this.testId);

  @override
  List<Object?> get props => [testId];

  @override
  String toString() => 'DeleteTestRequested($testId)';
}

// ==================== INTERPRETATION СОБЫТИЯ ====================

/// Получить AI интерпретацию
class LoadInterpretationRequested extends LabTestsEvent {
  final String testId;

  const LoadInterpretationRequested(this.testId);

  @override
  List<Object?> get props => [testId];

  @override
  String toString() => 'LoadInterpretationRequested($testId)';
}

// ==================== PARAMETERS СОБЫТИЯ ====================

/// Загрузить доступные параметры
class LoadAvailableParametersRequested extends LabTestsEvent {
  const LoadAvailableParametersRequested();

  @override
  String toString() => 'LoadAvailableParametersRequested()';
}

/// Загрузить тренд параметра
class LoadParameterTrendRequested extends LabTestsEvent {
  final String code;

  const LoadParameterTrendRequested(this.code);

  @override
  List<Object?> get props => [code];

  @override
  String toString() => 'LoadParameterTrendRequested($code)';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetLabTestsState extends LabTestsEvent {
  const ResetLabTestsState();

  @override
  String toString() => 'ResetLabTestsState()';
}




