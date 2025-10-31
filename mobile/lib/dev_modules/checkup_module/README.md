# Checkup Module

Модуль лабораторных анализов для Supply Diets приложения.

## 📦 Функционал

- Добавление результатов анализов
- История анализов
- Рекомендации по результатам
- Отслеживание показателей

## 🚀 Использование

```dart
// Добавить результат анализа
await CheckupService.addLabResult(
  testName: 'Общий анализ крови',
  date: DateTime.now(),
  results: {'hemoglobin': 140, 'erythrocytes': 4.5},
);

// Получить все анализы
final tests = await CheckupService.getAllTests();

// Получить историю
final history = await CheckupService.getHistory();
```

## 📡 API Endpoints

- `POST /lab-tests` - Добавить результат
- `GET /lab-tests` - Получить все тесты
- `GET /lab-tests/history` - Получить историю
- `DELETE /lab-tests/:id` - Удалить результат

## 📱 Экраны

- **CheckupMainScreen** - Главный экран checkup
- **CheckupListScreen** - Список анализов
- **AddLabResultScreen** - Добавление результата





