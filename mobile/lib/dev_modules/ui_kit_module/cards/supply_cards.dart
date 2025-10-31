import 'package:flutter/material.dart';
import '../buttons/supply_button.dart';

/// Малая карточка с текстом сверху и картинкой снизу
/// 
/// Используется для отображения компактной информации
/// с иллюстрацией (например, рецепты, статьи)
class SupplyMinorCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final String? imagePath;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? width;

  const SupplyMinorCard({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    this.imagePath,
    this.onTap,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 261, // Фиксированная высота
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Текстовый контент
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 12, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Верхняя строка с лейблом и стрелкой
                    Row(
                      children: [
                        Text(
                          label, 
                          style: const TextStyle(
                            fontSize: 10, 
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: -0.03,
                            fontFamily: 'InterDisplay',
                          )
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Заголовок
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.2,
                        letterSpacing: -0.02,
                        fontFamily: 'Urbanist',
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Описание
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF271E1E),
                          height: 1.6,
                          fontFamily: 'Urbanist',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Картинка снизу (если есть)
            if (imagePath != null)
              Container(
                width: double.infinity,
                height: 162,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Большая карточка с фоновым изображением и кнопкой
/// 
/// Используется для промо-материалов, главных экранов
class SupplyMajorCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final String? imagePath;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onCardTap;
  final SupplyButtonType buttonType;
  final double? buttonHeight;
  final double? buttonWidth;
  final IconData? buttonIcon;
  final bool buttonIsLoading;
  final bool buttonIsDisabled;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const SupplyMajorCard({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    this.imagePath,
    this.buttonText,
    this.onButtonPressed,
    this.onCardTap,
    this.buttonType = SupplyButtonType.primary,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonIcon,
    this.buttonIsLoading = false,
    this.buttonIsDisabled = false,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 502,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Фоновое изображение (если есть)
              if (imagePath != null)
                Positioned.fill(
                  child: Image.asset(
                    imagePath!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              
              // Контент карточки
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 20, right: 24, bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Лейбл
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'InterDisplay',
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Заголовок
                    SizedBox(
                      width: 326,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25.43,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF271E1E),
                          height: 1.1,
                          fontFamily: 'Urbanist',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Описание
                    SizedBox(
                      width: 326,
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF271E1E),
                          height: 1.4,
                          fontFamily: 'Urbanist',
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Кнопка (если есть)
                    if (buttonText != null)
                      SupplyButton(
                        text: buttonText!,
                        onPressed: onButtonPressed,
                        type: buttonType,
                        height: buttonHeight,
                        width: buttonWidth,
                        icon: buttonIcon,
                        isLoading: buttonIsLoading,
                        isDisabled: buttonIsDisabled,
                        isFullWidth: buttonWidth == null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





