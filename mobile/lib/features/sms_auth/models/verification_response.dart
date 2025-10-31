import 'package:mobile/shared/models/user_model.dart';

/// Ответ при верификации SMS/Email кода
class VerificationResponse {
  final bool success;
  final String message;
  final bool isNewUser;
  final String? token;
  final User? user;

  VerificationResponse({
    required this.success,
    required this.message,
    required this.isNewUser,
    this.token,
    this.user,
  });

  /// Создать из JSON (Backend API response)
  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    return VerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isNewUser: data?['isNewUser'] ?? false,
      token: data?['token'],
      user: data?['user'] != null 
          ? User.fromJson(data!['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'isNewUser': isNewUser,
        'token': token,
        'user': user?.toJson(),
      }
    };
  }

  @override
  String toString() {
    return 'VerificationResponse(success: $success, isNewUser: $isNewUser, hasToken: ${token != null}, hasUser: ${user != null})';
  }
}

/// Ответ при отправке кода
class SendCodeResponse {
  final bool success;
  final String message;

  SendCodeResponse({
    required this.success,
    required this.message,
  });

  /// Создать из JSON
  factory SendCodeResponse.fromJson(Map<String, dynamic> json) {
    return SendCodeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'SendCodeResponse(success: $success, message: $message)';
  }
}

/// Ответ при установке пароля
class SetPasswordResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;

  SetPasswordResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  /// Создать из JSON
  factory SetPasswordResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    return SetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data?['token'],
      user: data?['user'] != null 
          ? User.fromJson(data!['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Конвертировать в JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'token': token,
        'user': user?.toJson(),
      }
    };
  }

  @override
  String toString() {
    return 'SetPasswordResponse(success: $success, hasToken: ${token != null})';
  }
}

