import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/lab_tests/bloc/lab_tests_event.dart';
import 'package:mobile/features/lab_tests/bloc/lab_tests_state.dart';
import 'package:mobile/features/lab_tests/services/lab_tests_service.dart';

/// BLoC для управления лабораторными анализами
///
/// Обрабатывает все действия пользователя:
/// - Загрузка списка анализов
/// - Просмотр детальной информации
/// - Загрузка новых анализов
/// - Удаление анализов
/// - Получение AI интерпретации
/// - Просмотр трендов параметров
class LabTestsBloc extends Bloc<LabTestsEvent, LabTestsState> {
  LabTestsBloc() : super(const LabTestsInitial()) {
    on<LoadMyTestsRequested>(_onLoadMyTests);
    on<LoadTestRequested>(_onLoadTest);
    on<UploadTestRequested>(_onUploadTest);
    on<DeleteTestRequested>(_onDeleteTest);
    on<LoadInterpretationRequested>(_onLoadInterpretation);
    on<LoadAvailableParametersRequested>(_onLoadAvailableParameters);
    on<LoadParameterTrendRequested>(_onLoadParameterTrend);
    on<ResetLabTestsState>(_onResetState);
  }

  // ==================== LAB TESTS ====================

  /// Загрузить список анализов
  Future<void> _onLoadMyTests(
    LoadMyTestsRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Загрузка анализов...'));
      
      final tests = await LabTestsService.getMyTests(
        limit: event.limit,
      );
      
      emit(MyTestsLoaded(tests));
      print('✅ LabTestsBloc: Анализы загружены (${tests.length})');
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось загрузить анализы: $e',
        code: 'LOAD_TESTS_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки анализов: $e');
    }
  }

  /// Загрузить конкретный анализ
  Future<void> _onLoadTest(
    LoadTestRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Загрузка анализа...'));
      
      final test = await LabTestsService.getTest(event.testId);
      
      emit(TestLoaded(test));
      print('✅ LabTestsBloc: Анализ загружен: ${test.title}');
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось загрузить анализ: $e',
        code: 'LOAD_TEST_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки анализа: $e');
    }
  }

  /// Загрузить новый анализ
  Future<void> _onUploadTest(
    UploadTestRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Загрузка анализа...'));
      
      final test = await LabTestsService.uploadTest(
        file: event.file,
        testDate: event.testDate,
        title: event.title,
        notes: event.notes,
      );
      
      emit(TestUploaded(
        test: test,
        message: 'Анализ успешно загружен',
      ));
      print('✅ LabTestsBloc: Анализ загружен: ${test.id}');
      
      // Перезагружаем список анализов
      final tests = await LabTestsService.getMyTests();
      emit(MyTestsLoaded(tests));
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось загрузить анализ: $e',
        code: 'UPLOAD_TEST_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки анализа: $e');
    }
  }

  /// Удалить анализ
  Future<void> _onDeleteTest(
    DeleteTestRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Удаление анализа...'));
      
      await LabTestsService.deleteTest(event.testId);
      
      emit(TestDeleted(
        testId: event.testId,
        message: 'Анализ удален',
      ));
      print('✅ LabTestsBloc: Анализ удален: ${event.testId}');
      
      // Перезагружаем список анализов
      final tests = await LabTestsService.getMyTests();
      emit(MyTestsLoaded(tests));
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось удалить анализ: $e',
        code: 'DELETE_TEST_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка удаления анализа: $e');
    }
  }

  // ==================== INTERPRETATION ====================

  /// Загрузить AI интерпретацию
  Future<void> _onLoadInterpretation(
    LoadInterpretationRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Генерация интерпретации...'));
      
      final interpretation = await LabTestsService.getInterpretation(event.testId);
      
      emit(InterpretationLoaded(interpretation));
      print('✅ LabTestsBloc: Интерпретация загружена: ${event.testId}');
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось получить интерпретацию: $e',
        code: 'LOAD_INTERPRETATION_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки интерпретации: $e');
    }
  }

  // ==================== PARAMETERS ====================

  /// Загрузить доступные параметры
  Future<void> _onLoadAvailableParameters(
    LoadAvailableParametersRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Загрузка параметров...'));
      
      final parameters = await LabTestsService.getAvailableParameters();
      
      emit(AvailableParametersLoaded(parameters));
      print('✅ LabTestsBloc: Параметры загружены (${parameters.length})');
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось загрузить параметры: $e',
        code: 'LOAD_PARAMETERS_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки параметров: $e');
    }
  }

  /// Загрузить тренд параметра
  Future<void> _onLoadParameterTrend(
    LoadParameterTrendRequested event,
    Emitter<LabTestsState> emit,
  ) async {
    try {
      emit(const LabTestsLoading(message: 'Загрузка тренда...'));
      
      final trend = await LabTestsService.getParameterTrend(event.code);
      
      emit(ParameterTrendLoaded(trend));
      print('✅ LabTestsBloc: Тренд загружен: ${trend.name}');
    } catch (e) {
      emit(LabTestsError(
        message: 'Не удалось загрузить тренд: $e',
        code: 'LOAD_TREND_ERROR',
      ));
      print('❌ LabTestsBloc: Ошибка загрузки тренда: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetLabTestsState event,
    Emitter<LabTestsState> emit,
  ) async {
    emit(const LabTestsInitial());
    print('🔄 LabTestsBloc: Состояние сброшено');
  }
}




