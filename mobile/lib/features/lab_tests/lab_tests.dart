/// Lab Tests Feature
///
/// Модуль для работы с лабораторными анализами
///
/// Включает:
/// - Models: LabTest, ParameterValue, Interpretation, ParameterTrend
/// - Service: LabTestsService (Mock + Real API)
/// - BLoC: LabTestsBloc, LabTestsEvent, LabTestsState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/lab_tests/lab_tests.dart';
///
/// // В BlocProvider
/// BlocProvider<LabTestsBloc>(
///   create: (context) => LabTestsBloc()
///     ..add(LoadMyTestsRequested()),
///   child: MyWidget(),
/// )
///
/// // Загрузить анализ
/// context.read<LabTestsBloc>().add(
///   UploadTestRequested(
///     file: file,
///     testDate: DateTime.now(),
///     title: 'Биохимия',
///   ),
/// );
///
/// // Получить интерпретацию
/// context.read<LabTestsBloc>().add(
///   LoadInterpretationRequested('test_123'),
/// );
/// ```
library;

export 'models/lab_test_models.dart';
export 'services/lab_tests_service.dart';
export 'bloc/lab_tests_bloc.dart';
export 'bloc/lab_tests_event.dart';
export 'bloc/lab_tests_state.dart';




