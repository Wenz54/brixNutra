# Survey Module - Опросники

Модуль для работы с опросниками и анкетами.

## 📦 Функциональность

- Опросники
- Вопросы и варианты ответов
- Ответы пользователей
- Анализ результатов
- Статистика опросов

## 🚀 API Endpoints

- `GET /api/surveys` - список опросников
- `GET /api/surveys/:id` - опросник по ID
- `POST /api/surveys/:id/responses` - отправить ответы
- `GET /api/surveys/:id/results` - результаты (admin)

## 📊 Типы

```typescript
interface Survey {
  id: string
  title_ru: string
  description_ru?: string
  isActive: boolean
  questions: SurveyQuestion[]
}

interface SurveyQuestion {
  id: string
  surveyId: string
  text_ru: string
  type: 'single' | 'multiple' | 'text' | 'scale'
  options?: string[]
  required: boolean
  order: number
}

interface SurveyResponse {
  id: string
  userId: string
  surveyId: string
  answers: Record<string, any>
  completedAt: Date
}
```

---

**Версия:** 1.0.0

