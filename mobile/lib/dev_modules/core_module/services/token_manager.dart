import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Менеджер для работы с JWT токенами и данными пользователя
/// 
/// Использует:
/// - `flutter_secure_storage` для JWT токенов (безопасное хранилище)
/// - `shared_preferences` для user metadata (userId, email)
class TokenManager {
  // Keys для хранилища
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  
  // Secure storage для токенов
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  
  // SharedPreferences для metadata
  static SharedPreferences? _prefs;
  
  /// Инициализация TokenManager
  /// 
  /// Должна быть вызвана в main.dart перед runApp()
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    debugPrint('🔐 TokenManager initialized');
  }

  // ==================== ACCESS TOKEN ====================

  /// Сохранить Access Token (JWT)
  /// 
  /// Использует secure storage для безопасного хранения
  static Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    debugPrint('🔑 Access token saved (${token.length} chars)');
  }

  /// Получить Access Token
  /// 
  /// Возвращает JWT токен или null
  static Future<String?> getToken() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (kDebugMode && token != null) {
      debugPrint('🔑 Access token retrieved: ${token.substring(0, 20).replaceAll(RegExp(r'.'), '*')}...');
    }
    return token;
  }

  // ==================== REFRESH TOKEN ====================

  /// Сохранить Refresh Token
  /// 
  /// Для обновления Access Token когда он истечет
  static Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
    debugPrint('🔄 Refresh token saved');
  }

  /// Получить Refresh Token
  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // ==================== USER METADATA ====================

  /// Сохранить данные пользователя
  /// 
  /// [userId] - ID пользователя
  /// [email] - Email
  /// [name] - Имя пользователя
  static Future<void> saveUserData({
    String? userId,
    String? email,
    String? name,
  }) async {
    await init();
    
    if (userId != null) {
      await _prefs!.setString(_userIdKey, userId);
    }
    
    if (email != null) {
      await _prefs!.setString(_userEmailKey, email);
    }
    
    if (name != null) {
      await _prefs!.setString(_userNameKey, name);
    }
    
    debugPrint('👤 User data saved: $email');
  }

  /// Получить User ID
  static Future<String?> getUserId() async {
    await init();
    return _prefs!.getString(_userIdKey);
  }

  /// Получить User Email
  static Future<String?> getUserEmail() async {
    await init();
    return _prefs!.getString(_userEmailKey);
  }

  /// Получить User Name
  static Future<String?> getUserName() async {
    await init();
    return _prefs!.getString(_userNameKey);
  }

  // ==================== AUTH STATE ====================

  /// Проверить, авторизован ли пользователь
  /// 
  /// Проверяет наличие Access Token
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== LOGOUT ====================

  /// Полная очистка данных авторизации
  /// 
  /// Удаляет:
  /// - Access Token (secure storage)
  /// - Refresh Token (secure storage)
  /// - User metadata (shared preferences)
  static Future<void> clearAuth() async {
    await init();
    
    // Удаляем токены из secure storage
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    
    // Удаляем metadata из shared preferences
    await _prefs!.remove(_userIdKey);
    await _prefs!.remove(_userEmailKey);
    await _prefs!.remove(_userNameKey);
    
    debugPrint('🔓 Auth data cleared - user logged out');
  }

  // ==================== FULL AUTH SAVE ====================

  /// Сохранить полные данные авторизации
  /// 
  /// Используется после успешного логина
  /// 
  /// [accessToken] - JWT Access Token
  /// [refreshToken] - JWT Refresh Token (опционально)
  /// [userId] - ID пользователя
  /// [email] - Email пользователя
  /// [name] - Имя пользователя (опционально)
  static Future<void> saveAuth({
    required String accessToken,
    String? refreshToken,
    String? userId,
    String? email,
    String? name,
  }) async {
    // Сохраняем токены
    await saveAccessToken(accessToken);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    
    // Сохраняем user metadata
    await saveUserData(
      userId: userId,
      email: email,
      name: name,
    );
    
    debugPrint('✅ Full auth data saved');
  }
}





