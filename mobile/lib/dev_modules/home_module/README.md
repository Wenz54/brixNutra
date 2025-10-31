# Home Module

Модуль главного экрана для Supply Diets приложения.

## 📦 Функционал

- Приветствие пользователя
- Активный план питания
- Быстрые действия
- Статистика
- Рекомендации

## 🚀 Использование

```dart
// Получить данные для главного экрана
final homeData = await HomeService.getHomeData();

// Получить статистику
final stats = await HomeService.getStatistics();

// Получить рекомендации
final recommendations = await HomeService.getRecommendations();
```

## 📡 API Endpoints

- `GET /home/data` - Получить данные главного экрана
- `GET /home/statistics` - Получить статистику
- `GET /home/recommendations` - Получить рекомендации

## 📱 Компоненты

- **HomeScreen** - Главный экран
- **WelcomeCard** - Карточка приветствия
- **ActivePlanCard** - Карточка активного плана
- **QuickActionsGrid** - Сетка быстрых действий
- **StatisticsWidget** - Виджет статистики





