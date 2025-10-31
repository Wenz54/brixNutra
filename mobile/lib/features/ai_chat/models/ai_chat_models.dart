import 'package:equatable/equatable.dart';

// ==================== MESSAGE ROLE ====================

/// Роль отправителя сообщения
enum MessageRole {
  user,      // Пользователь
  assistant, // AI ассистент
  system,    // Системное сообщение
}

extension MessageRoleExtension on MessageRole {
  String get name {
    switch (this) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }

  static MessageRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }
}

// ==================== CHAT MESSAGE ====================

/// Сообщение в чате
class ChatMessage extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isStreaming; // Сообщение еще печатается (streaming)
  final Map<String, dynamic>? metadata; // Доп. данные (например, анализ дневника)

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isStreaming = false,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      role: MessageRoleExtension.fromString(json['role'] ?? 'user'),
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isStreaming: json['is_streaming'] ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_streaming': isStreaming,
      'metadata': metadata,
    };
  }

  /// Создать копию с изменениями
  ChatMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    bool? isStreaming,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Является ли сообщением пользователя
  bool get isUser => role == MessageRole.user;

  /// Является ли сообщением AI
  bool get isAssistant => role == MessageRole.assistant;

  /// Является ли системным сообщением
  bool get isSystem => role == MessageRole.system;

  @override
  List<Object?> get props => [
        id,
        role,
        content,
        timestamp,
        isStreaming,
        metadata,
      ];

  @override
  String toString() =>
      'ChatMessage(${role.name}: ${content.length > 50 ? content.substring(0, 50) + "..." : content})';
}

// ==================== CHAT SESSION ====================

/// Сессия чата (диалог с AI)
class ChatSession extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;
  final bool isActive;
  final String? contextType; // 'diary_analysis', 'meal_plan', 'general', etc.
  final Map<String, dynamic>? contextData; // Данные контекста

  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    this.isActive = true,
    this.contextType,
    this.contextData,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Новый чат',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      messages: (json['messages'] as List?)
              ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['is_active'] ?? true,
      contextType: json['context_type'],
      contextData: json['context_data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'is_active': isActive,
      'context_type': contextType,
      'context_data': contextData,
    };
  }

  /// Создать копию с изменениями
  ChatSession copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMessage>? messages,
    bool? isActive,
    String? contextType,
    Map<String, dynamic>? contextData,
  }) {
    return ChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      isActive: isActive ?? this.isActive,
      contextType: contextType ?? this.contextType,
      contextData: contextData ?? this.contextData,
    );
  }

  /// Получить последнее сообщение
  ChatMessage? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Получить превью последнего сообщения
  String get lastMessagePreview {
    if (messages.isEmpty) return 'Нет сообщений';
    final content = messages.last.content;
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  /// Количество сообщений
  int get messagesCount => messages.length;

  /// Есть ли сообщения
  bool get hasMessages => messages.isNotEmpty;

  /// Получить сообщения пользователя
  List<ChatMessage> get userMessages {
    return messages.where((m) => m.isUser).toList();
  }

  /// Получить сообщения AI
  List<ChatMessage> get assistantMessages {
    return messages.where((m) => m.isAssistant).toList();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        updatedAt,
        messages,
        isActive,
        contextType,
        contextData,
      ];

  @override
  String toString() =>
      'ChatSession($title, ${messages.length} сообщений, updated: $updatedAt)';
}

// ==================== CHAT SESSION PREVIEW ====================

/// Краткая информация о сессии (для списка)
class ChatSessionPreview extends Equatable {
  final String id;
  final String title;
  final DateTime updatedAt;
  final String lastMessagePreview;
  final int messagesCount;
  final bool isActive;

  const ChatSessionPreview({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.lastMessagePreview,
    required this.messagesCount,
    this.isActive = true,
  });

  factory ChatSessionPreview.fromJson(Map<String, dynamic> json) {
    return ChatSessionPreview(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Новый чат',
      updatedAt: DateTime.parse(json['updated_at']),
      lastMessagePreview: json['last_message_preview'] ?? '',
      messagesCount: json['messages_count'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'updated_at': updatedAt.toIso8601String(),
      'last_message_preview': lastMessagePreview,
      'messages_count': messagesCount,
      'is_active': isActive,
    };
  }

  /// Получить дату в читаемом формате
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inMinutes < 1) {
      return 'Только что';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} мин назад';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} дн назад';
    } else {
      return '${updatedAt.day}.${updatedAt.month}.${updatedAt.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        updatedAt,
        lastMessagePreview,
        messagesCount,
        isActive,
      ];

  @override
  String toString() => 'ChatSessionPreview($title, $messagesCount сообщений)';
}

// ==================== AI CHAT CONTEXT ====================

/// Контекст для AI чата
class AiChatContext extends Equatable {
  final String type; // 'diary_analysis', 'meal_plan', 'lab_tests', 'general'
  final Map<String, dynamic> data;

  const AiChatContext({
    required this.type,
    required this.data,
  });

  factory AiChatContext.fromJson(Map<String, dynamic> json) {
    return AiChatContext(
      type: json['type'] ?? 'general',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }

  /// Общий чат (без контекста)
  factory AiChatContext.general() {
    return const AiChatContext(
      type: 'general',
      data: {},
    );
  }

  /// Анализ дневника
  factory AiChatContext.diaryAnalysis({
    required DateTime date,
    required Map<String, dynamic> diaryData,
  }) {
    return AiChatContext(
      type: 'diary_analysis',
      data: {
        'date': date.toIso8601String(),
        'diary_data': diaryData,
      },
    );
  }

  /// План питания
  factory AiChatContext.mealPlan({
    required String planId,
    required Map<String, dynamic> planData,
  }) {
    return AiChatContext(
      type: 'meal_plan',
      data: {
        'plan_id': planId,
        'plan_data': planData,
      },
    );
  }

  /// Анализы
  factory AiChatContext.labTests({
    required String testId,
    required Map<String, dynamic> testData,
  }) {
    return AiChatContext(
      type: 'lab_tests',
      data: {
        'test_id': testId,
        'test_data': testData,
      },
    );
  }

  @override
  List<Object?> get props => [type, data];

  @override
  String toString() => 'AiChatContext($type)';
}




