/// Subscriptions Feature
///
/// Модуль для работы с подписками
///
/// Включает:
/// - Models: SubscriptionPlan, UserSubscription
/// - Service: SubscriptionsService (Mock + Real API)
/// - BLoC: SubscriptionsBloc, SubscriptionsEvent, SubscriptionsState
///
/// Использование:
/// ```dart
/// import 'package:mobile/features/subscriptions/subscriptions.dart';
///
/// // В BlocProvider
/// BlocProvider<SubscriptionsBloc>(
///   create: (context) => SubscriptionsBloc()
///     ..add(LoadPlansRequested()),
///   child: MyWidget(),
/// )
///
/// // Загрузить планы
/// context.read<SubscriptionsBloc>().add(
///   LoadPlansRequested(),
/// );
///
/// // Оформить подписку
/// context.read<SubscriptionsBloc>().add(
///   SubscribeRequested(planId: 'plan_basic'),
/// );
///
/// // Отменить подписку
/// context.read<SubscriptionsBloc>().add(
///   CancelSubscriptionRequested(),
/// );
/// ```
library;

export 'models/subscription_models.dart';
export 'services/subscriptions_service.dart';
export 'bloc/subscriptions_bloc.dart';
export 'bloc/subscriptions_event.dart';
export 'bloc/subscriptions_state.dart';




