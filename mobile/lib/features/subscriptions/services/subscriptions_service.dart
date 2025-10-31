import 'package:mobile/shared/constants/api_endpoints.dart';
import 'package:mobile/dev_modules/core_module/services/api_service.dart';
import 'package:mobile/features/subscriptions/models/subscription_models.dart';

/// Сервис для работы с подписками
///
/// Поддерживает два режима:
/// - Mock режим (для разработки UI без backend)
/// - Real API режим (для работы с реальным backend)
class SubscriptionsService {
  // ⚠️ РЕЖИМ РАБОТЫ: true = Mock, false = Real API
  static const bool useMockMode = false; // ✅ Backend готов - используем реальный API! // TODO: Изменить на false когда backend готов

  // ==================== PLANS ====================

  /// Получить список доступных планов
  static Future<List<SubscriptionPlan>> getPlans() async {
    try {
      if (useMockMode) {
        return _mockGetPlans();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.subscriptionsPlans,
      );

      return (response['data'] as List)
          .map((item) => SubscriptionPlan.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ getPlans error: $e');
      rethrow;
    }
  }

  // ==================== USER SUBSCRIPTION ====================

  /// Получить подписку пользователя
  static Future<UserSubscription?> getMySubscription() async {
    try {
      if (useMockMode) {
        return _mockGetMySubscription();
      }

      // Реальный API запрос
      final response = await ApiService.get(
        ApiEndpoints.subscriptionsMy,
      );

      if (response['data'] == null) return null;

      return UserSubscription.fromJson(response['data']);
    } catch (e) {
      print('❌ getMySubscription error: $e');
      rethrow;
    }
  }

  /// Оформить подписку
  ///
  /// [planId] - ID плана
  /// [paymentMethod] - способ оплаты
  static Future<UserSubscription> subscribe({
    required String planId,
    String? paymentMethod,
  }) async {
    try {
      if (useMockMode) {
        return _mockSubscribe(planId: planId, paymentMethod: paymentMethod);
      }

      // Реальный API запрос
      final response = await ApiService.post(
        ApiEndpoints.subscriptionsSubscribe,
        {
          'plan_id': planId,
          if (paymentMethod != null) 'payment_method': paymentMethod,
        },
      );

      return UserSubscription.fromJson(response['data']);
    } catch (e) {
      print('❌ subscribe error: $e');
      rethrow;
    }
  }

  /// Отменить подписку
  static Future<void> cancelSubscription() async {
    try {
      if (useMockMode) {
        return _mockCancelSubscription();
      }

      // Реальный API запрос
      await ApiService.post(
        ApiEndpoints.subscriptionsCancel,
        {},
      );
      print('✅ Подписка отменена');
    } catch (e) {
      print('❌ cancelSubscription error: $e');
      rethrow;
    }
  }

  // ==================== MOCK МЕТОДЫ ====================

  // Mock данные
  static final List<SubscriptionPlan> _mockPlans = [
    const SubscriptionPlan(
      id: 'plan_free',
      name: 'Бесплатный',
      description: 'Базовые функции для начала',
      priceMonthly: 0,
      currency: 'RUB',
      features: [
        'Дневник питания',
        'Базовые рецепты',
        'Трекер воды',
        'Статьи блога',
      ],
    ),
    const SubscriptionPlan(
      id: 'plan_basic',
      name: 'Базовый',
      description: 'Для серьезного подхода к питанию',
      priceMonthly: 490,
      priceYearly: 4900,
      currency: 'RUB',
      features: [
        'Все из Бесплатного',
        'Персональный план питания',
        'AI нутрициолог',
        'Расширенная база рецептов',
        'Анализ лабораторных анализов',
      ],
      isPopular: true,
      trialDays: 7,
    ),
    const SubscriptionPlan(
      id: 'plan_premium',
      name: 'Премиум',
      description: 'Максимум возможностей',
      priceMonthly: 990,
      priceYearly: 9900,
      currency: 'RUB',
      features: [
        'Все из Базового',
        'Приоритетная поддержка',
        'Эксклюзивные курсы',
        'Индивидуальные консультации',
        'Детальная аналитика',
        'Экспорт данных',
      ],
      trialDays: 14,
    ),
  ];

  static UserSubscription? _mockCurrentSubscription = UserSubscription(
    id: 'sub_1',
    planId: 'plan_basic',
    planName: 'Базовый',
    status: 'active',
    startDate: DateTime.now().subtract(const Duration(days: 15)),
    endDate: DateTime.now().add(const Duration(days: 15)),
    autoRenew: true,
    paymentMethod: 'card',
  );

  static Future<List<SubscriptionPlan>> _mockGetPlans() async {
    print('🎭 MOCK: Получение планов подписок');
    await Future.delayed(const Duration(milliseconds: 600));

    return _mockPlans;
  }

  static Future<UserSubscription?> _mockGetMySubscription() async {
    print('🎭 MOCK: Получение подписки пользователя');
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockCurrentSubscription;
  }

  static Future<UserSubscription> _mockSubscribe({
    required String planId,
    String? paymentMethod,
  }) async {
    print('🎭 MOCK: Оформление подписки: $planId');
    await Future.delayed(const Duration(milliseconds: 1000));

    final plan = _mockPlans.firstWhere(
      (p) => p.id == planId,
      orElse: () => _mockPlans[1],
    );

    final isTrial = plan.trialDays != null && plan.trialDays! > 0;

    _mockCurrentSubscription = UserSubscription(
      id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      planId: planId,
      planName: plan.name,
      status: isTrial ? 'trial' : 'active',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      trialEndDate: isTrial
          ? DateTime.now().add(Duration(days: plan.trialDays!))
          : null,
      autoRenew: true,
      paymentMethod: paymentMethod ?? 'card',
    );

    return _mockCurrentSubscription!;
  }

  static Future<void> _mockCancelSubscription() async {
    print('🎭 MOCK: Отмена подписки');
    await Future.delayed(const Duration(milliseconds: 500));

    if (_mockCurrentSubscription != null) {
      _mockCurrentSubscription = UserSubscription(
        id: _mockCurrentSubscription!.id,
        planId: _mockCurrentSubscription!.planId,
        planName: _mockCurrentSubscription!.planName,
        status: 'cancelled',
        startDate: _mockCurrentSubscription!.startDate,
        endDate: _mockCurrentSubscription!.endDate,
        autoRenew: false,
        paymentMethod: _mockCurrentSubscription!.paymentMethod,
      );
    }
  }
}

