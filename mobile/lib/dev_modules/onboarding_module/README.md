# Onboarding Module

Модуль онбординга при первом входе для Supply Diets приложения.

## 📦 Функционал

- Опрос при первом входе
- Сбор предпочтений по питанию
- Определение целей
- Персонализация опыта

## 🚀 Использование

```dart
// Сохранить ответы опроса
await OnboardingService.saveSurveyAnswers({
  'age': 25,
  'gender': 'male',
  'nutrition_type': 'vegetarian',
  'goals': ['weight_loss', 'healthy_eating'],
});

// Проверить завершен ли онбординг
final isCompleted = await OnboardingService.isOnboardingCompleted();

// Пропустить онбординг
await OnboardingService.skipOnboarding();
```

## 📡 API Endpoints

- `POST /onboarding/survey` - Сохранить ответы
- `GET /onboarding/status` - Проверить статус
- `POST /onboarding/skip` - Пропустить

## 📱 Экраны

- **SurveyNutritionScreen** - Тип питания
- **SurveyGenderScreen** - Пол и возраст
- **SurveyGoalsScreen** - Цели пользователя





