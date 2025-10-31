import 'package:flutter/material.dart';
import '../../ui_kit_module/theme/brix_theme.dart';
import '../../ui_kit_module/buttons/brix_button.dart';

/// Экран выбора целей (Onboarding Шаг 1)
class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'weight_loss',
      title: 'Снижение веса',
      description: 'Хочу сбросить лишние килограммы',
      icon: Icons.trending_down,
      color: BrixColors.accent,
    ),
    GoalOption(
      id: 'weight_gain',
      title: 'Набор веса',
      description: 'Хочу набрать вес и мышечную массу',
      icon: Icons.trending_up,
      color: BrixColors.secondary,
    ),
    GoalOption(
      id: 'muscle_gain',
      title: 'Набор мышечной массы',
      description: 'Хочу нарастить мышцы',
      icon: Icons.fitness_center,
      color: BrixColors.primary,
    ),
    GoalOption(
      id: 'health',
      title: 'Здоровье',
      description: 'Хочу питаться правильно и быть здоровым',
      icon: Icons.favorite,
      color: BrixColors.error,
    ),
  ];

  void _continue() {
    if (_selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите цель')),
      );
      return;
    }

    // Переход к следующему экрану
    Navigator.pushNamed(context, '/onboarding/name', arguments: _selectedGoal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(), // Убираем кнопку назад на первом шаге
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(BrixSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Индикатор прогресса
              LinearProgressIndicator(
                value: 1 / 3, // Шаг 1 из 3
                backgroundColor: BrixColors.surfaceDark,
                valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.primary),
                minHeight: 4,
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Заголовок
              Text(
                'Какая у вас цель?',
                style: BrixTypography.display1,
              ),
              SizedBox(height: BrixSpacing.sm),
              Text(
                'Мы поможем составить персональный план питания',
                style: BrixTypography.bodyLarge.copyWith(
                  color: BrixColors.textSecondary,
                ),
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Список целей
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (_, __) => SizedBox(height: BrixSpacing.md),
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoal == goal.id;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedGoal = goal.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(BrixSpacing.lg),
                        decoration: BoxDecoration(
                          color: BrixColors.surface,
                          borderRadius: BrixSpacing.borderRadiusMD,
                          border: Border.all(
                            color: isSelected ? BrixColors.primary : BrixColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? BrixShadows.medium : BrixShadows.small,
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(BrixSpacing.md),
                              decoration: BoxDecoration(
                                color: goal.color.withValues(alpha: 0.1),
                                borderRadius: BrixSpacing.borderRadiusMD,
                              ),
                              child: Icon(
                                goal.icon,
                                color: goal.color,
                                size: 32,
                              ),
                            ),

                            SizedBox(width: BrixSpacing.lg),

                            // Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.title,
                                    style: BrixTypography.h5.copyWith(
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: BrixSpacing.xs),
                                  Text(
                                    goal.description,
                                    style: BrixTypography.bodySmall.copyWith(
                                      color: BrixColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Checkmark
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: BrixColors.primary,
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: BrixSpacing.xl),

              // Кнопка продолжить
              BrixButton.primary(
                text: 'Продолжить',
                onPressed: _continue,
                size: BrixButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Модель для цели
class GoalOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

