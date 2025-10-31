import 'package:equatable/equatable.dart';

// ==================== SUBSCRIPTION PLAN ====================

/// План подписки
class SubscriptionPlan extends Equatable {
  final String id;
  final String name;              // Название плана
  final String? description;      // Описание
  final double priceMonthly;      // Цена в месяц
  final double? priceYearly;      // Цена в год (опционально)
  final String currency;          // Валюта (RUB, USD, EUR)
  final List<String> features;    // Список возможностей
  final bool isPopular;           // Популярный тариф?
  final int? trialDays;           // Пробный период (дни)

  const SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.priceMonthly,
    this.priceYearly,
    this.currency = 'RUB',
    required this.features,
    this.isPopular = false,
    this.trialDays,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      priceMonthly: (json['price_monthly'] as num?)?.toDouble() ?? 0.0,
      priceYearly: (json['price_yearly'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'RUB',
      features: (json['features'] as List?)?.map((f) => f.toString()).toList() ?? [],
      isPopular: json['is_popular'] ?? false,
      trialDays: json['trial_days'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_monthly': priceMonthly,
      'price_yearly': priceYearly,
      'currency': currency,
      'features': features,
      'is_popular': isPopular,
      'trial_days': trialDays,
    };
  }

  /// Экономия при годовой подписке (%)
  double? get yearlySavingsPercent {
    if (priceYearly == null) return null;
    final monthlyTotal = priceMonthly * 12;
    if (monthlyTotal == 0) return null;
    return ((monthlyTotal - priceYearly!) / monthlyTotal) * 100;
  }

  /// Цена в месяц при годовой подписке
  double? get yearlyMonthlyPrice {
    if (priceYearly == null) return null;
    return priceYearly! / 12;
  }

  /// Форматированная цена (месяц)
  String get formattedPriceMonthly {
    return '${priceMonthly.toStringAsFixed(0)} $currency';
  }

  /// Форматированная цена (год)
  String? get formattedPriceYearly {
    if (priceYearly == null) return null;
    return '${priceYearly!.toStringAsFixed(0)} $currency';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        priceMonthly,
        priceYearly,
        currency,
        features,
        isPopular,
        trialDays,
      ];

  @override
  String toString() => 'SubscriptionPlan($name, $priceMonthly $currency/мес)';
}

// ==================== USER SUBSCRIPTION ====================

/// Подписка пользователя
class UserSubscription extends Equatable {
  final String id;
  final String planId;
  final String planName;
  final String status;            // 'active', 'expired', 'cancelled', 'trial'
  final DateTime startDate;
  final DateTime? endDate;        // Дата окончания
  final DateTime? trialEndDate;   // Дата окончания пробного периода
  final bool autoRenew;           // Автопродление
  final String? paymentMethod;    // Способ оплаты

  const UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.status,
    required this.startDate,
    this.endDate,
    this.trialEndDate,
    this.autoRenew = true,
    this.paymentMethod,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id']?.toString() ?? '',
      planId: json['plan_id']?.toString() ?? '',
      planName: json['plan_name'] ?? '',
      status: json['status'] ?? 'expired',
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      trialEndDate: json['trial_end_date'] != null ? DateTime.parse(json['trial_end_date']) : null,
      autoRenew: json['auto_renew'] ?? true,
      paymentMethod: json['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_name': planName,
      'status': status,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'trial_end_date': trialEndDate?.toIso8601String(),
      'auto_renew': autoRenew,
      'payment_method': paymentMethod,
    };
  }

  /// Активна ли подписка
  bool get isActive => status == 'active' || status == 'trial';

  /// Истекла ли подписка
  bool get isExpired => status == 'expired';

  /// Отменена ли подписка
  bool get isCancelled => status == 'cancelled';

  /// Пробный период?
  bool get isTrial => status == 'trial';

  /// Дней до окончания
  int? get daysUntilExpiry {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (endDate!.isBefore(now)) return 0;
    return endDate!.difference(now).inDays;
  }

  /// Истекает скоро? (менее 7 дней)
  bool get expiringsSoon {
    final days = daysUntilExpiry;
    return days != null && days > 0 && days <= 7;
  }

  /// Статус в читаемом формате
  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Активна';
      case 'trial':
        return 'Пробный период';
      case 'expired':
        return 'Истекла';
      case 'cancelled':
        return 'Отменена';
      default:
        return 'Неизвестно';
    }
  }

  /// Emoji статуса
  String get statusEmoji {
    switch (status) {
      case 'active':
        return '✅';
      case 'trial':
        return '⏰';
      case 'expired':
        return '❌';
      case 'cancelled':
        return '⛔';
      default:
        return '❓';
    }
  }

  @override
  List<Object?> get props => [
        id,
        planId,
        planName,
        status,
        startDate,
        endDate,
        trialEndDate,
        autoRenew,
        paymentMethod,
      ];

  @override
  String toString() => 'UserSubscription($planName, $status $statusEmoji)';
}

// ==================== SUBSCRIPTION FEATURE ====================

/// Возможность подписки
class SubscriptionFeature extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool availableInFree;
  final bool availableInPremium;

  const SubscriptionFeature({
    required this.id,
    required this.name,
    this.description,
    this.availableInFree = false,
    this.availableInPremium = true,
  });

  factory SubscriptionFeature.fromJson(Map<String, dynamic> json) {
    return SubscriptionFeature(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      availableInFree: json['available_in_free'] ?? false,
      availableInPremium: json['available_in_premium'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'available_in_free': availableInFree,
      'available_in_premium': availableInPremium,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        availableInFree,
        availableInPremium,
      ];

  @override
  String toString() => 'SubscriptionFeature($name)';
}




