import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/ai_chat/bloc/ai_chat_event.dart';
import 'package:mobile/features/ai_chat/bloc/ai_chat_state.dart';
import 'package:mobile/features/ai_chat/services/ai_chat_service.dart';

/// BLoC для управления AI чатом
///
/// Обрабатывает все действия пользователя:
/// - Создание и загрузка сессий
/// - Отправка сообщений
/// - Streaming ответы
/// - Анализ дневника
/// - Удаление сессий
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(const AiChatInitial()) {
    on<CreateSessionRequested>(_onCreateSession);
    on<LoadSessionsRequested>(_onLoadSessions);
    on<LoadSessionRequested>(_onLoadSession);
    on<DeleteSessionRequested>(_onDeleteSession);
    on<SendMessageRequested>(_onSendMessage);
    on<SendMessageStreamRequested>(_onSendMessageStream);
    on<StreamingMessageUpdated>(_onStreamingMessageUpdated);
    on<AnalyzeDiaryRequested>(_onAnalyzeDiary);
    on<ResetAiChatState>(_onResetState);
  }

  // ==================== SESSIONS ====================

  /// Создать новую сессию
  Future<void> _onCreateSession(
    CreateSessionRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Создание чата...'));
      
      final session = await AiChatService.createSession(
        context: event.context,
      );
      
      emit(SessionCreated(
        session: session,
        message: 'Новый чат создан',
      ));
      print('✅ AiChatBloc: Сессия создана: ${session.id}');
      
      // Автоматически загружаем сессию
      emit(SessionLoaded(session));
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось создать чат: $e',
        code: 'CREATE_SESSION_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка создания сессии: $e');
    }
  }

  /// Загрузить список сессий
  Future<void> _onLoadSessions(
    LoadSessionsRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Загрузка чатов...'));
      
      final sessions = await AiChatService.getSessions(
        limit: event.limit,
        includeInactive: event.includeInactive,
      );
      
      emit(SessionsLoaded(sessions));
      print('✅ AiChatBloc: Сессии загружены (${sessions.length})');
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось загрузить чаты: $e',
        code: 'LOAD_SESSIONS_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка загрузки сессий: $e');
    }
  }

  /// Загрузить конкретную сессию
  Future<void> _onLoadSession(
    LoadSessionRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Загрузка чата...'));
      
      final session = await AiChatService.getSession(event.sessionId);
      
      emit(SessionLoaded(session));
      print('✅ AiChatBloc: Сессия загружена: ${session.id}');
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось загрузить чат: $e',
        code: 'LOAD_SESSION_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка загрузки сессии: $e');
    }
  }

  /// Удалить сессию
  Future<void> _onDeleteSession(
    DeleteSessionRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Удаление чата...'));
      
      await AiChatService.deleteSession(event.sessionId);
      
      emit(SessionDeleted(
        sessionId: event.sessionId,
        message: 'Чат удален',
      ));
      print('✅ AiChatBloc: Сессия удалена: ${event.sessionId}');
      
      // Перезагрузка списка сессий
      final sessions = await AiChatService.getSessions();
      emit(SessionsLoaded(sessions));
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось удалить чат: $e',
        code: 'DELETE_SESSION_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка удаления сессии: $e');
    }
  }

  // ==================== MESSAGES ====================

  /// Отправить сообщение
  Future<void> _onSendMessage(
    SendMessageRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Отправка сообщения...'));
      
      final aiMessage = await AiChatService.sendMessage(
        sessionId: event.sessionId,
        message: event.message,
        context: event.context,
      );
      
      // Определяем sessionId (может быть создан новый)
      final sessionId = event.sessionId ?? 'new_session';
      
      emit(MessageReceived(
        message: aiMessage,
        sessionId: sessionId,
      ));
      print('✅ AiChatBloc: Сообщение отправлено и получен ответ');
      
      // Перезагружаем сессию для обновления UI
      if (event.sessionId != null) {
        final session = await AiChatService.getSession(event.sessionId!);
        emit(SessionLoaded(session));
      }
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось отправить сообщение: $e',
        code: 'SEND_MESSAGE_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка отправки сообщения: $e');
    }
  }

  /// Отправить сообщение со streaming
  Future<void> _onSendMessageStream(
    SendMessageStreamRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Отправка сообщения...'));
      
      final aiMessage = await AiChatService.sendMessageStream(
        sessionId: event.sessionId,
        message: event.message,
        onChunk: (chunk) {
          // Эмитим промежуточное состояние с чанком
          add(StreamingMessageUpdated(chunk));
        },
      );
      
      emit(MessageReceived(
        message: aiMessage,
        sessionId: event.sessionId,
      ));
      print('✅ AiChatBloc: Streaming сообщение завершено');
      
      // Перезагружаем сессию
      final session = await AiChatService.getSession(event.sessionId);
      emit(SessionLoaded(session));
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось отправить сообщение: $e',
        code: 'SEND_MESSAGE_STREAM_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка streaming сообщения: $e');
    }
  }

  /// Обновление streaming сообщения
  Future<void> _onStreamingMessageUpdated(
    StreamingMessageUpdated event,
    Emitter<AiChatState> emit,
  ) async {
    // Получаем текущий sessionId из предыдущего состояния
    String sessionId = 'unknown';
    if (state is MessageStreaming) {
      sessionId = (state as MessageStreaming).sessionId;
    } else if (state is SessionLoaded) {
      sessionId = (state as SessionLoaded).session.id;
    }

    emit(MessageStreaming(
      content: event.content,
      sessionId: sessionId,
    ));
  }

  // ==================== CONTEXT ACTIONS ====================

  /// Анализ дневника
  Future<void> _onAnalyzeDiary(
    AnalyzeDiaryRequested event,
    Emitter<AiChatState> emit,
  ) async {
    try {
      emit(const AiChatLoading(message: 'Анализ дневника...'));
      
      final session = await AiChatService.analyzeDiary(event.date);
      
      emit(DiaryAnalysisCompleted(
        session: session,
        message: 'Анализ дневника завершен',
      ));
      print('✅ AiChatBloc: Анализ дневника завершен');
      
      // Загружаем сессию
      emit(SessionLoaded(session));
    } catch (e) {
      emit(AiChatError(
        message: 'Не удалось проанализировать дневник: $e',
        code: 'ANALYZE_DIARY_ERROR',
      ));
      print('❌ AiChatBloc: Ошибка анализа дневника: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetAiChatState event,
    Emitter<AiChatState> emit,
  ) async {
    emit(const AiChatInitial());
    print('🔄 AiChatBloc: Состояние сброшено');
  }
}




