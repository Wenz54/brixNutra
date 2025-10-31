import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/sms_auth/bloc/sms_auth_event.dart';
import 'package:mobile/features/sms_auth/bloc/sms_auth_state.dart';
import 'package:mobile/features/sms_auth/services/sms_auth_service.dart';

/// BLoC для управления SMS/Email авторизацией
///
/// Обрабатывает все события авторизации и управляет состоянием.
/// Использует [SmsAuthService] для взаимодействия с API.
class SmsAuthBloc extends Bloc<SmsAuthEvent, SmsAuthState> {
  SmsAuthBloc() : super(const SmsAuthInitial()) {
    // Регистрация обработчиков событий
    on<SendCodeToEmailRequested>(_onSendCodeToEmail);
    on<SendCodeToPhoneRequested>(_onSendCodeToPhone);
    on<VerifyEmailCodeRequested>(_onVerifyEmailCode);
    on<VerifyPhoneCodeRequested>(_onVerifyPhoneCode);
    on<SetPasswordRequested>(_onSetPassword);
    on<LogoutRequested>(_onLogout);
    on<ResetAuthState>(_onResetAuthState);
  }

  // ==================== EMAIL HANDLERS ====================

  /// Обработка отправки кода на Email
  Future<void> _onSendCodeToEmail(
    SendCodeToEmailRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      emit(const SmsAuthLoading(message: 'Отправка кода на Email...'));

      final response = await SmsAuthService.sendCodeToEmail(event.email);

      if (response.success) {
        emit(CodeSentSuccess(
          identifier: event.email,
          message: response.message,
          isEmail: true,
        ));
        print('✅ Код отправлен на email: ${event.email}');
      } else {
        emit(SmsAuthError(message: response.message));
        print('❌ Ошибка отправки кода: ${response.message}');
      }
    } catch (e) {
      emit(SmsAuthError(message: 'Не удалось отправить код: $e'));
      print('❌ Exception при отправке email кода: $e');
    }
  }

  /// Обработка проверки Email кода
  Future<void> _onVerifyEmailCode(
    VerifyEmailCodeRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      emit(const SmsAuthLoading(message: 'Проверка кода...'));

      final response = await SmsAuthService.verifyEmailCode(
        email: event.email,
        code: event.code,
      );

      if (response.success) {
        if (response.isNewUser) {
          // Новый пользователь - требуется пароль
          emit(CodeVerifiedNewUser(
            email: event.email,
            message: response.message,
          ));
          print('✅ Новый Email пользователь: ${event.email}');
        } else {
          // Существующий пользователь - вход выполнен
          if (response.user != null && response.token != null) {
            emit(CodeVerifiedExistingUser(
              user: response.user!,
              token: response.token!,
              message: response.message,
            ));
            print('✅ Email вход выполнен: ${response.user!.email}');
          } else {
            emit(const SmsAuthError(message: 'Ошибка получения данных пользователя'));
          }
        }
      } else {
        emit(SmsAuthError(message: response.message));
        print('❌ Ошибка проверки кода: ${response.message}');
      }
    } catch (e) {
      emit(SmsAuthError(message: 'Неверный код или ошибка проверки'));
      print('❌ Exception при проверке email кода: $e');
    }
  }

  /// Обработка установки пароля
  Future<void> _onSetPassword(
    SetPasswordRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      emit(const SmsAuthLoading(message: 'Создание пароля...'));

      final response = await SmsAuthService.setPassword(
        email: event.email,
        password: event.password,
      );

      if (response.success) {
        if (response.user != null && response.token != null) {
          emit(PasswordSetSuccess(
            user: response.user!,
            token: response.token!,
            message: response.message,
          ));
          print('✅ Пароль установлен для: ${event.email}');
        } else {
          emit(const SmsAuthError(message: 'Ошибка установки пароля'));
        }
      } else {
        emit(SmsAuthError(message: response.message));
        print('❌ Ошибка установки пароля: ${response.message}');
      }
    } catch (e) {
      emit(SmsAuthError(message: 'Не удалось установить пароль: $e'));
      print('❌ Exception при установке пароля: $e');
    }
  }

  // ==================== PHONE HANDLERS ====================

  /// Обработка отправки SMS кода на телефон
  Future<void> _onSendCodeToPhone(
    SendCodeToPhoneRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      emit(const SmsAuthLoading(message: 'Отправка SMS...'));

      final response = await SmsAuthService.sendCodeToPhone(event.phone);

      if (response.success) {
        emit(CodeSentSuccess(
          identifier: event.phone,
          message: response.message,
          isEmail: false,
        ));
        print('✅ SMS отправлено на: ${event.phone}');
      } else {
        emit(SmsAuthError(message: response.message));
        print('❌ Ошибка отправки SMS: ${response.message}');
      }
    } catch (e) {
      emit(SmsAuthError(message: 'Не удалось отправить SMS: $e'));
      print('❌ Exception при отправке SMS: $e');
    }
  }

  /// Обработка проверки Phone SMS кода
  Future<void> _onVerifyPhoneCode(
    VerifyPhoneCodeRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      emit(const SmsAuthLoading(message: 'Проверка кода...'));

      final response = await SmsAuthService.verifyPhoneCode(
        phone: event.phone,
        code: event.code,
      );

      if (response.success) {
        // Phone авторизация не требует пароля - сразу вход
        if (response.user != null && response.token != null) {
          emit(CodeVerifiedExistingUser(
            user: response.user!,
            token: response.token!,
            message: response.message,
          ));
          print('✅ Phone вход выполнен: ${event.phone}');
        } else {
          emit(const SmsAuthError(message: 'Ошибка получения данных пользователя'));
        }
      } else {
        emit(SmsAuthError(message: response.message));
        print('❌ Ошибка проверки SMS кода: ${response.message}');
      }
    } catch (e) {
      emit(SmsAuthError(message: 'Неверный код или ошибка проверки'));
      print('❌ Exception при проверке phone кода: $e');
    }
  }

  // ==================== ОБЩИЕ HANDLERS ====================

  /// Обработка выхода из системы
  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<SmsAuthState> emit,
  ) async {
    try {
      await SmsAuthService.logout();
      emit(const Unauthenticated());
      print('✅ Logout успешен');
    } catch (e) {
      emit(SmsAuthError(message: 'Ошибка выхода: $e'));
      print('❌ Exception при logout: $e');
    }
  }

  /// Сброс состояния на начальное
  Future<void> _onResetAuthState(
    ResetAuthState event,
    Emitter<SmsAuthState> emit,
  ) async {
    emit(const SmsAuthInitial());
    print('🔄 Auth state reset');
  }
}




