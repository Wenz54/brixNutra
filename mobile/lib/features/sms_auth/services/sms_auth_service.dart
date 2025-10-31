import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/dev_modules/core_module/services/token_manager.dart';
import 'package:mobile/features/sms_auth/models/verification_response.dart';
import 'package:mobile/shared/models/user_model.dart';

/// Сервис SMS/Email авторизации для Brix Nutrition
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class SmsAuthService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = true; // TODO: Изменить на false когда backend готов
  
  // Mock данные для тестирования
  static final Map<String, String> _mockCodes = {
    'test@example.com': '1234',
    '+79991234567': '1234',
  };

  // ==================== EMAIL АВТОРИЗАЦИЯ ====================

  /// Отправить код верификации на Email
  ///
  /// [email] - Email адрес пользователя
  ///
  /// Возвращает [SendCodeResponse] с результатом
  static Future<SendCodeResponse> sendCodeToEmail(String email) async {
    try {
      if (useMockMode) {
        return _mockSendCodeToEmail(email);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.authEmailSendCode,
        {'email': email},
      );

      return SendCodeResponse.fromJson(response);
    } catch (e) {
      print('❌ sendCodeToEmail error: $e');
      rethrow;
    }
  }

  /// Проверить Email код верификации
  ///
  /// [email] - Email адрес
  /// [code] - 4-значный код из email
  ///
  /// Возвращает [VerificationResponse] с токеном и данными пользователя
  static Future<VerificationResponse> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      if (useMockMode) {
        return _mockVerifyEmailCode(email: email, code: code);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.authEmailVerifyCode,
        {
          'email': email,
          'code': code,
        },
      );

      final verificationResponse = VerificationResponse.fromJson(response);

      // Если успешно и есть токен - сохраняем авторизацию
      if (verificationResponse.success && verificationResponse.token != null) {
        await _saveAuth(verificationResponse);
      }

      return verificationResponse;
    } catch (e) {
      print('❌ verifyEmailCode error: $e');
      rethrow;
    }
  }

  /// Установить пароль для нового Email пользователя
  ///
  /// [email] - Email адрес
  /// [password] - Новый пароль
  ///
  /// Возвращает [SetPasswordResponse] с токеном
  static Future<SetPasswordResponse> setPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (useMockMode) {
        return _mockSetPassword(email: email, password: password);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.authEmailSetPassword,
        {
          'email': email,
          'password': password,
        },
      );

      final setPasswordResponse = SetPasswordResponse.fromJson(response);

      // Если успешно и есть токен - обновляем сохраненную авторизацию
      if (setPasswordResponse.success && setPasswordResponse.token != null) {
        await TokenManager.saveAccessToken(setPasswordResponse.token!);
      }

      return setPasswordResponse;
    } catch (e) {
      print('❌ setPassword error: $e');
      rethrow;
    }
  }

  // ==================== PHONE АВТОРИЗАЦИЯ ====================

  /// Отправить SMS код на телефон
  ///
  /// [phone] - Номер телефона (формат: +79991234567)
  ///
  /// Возвращает [SendCodeResponse] с результатом
  static Future<SendCodeResponse> sendCodeToPhone(String phone) async {
    try {
      if (useMockMode) {
        return _mockSendCodeToPhone(phone);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.authPhoneSendCode,
        {'phone': phone},
      );

      return SendCodeResponse.fromJson(response);
    } catch (e) {
      print('❌ sendCodeToPhone error: $e');
      rethrow;
    }
  }

  /// Проверить SMS код верификации
  ///
  /// [phone] - Номер телефона
  /// [code] - 4-значный SMS код
  ///
  /// Возвращает [VerificationResponse] с токеном и данными пользователя
  static Future<VerificationResponse> verifyPhoneCode({
    required String phone,
    required String code,
  }) async {
    try {
      if (useMockMode) {
        return _mockVerifyPhoneCode(phone: phone, code: code);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.authPhoneVerifyCode,
        {
          'phone': phone,
          'code': code,
        },
      );

      final verificationResponse = VerificationResponse.fromJson(response);

      // Если успешно и есть токен - сохраняем авторизацию
      if (verificationResponse.success && verificationResponse.token != null) {
        await _saveAuth(verificationResponse);
      }

      return verificationResponse;
    } catch (e) {
      print('❌ verifyPhoneCode error: $e');
      rethrow;
    }
  }

  // ==================== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ====================

  /// Сохранить данные авторизации после успешной верификации
  static Future<void> _saveAuth(VerificationResponse response) async {
    if (response.token != null && response.user != null) {
      await TokenManager.saveAuth(
        accessToken: response.token!,
        userId: response.user!.id,
        email: response.user!.email,
        name: response.user!.name,
      );
      print('✅ Auth saved: userId=${response.user!.id}, email=${response.user!.email}');
    }
  }

  /// Проверить авторизован ли пользователь
  static Future<bool> isAuthenticated() async {
    return await TokenManager.isAuthenticated();
  }

  /// Выйти из системы (очистить токены)
  static Future<void> logout() async {
    await TokenManager.clearAuth();
    print('✅ Logged out successfully');
  }

  // ==================== MOCK МЕТОДЫ (ДЛЯ РАЗРАБОТКИ) ====================

  static Future<SendCodeResponse> _mockSendCodeToEmail(String email) async {
    print('🎭 MOCK: Отправка кода на email: $email');
    await Future.delayed(const Duration(seconds: 1)); // Имитация сетевой задержки

    _mockCodes[email] = '1234'; // Сохраняем мок-код
    print('✅ КОД ДЛЯ $email: 1234'); // 👈 Вывод кода в логи

    return SendCodeResponse(
      success: true,
      message: 'Код отправлен на $email',
    );
  }

  static Future<SendCodeResponse> _mockSendCodeToPhone(String phone) async {
    print('🎭 MOCK: Отправка SMS на телефон: $phone');
    await Future.delayed(const Duration(seconds: 1));

    _mockCodes[phone] = '1234'; // Сохраняем мок-код
    print('✅ КОД ДЛЯ $phone: 1234'); // 👈 Вывод кода в логи

    return SendCodeResponse(
      success: true,
      message: 'SMS отправлено на $phone',
    );
  }

  static Future<VerificationResponse> _mockVerifyEmailCode({
    required String email,
    required String code,
  }) async {
    print('🎭 MOCK: Проверка Email кода: $email, код: $code');
    await Future.delayed(const Duration(milliseconds: 800));

    // Проверка кода
    final savedCode = _mockCodes[email];
    if (savedCode == null || savedCode != code) {
      throw Exception('Неверный код');
    }

    // Определяем новый ли это пользователь (для демо - случайно)
    final isNewUser = email.contains('new') || DateTime.now().second % 2 == 0;

    final mockToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    final mockUser = User(
      id: 'user_${email.hashCode}',
      email: email,
      name: 'Пользователь ${email.split('@')[0]}',
      createdAt: DateTime.now(),
    );

    return VerificationResponse(
      success: true,
      message: isNewUser 
          ? 'Email подтвержден. Пожалуйста, создайте пароль.'
          : 'Вход выполнен успешно!',
      isNewUser: isNewUser,
      token: mockToken,
      user: mockUser,
    );
  }

  static Future<VerificationResponse> _mockVerifyPhoneCode({
    required String phone,
    required String code,
  }) async {
    print('🎭 MOCK: Проверка Phone кода: $phone, код: $code');
    await Future.delayed(const Duration(milliseconds: 800));

    // Проверка кода
    final savedCode = _mockCodes[phone];
    if (savedCode == null || savedCode != code) {
      throw Exception('Неверный код');
    }

    // Phone пользователи всегда без пароля (isNewUser не важен)
    final mockToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    final mockUser = User(
      id: 'user_${phone.hashCode}',
      email: '', // У phone-пользователя может не быть email
      name: 'Пользователь ${phone.substring(phone.length - 4)}',
      createdAt: DateTime.now(),
    );

    return VerificationResponse(
      success: true,
      message: 'Вход выполнен успешно!',
      isNewUser: false, // Phone не требует пароля
      token: mockToken,
      user: mockUser,
    );
  }

  static Future<SetPasswordResponse> _mockSetPassword({
    required String email,
    required String password,
  }) async {
    print('🎭 MOCK: Установка пароля для: $email');
    await Future.delayed(const Duration(seconds: 1));

    // Валидация пароля
    if (password.length < 8) {
      throw Exception('Пароль должен содержать минимум 8 символов');
    }

    final mockToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    final mockUser = User(
      id: 'user_${email.hashCode}',
      email: email,
      name: 'Пользователь ${email.split('@')[0]}',
      createdAt: DateTime.now(),
    );

    return SetPasswordResponse(
      success: true,
      message: 'Пароль установлен. Добро пожаловать!',
      token: mockToken,
      user: mockUser,
    );
  }
}

