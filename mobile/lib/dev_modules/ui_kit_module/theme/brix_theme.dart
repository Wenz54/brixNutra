import 'package:flutter/material.dart';

/// 🎨 Цветовая схема Brix Nutrition
class BrixColors {
  // Primary Colors
  static const primary = Color(0xFF4CAF50); // Зеленый
  static const primaryLight = Color(0xFF81C784);
  static const primaryDark = Color(0xFF388E3C);
  
  // Secondary Colors
  static const secondary = Color(0xFFFF9800); // Оранжевый
  static const secondaryLight = Color(0xFFFFB74D);
  static const secondaryDark = Color(0xFFF57C00);
  
  // Accent Colors
  static const accent = Color(0xFF2196F3); // Синий
  static const accentLight = Color(0xFF64B5F6);
  static const accentDark = Color(0xFF1976D2);
  
  // Background & Surface
  static const background = Color(0xFFFDFEFA); // #FDFEFA как на Auth Screen
  static const surface = Colors.white;
  static const surfaceDark = Color(0xFFF5F5F5);
  
  // Text Colors
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF9E9E9E);
  static const textOnPrimary = Colors.white;
  static const textOnSecondary = Colors.white;
  
  // Border & Divider
  static const border = Color(0xFFE0E0E0);
  static const divider = Color(0xFFE0E0E0);
  
  // Status Colors
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFEF5350);
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF2196F3);
  
  // Special Colors
  static const water = Color(0xFF03A9F4); // Для счетчика воды
  static const protein = Color(0xFFE91E63); // Для макроса "Белки"
  static const carbs = Color(0xFFFFEB3B); // Для макроса "Углеводы"
  static const fats = Color(0xFFFF9800); // Для макроса "Жиры"
  static const calories = Color(0xFF9C27B0); // Для калорий
}

/// 📝 Типографика Brix
class BrixTypography {
  // Font Family
  static const String fontFamily = 'Urbanist';
  
  // Display (для больших заголовков)
  static const TextStyle display1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: BrixColors.textPrimary,
    height: 1.2,
  );
  
  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: BrixColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: BrixColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: BrixColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: BrixColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: BrixColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: BrixColors.textPrimary,
    height: 1.5,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BrixColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: BrixColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BrixColors.textSecondary,
    height: 1.5,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: BrixColors.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: BrixColors.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: BrixColors.textTertiary,
    height: 1.4,
  );
  
  // Captions
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: BrixColors.textTertiary,
    height: 1.3,
  );
  
  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}

/// 📏 Отступы и размеры Brix
class BrixSpacing {
  // Base spacing unit
  static const double unit = 4.0;
  
  // Spacing scale
  static const double xs = unit; // 4px
  static const double sm = unit * 2; // 8px
  static const double md = unit * 3; // 12px
  static const double lg = unit * 4; // 16px
  static const double xl = unit * 5; // 20px
  static const double xxl = unit * 6; // 24px
  static const double xxxl = unit * 8; // 32px
  
  // Padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  
  // Horizontal padding
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  
  // Vertical padding
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  
  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusRound = 999.0; // Полностью круглые элементы
  
  // BorderRadius presets
  static final BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);
  static final BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);
  static final BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static final BorderRadius borderRadiusRound = BorderRadius.circular(radiusRound);
}

/// 🎭 Shadows Brix
class BrixShadows {
  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}

/// 📱 Breakpoints для адаптивного дизайна
class BrixBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}

/// 🎨 Полная тема приложения Brix
class BrixTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: BrixTypography.fontFamily,
      
      // Colors
      colorScheme: const ColorScheme.light(
        primary: BrixColors.primary,
        secondary: BrixColors.secondary,
        surface: BrixColors.surface,
        error: BrixColors.error,
        onPrimary: BrixColors.textOnPrimary,
        onSecondary: BrixColors.textOnSecondary,
      ),
      
      scaffoldBackgroundColor: BrixColors.background,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: BrixColors.surface,
        foregroundColor: BrixColors.textPrimary,
        elevation: 0,
        titleTextStyle: BrixTypography.h3,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: BrixTypography.display1,
        headlineLarge: BrixTypography.h1,
        headlineMedium: BrixTypography.h2,
        headlineSmall: BrixTypography.h3,
        titleLarge: BrixTypography.h4,
        titleMedium: BrixTypography.h5,
        titleSmall: BrixTypography.h6,
        bodyLarge: BrixTypography.bodyLarge,
        bodyMedium: BrixTypography.bodyMedium,
        bodySmall: BrixTypography.bodySmall,
        labelLarge: BrixTypography.labelLarge,
        labelMedium: BrixTypography.labelMedium,
        labelSmall: BrixTypography.labelSmall,
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrixColors.primary,
          foregroundColor: BrixColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusXL,
          ),
          textStyle: BrixTypography.buttonMedium,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrixColors.primary,
          side: const BorderSide(color: BrixColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BrixSpacing.borderRadiusXL,
          ),
          textStyle: BrixTypography.buttonMedium,
        ),
      ),
      
      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrixColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
          borderSide: const BorderSide(color: BrixColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
          borderSide: const BorderSide(color: BrixColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
          borderSide: const BorderSide(color: BrixColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
          borderSide: const BorderSide(color: BrixColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: BrixColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BrixSpacing.borderRadiusMD,
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: BrixColors.divider,
        thickness: 1,
      ),
    );
  }
}

