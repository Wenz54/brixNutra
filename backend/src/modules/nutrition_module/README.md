# Nutrition Module - Планы питания

Модуль для управления планами питания, продуктами и КБЖУ.

## 📦 Состав модуля

### Routes
- `GET /nutrition/plans` - список планов питания
- `GET /nutrition/plans/:id` - план по ID
- `POST /nutrition/plans` - создать план (admin)
- `PUT /nutrition/plans/:id` - обновить план (admin)
- `DELETE /nutrition/plans/:id` - удалить план (admin)
- `GET /nutrition/products` - список продуктов
- `POST /nutrition/plans/:id/products` - добавить продукт (admin)
- `GET /nutrition/plans/:id/meals` - приемы пищи плана
- `POST /nutrition/plans/:id/meals` - создать прием пищи (admin)

### Services
- `NutritionService` - работа с планами
- `ProductService` - работа с продуктами
- `MealService` - работа с приемами пищи
- `KBZHUCalculator` - расчет КБЖУ

## 🚀 API Endpoints

### Получить все планы

```http
GET /api/nutrition/plans?page=1&limit=20
```

**Query Parameters:**
- `page` (optional) - номер страницы
- `limit` (optional) - количество на странице
- `isPremium` (optional) - фильтр по премиум
- `isVegetarian` (optional) - вегетарианские
- `isVegan` (optional) - веганские
- `isGlutenFree` (optional) - без глютена

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title_ru": "Средиземноморская диета",
      "shortDescription": "Здоровое питание",
      "mainImageUrl": "/uploads/images/plan1.jpg",
      "isPremium": false,
      "isVegetarian": false,
      "isVegan": false,
      "isGlutenFree": false,
      "caloriesPerDay": 2000,
      "proteinsPerDay": 100,
      "fatsPerDay": 70,
      "carbsPerDay": 250,
      "tags": ["здоровье", "морепродукты"]
    }
  ],
  "pagination": {
    "total": 15,
    "page": 1,
    "limit": 20,
    "pages": 1
  }
}
```

### Создать план (Admin only)

```http
POST /api/nutrition/plans
Authorization: Bearer {token}
Content-Type: application/json

{
  "title_ru": "Кето диета",
  "shortDescription": "Низкоуглеводная диета",
  "description_ru": "Полное описание...",
  "mainImageUrl": "/uploads/images/keto.jpg",
  "isPremium": true,
  "isVegetarian": false,
  "isVegan": false,
  "isGlutenFree": true,
  "caloriesPerDay": 1800,
  "proteinsPerDay": 120,
  "fatsPerDay": 140,
  "carbsPerDay": 30,
  "tags": ["кето", "низкоуглеводная"]
}
```

### Получить продукты

```http
GET /api/nutrition/products?limit=100
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name_ru": "Куриная грудка",
      "category_ru": "Мясо",
      "caloriesPer100g": 165,
      "proteinsPer100g": 31,
      "fatsPer100g": 3.6,
      "carbsPer100g": 0,
      "imageUrl": "/uploads/images/chicken.jpg"
    }
  ]
}
```

### Добавить продукт в план (Admin)

```http
POST /api/nutrition/plans/:planId/products
Authorization: Bearer {token}
Content-Type: application/json

{
  "productId": 1,
  "quantityGrams": 150,
  "mealType": "lunch",
  "dayNumber": 1
}
```

## 🔧 Использование

### NutritionService

```typescript
import { NutritionService } from '@/backend_modules/nutrition_module'

const service = new NutritionService()

// Получить все планы
const plans = await service.getAllPlans({ 
  page: 1, 
  limit: 20,
  isPremium: false 
})

// Создать план
const newPlan = await service.createPlan({
  title_ru: 'Новая диета',
  shortDescription: 'Описание',
  isPremium: false,
  // ...
})

// Получить план по ID
const plan = await service.getPlanById(1)
```

### KBZHU Calculator

```typescript
import { calculateKBZHU } from '@/backend_modules/nutrition_module'

// Расчет КБЖУ для продукта
const kbzhu = calculateKBZHU({
  caloriesPer100g: 165,
  proteinsPer100g: 31,
  fatsPer100g: 3.6,
  carbsPer100g: 0
}, 150) // 150 грамм

// Результат:
// {
//   calories: 247.5,
//   proteins: 46.5,
//   fats: 5.4,
//   carbs: 0
// }
```

## 📊 Типы

### NutritionPlan

```typescript
interface NutritionPlan {
  id: number
  title_ru: string
  shortDescription?: string
  description_ru?: string
  mainImageUrl?: string
  isPremium: boolean
  isVegetarian: boolean
  isVegan: boolean
  isGlutenFree: boolean
  caloriesPerDay?: number
  proteinsPerDay?: number
  fatsPerDay?: number
  carbsPerDay?: number
  durationDays?: number
  tags: string[]
  createdAt: Date
  updatedAt: Date
}
```

### Product

```typescript
interface Product {
  id: number
  name_ru: string
  category_ru?: string
  caloriesPer100g: number
  proteinsPer100g: number
  fatsPer100g: number
  carbsPer100g: number
  imageUrl?: string
  isVegetarian?: boolean
  isVegan?: boolean
  isGlutenFree?: boolean
}
```

### Meal

```typescript
interface Meal {
  id: number
  planId: number
  dayNumber: number
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack'
  name_ru: string
  description_ru?: string
  imageUrl?: string
  calories: number
  proteins: number
  fats: number
  carbs: number
  products: MealProduct[]
}
```

## 🔐 Права доступа

- **Все пользователи:** просмотр планов и продуктов
- **Подписчики:** доступ к премиум планам
- **Админы:** создание, редактирование, удаление

## 📦 Зависимости

```json
{
  "core_module": "^1.0.0",
  "database_module": "^1.0.0",
  "auth_module": "^1.0.0"
}
```

## 🔗 Связанные модули

- Зависит от `core_module` для middleware
- Зависит от `auth_module` для проверки прав
- Используется в `diary_module` для трекинга питания

---

**Версия:** 1.0.0  
**Обновлено:** October 2025

