import 'package:equatable/equatable.dart';
import 'package:mobile/shared/models/user_model.dart';

/// Состояния SMS/Email авторизации
abstract class SmsAuthState extends Equatable {
  const SmsAuthState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class SmsAuthInitial extends SmsAuthState {
  const SmsAuthInitial();

  @override
  String toString() => 'SmsAuthInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка (отправка кода, проверка и т.д.)
class SmsAuthLoading extends SmsAuthState {
  final String? message;

  const SmsAuthLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'SmsAuthLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ ====================

/// Код успешно отправлен (Email или Phone)
class CodeSentSuccess extends SmsAuthState {
  final String identifier; // Email или Phone
  final String message;
  final bool isEmail; // true = email, false = phone

  const CodeSentSuccess({
    required this.identifier,
    required this.message,
    required this.isEmail,
  });

  @override
  List<Object?> get props => [identifier, message, isEmail];

  @override
  String toString() => 'CodeSentSuccess(identifier: $identifier, isEmail: $isEmail)';
}

/// Код верификации проверен - НОВЫЙ пользователь (требуется пароль)
class CodeVerifiedNewUser extends SmsAuthState {
  final String email;
  final String message;

  const CodeVerifiedNewUser({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];

  @override
  String toString() => 'CodeVerifiedNewUser(email: $email)';
}

/// Код верификации проверен - СУЩЕСТВУЮЩИЙ пользователь (вход выполнен)
class CodeVerifiedExistingUser extends SmsAuthState {
  final User user;
  final String token;
  final String message;

  const CodeVerifiedExistingUser({
    required this.user,
    required this.token,
    required this.message,
  });

  @override
  List<Object?> get props => [user, token, message];

  @override
  String toString() => 'CodeVerifiedExistingUser(user: ${user.email})';
}

/// Пароль установлен успешно (финальная авторизация)
class PasswordSetSuccess extends SmsAuthState {
  final User user;
  final String token;
  final String message;

  const PasswordSetSuccess({
    required this.user,
    required this.token,
    required this.message,
  });

  @override
  List<Object?> get props => [user, token, message];

  @override
  String toString() => 'PasswordSetSuccess(user: ${user.email})';
}

/// Пользователь авторизован
class Authenticated extends SmsAuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'Authenticated(user: ${user.email})';
}

/// Пользователь НЕ авторизован
class Unauthenticated extends SmsAuthState {
  const Unauthenticated();

  @override
  String toString() => 'Unauthenticated';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка авторизации
class SmsAuthError extends SmsAuthState {
  final String message;
  final String? code; // Код ошибки (опционально)

  const SmsAuthError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'SmsAuthError(message: $message, code: $code)';
}

