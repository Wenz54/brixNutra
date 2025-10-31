import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Карточка приема пищи Brix
/// 
/// Используется для отображения блюд в плане питания
/// Показывает фото, название, КБЖУ, время приема
class BrixMealCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? mealType; // "breakfast", "lunch", "dinner", etc.
  final String? time;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fats;
  final VoidCallback? onTap;
  final VoidCallback? onReplace;
  final bool showNutrition;
  final bool isCompleted;

  const BrixMealCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.mealType,
    this.time,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.onTap,
    this.onReplace,
    this.showNutrition = true,
    this.isCompleted = false,
  });

  String _getMealTypeLabel() {
    switch (mealType) {
      case 'wakeup':
        return 'Пробуждение';
      case 'breakfast':
        return 'Завтрак';
      case 'snack':
        return 'Перекус';
      case 'lunch':
        return 'Обед';
      case 'afternoon_snack':
        return 'Полдник';
      case 'dinner':
        return 'Ужин';
      case 'sleep':
        return 'Перед сном';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: BrixColors.surface,
          borderRadius: BrixSpacing.borderRadiusMD,
          boxShadow: BrixShadows.small,
          border: isCompleted
              ? Border.all(color: BrixColors.success, width: 2)
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (imageUrl != null)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl!.startsWith('http')
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                          )
                        : Image.asset(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                          ),
                  ),
                  // Meal Type Badge
                  if (mealType != null)
                    Positioned(
                      top: BrixSpacing.sm,
                      left: BrixSpacing.sm,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: BrixSpacing.md,
                          vertical: BrixSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: BrixColors.primary.withOpacity(0.9),
                          borderRadius: BrixSpacing.borderRadiusSM,
                        ),
                        child: Text(
                          _getMealTypeLabel(),
                          style: BrixTypography.labelSmall.copyWith(
                            color: BrixColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Completed Badge
                  if (isCompleted)
                    Positioned(
                      top: BrixSpacing.sm,
                      right: BrixSpacing.sm,
                      child: Container(
                        padding: EdgeInsets.all(BrixSpacing.xs),
                        decoration: const BoxDecoration(
                          color: BrixColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: BrixColors.textOnPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              )
            else
              _buildImagePlaceholder(),

            // Content
            Padding(
              padding: EdgeInsets.all(BrixSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: BrixTypography.h5,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (time != null) ...[
                        SizedBox(width: BrixSpacing.sm),
                        Text(
                          time!,
                          style: BrixTypography.labelSmall,
                        ),
                      ],
                    ],
                  ),

                  // Nutrition Info
                  if (showNutrition && calories != null) ...[
                    SizedBox(height: BrixSpacing.sm),
                    Row(
                      children: [
                        _buildNutritionBadge(
                          Icons.local_fire_department,
                          '$calories ккал',
                          BrixColors.calories,
                        ),
                        if (protein != null) ...[
                          SizedBox(width: BrixSpacing.sm),
                          _buildNutritionBadge(
                            null,
                            'Б: ${protein!.toStringAsFixed(1)}г',
                            BrixColors.protein,
                          ),
                        ],
                        if (carbs != null) ...[
                          SizedBox(width: BrixSpacing.sm),
                          _buildNutritionBadge(
                            null,
                            'У: ${carbs!.toStringAsFixed(1)}г',
                            BrixColors.carbs,
                          ),
                        ],
                        if (fats != null) ...[
                          SizedBox(width: BrixSpacing.sm),
                          _buildNutritionBadge(
                            null,
                            'Ж: ${fats!.toStringAsFixed(1)}г',
                            BrixColors.fats,
                          ),
                        ],
                      ],
                    ),
                  ],

                  // Replace Button
                  if (onReplace != null) ...[
                    SizedBox(height: BrixSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onReplace,
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('Заменить'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: BrixSpacing.sm),
                          side: const BorderSide(color: BrixColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BrixSpacing.borderRadiusMD,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: BrixColors.surfaceDark,
        child: const Icon(
          Icons.restaurant,
          size: 48,
          color: BrixColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildNutritionBadge(IconData? icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: BrixSpacing.sm,
        vertical: BrixSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BrixSpacing.borderRadiusSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 2),
          ],
          Text(
            text,
            style: BrixTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Компактная карточка приема пищи (для списка в дневнике)
class BrixMealListItem extends StatelessWidget {
  final String title;
  final String? time;
  final int? calories;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BrixMealListItem({
    super.key,
    required this.title,
    this.time,
    this.calories,
    this.isCompleted = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(BrixSpacing.sm),
        decoration: BoxDecoration(
          color: isCompleted
              ? BrixColors.success.withOpacity(0.1)
              : BrixColors.surfaceDark,
          borderRadius: BrixSpacing.borderRadiusSM,
        ),
        child: Icon(
          isCompleted ? Icons.check_circle : Icons.restaurant,
          color: isCompleted ? BrixColors.success : BrixColors.textTertiary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: BrixTypography.bodyLarge.copyWith(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: time != null
          ? Text(
              time!,
              style: BrixTypography.caption,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (calories != null)
            Text(
              '$calories ккал',
              style: BrixTypography.labelMedium.copyWith(
                color: BrixColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (onDelete != null) ...[
            SizedBox(width: BrixSpacing.sm),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: BrixColors.error,
              iconSize: 20,
            ),
          ],
        ],
      ),
    );
  }
}



