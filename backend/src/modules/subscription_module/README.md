# Subscription Module - Подписки

Модуль для управления подписками и премиум доступом.

## 📦 Функциональность

- Планы подписок
- Платежи
- Премиум доступ к контенту
- История платежей
- Автоматическое продление

## 🚀 API Endpoints

- `GET /api/subscriptions/plans` - планы подписок
- `GET /api/subscriptions/my` - моя подписка
- `POST /api/subscriptions/subscribe` - оформить подписку
- `POST /api/subscriptions/cancel` - отменить подписку
- `GET /api/subscriptions/payments` - история платежей

## 📊 Типы

```typescript
interface SubscriptionPlan {
  id: string
  name: string
  priceMonthly: number
  priceYearly: number
  features: string[]
  isActive: boolean
}

interface UserSubscription {
  id: string
  userId: string
  planId: string
  status: 'active' | 'cancelled' | 'expired'
  startDate: Date
  endDate: Date
  autoRenew: boolean
}

interface Payment {
  id: string
  userId: string
  subscriptionId: string
  amount: number
  currency: string
  status: 'pending' | 'completed' | 'failed'
  createdAt: Date
}
```

---

**Версия:** 1.0.0

