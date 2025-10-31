import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/sms_auth/sms_auth.dart';
import 'package:mobile/features/sms_auth/screens/auth_screen.dart';
import 'package:mobile/features/sms_auth/screens/test_sms_auth_screen.dart';
import 'package:mobile/app/splash_screen.dart';
import 'package:mobile/app/endpoints_test_screen.dart';
import 'package:mobile/app/storage_test_screen.dart';
import 'package:mobile/features/navigation/main_navigation_screen.dart';
import 'package:mobile/features/meal_plan/meal_plan.dart';
import 'package:mobile/features/meal_plan/screens/recipe_detail_screen.dart';
import 'package:mobile/features/meal_plan/screens/recipe_alternatives_screen.dart';
import 'package:mobile/features/diary/diary.dart';
import 'package:mobile/features/diary/screens/add_meal_screen.dart';
import 'package:mobile/features/ai_chat/ai_chat.dart';
import 'package:mobile/features/ai_chat/screens/ai_chat_screen.dart';
import 'package:mobile/features/lab_tests/lab_tests.dart';
import 'package:mobile/features/lab_tests/screens/lab_tests_screen.dart';
import 'package:mobile/features/knowledge_base/knowledge_base.dart';
import 'package:mobile/features/knowledge_base/screens/knowledge_base_screen.dart';

/// Маршруты приложения Brix Nutrition
class AppRoutes {
  // Main app
  static const String splash = '/';
  static const String home = '/home';
  
  // Detail screens
  static const String recipeDetail = '/recipe-detail';
  static const String recipeAlternatives = '/recipe-alternatives';
  static const String addMeal = '/add-meal';
  static const String aiChat = '/ai-chat';
  static const String labTests = '/lab-tests';
  static const String knowledgeBase = '/knowledge-base';
  
  // Auth routes
  static const String auth = '/auth';
  
  // Test routes
  static const String testSmsAuth = '/test-sms-auth';
  static const String endpointsTest = '/endpoints-test';
  static const String storageTest = '/storage-test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      
      case auth:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SmsAuthBloc(),
            child: const AuthScreen(),
          ),
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        );
      
      // Detail screens
      case recipeDetail:
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(recipe: recipe),
        );
      
      case recipeAlternatives:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => MealPlanBloc(),
            child: RecipeAlternativesScreen(
              originalRecipeId: args['recipeId'] as String,
              originalRecipeName: args['recipeName'] as String,
              mealType: args['mealType'] as MealType?,
            ),
          ),
        );
      
      case addMeal:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DiaryBloc(),
            child: AddMealScreen(
              date: args?['date'] as DateTime? ?? DateTime.now(),
              initialMealType: args?['mealType'] as String?,
            ),
          ),
        );
      
      case aiChat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AiChatBloc(),
            child: const AiChatScreen(),
          ),
        );
      
      case labTests:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LabTestsBloc(),
            child: const LabTestsScreen(),
          ),
        );
      
      case knowledgeBase:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => KnowledgeBaseBloc(),
            child: const KnowledgeBaseScreen(),
          ),
        );
      
      // Test routes
      case testSmsAuth:
        return MaterialPageRoute(
          builder: (_) => const TestSmsAuthScreen(),
        );

      case endpointsTest:
        return MaterialPageRoute(
          builder: (_) => const EndpointsTestScreen(),
        );

      case storageTest:
        return MaterialPageRoute(
          builder: (_) => const StorageTestScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
