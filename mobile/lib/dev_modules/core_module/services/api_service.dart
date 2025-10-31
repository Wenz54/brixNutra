import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_manager.dart';
import '../config/api_config.dart';

/// Сервис для работы с API Brix Nutrition
/// 
/// Предоставляет методы для HTTP запросов с автоматическим:
/// - Добавлением JWT токена
/// - Логированием запросов/ответов
/// - Обработкой ошибок
class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: ApiConfig.connectTimeout),
    receiveTimeout: Duration(seconds: ApiConfig.receiveTimeout),
    headers: ApiConfig.defaultHeaders,
  ));

  /// Инициализация interceptors
  /// 
  /// Должна быть вызвана при запуске приложения (в main.dart)
  static void initializeInterceptors() {
    _dio.interceptors.clear();
    
    // 1. Token Interceptor - добавляет JWT Bearer token
    _dio.interceptors.add(_tokenInterceptor());
    
    // 2. Log Interceptor - логирование запросов (только в debug режиме)
    if (kDebugMode) {
      _dio.interceptors.add(_logInterceptor());
    }
    
    // 3. Error Interceptor - обработка ошибок
    _dio.interceptors.add(_errorInterceptor());
  }

  /// Token Interceptor - автоматическое добавление Bearer token
  static InterceptorsWrapper _tokenInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Исключаем auth endpoints (они не требуют токена)
        final isAuthEndpoint = options.path.contains('/auth/email/send-code') ||
            options.path.contains('/auth/email/verify-code') ||
            options.path.contains('/auth/phone/send-code') ||
            options.path.contains('/auth/phone/verify-code');
        
        if (!isAuthEndpoint) {
          final token = await TokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        
        handler.next(options);
      },
    );
  }

  /// Log Interceptor - детальное логирование (только debug)
  static InterceptorsWrapper _logInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('┌─────── DIO REQUEST ───────');
        debugPrint('│ ${options.method} ${options.uri}');
        debugPrint('│ Headers: ${options.headers}');
        if (options.data != null) {
          debugPrint('│ Body: ${options.data}');
        }
        if (options.queryParameters.isNotEmpty) {
          debugPrint('│ Query: ${options.queryParameters}');
        }
        debugPrint('└───────────────────────────');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('┌─────── DIO RESPONSE ──────');
        debugPrint('│ ${response.statusCode} ${response.requestOptions.uri}');
        debugPrint('│ Data: ${response.data}');
        debugPrint('└───────────────────────────');
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('┌─────── DIO ERROR ─────────');
        debugPrint('│ ${error.requestOptions.method} ${error.requestOptions.uri}');
        debugPrint('│ Status: ${error.response?.statusCode}');
        debugPrint('│ Message: ${error.message}');
        debugPrint('│ Response: ${error.response?.data}');
        debugPrint('└───────────────────────────');
        handler.next(error);
      },
    );
  }

  /// Error Interceptor - обработка HTTP ошибок
  static InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;
        
        // 401 Unauthorized - невалидный/истекший токен
        if (statusCode == 401) {
          debugPrint('🔐 Token expired or invalid - logging out');
          await TokenManager.clearAuth();
          // TODO: Navigate to login screen
        }
        
        // 403 Forbidden - нет прав доступа
        if (statusCode == 403) {
          debugPrint('⛔ Access forbidden');
        }
        
        // 404 Not Found
        if (statusCode == 404) {
          debugPrint('❌ Resource not found');
        }
        
        // 500 Server Error
        if (statusCode != null && statusCode >= 500) {
          debugPrint('💥 Server error: $statusCode');
        }
        
        handler.next(error);
      },
    );
  }
  
  // ==================== HTTP METHODS ====================

  /// GET запрос
  /// 
  /// [endpoint] - путь к эндпоинту
  /// [queryParameters] - query параметры (опционально)
  /// 
  /// Пример: `get('/recipes', {'meal_type': 'breakfast', 'limit': '10'})`
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST запрос
  /// 
  /// [endpoint] - путь к эндпоинту
  /// [data] - данные для отправки
  /// 
  /// Пример: `post('/auth/login', {'email': 'user@example.com', 'password': '123'})`
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT запрос
  /// 
  /// [endpoint] - путь к эндпоинту
  /// [data] - данные для обновления
  /// 
  /// Пример: `put('/profile/update', {'name': 'John Doe'})`
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH запрос
  /// 
  /// [endpoint] - путь к эндпоинту
  /// [data] - данные для частичного обновления
  /// 
  /// Пример: `patch('/diary/mood', {'date': '2025-10-13', 'rating': 4})`
  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE запрос
  /// 
  /// [endpoint] - путь к эндпоинту
  /// 
  /// Пример: `delete('/diary/meal/123')`
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== HELPER METHODS ====================

  /// Обработка успешного ответа
  static Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // Если data это уже Map - возвращаем как есть
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      // Если data это List или другой тип - оборачиваем
      return {'data': response.data};
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
    }
  }

  /// Обработка ошибок
  static Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Exception('Connection timeout - проверьте интернет соединение');
        case DioExceptionType.sendTimeout:
          return Exception('Send timeout - запрос занял слишком много времени');
        case DioExceptionType.receiveTimeout:
          return Exception('Receive timeout - сервер не отвечает');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 
                         error.response?.data?['error'] ?? 
                         error.response?.statusMessage ?? 
                         'Unknown error';
          return Exception('HTTP $statusCode: $message');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.connectionError:
          return Exception('Connection error - проверьте что backend запущен на localhost:3000');
        case DioExceptionType.badCertificate:
          return Exception('Bad certificate - SSL error');
        case DioExceptionType.unknown:
          return Exception('Unknown error: ${error.message}');
      }
    }
    
    return Exception(error.toString());
  }
}





