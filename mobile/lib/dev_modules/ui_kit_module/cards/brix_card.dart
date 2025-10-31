import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Основная карточка Brix
/// 
/// Базовая карточка с тенью, скруглением и padding
class BrixCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const BrixCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? BrixSpacing.paddingMD,
      decoration: BoxDecoration(
        color: color ?? BrixColors.surface,
        borderRadius: BrixSpacing.borderRadiusMD,
        boxShadow: boxShadow ?? BrixShadows.small,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

/// Малая карточка Brix
/// 
/// Используется для отображения категорий, тегов, статистики
class BrixMinorCard extends StatelessWidget {
  final String? label;
  final String title;
  final String? description;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const BrixMinorCard({
    super.key,
    this.label,
    required this.title,
    this.description,
    this.imageUrl,
    this.icon,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(BrixSpacing.md),
        decoration: BoxDecoration(
          color: backgroundColor ?? BrixColors.surface,
          borderRadius: BrixSpacing.borderRadiusMD,
          boxShadow: BrixShadows.small,
        ),
        child: Row(
          children: [
            // Image or Icon
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BrixSpacing.borderRadiusSM,
                child: Image.network(
                  imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildIconPlaceholder(),
                ),
              )
            else if (icon != null)
              _buildIconPlaceholder(),

            SizedBox(width: BrixSpacing.md),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Text(
                      label!,
                      style: BrixTypography.labelSmall.copyWith(
                        color: BrixColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: BrixSpacing.xs),
                  ],
                  Text(
                    title,
                    style: BrixTypography.h6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    SizedBox(height: BrixSpacing.xs),
                    Text(
                      description!,
                      style: BrixTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Arrow Icon
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: BrixColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: BrixColors.primary.withOpacity(0.1),
        borderRadius: BrixSpacing.borderRadiusSM,
      ),
      child: Icon(
        icon ?? Icons.image,
        color: BrixColors.primary,
        size: 32,
      ),
    );
  }
}

/// Большая карточка Brix с фоновым изображением
/// 
/// Используется для промо-материалов, фичевых курсов, рецептов
class BrixMajorCard extends StatelessWidget {
  final String? label;
  final String title;
  final String? description;
  final String? imagePath;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onTap;
  final double height;

  const BrixMajorCard({
    super.key,
    this.label,
    required this.title,
    this.description,
    this.imagePath,
    this.buttonText,
    this.onButtonPressed,
    this.onTap,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BrixSpacing.borderRadiusMD,
          boxShadow: BrixShadows.medium,
        ),
        child: Stack(
          children: [
            // Background Image
            if (imagePath != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BrixSpacing.borderRadiusMD,
                  child: imagePath!.startsWith('http')
                      ? Image.network(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                        )
                      : Image.asset(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                        ),
                ),
              )
            else
              Positioned.fill(child: _buildImagePlaceholder()),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BrixSpacing.borderRadiusMD,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              left: BrixSpacing.lg,
              right: BrixSpacing.lg,
              bottom: BrixSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: BrixSpacing.md,
                        vertical: BrixSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: BrixColors.primary,
                        borderRadius: BrixSpacing.borderRadiusSM,
                      ),
                      child: Text(
                        label!,
                        style: BrixTypography.labelSmall.copyWith(
                          color: BrixColors.textOnPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: BrixSpacing.sm),
                  ],
                  Text(
                    title,
                    style: BrixTypography.h3.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    SizedBox(height: BrixSpacing.sm),
                    Text(
                      description!,
                      style: BrixTypography.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (buttonText != null && onButtonPressed != null) ...[
                    SizedBox(height: BrixSpacing.md),
                    ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrixColors.primary,
                        foregroundColor: BrixColors.textOnPrimary,
                        padding: EdgeInsets.symmetric(
                          horizontal: BrixSpacing.xl,
                          vertical: BrixSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BrixSpacing.borderRadiusXL,
                        ),
                      ),
                      child: Text(
                        buttonText!,
                        style: BrixTypography.buttonMedium,
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
    return Container(
      decoration: BoxDecoration(
        color: BrixColors.primary.withOpacity(0.2),
        borderRadius: BrixSpacing.borderRadiusMD,
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: BrixColors.primary,
        ),
      ),
    );
  }
}



