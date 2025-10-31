import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Прогресс-бар Brix для отображения прогресса плана питания или целей
/// 
/// Поддерживает:
/// - Процент прогресса (0-100)
/// - Текстовый лейбл
/// - Настраиваемый цвет
/// - Анимация изменения прогресса
class BrixProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String? label;
  final Color? color;
  final double height;
  final bool showPercentage;
  final bool animate;

  const BrixProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.color,
    this.height = 8.0,
    this.showPercentage = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? BrixColors.primary;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentageText = '${(clampedProgress * 100).toInt()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label & Percentage
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: BrixTypography.labelMedium,
                ),
              if (showPercentage)
                Text(
                  percentageText,
                  style: BrixTypography.labelMedium.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: BrixSpacing.sm),
        ],

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            width: double.infinity,
            color: BrixColors.surfaceDark,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedProgress,
              child: AnimatedContainer(
                duration: animate ? const Duration(milliseconds: 500) : Duration.zero,
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Макро-прогресс-бар с делением на белки, жиры, углеводы
/// 
/// Используется для визуализации потребления макронутриентов
class BrixMacroProgressBar extends StatelessWidget {
  final double protein; // граммы
  final double carbs; // граммы
  final double fats; // граммы
  final double targetProtein;
  final double targetCarbs;
  final double targetFats;
  final double height;

  const BrixMacroProgressBar({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final proteinProgress = (protein / targetProtein).clamp(0.0, 1.0);
    final carbsProgress = (carbs / targetCarbs).clamp(0.0, 1.0);
    final fatsProgress = (fats / targetFats).clamp(0.0, 1.0);

    return Column(
      children: [
        // Белки
        BrixProgressBar(
          progress: proteinProgress,
          label: 'Белки',
          color: BrixColors.protein,
          height: height,
          showPercentage: true,
          animate: true,
        ),
        SizedBox(height: BrixSpacing.md),

        // Углеводы
        BrixProgressBar(
          progress: carbsProgress,
          label: 'Углеводы',
          color: BrixColors.carbs,
          height: height,
          showPercentage: true,
          animate: true,
        ),
        SizedBox(height: BrixSpacing.md),

        // Жиры
        BrixProgressBar(
          progress: fatsProgress,
          label: 'Жиры',
          color: BrixColors.fats,
          height: height,
          showPercentage: true,
          animate: true,
        ),
      ],
    );
  }
}

/// Circular progress indicator Brix с кастомным дизайном
/// 
/// Используется для отображения калорий или прогресса дня
class BrixCircularProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? centerText;
  final TextStyle? centerTextStyle;

  const BrixCircularProgress({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.color,
    this.centerText,
    this.centerTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? BrixColors.primary;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            backgroundColor: BrixColors.surfaceDark,
            valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.surfaceDark),
          ),

          // Progress Circle
          CircularProgressIndicator(
            value: clampedProgress,
            strokeWidth: strokeWidth,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),

          // Center Text
          if (centerText != null)
            Text(
              centerText!,
              style: centerTextStyle ?? BrixTypography.h2.copyWith(
                color: BrixColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}



