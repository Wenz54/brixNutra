/// Сервис работы с профилем пользователя
class ProfileService {
  /// Получить профиль пользователя
  static Future<Map<String, dynamic>> getProfile() async {
    // Mock данные
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': '123',
      'name': 'Иван Иванов',
      'email': 'ivan@example.com',
      'phone': '+7 999 123-45-67',
      'subscription': 'premium',
      'subscriptionExpires': '2025-12-31',
    };
  }

  /// Обновить профиль
  static Future<bool> updateProfile({
    String? name,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Сменить email
  static Future<bool> changeEmail(String newEmail) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Сменить пароль
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  /// Удалить аккаунт
  static Future<bool> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}





