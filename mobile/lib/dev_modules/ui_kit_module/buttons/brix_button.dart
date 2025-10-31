import 'package:flutter/material.dart';
import '../theme/brix_theme.dart';

/// Типы кнопок Brix
enum BrixButtonType {
  primary,    // Зеленая кнопка с белым текстом
  secondary,  // Оранжевая кнопка  
  outline,    // Белая кнопка с зеленой рамкой
  text,       // Текстовая кнопка без фона
}

/// Размеры кнопок Brix
enum BrixButtonSize {
  small,   // 40px высота
  medium,  // 48px высота
  large,   // 56px высота
}

/// Переиспользуемая кнопка Brix Nutrition
/// 
/// Поддерживает четыре типа: primary, secondary, outline, text
/// Три размера: small, medium, large
/// Имеет состояния: loading, disabled
/// Может содержать иконку
class BrixButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BrixButtonType type;
  final BrixButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isDisabled;

  const BrixButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = BrixButtonType.primary,
    this.size = BrixButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.icon,
    this.suffixIcon,
    this.isDisabled = false,
  });

  // Фабричные методы для удобства
  
  /// Создать primary кнопку (зеленая)
  static BrixButton primary({
    required String text,
    required VoidCallback? onPressed,
    BrixButtonSize size = BrixButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    double? width,
    IconData? icon,
    IconData? suffixIcon,
    bool isDisabled = false,
  }) {
    return BrixButton(
      text: text,
      onPressed: onPressed,
      type: BrixButtonType.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      width: width,
      icon: icon,
      suffixIcon: suffixIcon,
      isDisabled: isDisabled,
    );
  }

  /// Создать secondary кнопку (оранжевая)
  static BrixButton secondary({
    required String text,
    required VoidCallback? onPressed,
    BrixButtonSize size = BrixButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    double? width,
    IconData? icon,
    IconData? suffixIcon,
    bool isDisabled = false,
  }) {
    return BrixButton(
      text: text,
      onPressed: onPressed,
      type: BrixButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      width: width,
      icon: icon,
      suffixIcon: suffixIcon,
      isDisabled: isDisabled,
    );
  }

  /// Создать outline кнопку
  static BrixButton outline({
    required String text,
    required VoidCallback? onPressed,
    BrixButtonSize size = BrixButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    double? width,
    IconData? icon,
    IconData? suffixIcon,
    bool isDisabled = false,
  }) {
    return BrixButton(
      text: text,
      onPressed: onPressed,
      type: BrixButtonType.outline,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      width: width,
      icon: icon,
      suffixIcon: suffixIcon,
      isDisabled: isDisabled,
    );
  }

  /// Создать text кнопку
  static BrixButton textButton({
    required String text,
    required VoidCallback? onPressed,
    BrixButtonSize size = BrixButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    double? width,
    IconData? icon,
    IconData? suffixIcon,
    bool isDisabled = false,
  }) {
    return BrixButton(
      text: text,
      onPressed: onPressed,
      type: BrixButtonType.text,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      width: width,
      icon: icon,
      suffixIcon: suffixIcon,
      isDisabled: isDisabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getHeight();
    final buttonWidth = isFullWidth ? double.infinity : width;

    switch (type) {
      case BrixButtonType.primary:
        return _buildPrimaryButton(buttonHeight, buttonWidth);
      case BrixButtonType.secondary:
        return _buildSecondaryButton(buttonHeight, buttonWidth);
      case BrixButtonType.outline:
        return _buildOutlineButton(buttonHeight, buttonWidth);
      case BrixButtonType.text:
        return _buildTextButton(buttonHeight, buttonWidth);
    }
  }

  double _getHeight() {
    switch (size) {
      case BrixButtonSize.small:
        return 40.0;
      case BrixButtonSize.medium:
        return 48.0;
      case BrixButtonSize.large:
        return 56.0;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BrixButtonSize.small:
        return BrixTypography.buttonSmall;
      case BrixButtonSize.medium:
        return BrixTypography.buttonMedium;
      case BrixButtonSize.large:
        return BrixTypography.buttonLarge;
    }
  }

  Widget _buildPrimaryButton(double height, double? width) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BrixColors.primary,
          foregroundColor: BrixColors.textOnPrimary,
          disabledBackgroundColor: BrixColors.border,
          disabledForegroundColor: BrixColors.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusXL,
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: BrixSpacing.lg,
            vertical: BrixSpacing.sm,
          ),
        ),
        child: _buildButtonContent(BrixColors.textOnPrimary),
      ),
    );
  }

  Widget _buildSecondaryButton(double height, double? width) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BrixColors.secondary,
          foregroundColor: BrixColors.textOnSecondary,
          disabledBackgroundColor: BrixColors.border,
          disabledForegroundColor: BrixColors.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusXL,
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: BrixSpacing.lg,
            vertical: BrixSpacing.sm,
          ),
        ),
        child: _buildButtonContent(BrixColors.textOnSecondary),
      ),
    );
  }

  Widget _buildOutlineButton(double height, double? width) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: BrixColors.surface,
          foregroundColor: BrixColors.primary,
          disabledBackgroundColor: BrixColors.surfaceDark,
          disabledForegroundColor: BrixColors.textTertiary,
          side: BorderSide(
            color: isDisabled ? BrixColors.border : BrixColors.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusXL,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: BrixSpacing.lg,
            vertical: BrixSpacing.sm,
          ),
        ),
        child: _buildButtonContent(BrixColors.primary),
      ),
    );
  }

  Widget _buildTextButton(double height, double? width) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: BrixColors.primary,
          disabledForegroundColor: BrixColors.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusMD,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: BrixSpacing.md,
            vertical: BrixSpacing.sm,
          ),
        ),
        child: _buildButtonContent(BrixColors.primary),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    final textStyle = _getTextStyle().copyWith(
      color: isDisabled ? BrixColors.textTertiary : textColor,
    );

    if (icon != null || suffixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: size == BrixButtonSize.small ? 16 : 20,
              color: isDisabled ? BrixColors.textTertiary : textColor,
            ),
            SizedBox(width: BrixSpacing.sm),
          ],
          Flexible(
            child: Text(
              text,
              style: textStyle,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (suffixIcon != null) ...[
            SizedBox(width: BrixSpacing.sm),
            Icon(
              suffixIcon,
              size: size == BrixButtonSize.small ? 16 : 20,
              color: isDisabled ? BrixColors.textTertiary : textColor,
            ),
          ],
        ],
      );
    }

    return Text(
      text,
      style: textStyle,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}

