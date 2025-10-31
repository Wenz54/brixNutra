import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Счетчик воды Brix
/// 
/// Используется для отслеживания потребления воды
/// Показывает прогресс в миллилитрах и процентах
class BrixWaterCounter extends StatelessWidget {
  final int currentAmount; // текущее количество воды (мл)
  final int targetAmount; // целевое количество воды (мл)
  final Function(int)? onAdd; // callback при добавлении воды
  final Function(int)? onSubtract; // callback при вычитании воды

  const BrixWaterCounter({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    this.onAdd,
    this.onSubtract,
  });

  double get _progress {
    if (targetAmount == 0) return 0.0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  String get _progressText {
    return '$currentAmount / $targetAmount мл';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(BrixSpacing.lg),
      decoration: BoxDecoration(
        color: BrixColors.surface,
        borderRadius: BrixSpacing.borderRadiusMD,
        boxShadow: BrixShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.water_drop,
                color: BrixColors.water,
                size: 24,
              ),
              SizedBox(width: BrixSpacing.sm),
              Text(
                'Вода',
                style: BrixTypography.h5,
              ),
              const Spacer(),
              Text(
                '${(_progress * 100).toInt()}%',
                style: BrixTypography.h5.copyWith(
                  color: BrixColors.water,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: BrixSpacing.md),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 12,
              backgroundColor: BrixColors.surfaceDark,
              valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.water),
            ),
          ),

          SizedBox(height: BrixSpacing.sm),

          // Amount Text
          Text(
            _progressText,
            style: BrixTypography.bodySmall.copyWith(
              color: BrixColors.textSecondary,
            ),
          ),

          SizedBox(height: BrixSpacing.lg),

          // Quick Add Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAddButton('+100', 100),
              _buildQuickAddButton('+200', 200),
              _buildQuickAddButton('+250', 250),
              _buildQuickAddButton('-100', -100, isSubtract: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddButton(String label, int amount, {bool isSubtract = false}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: BrixSpacing.xs),
        child: ElevatedButton(
          onPressed: () {
            if (isSubtract && onSubtract != null) {
              onSubtract!(amount.abs());
            } else if (!isSubtract && onAdd != null) {
              onAdd!(amount);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubtract ? BrixColors.error.withOpacity(0.1) : BrixColors.water.withOpacity(0.1),
            foregroundColor: isSubtract ? BrixColors.error : BrixColors.water,
            padding: EdgeInsets.symmetric(vertical: BrixSpacing.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BrixSpacing.borderRadiusMD,
            ),
            elevation: 0,
          ),
          child: Text(
            label,
            style: BrixTypography.buttonSmall.copyWith(
              color: isSubtract ? BrixColors.error : BrixColors.water,
            ),
          ),
        ),
      ),
    );
  }
}

/// Компактная версия счетчика воды (для списка)
class BrixWaterCounterCompact extends StatelessWidget {
  final int currentAmount;
  final int targetAmount;
  final VoidCallback? onTap;

  const BrixWaterCounterCompact({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BrixSpacing.borderRadiusMD,
      child: Container(
        padding: EdgeInsets.all(BrixSpacing.md),
        decoration: BoxDecoration(
          color: BrixColors.water.withOpacity(0.1),
          borderRadius: BrixSpacing.borderRadiusMD,
          border: Border.all(color: BrixColors.water.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(BrixSpacing.sm),
              decoration: const BoxDecoration(
                color: BrixColors.water,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop,
                color: BrixColors.textOnPrimary,
                size: 20,
              ),
            ),
            SizedBox(width: BrixSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Вода',
                    style: BrixTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: BrixSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: BrixColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.water),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: BrixSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$currentAmount мл',
                  style: BrixTypography.labelLarge.copyWith(
                    color: BrixColors.water,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'из $targetAmount',
                  style: BrixTypography.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



