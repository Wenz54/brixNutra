# Plans Module

Модуль планов питания для Supply Diets приложения.

## 📦 Функционал

- Просмотр доступных планов питания
- Фильтрация и поиск планов
- Подробная информация о плане
- Активация плана
- Мои планы питания

## 🚀 Использование

```dart
// Получить все планы
final plans = await PlansService.getAllPlans();

// Получить план по ID
final plan = await PlansService.getPlanById(planId);

// Активировать план
await PlansService.activatePlan(planId);

// Получить активный план
final activePlan = await PlansService.getActivePlan();
```

## 📡 API Endpoints

- `GET /plans` - Получить все планы
- `GET /plans/:id` - Получить план по ID
- `POST /plans/:id/activate` - Активировать план
- `GET /plans/active` - Получить активный план

## 📱 Экраны

- **AllPlansScreen** - Список всех планов
- **PlanDetailScreen** - Детали плана
- **PlanSelectionScreen** - Выбор плана
- **MyPlansScreen** - Мои планы





