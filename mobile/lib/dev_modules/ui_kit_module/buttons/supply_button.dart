import 'package:flutter/material.dart';
// Импортируйте тему из core_module:
// import 'package:supply_diets_app/dev_modules/core_module/theme/app_theme.dart';

/// Типы кнопок Supply Diets
enum SupplyButtonType {
  primary,    // Зеленая кнопка с белым текстом
  secondary,  // Белая кнопка с зеленой рамкой
  welcome,    // Специальная кнопка для welcome screen с декоративными элементами
}

/// Переиспользуемая кнопка Supply Diets
/// 
/// Поддерживает три типа: primary, secondary, welcome
/// Имеет состояния: loading, disabled
/// Может содержать иконку
class SupplyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final SupplyButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? width;
  final IconData? icon;
  final bool isDisabled;
  final double? fontSize;

  const SupplyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = SupplyButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.width,
    this.icon,
    this.isDisabled = false,
    this.fontSize,
  });

  // Фабричные методы для удобства
  
  /// Создать primary кнопку
  static SupplyButton primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    double? height,
    double? width,
    IconData? icon,
    bool isDisabled = false,
    double? fontSize,
  }) {
    return SupplyButton(
      text: text,
      onPressed: onPressed,
      type: SupplyButtonType.primary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      height: height,
      width: width,
      icon: icon,
      isDisabled: isDisabled,
      fontSize: fontSize,
    );
  }

  /// Создать outline кнопку
  static SupplyButton outline({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    double? height,
    double? width,
    IconData? icon,
    bool isDisabled = false,
    double? fontSize,
  }) {
    return SupplyButton(
      text: text,
      onPressed: onPressed,
      type: SupplyButtonType.secondary,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      height: height,
      width: width,
      icon: icon,
      isDisabled: isDisabled,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 56.0;
    final buttonWidth = isFullWidth ? double.infinity : width;

    switch (type) {
      case SupplyButtonType.primary:
        return _buildPrimaryButton(buttonHeight, buttonWidth);
      case SupplyButtonType.secondary:
        return _buildSecondaryButton(buttonHeight, buttonWidth);
      case SupplyButtonType.welcome:
        return _buildWelcomeButton(buttonHeight, buttonWidth);
    }
  }

  Widget _buildPrimaryButton(double height, double? width) {
    // Используйте цвета из AppColors (core_module/theme/app_theme.dart)
    const primaryColor = Color(0xFFD9E74C);
    const textColor = Color(0xFF000000);
    const disabledBgColor = Color(0xFFE0E0E0);
    const disabledTextColor = Color(0xFF9E9E9E);
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          disabledBackgroundColor: disabledBgColor,
          disabledForegroundColor: disabledTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildSecondaryButton(double height, double? width) {
    const primaryColor = Color(0xFFD9E74C);
    const primaryLight = Color(0xFFF1F3DB);
    const textColor = Color(0xFF000000);
    const bgCardColor = Color(0xFFF8F8F8);
    const disabledTextColor = Color(0xFF9E9E9E);
    const borderLightColor = Color(0xFFE0E0E0);
    
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: textColor,
          disabledBackgroundColor: bgCardColor,
          disabledForegroundColor: disabledTextColor,
          side: BorderSide(
            color: isDisabled ? borderLightColor : primaryColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildWelcomeButton(double height, double? width) {
    const primaryColor = Color(0xFFD9E74C);
    const primaryLight = Color(0xFFF1F3DB);
    const bgCardColor = Color(0xFFF8F8F8);
    const borderLightColor = Color(0xFFE0E0E0);
    
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: (isDisabled || isLoading) ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isDisabled ? bgCardColor : primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Декоративная зеленая фигура
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDisabled ? borderLightColor : primaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              // Текст в левом верхнем углу
              Positioned(
                top: 16,
                left: 16,
                child: _buildButtonContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    const textColor = Color(0xFF000000);
    const primaryColor = Color(0xFFD9E74C);
    const disabledTextColor = Color(0xFF9E9E9E);
    
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == SupplyButtonType.primary 
                ? textColor 
                : primaryColor,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 20, 
            color: isDisabled ? disabledTextColor : textColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w400,
              color: isDisabled ? disabledTextColor : textColor,
              fontFamily: 'Urbanist',
            ),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w400,
        color: isDisabled ? disabledTextColor : textColor,
        fontFamily: 'Urbanist',
      ),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}





