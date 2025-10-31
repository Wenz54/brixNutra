import 'package:equatable/equatable.dart';
import 'package:mobile/features/ai_chat/models/ai_chat_models.dart';

/// События для управления AI чатом
abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

// ==================== SESSION СОБЫТИЯ ====================

/// Создать новую сессию
class CreateSessionRequested extends AiChatEvent {
  final AiChatContext? context;

  const CreateSessionRequested({this.context});

  @override
  List<Object?> get props => [context];

  @override
  String toString() => 'CreateSessionRequested(context: ${context?.type})';
}

/// Загрузить список сессий
class LoadSessionsRequested extends AiChatEvent {
  final int limit;
  final bool includeInactive;

  const LoadSessionsRequested({
    this.limit = 50,
    this.includeInactive = false,
  });

  @override
  List<Object?> get props => [limit, includeInactive];

  @override
  String toString() => 'LoadSessionsRequested(limit: $limit)';
}

/// Загрузить конкретную сессию
class LoadSessionRequested extends AiChatEvent {
  final String sessionId;

  const LoadSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];

  @override
  String toString() => 'LoadSessionRequested($sessionId)';
}

/// Удалить сессию
class DeleteSessionRequested extends AiChatEvent {
  final String sessionId;

  const DeleteSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];

  @override
  String toString() => 'DeleteSessionRequested($sessionId)';
}

// ==================== MESSAGE СОБЫТИЯ ====================

/// Отправить сообщение
class SendMessageRequested extends AiChatEvent {
  final String? sessionId; // null = новая сессия
  final String message;
  final AiChatContext? context;

  const SendMessageRequested({
    this.sessionId,
    required this.message,
    this.context,
  });

  @override
  List<Object?> get props => [sessionId, message, context];

  @override
  String toString() => 'SendMessageRequested(message: ${message.length} chars)';
}

/// Отправить сообщение со streaming
class SendMessageStreamRequested extends AiChatEvent {
  final String sessionId;
  final String message;

  const SendMessageStreamRequested({
    required this.sessionId,
    required this.message,
  });

  @override
  List<Object?> get props => [sessionId, message];

  @override
  String toString() => 'SendMessageStreamRequested(message: ${message.length} chars)';
}

/// Обновление streaming сообщения (чанк получен)
class StreamingMessageUpdated extends AiChatEvent {
  final String content;

  const StreamingMessageUpdated(this.content);

  @override
  List<Object?> get props => [content];

  @override
  String toString() => 'StreamingMessageUpdated(${content.length} chars)';
}

// ==================== CONTEXT СОБЫТИЯ ====================

/// Анализ дневника
class AnalyzeDiaryRequested extends AiChatEvent {
  final DateTime date;

  const AnalyzeDiaryRequested(this.date);

  @override
  List<Object?> get props => [date];

  @override
  String toString() => 'AnalyzeDiaryRequested(${date.toIso8601String().split('T')[0]})';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetAiChatState extends AiChatEvent {
  const ResetAiChatState();

  @override
  String toString() => 'ResetAiChatState()';
}




