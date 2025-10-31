/// API Configuration для Brix Nutrition App
/// 
/// Настройки подключения к бэкенду
class ApiConfig {
  /// Базовый URL бэкенда
  /// 
  /// Для Android эмулятора: http://10.0.2.2:3002/api
  /// Для iOS симулятора: http://localhost:3002/api
  /// Для физического устройства: http://YOUR_IP:3002/api
  /// 
  /// Для продакшена измените на:
  /// - 'https://api.brix-nutrition.com/api'
  static const String baseUrl = 'http://10.0.2.2:3002/api';
  
  /// Timeout для подключения (в секундах)
  static const int connectTimeout = 10;
  
  /// Timeout для получения ответа (в секундах)
  static const int receiveTimeout = 10;
  
  /// Заголовки по умолчанию
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  /// Эндпоинты API для Brix Nutrition
  static const String authEndpoint = '/auth';
  static const String profileEndpoint = '/profile';
  static const String recipesEndpoint = '/recipes';
  static const String mealPlanEndpoint = '/meal-plan';
  static const String diaryEndpoint = '/diary';
  static const String knowledgeEndpoint = '/knowledge';
  static const String aiChatEndpoint = '/ai-chat';
  static const String labTestsEndpoint = '/lab-tests';
  static const String blogEndpoint = '/blog';
  static const String notificationsEndpoint = '/notifications';
  static const String filesEndpoint = '/files';
  static const String subscriptionsEndpoint = '/subscriptions';
}





