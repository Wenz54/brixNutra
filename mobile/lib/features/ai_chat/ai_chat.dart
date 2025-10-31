/// AI Chat Feature
///
/// Модуль для работы с AI нутрициологом
///
/// Включает:
/// - Models: ChatSession, ChatMessage, MessageRole, AiChatContext
/// - Service: AiChatService (Mock + Real API)
/// - BLoC: AiChatBloc, AiChatEvent, AiChatState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/ai_chat/ai_chat.dart';
///
/// // В BlocProvider
/// BlocProvider<AiChatBloc>(
///   create: (context) => AiChatBloc()
///     ..add(LoadSessionsRequested()),
///   child: MyWidget(),
/// )
///
/// // Отправить сообщение
/// context.read<AiChatBloc>().add(SendMessageRequested(
///   sessionId: 'session_123',
///   message: 'Сколько белка нужно в день?',
/// ));
///
/// // Анализ дневника
/// context.read<AiChatBloc>().add(
///   AnalyzeDiaryRequested(DateTime.now()),
/// );
/// ```
library;

export 'models/ai_chat_models.dart';
export 'services/ai_chat_service.dart';
export 'bloc/ai_chat_bloc.dart';
export 'bloc/ai_chat_event.dart';
export 'bloc/ai_chat_state.dart';




