# Knowledge Module - База знаний

Модуль для управления курсами, уроками и категориями базы знаний.

## 📦 Функциональность

- Курсы с уроками
- Категории контента
- Типы уроков (основные, подписка, авторские)
- Аудио и видео контент
- Просмотры и статистика

## 🚀 API Endpoints

### Курсы

- `GET /api/courses` - список курсов
- `GET /api/courses/:id` - курс по ID
- `POST /api/courses` - создать курс (admin)
- `PUT /api/courses/:id` - обновить курс (admin)
- `DELETE /api/courses/:id/deactivate` - деактивировать (admin)

### Уроки

- `GET /api/lessons` - список уроков
- `GET /api/lessons/:id` - урок по ID
- `POST /api/lessons` - создать урок (admin)
- `PUT /api/lessons/:id` - обновить урок (admin)

### Категории

- `GET /api/categories` - список категорий
- `POST /api/categories` - создать категорию (admin)

## 📊 Типы

```typescript
interface Course {
  id: string
  title_ru: string
  description_ru?: string
  previewImageUrl?: string
  tags: string[]
  difficultyLevel: number
  isPremium: boolean
  isFeatured: boolean
  isMarathon: boolean
  isActive: boolean
}

interface Lesson {
  id: string
  title_ru: string
  type: LessonType
  durationMinutes: number
  isPremium: boolean
  contentType: 'text' | 'audio' | 'video'
}

type LessonType = 
  | 'main_lesson' 
  | 'secondary_lesson' 
  | 'subscriber_lesson' 
  | 'author_course'
```

---

**Версия:** 1.0.0

