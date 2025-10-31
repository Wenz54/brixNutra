# Users Module - Пользователи

Модуль для управления профилями пользователей.

## 📦 Функциональность

- Профили пользователей
- Загрузка аватаров
- Обновление данных
- Настройки пользователя
- Статистика активности

## 🚀 API Endpoints

- `GET /api/profile` - мой профиль
- `PUT /api/profile` - обновить профиль
- `POST /api/profile/avatar` - загрузить аватар
- `GET /api/users/:id` - профиль пользователя (public)

## 📊 Типы

```typescript
interface UserProfile {
  id: string
  email: string
  name: string
  avatarUrl?: string
  age?: number
  gender?: 'male' | 'female' | 'other'
  height?: number
  weight?: number
  activityLevel?: number
  goals?: string[]
  createdAt: Date
  updatedAt: Date
}
```

---

**Версия:** 1.0.0

