import 'package:flutter/material.dart';
// Импортируйте тему из core_module:
// import 'package:supply_diets_app/dev_modules/core_module/theme/app_theme.dart';

/// Типы алертов Supply Diets
enum SupplyAlertType {
  success,
  error,
  warning,
  info,
}

/// Переиспользуемый алерт компонент Supply Diets
/// 
/// Может отображаться как:
/// - Встроенный компонент
/// - SnackBar (showSnackBar)
/// - Диалог (showAlertDialog)
class SupplyAlert extends StatelessWidget {
  final String title;
  final String? message;
  final SupplyAlertType type;
  final bool showIcon;
  final bool isDismissible;
  final VoidCallback? onDismiss;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SupplyAlert({
    super.key,
    required this.title,
    this.message,
    this.type = SupplyAlertType.info,
    this.showIcon = true,
    this.isDismissible = true,
    this.onDismiss,
    this.actionText,
    this.onActionPressed,
  });

  Color get _backgroundColor {
    switch (type) {
      case SupplyAlertType.success:
        return const Color(0xFF4CAF50).withOpacity(0.1);
      case SupplyAlertType.error:
        return const Color(0xFFE57373).withOpacity(0.1);
      case SupplyAlertType.warning:
        return const Color(0xFFFF9800).withOpacity(0.1);
      case SupplyAlertType.info:
        return const Color(0xFF2196F3).withOpacity(0.1);
    }
  }

  Color get _borderColor {
    switch (type) {
      case SupplyAlertType.success:
        return const Color(0xFF4CAF50);
      case SupplyAlertType.error:
        return const Color(0xFFE57373);
      case SupplyAlertType.warning:
        return const Color(0xFFFF9800);
      case SupplyAlertType.info:
        return const Color(0xFF2196F3);
    }
  }

  Color get _iconColor {
    return _borderColor;
  }

  IconData get _icon {
    switch (type) {
      case SupplyAlertType.success:
        return Icons.check_circle_outline;
      case SupplyAlertType.error:
        return Icons.error_outline;
      case SupplyAlertType.warning:
        return Icons.warning_amber_outlined;
      case SupplyAlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    const textPrimaryColor = Color(0xFF000000);
    const textSecondaryColor = Color(0xFF271E1E);
    const textTertiaryColor = Color(0xFF9E9E9E);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          if (showIcon) ...[
            Icon(
              _icon,
              color: _iconColor,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                    fontFamily: 'Urbanist',
                  ),
                ),

                // Message
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: textSecondaryColor,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],

                // Action button
                if (actionText != null && onActionPressed != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onActionPressed,
                    child: Text(
                      actionText!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _iconColor,
                        fontFamily: 'Urbanist',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Dismiss button
          if (isDismissible) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: textTertiaryColor,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Показать alert как SnackBar
  static void showSnackBar(
    BuildContext context, {
    required String title,
    String? message,
    SupplyAlertType type = SupplyAlertType.info,
    Duration duration = const Duration(seconds: 4),
    String? actionText,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: SupplyAlert(
        title: title,
        message: message,
        type: type,
        isDismissible: false,
        actionText: actionText,
        onActionPressed: onActionPressed,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Показать alert как диалог
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    String? message,
    SupplyAlertType type = SupplyAlertType.info,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    const bgColor = Color(0xFFFFFFFF);
    const textTertiaryColor = Color(0xFF9E9E9E);
    const primaryColor = Color(0xFFD9E74C);
    
    return showDialog<void>(
      context: context,
      barrierDismissible: cancelText != null,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: SupplyAlert(
            title: title,
            message: message,
            type: type,
            isDismissible: false,
          ),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: onCancel ?? () => Navigator.of(context).pop(),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textTertiaryColor,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
            if (confirmText != null)
              TextButton(
                onPressed: onConfirm ?? () => Navigator.of(context).pop(),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}





