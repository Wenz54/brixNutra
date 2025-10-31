# Subscription Module

Модуль подписок для Supply Diets приложения.

## 📦 Функционал

- Просмотр тарифов
- Оформление подписки
- Управление подпиской
- История платежей

## 🚀 Использование

```dart
// Получить доступные тарифы
final plans = await SubscriptionService.getPlans();

// Оформить подписку
await SubscriptionService.subscribe(planId: 'premium');

// Получить текущую подписку
final subscription = await SubscriptionService.getCurrentSubscription();

// Отменить подписку
await SubscriptionService.cancelSubscription();
```

## 📡 API Endpoints

- `GET /subscriptions/plans` - Получить тарифы
- `POST /subscriptions/subscribe` - Оформить подписку
- `GET /subscriptions/current` - Текущая подписка
- `POST /subscriptions/cancel` - Отменить подписку

## 📱 Экраны

- **SubscriptionPlansScreen** - Список тарифов
- **SubscriptionDetailScreen** - Детали подписки
- **PaymentScreen** - Оплата





