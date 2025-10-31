# 🤖 AI Chat Feature

Модуль AI чата с нутрициологом для Brix Nutrition App.

## 📋 Описание

AI Chat Feature предоставляет полный функционал для общения с AI нутрициологом:
- 💬 Диалоги с AI в режиме реального времени
- 📊 Анализ дневника питания
- 🎯 Рекомендации по питанию
- 📝 История чатов
- ⚡ Streaming ответы (печатание в реальном времени)
- 🔄 Контекстные чаты (дневник, план питания, анализы)

## 🗂️ Структура

```
features/ai_chat/
├── models/
│   └── ai_chat_models.dart       # Модели данных
├── services/
│   └── ai_chat_service.dart      # API сервис (Mock + Real)
├── bloc/
│   ├── ai_chat_event.dart        # События BLoC
│   ├── ai_chat_state.dart        # Состояния BLoC
│   └── ai_chat_bloc.dart         # Основной BLoC
├── ai_chat.dart                  # Barrel file (экспорты)
└── README.md                     # Документация
```

## 📦 Models

### MessageRole (Enum)
Роль отправителя сообщения:
```dart
enum MessageRole {
  user,       // Пользователь
  assistant,  // AI ассистент
  system,     // Системное сообщение
}
```

### ChatMessage
Сообщение в чате:
```dart
class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isStreaming;              // Печатается ли сейчас
  final Map<String, dynamic>? metadata; // Доп. данные
}
```

**Методы:**
- `isUser`, `isAssistant`, `isSystem` - проверка роли

### ChatSession
Сессия чата (диалог):
```dart
class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;
  final bool isActive;
  final String? contextType;           // 'diary_analysis', 'meal_plan', etc.
  final Map<String, dynamic>? contextData;
}
```

**Методы:**
- `lastMessage` - последнее сообщение
- `lastMessagePreview` - превью (100 символов)
- `messagesCount` - количество сообщений
- `hasMessages` - есть ли сообщения
- `userMessages` - сообщения пользователя
- `assistantMessages` - сообщения AI

### ChatSessionPreview
Краткая информация о сессии (для списка):
```dart
class ChatSessionPreview {
  final String id;
  final String title;
  final DateTime updatedAt;
  final String lastMessagePreview;
  final int messagesCount;
  final bool isActive;
}
```

**Методы:**
- `formattedDate` - "2 ч назад", "Вчера", "15.10.2025"

### AiChatContext
Контекст для AI чата:
```dart
class AiChatContext {
  final String type;  // 'diary_analysis', 'meal_plan', 'lab_tests', 'general'
  final Map<String, dynamic> data;
}
```

**Фабричные методы:**
- `AiChatContext.general()` - общий чат
- `AiChatContext.diaryAnalysis({date, diaryData})` - анализ дневника
- `AiChatContext.mealPlan({planId, planData})` - план питания
- `AiChatContext.labTests({testId, testData})` - анализы

## 🔌 Service API

### AiChatService

**Режим работы:**
```dart
static const bool useMockMode = true; // Mock режим для разработки
```

**Методы:**

#### Сессии
```dart
// Создать новую сессию
Future<ChatSession> createSession({AiChatContext? context})

// Получить список сессий
Future<List<ChatSessionPreview>> getSessions({
  int limit = 50,
  bool includeInactive = false,
})

// Получить полную сессию со всеми сообщениями
Future<ChatSession> getSession(String sessionId)

// Удалить сессию
Future<void> deleteSession(String sessionId)
```

#### Сообщения
```dart
// Отправить сообщение (обычный режим)
Future<ChatMessage> sendMessage({
  String? sessionId,     // null = новая сессия
  required String message,
  AiChatContext? context,
})

// Отправить сообщение со streaming
Future<ChatMessage> sendMessageStream({
  required String sessionId,
  required String message,
  required Function(String chunk) onChunk,
})
```

#### Контекстные действия
```dart
// Анализ дневника питания
Future<ChatSession> analyzeDiary(DateTime date)
```

## 🧠 BLoC Architecture

### Events

```dart
// Сессии
CreateSessionRequested({context})
LoadSessionsRequested({limit, includeInactive})
LoadSessionRequested(sessionId)
DeleteSessionRequested(sessionId)

// Сообщения
SendMessageRequested({sessionId, message, context})
SendMessageStreamRequested({sessionId, message})
StreamingMessageUpdated(content)

// Контекст
AnalyzeDiaryRequested(date)

// Утилиты
ResetAiChatState()
```

### States

```dart
// Начальное
AiChatInitial()

// Загрузка
AiChatLoading({message})

// Успех - Сессии
SessionCreated({session, message})
SessionsLoaded(List<ChatSessionPreview> sessions)
SessionLoaded(ChatSession session)
SessionDeleted({sessionId, message})

// Успех - Сообщения
MessageSent({message, sessionId})
MessageReceived({message, sessionId})
MessageStreaming({content, sessionId})

// Контекст
DiaryAnalysisCompleted({session, message})

// Ошибка
AiChatError({message, code})
```

## 💡 Использование

### Базовое использование

```dart
import 'package:mobile/features/ai_chat/ai_chat.dart';

// 1. Создать BLoC
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AiChatBloc>(
      create: (context) => AiChatBloc()
        ..add(LoadSessionsRequested()),
      child: MyWidget(),
    );
  }
}

// 2. Использовать в виджете
class AiChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatBloc, AiChatState>(
      builder: (context, state) {
        if (state is AiChatLoading) {
          return CircularProgressIndicator();
        }
        
        if (state is SessionsLoaded) {
          return ListView.builder(
            itemCount: state.sessions.length,
            itemBuilder: (context, index) {
              final session = state.sessions[index];
              return ListTile(
                title: Text(session.title),
                subtitle: Text(session.lastMessagePreview),
                trailing: Text(session.formattedDate),
              );
            },
          );
        }
        
        return SizedBox.shrink();
      },
    );
  }
}
```

### Создать новую сессию

```dart
// Общий чат
context.read<AiChatBloc>().add(
  CreateSessionRequested(),
);

// Чат с контекстом (анализ дневника)
context.read<AiChatBloc>().add(CreateSessionRequested(
  context: AiChatContext.diaryAnalysis(
    date: DateTime.now(),
    diaryData: {...},
  ),
));
```

### Загрузить список чатов

```dart
context.read<AiChatBloc>().add(
  LoadSessionsRequested(limit: 50),
);
```

### Отправить сообщение

```dart
// Обычная отправка
context.read<AiChatBloc>().add(SendMessageRequested(
  sessionId: 'session_123',
  message: 'Сколько белка нужно есть в день?',
));

// Со streaming (печатание в реальном времени)
context.read<AiChatBloc>().add(SendMessageStreamRequested(
  sessionId: 'session_123',
  message: 'Проанализируй мой дневник',
));
```

### Анализ дневника

```dart
// Быстрый анализ дневника
context.read<AiChatBloc>().add(
  AnalyzeDiaryRequested(DateTime.now()),
);

// Результат: создается новая сессия с анализом
```

### Обработка состояний

```dart
BlocListener<AiChatBloc, AiChatState>(
  listener: (context, state) {
    if (state is MessageReceived) {
      // Сообщение получено
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ответ получен')),
      );
    } else if (state is MessageStreaming) {
      // Streaming идет (печатание)
      // Обновляем UI с частичным текстом
    } else if (state is AiChatError) {
      // Ошибка
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${state.message}')),
      );
    }
  },
  child: ChatWidget(),
)
```

### Полный пример чата

```dart
class ChatScreen extends StatefulWidget {
  final String sessionId;

  const ChatScreen({required this.sessionId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Загружаем сессию
    context.read<AiChatBloc>().add(LoadSessionRequested(widget.sessionId));
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    context.read<AiChatBloc>().add(SendMessageRequested(
      sessionId: widget.sessionId,
      message: _controller.text.trim(),
    ));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Чат')),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: BlocBuilder<AiChatBloc, AiChatState>(
              builder: (context, state) {
                if (state is SessionLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.session.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.session.messages.reversed.elementAt(index);
                      return MessageBubble(message: message);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),

          // Поле ввода
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## 🎭 Mock данные

Mock режим включает:
- **2 готовые сессии:**
  1. "Анализ дневника за сегодня" - с анализом КБЖУ
  2. "Вопросы о питании" - диалог о белке
- **Умные ответы:** AI распознает ключевые слова (белок, вода, калории, дневник) и дает релевантные ответы
- **Streaming имитация:** Слова печатаются по одному (50ms задержка)

### Примеры mock ответов:

**Вопрос о белке:**
> "Белок - важнейший макронутриент для роста и восстановления мышц. Рекомендуемая норма: 1.6-2.2г на кг массы тела для активных людей. Лучшие источники: курица, рыба, яйца, творог, бобовые."

**Вопрос о воде:**
> "Рекомендуется пить 30-40мл воды на кг массы тела в день. Для человека весом 70кг это 2100-2800мл. Пейте равномерно в течение дня, особенно до и после тренировок."

**Анализ дневника:**
> "📊 Анализ дневника питания за 14.10.2025
> ✅ Калории: 600/1800 ккал (33%)
> ✅ Белки: 30/120г (25%)
> ✅ Углеводы: 77/180г (43%)
> ✅ Жиры: 18/60г (30%)
> 💧 Вода: 1200/2000мл (60%)"

## 🔄 Переключение в Real API

В файле `ai_chat_service.dart`:
```dart
static const bool useMockMode = false; // Переключить на false
```

Backend endpoints:
- `POST /api/ai-chat/sessions` - создать сессию
- `GET /api/ai-chat/sessions` - список сессий
- `GET /api/ai-chat/sessions/:id` - получить сессию
- `DELETE /api/ai-chat/sessions/:id` - удалить
- `POST /api/ai-chat/message` - отправить сообщение

## ✅ Features

- ✅ Полная BLoC архитектура
- ✅ Mock режим для UI разработки
- ✅ Real API интеграция готова
- ✅ Все модели с Equatable
- ✅ fromJson/toJson для всех моделей
- ✅ Подробное логирование
- ✅ Обработка ошибок
- ✅ Streaming поддержка
- ✅ Контекстные чаты
- ✅ Анализ дневника
- ✅ История сессий
- ✅ Умные mock ответы

## 🎨 UI Примеры

### Сообщение пользователя
```dart
Container(
  alignment: Alignment.centerRight,
  child: Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      message.content,
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

### Сообщение AI
```dart
Container(
  alignment: Alignment.centerLeft,
  child: Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(message.content),
  ),
)
```

## 📝 TODO

- [ ] UI экраны (будут в Task 4.x)
- [ ] Real streaming через SSE/WebSocket
- [ ] Голосовой ввод
- [ ] Рекомендации по рецептам
- [ ] История диалогов с поиском
- [ ] Экспорт чатов

## 🔗 Связанные модули

- `diary` - анализ дневника питания
- `meal_plan` - рекомендации по плану
- `lab_tests` - интерпретация анализов
- `core_module` - ApiService

---

**Создано:** 14 октября 2025  
**Версия:** 1.0.0  
**Task:** 3.6




