import 'package:equatable/equatable.dart';
import 'package:mobile/features/ai_chat/models/ai_chat_models.dart';

/// Состояния AI чата
abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class AiChatInitial extends AiChatState {
  const AiChatInitial();

  @override
  String toString() => 'AiChatInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class AiChatLoading extends AiChatState {
  final String? message;

  const AiChatLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AiChatLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ - SESSIONS ====================

/// Сессия создана
class SessionCreated extends AiChatState {
  final ChatSession session;
  final String message;

  const SessionCreated({
    required this.session,
    this.message = 'Новый чат создан',
  });

  @override
  List<Object?> get props => [session, message];

  @override
  String toString() => 'SessionCreated(${session.id})';
}

/// Список сессий загружен
class SessionsLoaded extends AiChatState {
  final List<ChatSessionPreview> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];

  @override
  String toString() => 'SessionsLoaded(${sessions.length} сессий)';
}

/// Сессия загружена
class SessionLoaded extends AiChatState {
  final ChatSession session;

  const SessionLoaded(this.session);

  @override
  List<Object?> get props => [session];

  @override
  String toString() =>
      'SessionLoaded(${session.id}, ${session.messages.length} сообщений)';
}

/// Сессия удалена
class SessionDeleted extends AiChatState {
  final String sessionId;
  final String message;

  const SessionDeleted({
    required this.sessionId,
    this.message = 'Чат удален',
  });

  @override
  List<Object?> get props => [sessionId, message];

  @override
  String toString() => 'SessionDeleted($sessionId)';
}

// ==================== SUCCESS СОСТОЯНИЯ - MESSAGES ====================

/// Сообщение отправлено
class MessageSent extends AiChatState {
  final ChatMessage message;
  final String sessionId;

  const MessageSent({
    required this.message,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [message, sessionId];

  @override
  String toString() => 'MessageSent(sessionId: $sessionId)';
}

/// AI ответ получен
class MessageReceived extends AiChatState {
  final ChatMessage message;
  final String sessionId;

  const MessageReceived({
    required this.message,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [message, sessionId];

  @override
  String toString() => 'MessageReceived(sessionId: $sessionId)';
}

/// Streaming сообщение (печатается)
class MessageStreaming extends AiChatState {
  final String content;
  final String sessionId;

  const MessageStreaming({
    required this.content,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [content, sessionId];

  @override
  String toString() =>
      'MessageStreaming(sessionId: $sessionId, ${content.length} chars)';
}

// ==================== CONTEXT СОСТОЯНИЯ ====================

/// Анализ дневника завершен
class DiaryAnalysisCompleted extends AiChatState {
  final ChatSession session;
  final String message;

  const DiaryAnalysisCompleted({
    required this.session,
    this.message = 'Анализ дневника завершен',
  });

  @override
  List<Object?> get props => [session, message];

  @override
  String toString() => 'DiaryAnalysisCompleted(${session.id})';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка AI чата
class AiChatError extends AiChatState {
  final String message;
  final String? code;

  const AiChatError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'AiChatError(message: $message, code: $code)';
}




