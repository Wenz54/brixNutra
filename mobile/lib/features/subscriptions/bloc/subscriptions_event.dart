import 'package:equatable/equatable.dart';

/// События для управления подписками
abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();

  @override
  List<Object?> get props => [];
}

// ==================== PLANS СОБЫТИЯ ====================

/// Загрузить планы подписок
class LoadPlansRequested extends SubscriptionsEvent {
  const LoadPlansRequested();

  @override
  String toString() => 'LoadPlansRequested()';
}

// ==================== USER SUBSCRIPTION СОБЫТИЯ ====================

/// Загрузить подписку пользователя
class LoadMySubscriptionRequested extends SubscriptionsEvent {
  const LoadMySubscriptionRequested();

  @override
  String toString() => 'LoadMySubscriptionRequested()';
}

/// Оформить подписку
class SubscribeRequested extends SubscriptionsEvent {
  final String planId;
  final String? paymentMethod;

  const SubscribeRequested({
    required this.planId,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [planId, paymentMethod];

  @override
  String toString() => 'SubscribeRequested($planId, $paymentMethod)';
}

/// Отменить подписку
class CancelSubscriptionRequested extends SubscriptionsEvent {
  const CancelSubscriptionRequested();

  @override
  String toString() => 'CancelSubscriptionRequested()';
}

// ==================== UI СОБЫТИЯ ====================

/// Сбросить состояние
class ResetSubscriptionsState extends SubscriptionsEvent {
  const ResetSubscriptionsState();

  @override
  String toString() => 'ResetSubscriptionsState()';
}




