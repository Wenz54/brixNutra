# Diary Module

Модуль дневника питания для Supply Diets приложения.

## 📦 Содержание

- **services/** - Сервис работы с дневником
- **models/** - Модели данных (DiaryDay, MealEntry, WaterLog)
- **screens/** - Экраны дневника
- **widgets/** - Виджеты для отображения приемов пищи

## 🚀 Использование

### DiaryService

```dart
import 'package:supply_diets_app/dev_modules/diary_module/services/diary_service.dart';

// Получить день дневника
final diaryDay = await DiaryService.getDiaryDay(DateTime.now());

// Добавить прием пищи
final meal = await DiaryService.addMeal(
  mealName: 'Овсянка с фруктами',
  mealType: 'breakfast', // breakfast, lunch, dinner, snack
  consumedAt: DateTime.now(),
  portionGrams: 250,
  photo: imageFile, // опционально
);

// Обновить воду
await DiaryService.updateWater(
  date: DateTime.now(),
  totalAmount: 1500, // мл
);

// Обновить настроение
await DiaryService.updateMood(
  date: DateTime.now(),
  rating: 4, // 1-5
);

// Удалить прием пищи
await DiaryService.deleteMeal(mealId);

// Отметить день как завершенный
await DiaryService.updateDayStatus(DateTime.now(), true);
```

### Модели данных

#### DiaryDay
```dart
DiaryDay(
  date: DateTime.now(),
  selectedPlanName: 'Средиземноморская диета',
  meals: [meal1, meal2],
  waterLogs: [waterLog],
  moodRating: 4,
  isCompleted: false,
)
```

#### MealEntry
```dart
MealEntry(
  id: '123',
  mealName: 'Овсянка',
  mealType: 'breakfast',
  consumedAt: DateTime.now(),
  portionGrams: 250,
  photoUrl: 'https://...',
)
```

#### WaterLog
```dart
WaterLog(
  id: '456',
  date: DateTime.now(),
  totalAmount: 1500, // мл
)
```

## 📡 API Endpoints

Все endpoints настроены на `http://localhost:3001/api/diary`:

- `GET /diary/day/:date` - Получить день дневника
- `POST /diary/meal` - Добавить прием пищи
- `DELETE /diary/meal/:id` - Удалить прием пищи
- `POST /diary/water` - Обновить количество воды
- `PUT /diary/mood` - Обновить настроение
- `PUT /diary/day-status` - Обновить статус дня
- `GET /diary/ai-data` - Получить данные для AI анализа

## 📱 Типы приемов пищи

1. **breakfast** - Завтрак
2. **lunch** - Обед
3. **dinner** - Ужин
4. **snack** - Перекус

## 📊 Отслеживание воды

- Измеряется в миллилитрах (мл)
- Рекомендуемая норма: 2000-2500 мл в день
- Отображается прогресс бар
- Кнопки быстрого добавления: +200мл, +250мл, +500мл

## 😊 Отслеживание настроения

Рейтинг от 1 до 5:
- 1 ⭐ - Очень плохо
- 2 ⭐⭐ - Плохо
- 3 ⭐⭐⭐ - Нормально
- 4 ⭐⭐⭐⭐ - Хорошо
- 5 ⭐⭐⭐⭐⭐ - Отлично

## 📸 Фотографии блюд

- Поддержка загрузки фото при добавлении приема пищи
- Хранение в Supabase Storage (или другом хранилище)
- Отображение миниатюр в списке приемов пищи

## 🗓️ Календарь

- Выбор даты для просмотра дневника
- Визуальная индикация заполненных дней
- Отметка завершенных дней

## 🤖 AI Анализ

API предоставляет данные за последние N дней для AI анализа:
```dart
final aiData = await DiaryService.getAIData(days: 7);
// Возвращает агрегированные данные:
// - Список всех приемов пищи
// - Средний объем воды
// - Динамика настроения
// - Паттерны питания
```

## 💾 Офлайн режим

Модуль поддерживает локальное хранилище через `OfflineDiaryService`:
- Кэширование данных при отсутствии интернета
- Автоматическая синхронизация при восстановлении связи
- Использует Hive для локального хранения

```dart
// Инициализация офлайн сервиса
await OfflineDiaryService().init();

// Работает аналогично DiaryService
final day = await OfflineDiaryService().getDiaryDay(DateTime.now());
```

## 🎨 UI Компоненты

### DiaryScreen
Главный экран дневника с:
- Календарь выбора даты
- Список приемов пищи
- Счетчик воды
- Оценка настроения
- Кнопка "Добавить прием пищи"

### MealCard
Карточка приема пищи:
- Название блюда
- Время приема
- Тип приема (завтрак/обед/ужин/перекус)
- Фото (если есть)
- Порция (граммы)

### WaterTracker
Виджет отслеживания воды:
- Прогресс бар
- Текущее количество / Цель
- Кнопки быстрого добавления

### MoodSelector
Виджет выбора настроения:
- 5 звезд для оценки
- Интерактивный выбор

## 📚 Зависимости

```yaml
dependencies:
  # Из core_module
  dio: ^5.0.0 или http: ^1.0.0
  
  # Локальное хранилище
  hive: ^2.0.0
  hive_flutter: ^1.1.0
  
  # Работа с датами
  intl: ^0.18.0
  
  # Выбор изображений
  image_picker: ^1.0.0
```

## ⚙️ Конфигурация

### Изменить API URL

Отредактируйте `core_module/config/api_config.dart`:

```dart
static const String diaryEndpoint = '/diary';
```

### Настройка нормы воды

```dart
class DiaryConfig {
  static const double dailyWaterGoal = 2000; // мл
  static const List<double> quickAddAmounts = [200, 250, 500]; // мл
}
```

## 📝 Примечания

- Даты хранятся в формате ISO 8601
- Время в UTC, конвертируется в локальное при отображении
- Фотографии сжимаются перед загрузкой
- Поддержка пагинации для истории дневника
- Автоматическая очистка старых локальных данных (>30 дней)

## 🔒 Приватность

- Все данные дневника приватны для пользователя
- Требуется авторизация для доступа к API
- Фотографии хранятся с приватным доступом





