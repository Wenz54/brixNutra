# AI Chat Module - AI Чат

Модуль для общения с AI ассистентом на базе OpenAI.

## 📦 Функциональность

- Чат с AI ассистентом
- Контекст диалога
- История сообщений
- Streaming ответов
- Персонализированные рекомендации

## 🚀 API Endpoints

- `GET /api/ai-chat/conversations` - список диалогов
- `GET /api/ai-chat/conversations/:id` - диалог по ID
- `POST /api/ai-chat/conversations` - создать диалог
- `POST /api/ai-chat/conversations/:id/messages` - отправить сообщение
- `GET /api/ai-chat/conversations/:id/messages` - история сообщений

## 📊 Типы

```typescript
interface Conversation {
  id: string
  userId: string
  title: string
  createdAt: Date
  updatedAt: Date
}

interface Message {
  id: string
  conversationId: string
  role: 'user' | 'assistant' | 'system'
  content: string
  createdAt: Date
}

interface ChatRequest {
  conversationId?: string
  message: string
  context?: {
    userProfile?: any
    nutritionPlan?: any
    recentMeals?: any[]
  }
}
```

## 🤖 OpenAI Integration

```typescript
import { OpenAI } from 'openai'

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
})

// Отправка сообщения
const completion = await openai.chat.completions.create({
  model: 'gpt-4',
  messages: [
    {
      role: 'system',
      content: 'Ты - эксперт по питанию...'
    },
    {
      role: 'user',
      content: 'Как мне похудеть?'
    }
  ],
  stream: true
})
```

---

**Версия:** 1.0.0

