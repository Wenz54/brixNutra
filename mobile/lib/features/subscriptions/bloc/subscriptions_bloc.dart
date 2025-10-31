import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/subscriptions/bloc/subscriptions_event.dart';
import 'package:mobile/features/subscriptions/bloc/subscriptions_state.dart';
import 'package:mobile/features/subscriptions/services/subscriptions_service.dart';

/// BLoC для управления подписками
///
/// Обрабатывает все действия пользователя:
/// - Загрузка планов подписок
/// - Просмотр текущей подписки
/// - Оформление подписки
/// - Отмена подписки
class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc() : super(const SubscriptionsInitial()) {
    on<LoadPlansRequested>(_onLoadPlans);
    on<LoadMySubscriptionRequested>(_onLoadMySubscription);
    on<SubscribeRequested>(_onSubscribe);
    on<CancelSubscriptionRequested>(_onCancelSubscription);
    on<ResetSubscriptionsState>(_onResetState);
  }

  // ==================== PLANS ====================

  /// Загрузить планы подписок
  Future<void> _onLoadPlans(
    LoadPlansRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      emit(const SubscriptionsLoading(message: 'Загрузка планов...'));

      final plans = await SubscriptionsService.getPlans();

      emit(PlansLoaded(plans));
      print('✅ SubscriptionsBloc: Планы загружены (${plans.length})');
    } catch (e) {
      emit(SubscriptionsError(
        message: 'Не удалось загрузить планы: $e',
        code: 'LOAD_PLANS_ERROR',
      ));
      print('❌ SubscriptionsBloc: Ошибка загрузки планов: $e');
    }
  }

  // ==================== USER SUBSCRIPTION ====================

  /// Загрузить подписку пользователя
  Future<void> _onLoadMySubscription(
    LoadMySubscriptionRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      emit(const SubscriptionsLoading(message: 'Загрузка подписки...'));

      final subscription = await SubscriptionsService.getMySubscription();

      emit(MySubscriptionLoaded(subscription));
      print('✅ SubscriptionsBloc: Подписка загружена: ${subscription?.planName ?? "Нет"}');
    } catch (e) {
      emit(SubscriptionsError(
        message: 'Не удалось загрузить подписку: $e',
        code: 'LOAD_SUBSCRIPTION_ERROR',
      ));
      print('❌ SubscriptionsBloc: Ошибка загрузки подписки: $e');
    }
  }

  /// Оформить подписку
  Future<void> _onSubscribe(
    SubscribeRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      emit(const SubscriptionsLoading(message: 'Оформление подписки...'));

      final subscription = await SubscriptionsService.subscribe(
        planId: event.planId,
        paymentMethod: event.paymentMethod,
      );

      emit(Subscribed(
        subscription: subscription,
        message: subscription.isTrial
            ? 'Пробный период активирован! 🎉'
            : 'Подписка оформлена! 🎉',
      ));
      print('✅ SubscriptionsBloc: Подписка оформлена: ${subscription.planName}');

      // Перезагрузка подписки
      final updatedSubscription = await SubscriptionsService.getMySubscription();
      emit(MySubscriptionLoaded(updatedSubscription));
    } catch (e) {
      emit(SubscriptionsError(
        message: 'Не удалось оформить подписку: $e',
        code: 'SUBSCRIBE_ERROR',
      ));
      print('❌ SubscriptionsBloc: Ошибка оформления подписки: $e');
    }
  }

  /// Отменить подписку
  Future<void> _onCancelSubscription(
    CancelSubscriptionRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      emit(const SubscriptionsLoading(message: 'Отмена подписки...'));

      await SubscriptionsService.cancelSubscription();

      emit(const SubscriptionCancelled(
        message: 'Подписка отменена. Доступ сохранится до конца оплаченного периода.',
      ));
      print('✅ SubscriptionsBloc: Подписка отменена');

      // Перезагрузка подписки
      final subscription = await SubscriptionsService.getMySubscription();
      emit(MySubscriptionLoaded(subscription));
    } catch (e) {
      emit(SubscriptionsError(
        message: 'Не удалось отменить подписку: $e',
        code: 'CANCEL_SUBSCRIPTION_ERROR',
      ));
      print('❌ SubscriptionsBloc: Ошибка отмены подписки: $e');
    }
  }

  // ==================== RESET ====================

  /// Сбросить состояние
  Future<void> _onResetState(
    ResetSubscriptionsState event,
    Emitter<SubscriptionsState> emit,
  ) async {
    emit(const SubscriptionsInitial());
    print('🔄 SubscriptionsBloc: Состояние сброшено');
  }
}




