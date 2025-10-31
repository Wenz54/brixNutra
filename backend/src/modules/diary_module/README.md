# Diary Module - Дневник питания

Модуль для трекинга питания и воды.

## 📦 Функциональность

- Дневник приемов пищи
- Трекинг воды
- Статистика по дням
- Расчет КБЖУ
- История записей

## 🚀 API Endpoints

- `GET /api/diary/entries` - записи дневника
- `POST /api/diary/entries` - добавить запись
- `PUT /api/diary/entries/:id` - обновить запись
- `DELETE /api/diary/entries/:id` - удалить запись
- `GET /api/diary/stats` - статистика
- `POST /api/diary/water` - добавить воду

## 📊 Типы

```typescript
interface DiaryEntry {
  id: string
  userId: string
  date: Date
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack'
  productId: number
  quantityGrams: number
  calories: number
  proteins: number
  fats: number
  carbs: number
}

interface WaterEntry {
  id: string
  userId: string
  date: Date
  amountMl: number
}

interface DailyStats {
  date: Date
  totalCalories: number
  totalProteins: number
  totalFats: number
  totalCarbs: number
  totalWater: number
  mealsCount: number
}
```

---

**Версия:** 1.0.0

