import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Типы алертов Brix
enum BrixAlertType {
  success,
  error,
  warning,
  info,
}

/// Переиспользуемый алерт компонент Brix
/// 
/// Поддерживает 4 типа: success, error, warning, info
/// Может отображаться как SnackBar или Dialog
class BrixAlert {
  /// Показать SnackBar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    String? title,
    BrixAlertType type = BrixAlertType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
  }) {
    final colorData = _getColorData(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              colorData.icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: BrixSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: BrixTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: BrixSpacing.xs),
                  ],
                  Text(
                    message,
                    style: BrixTypography.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: colorData.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
        ),
        duration: duration,
        action: onTap != null
            ? SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: onTap,
              )
            : null,
      ),
    );
  }

  /// Показать Toast (короткое уведомление)
  static void showToast(
    BuildContext context, {
    required String message,
    BrixAlertType type = BrixAlertType.info,
  }) {
    showSnackBar(
      context,
      message: message,
      type: type,
      duration: const Duration(seconds: 2),
    );
  }

  /// Показать диалог
  static Future<bool?> showAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
    BrixAlertType type = BrixAlertType.info,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    final colorData = _getColorData(type);

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusMD,
          ),
          title: Row(
            children: [
              Icon(
                colorData.icon,
                color: colorData.color,
                size: 28,
              ),
              SizedBox(width: BrixSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: BrixTypography.h5,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: BrixTypography.bodyMedium,
          ),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  onCancel?.call();
                },
                child: Text(
                  cancelText,
                  style: BrixTypography.buttonMedium.copyWith(
                    color: BrixColors.textSecondary,
                  ),
                ),
              ),
            if (confirmText != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorData.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BrixSpacing.borderRadiusMD,
                  ),
                ),
                child: Text(
                  confirmText,
                  style: BrixTypography.buttonMedium,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Показать Bottom Sheet с алертом
  static Future<void> showBottomSheetAlert(
    BuildContext context, {
    required String title,
    required String message,
    BrixAlertType type = BrixAlertType.info,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    final colorData = _getColorData(type);

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BrixSpacing.radiusLG),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(BrixSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                colorData.icon,
                color: colorData.color,
                size: 48,
              ),
              SizedBox(height: BrixSpacing.lg),
              Text(
                title,
                style: BrixTypography.h4,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: BrixSpacing.md),
              Text(
                message,
                style: BrixTypography.bodyMedium.copyWith(
                  color: BrixColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: BrixSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorData.color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: BrixSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BrixSpacing.borderRadiusXL,
                    ),
                  ),
                  child: Text(
                    confirmText ?? 'OK',
                    style: BrixTypography.buttonLarge,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Получить данные цвета и иконки для типа алерта
  static _AlertColorData _getColorData(BrixAlertType type) {
    switch (type) {
      case BrixAlertType.success:
        return _AlertColorData(
          color: BrixColors.success,
          icon: Icons.check_circle,
        );
      case BrixAlertType.error:
        return _AlertColorData(
          color: BrixColors.error,
          icon: Icons.error,
        );
      case BrixAlertType.warning:
        return _AlertColorData(
          color: BrixColors.warning,
          icon: Icons.warning,
        );
      case BrixAlertType.info:
        return _AlertColorData(
          color: BrixColors.info,
          icon: Icons.info,
        );
    }
  }
}

/// Inline alert widget (для отображения прямо на странице)
class BrixInlineAlert extends StatelessWidget {
  final String title;
  final String? message;
  final BrixAlertType type;
  final VoidCallback? onDismiss;

  const BrixInlineAlert({
    super.key,
    required this.title,
    this.message,
    this.type = BrixAlertType.info,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorData = BrixAlert._getColorData(type);

    return Container(
      padding: EdgeInsets.all(BrixSpacing.md),
      decoration: BoxDecoration(
        color: colorData.color.withOpacity(0.1),
        borderRadius: BrixSpacing.borderRadiusMD,
        border: Border.all(
          color: colorData.color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            colorData.icon,
            color: colorData.color,
            size: 24,
          ),
          SizedBox(width: BrixSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: BrixTypography.labelLarge.copyWith(
                    color: colorData.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (message != null) ...[
                  SizedBox(height: BrixSpacing.xs),
                  Text(
                    message!,
                    style: BrixTypography.bodySmall.copyWith(
                      color: colorData.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: BrixSpacing.sm),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: colorData.color,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Внутренний класс для данных цвета и иконки
class _AlertColorData {
  final Color color;
  final IconData icon;

  _AlertColorData({
    required this.color,
    required this.icon,
  });
}



