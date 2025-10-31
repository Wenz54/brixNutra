import 'package:flutter/material.dart';

/// Цвета приложения Supply Diets
class AppColors {
  // Основные цвета согласно Figma и проекту
  static const Color primary = Color(0xFFD9E74C); // Ярко-салатовый основной
  static const Color primaryLight = Color(0xFFF1F3DB); // Светло-салатовый для фонов
  static const Color secondary = Color(0xFF00FF7F); // Вторичный зеленый
  
  // Фоновые цвета
  static const Color background = Color(0xFFFFFFFF); // Белый основной фон
  static const Color backgroundSecondary = Color(0xFFF5F5F5); // Светло-серый фон
  static const Color backgroundCard = Color(0xFFF8F8F8); // Фон карточек
  static const Color backgroundInput = Color(0xFFF8F8F8); // Фон полей ввода
  
  // Текстовые цвета
  static const Color textPrimary = Color(0xFF000000); // Черный основной
  static const Color textSecondary = Color(0xFF271E1E); // Темно-серый вторичный
  static const Color textTertiary = Color(0xFF9E9E9E); // Серый для подписей
  static const Color textLabel = Color(0xFF666666); // Серый для лейблов
  
  // Служебные цвета
  static const Color border = Color(0x1A000000); // Прозрачный черный для границ
  static const Color borderLight = Color(0xFFE0E0E0); // Светлые границы
  static const Color success = Color(0xFF4CAF50); // Зеленый успех
  static const Color error = Color(0xFFE57373); // Красный ошибка
  static const Color warning = Color(0xFFFF9800); // Оранжевый предупреждение
  static const Color info = Color(0xFF2196F3); // Синий информация
  
  // Специальные цвета
  static const Color checkupFlow = Color(0xFFE8F5E8); // Зеленый для check-up
  static const Color shadow = Color(0x0F000000); // Тени
  
  // Дополнительные цвета для совместимости
  static Color get surface => background;
  static Color get surfaceVariant => backgroundCard;
  static Color get accent => secondary;
}

/// Отступы приложения
class AppSpacing {
  // Стандартные отступы
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  
  // Специальные отступы
  static const double screenPadding = 16.0;
  static const double cardPadding = 24.0;
  static const double buttonPadding = 16.0;
  
  // Дополнительные геттеры для совместимости
  static EdgeInsets get allMedium => const EdgeInsets.all(md);
  static EdgeInsets get allSmall => const EdgeInsets.all(sm);
  static EdgeInsets get horizontalMedium => const EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get smallSymmetric => const EdgeInsets.symmetric(horizontal: sm, vertical: xs);
  static double get medium => md;
}

/// Типографика приложения
class AppTypography {
  // Основные шрифты
  static const String fontFamilyPrimary = 'Urbanist'; // Основной шрифт
  static const String fontFamilySecondary = 'InterDisplay'; // Для лейблов в скобках
  
  // Размеры шрифтов
  static const double fontSizeXS = 9.0;
  static const double fontSizeS = 10.0;
  static const double fontSizeM = 12.0;
  static const double fontSizeL = 14.0;
  static const double fontSizeXL = 16.0;
  static const double fontSizeXXL = 18.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeLargeTitle = 25.43;
  static const double fontSizeDisplay = 28.0;
  
  // Веса шрифтов
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  
  // Стили текста
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeDisplay,
    fontWeight: weightBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeLargeTitle,
    fontWeight: weightMedium,
    color: AppColors.textSecondary,
    height: 1.1,
    letterSpacing: 0.5,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeTitle,
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeXXL,
    fontWeight: weightSemiBold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeXL,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeL,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: fontSizeM,
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: fontSizeM,
    fontWeight: weightMedium,
    color: AppColors.textLabel,
    height: 1.0,
    letterSpacing: -0.03,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: fontSizeS,
    fontWeight: weightRegular,
    color: AppColors.textTertiary,
    height: 1.0,
    letterSpacing: -0.03,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilySecondary,
    fontSize: fontSizeXS,
    fontWeight: weightMedium,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  
  // Дополнительные стили для совместимости
  static TextStyle get h3 => titleMedium;
  static TextStyle get h4 => titleSmall;
  static TextStyle get body1 => bodyLarge;
  static TextStyle get body2 => bodyMedium;
  static TextStyle get caption => labelSmall;
}

/// Радиусы скругления
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
}

/// Алиасы для краткости
typedef AppTextStyles = AppTypography;
typedef AppRadius = AppBorderRadius;

/// Тени
class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  
  // Дополнительные тени
  static List<BoxShadow> get small => button;
}

/// Главная тема приложения
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamilyPrimary,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      
      // AppBar тема
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.titleSmall,
      ),

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.large),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          textStyle: AppTypography.bodyLarge.copyWith(
            fontWeight: AppTypography.weightRegular,
          ),
          elevation: 0,
        ),
      ),

      // Outlined кнопки
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.large),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          textStyle: AppTypography.bodyLarge.copyWith(
            fontWeight: AppTypography.weightRegular,
          ),
        ),
      ),

      // Текстовые поля
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.textTertiary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textLabel,
        ),
      ),

      // Текстовая тема
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        margin: const EdgeInsets.all(0),
      ),
    );
  }

  /// Dark theme (для будущего использования)
  static ThemeData get darkTheme {
    // TODO: Implement dark theme
    return lightTheme;
  }
}

