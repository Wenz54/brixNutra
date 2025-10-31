# 🧪 Lab Tests Feature

Модуль для работы с лабораторными анализами в Brix Nutrition App.

## 📋 Описание

Lab Tests Feature предоставляет полный функционал для управления анализами:
- 📤 Загрузка результатов анализов (PDF, фото)
- 📊 Просмотр параметров и референсных значений
- 🤖 AI интерпретация результатов
- 📈 Тренды параметров во времени
- ⚠️ Определение отклонений от нормы
- 💡 Персональные рекомендации

## 🗂️ Структура

```
features/lab_tests/
├── models/
│   └── lab_test_models.dart      # Модели данных
├── services/
│   └── lab_tests_service.dart    # API сервис (Mock + Real)
├── bloc/
│   ├── lab_tests_event.dart      # События BLoC
│   ├── lab_tests_state.dart      # Состояния BLoC
│   └── lab_tests_bloc.dart       # Основной BLoC
├── lab_tests.dart                # Barrel file (экспорты)
└── README.md                     # Документация
```

## 📦 Models

### LabTest
Лабораторный анализ:
```dart
class LabTest {
  final String id;
  final String title;
  final DateTime testDate;
  final List<ParameterValue> parameters;
  final String? fileUrl;
  final bool hasInterpretation;
}
```

**Методы:**
- `parametersCount`, `normalParametersCount`, `abnormalParametersCount`
- `normalPercentage`, `allNormal`
- `abnormalParameters`, `getParameter(code)`

### ParameterValue
Значение параметра:
```dart
class ParameterValue {
  final String code;           // "glucose", "cholesterol"
  final String name;
  final double value;
  final String unit;
  final ParameterRange range;
  final bool isNormal;
  final String? interpretation;
}
```

**Методы:**
- `status` - "low", "normal", "high"
- `statusEmoji` - ⬇️, ✅, ⬆️

### Interpretation
AI интерпретация:
```dart
class Interpretation {
  final String summary;
  final String detailed;
  final List<String> recommendations;
  final List<String> warnings;
}
```

### ParameterTrend
Тренд параметра:
```dart
class ParameterTrend {
  final String code;
  final List<TrendPoint> points;
  final ParameterRange range;
  final String trend;  // "up", "down", "stable"
}
```

## 🔌 Service API

### LabTestsService

**Методы:**

```dart
// Получить список анализов
Future<List<LabTestPreview>> getMyTests({int limit = 50})

// Получить анализ
Future<LabTest> getTest(String testId)

// Загрузить анализ
Future<LabTest> uploadTest({
  required File file,
  required DateTime testDate,
  String? title,
  String? notes,
})

// Удалить анализ
Future<void> deleteTest(String testId)

// Получить интерпретацию
Future<Interpretation> getInterpretation(String testId)

// Получить тренд параметра
Future<ParameterTrend> getParameterTrend(String code)
```

## 🧠 BLoC Architecture

### Events

```dart
LoadMyTestsRequested({limit})
LoadTestRequested(testId)
UploadTestRequested({file, testDate, title, notes})
DeleteTestRequested(testId)
LoadInterpretationRequested(testId)
LoadParameterTrendRequested(code)
ResetLabTestsState()
```

### States

```dart
LabTestsInitial()
LabTestsLoading({message})
MyTestsLoaded(List<LabTestPreview> tests)
TestLoaded(LabTest test)
TestUploaded({test, message})
TestDeleted({testId, message})
InterpretationLoaded(Interpretation)
ParameterTrendLoaded(ParameterTrend)
LabTestsError({message, code})
```

## 💡 Использование

### Загрузить список анализов

```dart
context.read<LabTestsBloc>().add(
  LoadMyTestsRequested(),
);
```

### Просмотр анализа

```dart
context.read<LabTestsBloc>().add(
  LoadTestRequested('test_123'),
);

// Обработка
BlocBuilder<LabTestsBloc, LabTestsState>(
  builder: (context, state) {
    if (state is TestLoaded) {
      final test = state.test;
      return Column(
        children: [
          Text('${test.title}'),
          Text('${test.normalParametersCount}/${test.parametersCount} в норме'),
          ...test.parameters.map((p) => ListTile(
            title: Text(p.name),
            subtitle: Text('${p.value} ${p.unit}'),
            trailing: Text(p.statusEmoji),
          )),
        ],
      );
    }
    return SizedBox.shrink();
  },
)
```

### Загрузить новый анализ

```dart
File file = ...; // Файл PDF или фото

context.read<LabTestsBloc>().add(UploadTestRequested(
  file: file,
  testDate: DateTime.now(),
  title: 'Биохимия крови',
  notes: 'Натощак',
));
```

### Получить AI интерпретацию

```dart
context.read<LabTestsBloc>().add(
  LoadInterpretationRequested('test_123'),
);

// Обработка
BlocBuilder<LabTestsBloc, LabTestsState>(
  builder: (context, state) {
    if (state is InterpretationLoaded) {
      final interp = state.interpretation;
      return Column(
        children: [
          Text(interp.summary),
          Text(interp.detailed),
          if (interp.hasWarnings)
            ...interp.warnings.map((w) => Text('⚠️ $w')),
          ...interp.recommendations.map((r) => Text('💡 $r')),
        ],
      );
    }
    return SizedBox.shrink();
  },
)
```

### Просмотр тренда

```dart
context.read<LabTestsBloc>().add(
  LoadParameterTrendRequested('glucose'),
);
```

## 🎭 Mock данные

Mock режим включает:
- **2 готовых анализа:**
  1. Общий анализ крови (все в норме)
  2. Биохимия (2 отклонения: глюкоза, холестерин)
  
- **Параметры:**
  - Гемоглобин, эритроциты, лейкоциты
  - Глюкоза, холестерин, АЛТ, АСТ

- **AI интерпретации:**
  - Детальный анализ каждого параметра
  - 3-5 персональных рекомендаций
  - Предупреждения при отклонениях

- **Тренды:**
  - Глюкоза: растущий тренд 📈
  - Холестерин: падающий тренд 📉

## ✅ Features

- ✅ Полная BLoC архитектура
- ✅ Mock режим для UI разработки
- ✅ Real API интеграция готова
- ✅ Все модели с Equatable
- ✅ AI интерпретация
- ✅ Тренды параметров
- ✅ Автоматическое определение отклонений
- ✅ Детальное логирование

---

**Создано:** 14 октября 2025  
**Версия:** 1.0.0  
**Task:** 3.7




