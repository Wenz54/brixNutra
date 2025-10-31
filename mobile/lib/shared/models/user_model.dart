import 'package:equatable/equatable.dart';

/// Модель пользователя
class User extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String? name;
  final String? avatar;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.phone,
    this.name,
    this.avatar,
    required this.createdAt,
  });

  /// Создать User из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['user_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      name: json['name'],
      avatar: json['avatar'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// Преобразовать User в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, email, phone, name, avatar, createdAt];

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}




