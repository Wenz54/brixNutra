# AI Chat Module

Модуль AI чата для Supply Diets приложения.

## 📦 Функционал

- Чат с AI ассистентом
- История разговоров
- Контекст пользователя (дневник, план питания)
- Персональные рекомендации

## 🚀 Использование

```dart
// Отправить сообщение
final response = await AIChatService.sendMessage(
  message: 'Что мне приготовить на ужин?',
);

// Получить историю чата
final history = await AIChatService.getChatHistory();

// Создать новый чат
final chat = await AIChatService.createChat(title: 'Новый разговор');

// Удалить чат
await AIChatService.deleteChat(chatId);
```

## 📡 API Endpoints

- `POST /ai-chat/message` - Отправить сообщение
- `GET /ai-chat/history` - Получить историю
- `POST /ai-chat/create` - Создать чат
- `DELETE /ai-chat/:id` - Удалить чат

## 📱 Экраны

- **AIChatScreen** - Экран чата
- **ChatHistoryScreen** - История разговоров





