# Analytics Module - Аналитика

Модуль для сбора и анализа статистики.

## 📦 Функциональность

- Статистика пользователей
- Метрики контента
- Активность по дням
- Dashboard данные
- Экспорт отчетов

## 🚀 API Endpoints

- `GET /api/analytics/dashboard` - общая статистика
- `GET /api/analytics/users` - статистика пользователей
- `GET /api/analytics/content` - статистика контента
- `GET /api/analytics/activity` - активность по дням

## 📊 Типы

```typescript
interface DashboardStats {
  totalUsers: number
  activeUsers: number
  totalPlans: number
  totalCourses: number
  totalLessons: number
  recentActivity: number
}

interface UserStats {
  newUsers: number
  activeUsers: number
  retentionRate: number
  churnRate: number
  avgSessionDuration: number
}

interface ContentStats {
  totalViews: number
  totalCompletions: number
  avgCompletionRate: number
  popularContent: Array<{
    id: string
    title: string
    views: number
    completions: number
  }>
}

interface DailyActivity {
  date: Date
  users: number
  sessions: number
  actions: number
}
```

---

**Версия:** 1.0.0

