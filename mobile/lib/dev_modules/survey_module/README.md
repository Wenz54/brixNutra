# Survey Module

Модуль опросов для Supply Diets приложения.

## 📦 Функционал

- Создание опросов
- Прохождение опросов
- Анализ результатов
- Рекомендации на основе ответов

## 🚀 Использование

```dart
// Получить доступные опросы
final surveys = await SurveyService.getAvailableSurveys();

// Получить опрос по ID
final survey = await SurveyService.getSurvey(surveyId);

// Отправить ответы
await SurveyService.submitAnswers(
  surveyId: surveyId,
  answers: {
    'question_1': 'answer_a',
    'question_2': 'answer_b',
  },
);

// Получить результаты
final results = await SurveyService.getResults(surveyId);
```

## 📡 API Endpoints

- `GET /surveys` - Получить опросы
- `GET /surveys/:id` - Получить опрос по ID
- `POST /surveys/:id/submit` - Отправить ответы
- `GET /surveys/:id/results` - Получить результаты

## 📱 Экраны

- **SurveyListScreen** - Список опросов
- **SurveyScreen** - Прохождение опроса
- **SurveyResultsScreen** - Результаты опроса





