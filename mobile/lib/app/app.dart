import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../dev_modules/core_module/theme/app_theme.dart';
import 'routes.dart';

/// Главный виджет приложения Brix Nutrition
class BrixNutritionApp extends StatelessWidget {
  const BrixNutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brix Nutrition',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Initial route - Splash screen с проверкой авторизации
      initialRoute: AppRoutes.splash,
      
      // Routes
      onGenerateRoute: AppRoutes.generateRoute,
      
      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ru', 'RU'),
    );
  }
}

