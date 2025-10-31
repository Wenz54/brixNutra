import 'package:equatable/equatable.dart';

/// События для SMS/Email авторизации
abstract class SmsAuthEvent extends Equatable {
  const SmsAuthEvent();

  @override
  List<Object?> get props => [];
}

// ==================== EMAIL СОБЫТИЯ ====================

/// Отправить код верификации на Email
class SendCodeToEmailRequested extends SmsAuthEvent {
  final String email;

  const SendCodeToEmailRequested(this.email);

  @override
  List<Object?> get props => [email];

  @override
  String toString() => 'SendCodeToEmailRequested(email: $email)';
}

/// Проверить Email код верификации
class VerifyEmailCodeRequested extends SmsAuthEvent {
  final String email;
  final String code;

  const VerifyEmailCodeRequested({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];

  @override
  String toString() => 'VerifyEmailCodeRequested(email: $email, code: $code)';
}

/// Установить пароль для нового Email пользователя
class SetPasswordRequested extends SmsAuthEvent {
  final String email;
  final String password;

  const SetPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() => 'SetPasswordRequested(email: $email)';
}

// ==================== PHONE СОБЫТИЯ ====================

/// Отправить SMS код на телефон
class SendCodeToPhoneRequested extends SmsAuthEvent {
  final String phone;

  const SendCodeToPhoneRequested(this.phone);

  @override
  List<Object?> get props => [phone];

  @override
  String toString() => 'SendCodeToPhoneRequested(phone: $phone)';
}

/// Проверить Phone SMS код
class VerifyPhoneCodeRequested extends SmsAuthEvent {
  final String phone;
  final String code;

  const VerifyPhoneCodeRequested({
    required this.phone,
    required this.code,
  });

  @override
  List<Object?> get props => [phone, code];

  @override
  String toString() => 'VerifyPhoneCodeRequested(phone: $phone, code: $code)';
}

// ==================== ОБЩИЕ СОБЫТИЯ ====================

/// Выйти из системы
class LogoutRequested extends SmsAuthEvent {
  const LogoutRequested();

  @override
  String toString() => 'LogoutRequested()';
}

/// Сбросить состояние
class ResetAuthState extends SmsAuthEvent {
  const ResetAuthState();

  @override
  String toString() => 'ResetAuthState()';
}




