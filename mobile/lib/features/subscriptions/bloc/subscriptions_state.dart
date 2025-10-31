import 'package:equatable/equatable.dart';
import 'package:mobile/features/subscriptions/models/subscription_models.dart';

/// Состояния подписок
abstract class SubscriptionsState extends Equatable {
  const SubscriptionsState();

  @override
  List<Object?> get props => [];
}

// ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================

/// Начальное состояние
class SubscriptionsInitial extends SubscriptionsState {
  const SubscriptionsInitial();

  @override
  String toString() => 'SubscriptionsInitial';
}

// ==================== LOADING СОСТОЯНИЯ ====================

/// Загрузка данных
class SubscriptionsLoading extends SubscriptionsState {
  final String? message;

  const SubscriptionsLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'SubscriptionsLoading(message: $message)';
}

// ==================== SUCCESS СОСТОЯНИЯ - PLANS ====================

/// Планы загружены
class PlansLoaded extends SubscriptionsState {
  final List<SubscriptionPlan> plans;

  const PlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];

  @override
  String toString() => 'PlansLoaded(${plans.length} планов)';
}

// ==================== SUCCESS СОСТОЯНИЯ - SUBSCRIPTION ====================

/// Подписка пользователя загружена
class MySubscriptionLoaded extends SubscriptionsState {
  final UserSubscription? subscription;

  const MySubscriptionLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];

  @override
  String toString() => 'MySubscriptionLoaded(${subscription?.planName ?? "Нет подписки"})';
}

/// Подписка оформлена
class Subscribed extends SubscriptionsState {
  final UserSubscription subscription;
  final String message;

  const Subscribed({
    required this.subscription,
    this.message = 'Подписка оформлена',
  });

  @override
  List<Object?> get props => [subscription, message];

  @override
  String toString() => 'Subscribed(${subscription.planName})';
}

/// Подписка отменена
class SubscriptionCancelled extends SubscriptionsState {
  final String message;

  const SubscriptionCancelled({
    this.message = 'Подписка отменена',
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'SubscriptionCancelled()';
}

// ==================== ERROR СОСТОЯНИЕ ====================

/// Ошибка подписок
class SubscriptionsError extends SubscriptionsState {
  final String message;
  final String? code;

  const SubscriptionsError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'SubscriptionsError(message: $message, code: $code)';
}




