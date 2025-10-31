import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dev_modules/core_module/services/token_manager.dart';
import 'dev_modules/core_module/services/api_service.dart';
import 'shared/config/supabase_config.dart';
import 'app/app.dart';

/// Главная точка входа в приложение Brix Nutrition
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Russian locale
  await initializeDateFormatting('ru_RU', null);

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize TokenManager (secure storage + shared preferences)
  await TokenManager.init();

  // Initialize API Service interceptors (Dio)
  ApiService.initializeInterceptors();

  // Initialize Supabase (Storage для файлов)
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  debugPrint('🚀 Brix Nutrition App initialized');
  debugPrint('📡 API Service ready');
  debugPrint('📦 Supabase Storage ready');

  // Run the app
  runApp(const BrixNutritionApp());
}
