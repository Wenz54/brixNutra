/// Diary Feature
///
/// Модуль для работы с дневником питания
///
/// Включает:
/// - Models: DiaryDay, DiaryMeal, WaterLog, DailyGoals, DailyStats
/// - Service: DiaryService (Mock + Real API)
/// - BLoC: DiaryBloc, DiaryEvent, DiaryState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/diary/diary.dart';
///
/// // В BlocProvider
/// BlocProvider<DiaryBloc>(
///   create: (context) => DiaryBloc()
///     ..add(LoadDayDiaryRequested(DateTime.now())),
///   child: MyWidget(),
/// )
///
/// // В виджете
/// BlocBuilder<DiaryBloc, DiaryState>(
///   builder: (context, state) {
///     if (state is DayDiaryLoaded) {
///       return Text('${state.diaryDay.stats.totalCalories} ккал');
///     }
///     return CircularProgressIndicator();
///   },
/// )
/// ```
library;

export 'models/diary_models.dart';
export 'services/diary_service.dart';
export 'bloc/diary_bloc.dart';
export 'bloc/diary_event.dart';
export 'bloc/diary_state.dart';




