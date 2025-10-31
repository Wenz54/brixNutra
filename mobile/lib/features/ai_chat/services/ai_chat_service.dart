import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/ai_chat/models/ai_chat_models.dart';

/// Сервис для работы с AI чатом
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend + OpenAI)
class AiChatService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API!

  // ==================== SESSIONS ====================

  /// Создать новую сессию чата
  ///
  /// [context] - контекст чата (опционально)
  static Future<ChatSession> createSession({
    AiChatContext? context,
  }) async {
    try {
      if (useMockMode) {
        return _mockCreateSession(context: context);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.aiChatNewSession,
        {
          if (context != null) 'context': context.toJson(),
        },
      );

      return ChatSession.fromJson(response['data']);
    } catch (e) {
      print('❌ createSession error: $e');
      rethrow;
    }
  }

  /// Получить список всех сессий
  ///
  /// [limit] - лимит результатов
  /// [includeInactive] - включить неактивные
  static Future<List<ChatSessionPreview>> getSessions({
    int limit = 50,
    bool includeInactive = false,
  }) async {
    try {
      if (useMockMode) {
        return _mockGetSessions(limit: limit, includeInactive: includeInactive);
      }

      // Реальный API запрос
      final queryParams = <String, String>{
        'limit': limit.toString(),
        if (includeInactive) 'include_inactive': 'true',
      };

      final response = await ApiService.get(
        ApiEndpoints.aiChatHistory,
        queryParameters: queryParams,
      );

      return (response['data'] as List)
          .map((item) => ChatSessionPreview.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getSessions error: $e');
      rethrow;
    }
  }

  /// Получить полную сессию со всеми сообщениями
  ///
  /// [sessionId] - ID сессии
  static Future<ChatSession> getSession(String sessionId) async {
    try {
      if (useMockMode) {
        return _mockGetSession(sessionId);
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.aiChatMessages(sessionId),
      );

      return ChatSession.fromJson(response['data']);
    } catch (e) {
      print('❌ getSession error: $e');
      rethrow;
    }
  }

  /// Удалить сессию
  ///
  /// [sessionId] - ID сессии
  static Future<void> deleteSession(String sessionId) async {
    try {
      if (useMockMode) {
        return _mockDeleteSession(sessionId);
      }

      // Реальный API запрос
      await ApiService.delete(
        ApiEndpoints.aiChatDelete(sessionId),
      );
      print('✅ Сессия удалена: $sessionId');
    } catch (e) {
      print('❌ deleteSession error: $e');
      rethrow;
    }
  }

  // ==================== MESSAGES ====================

  /// Отправить сообщение AI
  ///
  /// [sessionId] - ID сессии (null = новая сессия)
  /// [message] - текст сообщения
  /// [context] - контекст (если новая сессия)
  static Future<ChatMessage> sendMessage({
    String? sessionId,
    required String message,
    AiChatContext? context,
  }) async {
    try {
      if (useMockMode) {
        return _mockSendMessage(
          sessionId: sessionId,
          message: message,
          context: context,
        );
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.aiChatMessage,
        {
          if (sessionId != null) 'session_id': sessionId,
          'message': message,
          if (context != null) 'context': context.toJson(),
        },
      );

      return ChatMessage.fromJson(response['data']);
    } catch (e) {
      print('❌ sendMessage error: $e');
      rethrow;
    }
  }

  /// Отправить сообщение со streaming ответом
  ///
  /// [sessionId] - ID сессии
  /// [message] - текст сообщения
  /// [onChunk] - callback для каждого чанка ответа
  static Future<ChatMessage> sendMessageStream({
    required String sessionId,
    required String message,
    required Function(String chunk) onChunk,
  }) async {
    try {
      if (useMockMode) {
        return _mockSendMessageStream(
          sessionId: sessionId,
          message: message,
          onChunk: onChunk,
        );
      }

      // TODO: Реальный streaming запрос (SSE или WebSocket)
      // Пока используем обычный запрос
      return sendMessage(sessionId: sessionId, message: message);
    } catch (e) {
      print('❌ sendMessageStream error: $e');
      rethrow;
    }
  }

  // ==================== CONTEXT ACTIONS ====================

  /// Анализ дневника питания через AI
  ///
  /// [date] - дата для анализа
  static Future<ChatSession> analyzeDiary(DateTime date) async {
    try {
      if (useMockMode) {
        return _mockAnalyzeDiary(date);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.aiChatMessage,
        {
          'message': 'Проанализируй мой дневник питания за ${date.toIso8601String().split('T')[0]}',
          'context': AiChatContext.diaryAnalysis(
            date: date,
            diaryData: {}, // Backend сам получит данные
          ).toJson(),
        },
      );

      return ChatSession.fromJson(response['data']);
    } catch (e) {
      print('❌ analyzeDiary error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static final List<ChatSession> _mockSessions = [
    ChatSession(
      id: 'session_1',
      title: 'Анализ дневника за сегодня',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      messages: [
        ChatMessage(
          id: 'msg_1',
          role: MessageRole.user,
          content: 'Проанализируй мой дневник за сегодня',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: 'msg_2',
          role: MessageRole.assistant,
          content: 'Я проанализировал ваш дневник питания за сегодня. Вы съели 600 ккал из 1800 (33%). '
              'Это хороший прогресс! Белков 30г/120г (25%), углеводов 77г/180г (43%), жиров 18г/60г (30%). '
              'Рекомендую добавить еще источник белка в обед.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          metadata: {
            'type': 'diary_analysis',
            'date': DateTime.now().toIso8601String().split('T')[0],
          },
        ),
      ],
      contextType: 'diary_analysis',
    ),
    ChatSession(
      id: 'session_2',
      title: 'Вопросы о питании',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      messages: [
        ChatMessage(
          id: 'msg_3',
          role: MessageRole.user,
          content: 'Сколько белка нужно есть в день?',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatMessage(
          id: 'msg_4',
          role: MessageRole.assistant,
          content: 'Рекомендуемая норма белка зависит от ваших целей:\n\n'
              '• Поддержание веса: 0.8-1г на кг массы тела\n'
              '• Набор мышечной массы: 1.6-2.2г на кг\n'
              '• Похудение: 1.2-1.6г на кг\n\n'
              'Ваша текущая цель - 120г белка в день, что составляет примерно 1.5г на кг массы тела.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      contextType: 'general',
    ),
  ];

  static Future<ChatSession> _mockCreateSession({
    AiChatContext? context,
  }) async {
    print('🎭 MOCK: Создание новой сессии');
    await Future.delayed(const Duration(milliseconds: 500));

    final session = ChatSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Новый чат',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
      contextType: context?.type,
      contextData: context?.data,
    );

    _mockSessions.insert(0, session);
    return session;
  }

  static Future<List<ChatSessionPreview>> _mockGetSessions({
    int limit = 50,
    bool includeInactive = false,
  }) async {
    print('🎭 MOCK: Получение списка сессий');
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockSessions.take(limit).map((session) {
      return ChatSessionPreview(
        id: session.id,
        title: session.title,
        updatedAt: session.updatedAt,
        lastMessagePreview: session.lastMessagePreview,
        messagesCount: session.messagesCount,
        isActive: session.isActive,
      );
    }).toList();
  }

  static Future<ChatSession> _mockGetSession(String sessionId) async {
    print('🎭 MOCK: Получение сессии: $sessionId');
    await Future.delayed(const Duration(milliseconds: 600));

    final session = _mockSessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => _mockSessions.first,
    );

    return session;
  }

  static Future<void> _mockDeleteSession(String sessionId) async {
    print('🎭 MOCK: Удаление сессии: $sessionId');
    await Future.delayed(const Duration(milliseconds: 300));

    _mockSessions.removeWhere((s) => s.id == sessionId);
  }

  static Future<ChatMessage> _mockSendMessage({
    String? sessionId,
    required String message,
    AiChatContext? context,
  }) async {
    print('🎭 MOCK: Отправка сообщения: $message');
    await Future.delayed(const Duration(milliseconds: 800));

    // Создаем сообщение пользователя
    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      role: MessageRole.user,
      content: message,
      timestamp: DateTime.now(),
    );

    // Генерируем ответ AI
    final aiResponse = _generateMockResponse(message);
    final aiMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
      role: MessageRole.assistant,
      content: aiResponse,
      timestamp: DateTime.now(),
    );

    // Добавляем в сессию
    if (sessionId != null) {
      final sessionIndex = _mockSessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex != -1) {
        final session = _mockSessions[sessionIndex];
        final updatedMessages = [...session.messages, userMessage, aiMessage];
        _mockSessions[sessionIndex] = session.copyWith(
          messages: updatedMessages,
          updatedAt: DateTime.now(),
        );
      }
    }

    return aiMessage;
  }

  static Future<ChatMessage> _mockSendMessageStream({
    required String sessionId,
    required String message,
    required Function(String chunk) onChunk,
  }) async {
    print('🎭 MOCK: Отправка сообщения со streaming');
    await Future.delayed(const Duration(milliseconds: 500));

    final response = _generateMockResponse(message);
    final words = response.split(' ');

    // Имитируем streaming - отправляем слова по одному
    String accumulated = '';
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      accumulated += (i == 0 ? '' : ' ') + words[i];
      onChunk(accumulated);
    }

    final aiMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      role: MessageRole.assistant,
      content: response,
      timestamp: DateTime.now(),
    );

    return aiMessage;
  }

  static Future<ChatSession> _mockAnalyzeDiary(DateTime date) async {
    print('🎭 MOCK: Анализ дневника за ${date.toIso8601String().split('T')[0]}');
    await Future.delayed(const Duration(milliseconds: 1000));

    final session = ChatSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Анализ дневника за ${date.day}.${date.month}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [
        ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          role: MessageRole.assistant,
          content: '📊 Анализ дневника питания за ${date.day}.${date.month}.${date.year}\n\n'
              '✅ Калории: 600/1800 ккал (33%)\n'
              '✅ Белки: 30/120г (25%)\n'
              '✅ Углеводы: 77/180г (43%)\n'
              '✅ Жиры: 18/60г (30%)\n'
              '💧 Вода: 1200/2000мл (60%)\n\n'
              '🎯 Рекомендации:\n'
              '• Добавьте источник белка в обед (куриная грудка, рыба)\n'
              '• Увеличьте потребление воды на 800мл\n'
              '• Распределите приемы пищи равномерно в течение дня',
          timestamp: DateTime.now(),
          metadata: {
            'type': 'diary_analysis',
            'date': date.toIso8601String().split('T')[0],
          },
        ),
      ],
      contextType: 'diary_analysis',
      contextData: {'date': date.toIso8601String()},
    );

    _mockSessions.insert(0, session);
    return session;
  }

  /// Генерация mock ответа на основе вопроса
  static String _generateMockResponse(String question) {
    final lowerQuestion = question.toLowerCase();

    if (lowerQuestion.contains('белок') || lowerQuestion.contains('протеин')) {
      return 'Белок - важнейший макронутриент для роста и восстановления мышц. '
          'Рекомендуемая норма: 1.6-2.2г на кг массы тела для активных людей. '
          'Лучшие источники: курица, рыба, яйца, творог, бобовые.';
    } else if (lowerQuestion.contains('вода') || lowerQuestion.contains('пить')) {
      return 'Рекомендуется пить 30-40мл воды на кг массы тела в день. '
          'Для человека весом 70кг это 2100-2800мл. Пейте равномерно в течение дня, '
          'особенно до и после тренировок.';
    } else if (lowerQuestion.contains('калори') || lowerQuestion.contains('ккал')) {
      return 'Ваша дневная норма калорий зависит от целей:\n'
          '• Похудение: дефицит 300-500 ккал\n'
          '• Поддержание: норма калорий\n'
          '• Набор массы: профицит 200-400 ккал\n\n'
          'Ваша текущая цель - 1800 ккал в день.';
    } else if (lowerQuestion.contains('дневник') || lowerQuestion.contains('анализ')) {
      return 'Я проанализировал ваш дневник. Общий прогресс хороший! '
          'Обратите внимание на распределение БЖУ и время приемов пищи. '
          'Рекомендую добавить больше овощей и зелени.';
    } else if (lowerQuestion.contains('план') || lowerQuestion.contains('питани')) {
      return 'Ваш план питания составлен с учетом ваших целей и предпочтений. '
          'Следуйте ему, отмечая приемы пищи в дневнике. '
          'Если нужны замены блюд - просто спросите!';
    } else {
      return 'Я AI-нутрициолог Brix Nutrition. Готов помочь вам с вопросами о питании, '
          'анализом дневника, составлением рационов и достижением ваших целей. '
          'Задавайте любые вопросы!';
    }
  }
}

