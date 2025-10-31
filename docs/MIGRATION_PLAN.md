# 🔄 План миграции модулей для Brix Nutritional App

Детальный план адаптации существующих модулей под требования Brix Nutritional App:
- 📱 **Flutter модули** (dev_modules/) - 14 модулей для Mobile App
- 🖥️ **React модули** (admin_modules/) - 8 модулей для Admin Web Panel

## 📋 Содержание

### Часть 1: Flutter модули (dev_modules/)
1. [Общая стратегия](#1-общая-стратегия)
2. [Модули без изменений](#2-модули-без-изменений)
3. [Модули требующие адаптации](#3-модули-требующие-адаптации)
4. [Новые модули](#4-новые-модули)
5. [Изменения в UI Kit](#5-изменения-в-ui-kit)
6. [Checklist миграции Flutter](#6-checklist-миграции-flutter)

### Часть 2: React модули (admin_modules/)
7. [Стратегия адаптации Admin модулей](#7-стратегия-адаптации-admin-модулей)
8. [Admin модули без изменений](#8-admin-модули-без-изменений)
9. [Admin модули требующие адаптации](#9-admin-модули-требующие-адаптации)
10. [Новые Admin модули](#10-новые-admin-модули)
11. [Checklist миграции Admin](#11-checklist-миграции-admin)

### Часть 3: Backend модули (backend_modules/)
12. [Стратегия использования Backend модулей](#12-стратегия-использования-backend-модулей)
13. [Backend модули готовые к использованию](#13-backend-модули-готовые-к-использованию)
14. [Настройка Backend проекта](#14-настройка-backend-проекта)
15. [Checklist миграции Backend](#15-checklist-миграции-backend)

### Итоговые секции
16. [Сводная таблица всех модулей](#16-сводная-таблица-всех-модулей)
17. [Общие приоритеты](#17-общие-приоритеты)

---

## 1. Общая стратегия

### Принципы миграции

✅ **Используем максимально** существующий код  
✅ **Расширяем** там, где не хватает функционала  
✅ **Переделываем** только критичные модули  
✅ **Сохраняем** единый стиль кода

### Порядок миграции

```mermaid
graph TD
    A[1. Core & UI Kit] --> B[2. Auth + SMS]
    B --> C[3. Home Screen]
    C --> D[4. Meal Plan + Diary]
    D --> E[5. AI Chat + Lab Tests]
    E --> F[6. Knowledge + Subscription]
    F --> G[7. Blog + Notifications]
```

---

## 2. Модули без изменений

Эти модули можно использовать как есть, только скопировав в проект.

### 2.1 core_module ⚡

**Статус**: ✅ Используется без изменений

**Что делать:**
```bash
cp -r dev_modules/core_module mobile/lib/dev_modules/
```

**Изменить только:**
- `config/api_config.dart` → изменить `baseUrl` с `localhost:3001` на `localhost:1337` (Strapi)

```dart
// До:
static const String baseUrl = 'http://localhost:3001/api';

// После:
static const String baseUrl = 'http://localhost:1337/api';
```

### 2.2 profile_module 👤

**Статус**: ✅ Используется без изменений

**Что включает:**
- Просмотр профиля
- Редактирование данных
- Смена пароля
- Удаление аккаунта

### 2.3 tab_bar_module 📱

**Статус**: ✅ Используется без изменений

**Что включает:**
- Нижняя навигация
- 4 вкладки (настраиваемые)

**Настройка для Brix:**
```dart
// В main screen
TabItem.home → Главная
TabItem.diary → Дневник
TabItem.aiChat → AI Чат
TabItem.knowledgeBase → База знаний
```

### 2.4 subscription_module 💳

**Статус**: ✅ Используется без изменений

**Что включает:**
- Список тарифов
- Оформление подписки
- Управление подпиской
- Отмена подписки

---

## 3. Модули требующие адаптации

### 3.1 auth_module 🔐 → Частичная адаптация

**Статус**: ⚠️ Расширение (добавить SMS auth)

**Текущий функционал:**
- Email + Password авторизация
- Email верификация (6-значный код)
- Восстановление пароля

**Что добавить:**

#### 1. SMS верификация для телефона

**Новые файлы:**
```
auth_module/
├── services/
│   ├── auth_service.dart (уже есть)
│   └── sms_service.dart (НОВЫЙ)
├── screens/
│   ├── phone_input_screen.dart (НОВЫЙ)
│   └── sms_verification_screen.dart (адаптировать существующий email_verification_screen.dart)
```

**sms_service.dart:**
```dart
import '../../../core_module/services/api_service.dart';

class SmsService {
  /// Отправить SMS код на телефон
  static Future<Map<String, dynamic>> sendCodeToPhone({
    required String phone,
  }) async {
    try {
      final response = await ApiService.post('/auth/phone/send-code', {
        'phone': phone,
      });
      return response;
    } catch (e) {
      print('Error sending SMS: $e');
      rethrow;
    }
  }

  /// Проверить SMS код
  static Future<Map<String, dynamic>> verifyPhoneCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await ApiService.post('/auth/phone/verify-code', {
        'phone': phone,
        'code': code,
      });
      
      // Сохранить токен если успешно
      if (response['success'] == true && response['token'] != null) {
        await AuthService.saveAuthData(
          token: response['token'],
          userId: response['user']?['id'],
          email: response['user']?['email'],
        );
      }
      
      return response;
    } catch (e) {
      print('Error verifying SMS code: $e');
      rethrow;
    }
  }
  
  /// Отправить код на email (для совместимости)
  static Future<Map<String, dynamic>> sendCodeToEmail({
    required String email,
  }) async {
    try {
      final response = await ApiService.post('/auth/email/send-code', {
        'email': email,
      });
      return response;
    } catch (e) {
      print('Error sending email code: $e');
      rethrow;
    }
  }
  
  /// Проверить код email
  static Future<Map<String, dynamic>> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await ApiService.post('/auth/email/verify-code', {
        'email': email,
        'code': code,
      });
      
      return response;
    } catch (e) {
      print('Error verifying email code: $e');
      rethrow;
    }
  }
}
```

**phone_input_screen.dart:**
```dart
import 'package:flutter/material.dart';
import '../../../ui_kit_module/inputs/supply_input.dart';
import '../../../ui_kit_module/buttons/supply_button.dart';
import '../services/sms_service.dart';

class PhoneInputScreen extends StatefulWidget {
  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  
  Future<void> _handleSendCode() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await SmsService.sendCodeToPhone(
        phone: _phoneController.text,
      );
      
      if (response['success']) {
        Navigator.pushNamed(context, '/sms-verification', arguments: {
          'phone': _phoneController.text,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход по телефону')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SupplyInput(
              label: 'Номер телефона',
              controller: _phoneController,
              type: SupplyInputType.phone,
              hint: '+7 909 078 67 65',
            ),
            SizedBox(height: 24),
            SupplyButton.primary(
              text: 'Далее',
              onPressed: _handleSendCode,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 2. Адаптировать Welcome Screen

**Изменить:**
```dart
// auth_module/screens/welcome_screen.dart

// Добавить две кнопки:
SupplyButton.primary(
  text: 'Войти по почте',
  onPressed: () => Navigator.pushNamed(context, '/email-input'),
),
SizedBox(height: 16),
SupplyButton.outline(
  text: 'Войти по номеру телефона',
  onPressed: () => Navigator.pushNamed(context, '/phone-input'),
),
```

### 3.2 onboarding_module 🎯 → Изменение

**Статус**: ⚠️ Изменить под Brix опрос

**Текущий функционал:**
- Тип питания
- Пол и возраст
- Цели

**Что изменить:**

**Новые шаги (согласно Сценарию 5):**
1. **Шаг 1**: Какая у тебя цель? (Снижение веса, Набор массы, Поддержание, ЗОЖ)
2. **Шаг 2**: Как тебя зовут?
3. **Шаг 3**: Введи дату рождения

**Упростить:**
```dart
// onboarding_module/screens/onboarding_screen.dart

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  String? _goal;
  String? _name;
  DateTime? _birthDate;
  
  List<Widget> get _steps => [
    // Шаг 1: Цель
    GoalSelectionStep(
      onSelected: (goal) {
        setState(() => _goal = goal);
        _nextStep();
      },
    ),
    
    // Шаг 2: Имя
    NameInputStep(
      onSubmit: (name) {
        setState(() => _name = name);
        _nextStep();
      },
    ),
    
    // Шаг 3: Дата рождения
    BirthDateStep(
      onSubmit: (date) async {
        setState(() => _birthDate = date);
        await _completeOnboarding();
      },
    ),
  ];
  
  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }
  
  Future<void> _completeOnboarding() async {
    await OnboardingService.complete(
      goal: _goal!,
      name: _name!,
      birthDate: _birthDate!,
    );
    
    Navigator.pushReplacementNamed(context, '/home');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: PageController(initialPage: _currentStep),
        children: _steps,
      ),
    );
  }
}
```

### 3.3 home_module 🏠 → Переделка

**Статус**: 🔄 Полная переделка под дизайн Brix

**Текущий функционал:**
- Простой dashboard

**Новый функционал (Сценарий 6):**
- Приветствие: "Привет, {Имя}! Твоя доска выглядит отлично"
- План питания на неделю (прогресс %)
- Инструменты (Дневник, Рацион, AI-чат, Анализы)
- Блог/Новости (последние 3 статьи)
- Мои подписки
- Уведомления (колокольчик)

**Новый home_screen.dart:**
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          // Колокольчик
          IconButton(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications),
            ),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Приветствие
              GreetingWidget(),
              SizedBox(height: 24),
              
              // План питания
              PlanProgressCard(),
              SizedBox(height: 24),
              
              // Инструменты
              Text('Инструменты', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              ToolsGrid(),
              SizedBox(height: 24),
              
              // Блог
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Новости. Наш Блог', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/blog'),
                    child: Text('Показать все'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              BlogPreviewList(),
              SizedBox(height: 24),
              
              // Подписки
              SubscriptionCard(),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3.4 diary_module 📊 → Расширение

**Статус**: ⚠️ Расширение (связь с рационом)

**Текущий функционал:**
- ✅ Добавление приемов пищи
- ✅ Трекинг воды
- ✅ Настроение
- ✅ Фото блюд
- ✅ Календарь

**Что добавить:**

#### 1. Быстрое добавление из рациона

```dart
// diary_module/services/diary_service.dart

/// Добавить блюдо из плана питания
static Future<MealEntry?> addMealFromPlan({
  required String recipeId,
  required String mealType,
  required DateTime consumedAt,
}) async {
  try {
    final response = await ApiService.post('/diary/meal', {
      'recipeId': recipeId,
      'mealType': mealType,
      'consumedAt': consumedAt.toIso8601String(),
      'fromPlan': true,
    });
    
    return MealEntry.fromJson(response);
  } catch (e) {
    print('Error adding meal from plan: $e');
    return null;
  }
}
```

#### 2. Кнопка быстрого добавления

```dart
// В diary screen добавить:
ElevatedButton.icon(
  icon: Icon(Icons.restaurant_menu),
  label: Text('Из рациона'),
  onPressed: _showPlanMeals,
)
```

### 3.5 plans_module 🎯 → Расширение (Рацион)

**Статус**: ⚠️ Значительное расширение

**Текущий функционал:**
- Список планов
- Детали плана

**Что добавить (Сценарий 9):**

#### 1. Рецепты

**Новые файлы:**
```
plans_module/
├── services/
│   ├── plan_service.dart (уже есть)
│   └── recipe_service.dart (НОВЫЙ)
├── models/
│   ├── plan_model.dart (уже есть)
│   ├── recipe_model.dart (НОВЫЙ)
│   └── ingredient_model.dart (НОВЫЙ)
├── screens/
│   ├── meal_plan_screen.dart (переименовать из plan_detail)
│   ├── recipe_detail_screen.dart (НОВЫЙ)
│   └── recipe_alternatives_screen.dart (НОВЫЙ)
```

#### 2. Замена блюд

```dart
// recipe_service.dart
class RecipeService {
  static Future<List<Recipe>> getAlternatives(String recipeId) async {
    final response = await ApiService.get('/recipes/$recipeId/alternatives');
    return (response as List).map((r) => Recipe.fromJson(r)).toList();
  }
  
  static Future<bool> replaceInPlan({
    required String mealSlotId,
    required String newRecipeId,
  }) async {
    await ApiService.post('/meal-plan/replace', {
      'mealSlotId': mealSlotId,
      'newRecipeId': newRecipeId,
    });
    return true;
  }
}
```

### 3.6 checkup_module 🔬 → Расширение

**Статус**: ⚠️ Расширение (интерпретации)

**Текущий функционал:**
- Добавление результатов
- История анализов

**Что добавить (Сценарий 12):**

#### 1. Интерпретация показателей

```dart
// checkup_module/services/lab_test_service.dart

/// Получить интерпретацию анализа
static Future<LabInterpretation> getInterpretation(String testId) async {
  final response = await ApiService.get('/lab-tests/interpretation/$testId');
  return LabInterpretation.fromJson(response);
}

/// Получить справочник показателей
static Future<List<LabParameter>> getParameters({String? category}) async {
  final response = await ApiService.get('/lab-tests/parameters', 
    queryParameters: category != null ? {'category': category} : null);
  return (response as List).map((p) => LabParameter.fromJson(p)).toList();
}
```

#### 2. Экран расшифровки

**Новый файл:**
```dart
// checkup_module/screens/lab_interpretation_screen.dart

class LabInterpretationScreen extends StatelessWidget {
  final String testId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расшифровка анализов')),
      body: FutureBuilder<LabInterpretation>(
        future: LabTestService.getInterpretation(testId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                // Содержание (разделы)
                ContentsSection(interpretation: snapshot.data!),
                
                // Показатели с интерпретацией
                ...snapshot.data!.interpretations.map(
                  (i) => ParameterCard(interpretation: i),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

### 3.7 ai_chat_module 🤖 → Расширение

**Статус**: ⚠️ Расширение (контекст из БД)

**Текущий функционал:**
- Чат с AI
- История

**Что добавить (Сценарий 10):**

#### 1. Контекстные запросы

```dart
// ai_chat_module/services/ai_chat_service.dart

/// Отправить сообщение с контекстом
static Future<String> sendMessage({
  required String message,
  String? chatId,
  bool includeDiary = false,
  bool includeLabTests = false,
  bool includePlan = false,
}) async {
  final response = await ApiService.post('/ai/chat/message', {
    'message': message,
    'chatId': chatId,
    'context': {
      'includeDiary': includeDiary,
      'includeLabTests': includeLabTests,
      'includePlan': includePlan,
    },
  });
  
  return response['response'];
}
```

#### 2. Настройка контекста

```dart
// В chat screen добавить:
PopupMenuButton(
  icon: Icon(Icons.settings),
  itemBuilder: (context) => [
    CheckedPopupMenuItem(
      checked: _includeDiary,
      child: Text('Учитывать дневник'),
      onTap: () => setState(() => _includeDiary = !_includeDiary),
    ),
    CheckedPopupMenuItem(
      checked: _includeLabTests,
      child: Text('Учитывать анализы'),
      onTap: () => setState(() => _includeLabTests = !_includeLabTests),
    ),
    CheckedPopupMenuItem(
      checked: _includePlan,
      child: Text('Учитывать план'),
      onTap: () => setState(() => _includePlan = !_includePlan),
    ),
  ],
)
```

### 3.8 knowledge_module 📚 → Расширение

**Статус**: ⚠️ Расширение (материалы, прогресс)

**Текущий функционал:**
- Список курсов
- Уроки

**Что добавить (Сценарий 13):**

#### 1. Материалы для скачивания

```dart
// knowledge_module/models/lesson_model.dart

class Lesson {
  final String id;
  final String title;
  final String type; // 'video', 'text', 'audio'
  final String content;
  final List<Material> materials; // ДОБАВИТЬ
  
  // ...
}

class Material {
  final String name;
  final String url;
  
  Material({required this.name, required this.url});
  
  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      name: json['name'],
      url: json['url'],
    );
  }
}
```

#### 2. Прогресс обучения

```dart
// knowledge_module/services/knowledge_service.dart

/// Получить прогресс по курсу
static Future<CourseProgress> getProgress(String courseId) async {
  final response = await ApiService.get('/courses/$courseId/progress');
  return CourseProgress.fromJson(response);
}

/// Отметить урок просмотренным
static Future<void> markLessonComplete(String lessonId) async {
  await ApiService.post('/lessons/$lessonId/complete');
}
```

---

## 4. Новые модули

Эти модули нужно создать с нуля.

### 4.1 blog_module 📰

**Создать:**
```
features/blog/
├── services/
│   └── blog_service.dart
├── models/
│   └── article_model.dart
├── screens/
│   ├── blog_list_screen.dart
│   └── article_detail_screen.dart
└── widgets/
    ├── article_card.dart
    └── category_filter.dart
```

**blog_service.dart:**
```dart
class BlogService {
  static Future<List<Article>> getArticles({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    final response = await ApiService.get('/blog/articles', 
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
      });
    
    return (response['articles'] as List)
        .map((a) => Article.fromJson(a))
        .toList();
  }
  
  static Future<Article> getArticle(String id) async {
    final response = await ApiService.get('/blog/articles/$id');
    return Article.fromJson(response);
  }
}
```

### 4.2 notifications_module 🔔

**Создать:**
```
features/notifications/
├── services/
│   ├── notification_service.dart
│   └── push_notification_service.dart
├── models/
│   └── notification_model.dart
├── screens/
│   └── notifications_screen.dart
└── widgets/
    └── notification_card.dart
```

**notification_service.dart:**
```dart
class NotificationService {
  static Future<List<Notification>> getNotifications({
    bool unreadOnly = false,
  }) async {
    final response = await ApiService.get('/notifications',
      queryParameters: {'unreadOnly': unreadOnly});
    
    return (response['notifications'] as List)
        .map((n) => Notification.fromJson(n))
        .toList();
  }
  
  static Future<void> markAsRead(String id) async {
    await ApiService.patch('/notifications/$id/read');
  }
  
  static Future<void> delete(String id) async {
    await ApiService.delete('/notifications/$id');
  }
}
```

---

## 5. Изменения в UI Kit

### 5.1 Цветовая схема Brix

**Изменить:**
```dart
// ui_kit_module/theme/app_colors.dart

class AppColors {
  // Primary (зеленый для здорового питания)
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);
  
  // Secondary (оранжевый для акцентов)
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);
  
  // ... остальные цвета
}
```

### 5.2 Новые UI компоненты

#### ProgressCircle

```dart
// ui_kit_module/widgets/progress_circle.dart
class ProgressCircle extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String label;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Badge

```dart
// ui_kit_module/widgets/badge.dart
class Badge extends StatelessWidget {
  final Widget child;
  final String label;
  final Color? color;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -8,
          top: -8,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color ?? Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 6. Checklist миграции Flutter

### Фаза 1: Подготовка (1 неделя)

- [ ] Создать папку `mobile/`
- [ ] Инициализировать Flutter проект
- [ ] Скопировать `dev_modules/` в `mobile/lib/`
- [ ] Настроить `pubspec.yaml`
- [ ] Изменить API URL в `core_module`
- [ ] Обновить цветовую схему в `ui_kit_module`
- [ ] Создать базовую навигацию

### Фаза 2: Core модули (2 недели)

- [ ] ✅ `core_module` — без изменений
- [ ] ✅ `ui_kit_module` — изменить цвета, добавить виджеты
- [ ] ✅ `tab_bar_module` — без изменений

### Фаза 3: Авторизация (2 недели)

- [ ] ⚠️ `auth_module` — добавить SMS auth
  - [ ] Создать `sms_service.dart`
  - [ ] Создать `phone_input_screen.dart`
  - [ ] Адаптировать `sms_verification_screen.dart`
  - [ ] Изменить `welcome_screen.dart`
  - [ ] Тестирование

- [ ] ⚠️ `onboarding_module` — изменить опрос
  - [ ] Создать 3 новых шага
  - [ ] Обновить `onboarding_service.dart`
  - [ ] Тестирование

### Фаза 4: Главный экран (1 неделя)

- [ ] 🔄 `home_module` — полная переделка
  - [ ] Новый дизайн `home_screen.dart`
  - [ ] `GreetingWidget`
  - [ ] `PlanProgressCard`
  - [ ] `ToolsGrid`
  - [ ] `BlogPreviewList`
  - [ ] `SubscriptionCard`
  - [ ] Тестирование

### Фаза 5: Рацион и Дневник (3 недели)

- [ ] ⚠️ `plans_module` → Рацион
  - [ ] Создать `recipe_service.dart`
  - [ ] Создать модели (Recipe, Ingredient)
  - [ ] `meal_plan_screen.dart`
  - [ ] `recipe_detail_screen.dart`
  - [ ] `recipe_alternatives_screen.dart`
  - [ ] Функция замены блюд
  - [ ] Тестирование

- [ ] ⚠️ `diary_module` — расширение
  - [ ] Добавить `addMealFromPlan()`
  - [ ] Кнопка "Из рациона"
  - [ ] Связать с рецептами
  - [ ] Тестирование

### Фаза 6: AI и Анализы (2 недели)

- [ ] ⚠️ `ai_chat_module` — расширение
  - [ ] Добавить контекстные запросы
  - [ ] Настройка контекста (UI)
  - [ ] Тестирование

- [ ] ⚠️ `checkup_module` — расширение
  - [ ] `getInterpretation()`
  - [ ] `getParameters()`
  - [ ] `lab_interpretation_screen.dart`
  - [ ] Справочник показателей
  - [ ] Тестирование

### Фаза 7: Курсы и Подписки (2 недели)

- [ ] ⚠️ `knowledge_module` — расширение
  - [ ] Добавить материалы
  - [ ] Прогресс обучения
  - [ ] Скачивание материалов
  - [ ] Тестирование

- [ ] ✅ `subscription_module` — без изменений
  - [ ] Проверить интеграцию

### Фаза 8: Новые модули (2 недели)

- [ ] 🆕 `blog_module`
  - [ ] Создать структуру
  - [ ] `blog_service.dart`
  - [ ] `blog_list_screen.dart`
  - [ ] `article_detail_screen.dart`
  - [ ] Тестирование

- [ ] 🆕 `notifications_module`
  - [ ] Создать структуру
  - [ ] `notification_service.dart`
  - [ ] `push_notification_service.dart`
  - [ ] `notifications_screen.dart`
  - [ ] Firebase integration
  - [ ] Тестирование

### Фаза 9: Профиль (1 неделя)

- [ ] ✅ `profile_module` — без изменений
  - [ ] Проверить интеграцию
  - [ ] Тестирование

### Фаза 10: Финализация (2 недели)

- [ ] Полное тестирование
- [ ] UI/UX polish
- [ ] Performance optimization
- [ ] Bug fixing
- [ ] Документация

---

# Часть 2: React модули (admin_modules/)

## 7. Стратегия адаптации Admin модулей

### Принципы адаптации

✅ **Используем максимально** готовую структуру admin_modules  
✅ **Адаптируем API клиент** под Strapi endpoints  
✅ **Добавляем недостающие** модули для Brix (рецепты, анализы, блог)  
✅ **Интегрируем** с Strapi authentication  

### Что есть в admin_modules

| Модуль | Статус | Что дает |
|--------|--------|----------|
| `core_module` | ✅ Готов | Layout, API client, типы |
| `ui_components_module` | ✅ Готов | FileUpload, Modal, Forms |
| `dashboard_module` | ✅ Готов | Dashboard со статистикой |
| `courses_module` | ✅ Готов | Управление курсами |
| `lessons_module` | ✅ Готов | Управление уроками |
| `categories_module` | ✅ Готов | Управление категориями |
| `nutrition_plans_module` | ✅ Готов | Управление планами питания |
| `analytics_module` | ⏳ В разработке | Аналитика и отчеты |

**Итого**: 7 готовых модулей из 8 (87% готовности)

---

## 8. Admin модули без изменений

Эти модули можно использовать практически без изменений.

### 8.1 ui_components_module 🎨

**Статус**: ✅ Используется без изменений

**Что включает:**
- FileUpload (изображения, видео, аудио, документы)
- Modal components
- Form components
- Button components

**Что делать:**
```bash
cp -r admin_modules/ui_components_module admin/src/admin_modules/
```

### 8.2 categories_module 🏷️

**Статус**: ✅ Используется без изменений

**Что включает:**
- CRUD категорий
- Цветовая индикация
- Сортировка

**Интеграция с Strapi:**
Просто подключить к Strapi Categories API endpoint.

---

## 9. Admin модули требующие адаптации

### 9.1 core_module ⚙️ → Адаптация API клиента

**Статус**: ⚠️ Требует адаптации

**Что изменить:**

#### 1. API клиент для Strapi

```typescript
// admin/src/admin_modules/core_module/api/apiClient.ts

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:1337/api';

export const apiClient = {
  // Strapi auth
  async login(email: string, password: string) {
    const res = await fetch(`${API_URL}/auth/local`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identifier: email, password }),
    });
    const data = await res.json();
    if (data.jwt) {
      localStorage.setItem('token', data.jwt);
    }
    return data;
  },

  // Generic GET
  async get(endpoint: string) {
    const token = localStorage.getItem('token');
    const res = await fetch(`${API_URL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });
    return res.json();
  },

  // Generic POST
  async post(endpoint: string, data: any) {
    const token = localStorage.getItem('token');
    const res = await fetch(`${API_URL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(data),
    });
    return res.json();
  },

  // ... PUT, DELETE аналогично
};
```

#### 2. TypeScript типы под Brix

```typescript
// admin/src/admin_modules/core_module/types/index.ts

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'editor' | 'viewer';
}

export interface Recipe {
  id: string;
  name: string;
  description: string;
  imageUrl?: string;
  prepTime: number;
  calories: number;
  protein: number;
  carbs: number;
  fats: number;
  ingredients: Ingredient[];
  instructions: string[];
  tags: string[];
}

export interface MealPlan {
  id: string;
  name: string;
  description: string;
  type: string;
  startDate: string;
  meals: MealSlot[];
}

// ... остальные типы
```

### 9.2 dashboard_module 📊 → Адаптация метрик Brix

**Статус**: ⚠️ Адаптация метрик

**Что изменить:**

```typescript
// admin/src/admin_modules/dashboard_module/components/DashboardPage.tsx

export default function DashboardPage() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeUsers: 0,
    totalRecipes: 0,
    totalMealPlans: 0,
    totalCourses: 0,
    activeSubscriptions: 0,
  });

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    // Получить статистику из Strapi
    const usersCount = await apiClient.get('/users/count');
    const recipesCount = await apiClient.get('/recipes/count');
    const plansCount = await apiClient.get('/meal-plans/count');
    const coursesCount = await apiClient.get('/courses/count');
    const subscriptionsCount = await apiClient.get('/subscriptions/count?filters[status][$eq]=active');

    setStats({
      totalUsers: usersCount,
      activeUsers: usersCount, // TODO: добавить фильтр по активности
      totalRecipes: recipesCount,
      totalMealPlans: plansCount,
      totalCourses: coursesCount,
      activeSubscriptions: subscriptionsCount,
    });
  };

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-8">Dashboard</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StatCard title="Пользователи" value={stats.totalUsers} icon="👥" />
        <StatCard title="Рецепты" value={stats.totalRecipes} icon="🍽️" />
        <StatCard title="Планы питания" value={stats.totalMealPlans} icon="📋" />
        <StatCard title="Курсы" value={stats.totalCourses} icon="📚" />
        <StatCard title="Активные подписки" value={stats.activeSubscriptions} icon="💳" />
      </div>
    </div>
  );
}
```

### 9.3 courses_module + lessons_module 📚 → Интеграция с Strapi

**Статус**: ⚠️ Интеграция

**Что изменить:**

Заменить API calls на Strapi endpoints:

```typescript
// admin/src/admin_modules/courses_module/api/coursesApi.ts

export const coursesApi = {
  async getAll() {
    return apiClient.get('/courses?populate=*');
  },

  async getById(id: string) {
    return apiClient.get(`/courses/${id}?populate=*`);
  },

  async create(data: any) {
    return apiClient.post('/courses', { data });
  },

  async update(id: string, data: any) {
    return apiClient.put(`/courses/${id}`, { data });
  },

  async delete(id: string) {
    return apiClient.delete(`/courses/${id}`);
  },
};
```

### 9.4 nutrition_plans_module 🍽️ → Адаптация под Brix

**Статус**: ⚠️ Адаптация полей

**Что изменить:**

Добавить поля специфичные для Brix:

```typescript
// Добавить связь с рецептами
interface MealSlot {
  id: string;
  type: 'wakeup' | 'breakfast' | 'snack' | 'lunch' | 'dinner' | 'sleep';
  time: string;
  recipe: Recipe; // Связь с Recipe
  portion: number;
  calories: number;
  importance?: string;
}
```

---

## 10. Новые Admin модули

Эти модули нужно создать с нуля для Brix.

### 10.1 recipes_module 🍽️

**Создать:**
```
admin/src/admin_modules/recipes_module/
├── pages/
│   ├── RecipesListPage.tsx
│   └── RecipeFormPage.tsx
├── components/
│   ├── RecipeCard.tsx
│   └── IngredientsList.tsx
├── api/
│   └── recipesApi.ts
└── types/
    └── index.ts
```

**Основные функции:**
- CRUD рецептов
- Загрузка фото
- Управление ингредиентами
- Управление тегами
- Альтернативные рецепты

### 10.2 lab_tests_module 🔬

**Создать:**
```
admin/src/admin_modules/lab_tests_module/
├── pages/
│   ├── LabParametersPage.tsx
│   └── InterpretationsPage.tsx
├── components/
│   ├── ParameterForm.tsx
│   └── ReferenceRangeEditor.tsx
└── api/
    └── labTestsApi.ts
```

**Основные функции:**
- Управление справочником показателей
- Референсные значения (по полу/возрасту)
- Интерпретации отклонений
- Рекомендации

### 10.3 blog_module 📰

**Создать:**
```
admin/src/admin_modules/blog_module/
├── pages/
│   ├── ArticlesListPage.tsx
│   └── ArticleEditorPage.tsx
├── components/
│   ├── ArticleCard.tsx
│   └── MarkdownEditor.tsx
└── api/
    └── blogApi.ts
```

**Основные функции:**
- CRUD статей
- Markdown редактор
- Категории и теги
- Публикация/черновики

### 10.4 users_module 👥

**Создать:**
```
admin/src/admin_modules/users_module/
├── pages/
│   ├── UsersListPage.tsx
│   └── UserDetailPage.tsx
├── components/
│   ├── UserCard.tsx
│   └── UserStats.tsx
└── api/
    └── usersApi.ts
```

**Основные функции:**
- Список пользователей
- Детали пользователя (профиль, активность)
- Статистика по пользователю
- Блокировка/активация

### 10.5 subscriptions_module 💳

**Создать:**
```
admin/src/admin_modules/subscriptions_module/
├── pages/
│   ├── SubscriptionsListPage.tsx
│   └── SubscriptionPlansPage.tsx
├── components/
│   ├── SubscriptionCard.tsx
│   └── PlanEditor.tsx
└── api/
    └── subscriptionsApi.ts
```

**Основные функции:**
- Список подписок
- Управление тарифами
- Статистика (MRR, Churn Rate)
- Возвраты/отмены

---

## 11. Checklist миграции Admin

### Фаза 1: Подготовка (1 неделя)

- [ ] Создать Next.js проект в `admin/`
- [ ] Скопировать `admin_modules/` в `admin/src/admin_modules/`
- [ ] Установить зависимости
- [ ] Настроить Tailwind CSS
- [ ] Создать `.env.local` с NEXT_PUBLIC_API_URL

### Фаза 2: Core модули (1 неделя)

- [ ] ✅ `core_module` — адаптировать API клиент под Strapi
- [ ] ✅ `ui_components_module` — без изменений
- [ ] Настроить Layout (Header, Sidebar)
- [ ] Реализовать авторизацию (Strapi JWT)

### Фаза 3: Готовые модули (2 недели)

- [ ] ✅ `dashboard_module` — адаптировать метрики
- [ ] ✅ `courses_module` — интеграция с Strapi
- [ ] ✅ `lessons_module` — интеграция с Strapi
- [ ] ✅ `categories_module` — интеграция с Strapi
- [ ] ✅ `nutrition_plans_module` — адаптация под Brix

### Фаза 4: Новые модули (4 недели)

- [ ] 🆕 `recipes_module` — CRUD рецептов
- [ ] 🆕 `lab_tests_module` — справочник анализов
- [ ] 🆕 `blog_module` — управление блогом
- [ ] 🆕 `users_module` — управление пользователями
- [ ] 🆕 `subscriptions_module` — управление подписками

### Фаза 5: Analytics (1 неделя)

- [ ] ⚠️ `analytics_module` — завершить + интеграция
  - [ ] Графики активности пользователей
  - [ ] Статистика по курсам
  - [ ] Статистика по подпискам
  - [ ] Отчеты (экспорт в CSV/PDF)

### Фаза 6: Тестирование (1 неделя)

- [ ] Unit тесты (Jest)
- [ ] E2E тесты (Playwright)
- [ ] Тестирование на разных браузерах
- [ ] Проверка responsive дизайна

**Итого:** ~10 недель разработки Admin Panel

---

# Часть 3: Backend модули (backend_modules/)

## 12. Стратегия использования Backend модулей

### Принципы использования

✅ **Готовые модули** - используем все 13 модулей из backend_modules  
✅ **Минимальная настройка** - нужно только скопировать и настроить конфиг  
✅ **Расширение при необходимости** - добавляем дополнительные endpoints  
✅ **Совместимость** - модули спроектированы для работы с Flutter и Admin панелью  

### Что есть в backend_modules

| Модуль | Статус | Что дает |
|--------|--------|----------|
| `core_module` | ✅ Готов | Middleware, utils, типы, стандартизация |
| `database_module` | ✅ Готов | PostgreSQL + 27 миграций |
| `auth_module` | ✅ Готов | JWT, регистрация, верификация |
| `users_module` | ✅ Готов | Профили, аватары, настройки |
| `nutrition_module` | ✅ Готов | Планы питания, продукты, КБЖУ |
| `knowledge_module` | ✅ Готов | Курсы, уроки, категории |
| `diary_module` | ✅ Готов | Дневник питания, трекинг воды |
| `lab_module` | ✅ Готов | Лабораторные анализы, результаты |
| `survey_module` | ✅ Готов | Опросники, анкеты |
| `ai_chat_module` | ✅ Готов | OpenAI интеграция, история чатов |
| `subscription_module` | ✅ Готов | Подписки, платежи |
| `files_module` | ✅ Готов | Загрузка файлов (images, videos) |
| `analytics_module` | ✅ Готов | Статистика, метрики |

**Итого**: 13 модулей (100% готовы) + ~100 endpoints + 27 миграций

---

## 13. Backend модули готовые к использованию

### 13.1 core_module ⚙️

**Статус**: ✅ Готов к использованию

**Что включает:**
- Auth middleware (JWT проверка)
- Валидация схем (Zod)
- Стандартизация ответов API
- Утилиты (crypto, date helpers)
- Общие TypeScript типы

**Что делать:**
```bash
# Скопировать модуль
cp -r backend_modules/core_module backend/src/modules/

# Использовать middleware
import { authMiddleware } from '@/modules/core_module'

fastify.addHook('onRequest', authMiddleware)
```

### 13.2 database_module 🗄️

**Статус**: ✅ Готов к использованию

**Что включает:**
- Подключение к PostgreSQL (pg)
- Connection pooling
- **27 готовых миграций** для создания таблиц
- Seed данные (опционально)

**Миграции создают таблицы для:**
- Users, user_profiles
- Nutrition_plans, products, meals
- Courses, lessons, categories
- Diary_entries, water_tracking
- Lab_tests, lab_results
- AI_conversations, ai_messages
- Subscriptions, payments
- Survey_responses
- Files

**Что делать:**
```bash
# 1. Скопировать модуль
cp -r backend_modules/database_module backend/src/modules/

# 2. Настроить .env
DATABASE_URL=postgresql://user:password@localhost:5432/brix_nutrition

# 3. Запустить миграции
npm run db:migrate
```

### 13.3 auth_module 🔐

**Статус**: ✅ Готов к использованию

**Endpoints:**
```
POST /api/auth/register         # Регистрация
POST /api/auth/login            # Вход
POST /api/auth/verify-email     # Подтверждение email
POST /api/auth/reset-password   # Сброс пароля
POST /api/auth/refresh-token    # Обновление токена
```

**Что делать:**
```bash
cp -r backend_modules/auth_module backend/src/modules/
```

### 13.4 nutrition_module 🍽️

**Статус**: ✅ Готов к использованию

**Endpoints:**
```
GET    /api/nutrition/plans          # Список планов
POST   /api/nutrition/plans          # Создать план
GET    /api/nutrition/plans/:id      # Детали плана
PUT    /api/nutrition/plans/:id      # Обновить план
DELETE /api/nutrition/plans/:id      # Удалить план

GET    /api/nutrition/products       # Список продуктов
POST   /api/nutrition/products       # Добавить продукт
```

### 13.5 ai_chat_module 🤖

**Статус**: ✅ Готов к использованию (нужен OpenAI API ключ)

**Endpoints:**
```
GET    /api/ai-chat/conversations                    # История чатов
POST   /api/ai-chat/conversations/:id/messages       # Отправить сообщение
DELETE /api/ai-chat/conversations/:id                # Удалить чат
```

**Настройка:**
```env
OPENAI_API_KEY=sk-...
```

---

## 14. Настройка Backend проекта

### Шаг 1: Инициализация проекта

```bash
mkdir backend
cd backend

# Инициализация package.json
npm init -y

# Установка зависимостей
npm install fastify @fastify/jwt @fastify/cors @fastify/swagger \
  @fastify/multipart typescript zod bcryptjs pg openai resend \
  jsonwebtoken dotenv

npm install --save-dev @types/node @types/bcryptjs @types/jsonwebtoken \
  @types/pg tsx jest ts-jest @types/jest
```

### Шаг 2: Копирование модулей

```bash
# Создать структуру
mkdir -p src/modules

# Скопировать все модули
cp -r ../backend_modules/* src/modules/

# Структура:
# backend/
# ├── src/
# │   ├── index.ts
# │   └── modules/
# │       ├── core_module/
# │       ├── database_module/
# │       ├── auth_module/
# │       └── ... (остальные 10 модулей)
```

### Шаг 3: Настройка Fastify

```typescript
// src/index.ts
import Fastify from 'fastify'
import { authRoutes } from './modules/auth_module'
import { nutritionRoutes } from './modules/nutrition_module'
// ... импорт остальных модулей

const fastify = Fastify({ logger: true })

// Регистрация модулей
await fastify.register(authRoutes, { prefix: '/api/auth' })
await fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })
// ... регистрация остальных

// Запуск сервера
await fastify.listen({ port: 3000, host: '0.0.0.0' })
```

### Шаг 4: Настройка базы данных

```bash
# 1. Создать БД
createdb brix_nutrition

# 2. Настроить .env
DATABASE_URL=postgresql://user:password@localhost:5432/brix_nutrition

# 3. Запустить миграции
npm run db:migrate
```

### Шаг 5: Тестирование

```bash
# Запуск dev сервера
npm run dev

# Проверка endpoints
curl http://localhost:3000/api/health
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password123"}'
```

---

## 15. Checklist миграции Backend

### Фаза 1: Инициализация (1 день)

- [ ] ✅ Создать директорию `backend/`
- [ ] ✅ Инициализировать npm проект
- [ ] ✅ Установить зависимости (Fastify, PostgreSQL, TypeScript)
- [ ] ✅ Скопировать все `backend_modules/` в `backend/src/modules/`
- [ ] ✅ Создать `.env` файл
- [ ] ✅ Настроить `tsconfig.json`

### Фаза 2: База данных (1 день)

- [ ] ✅ Создать PostgreSQL базу данных `brix_nutrition`
- [ ] ✅ Настроить `DATABASE_URL` в `.env`
- [ ] ✅ Запустить 27 миграций из `database_module`
- [ ] ✅ Проверить создание всех таблиц
- [ ] ✅ (Опционально) Запустить seed данные для тестирования

### Фаза 3: Core модули (2 дня)

- [ ] ✅ `core_module` — настроить middleware
- [ ] ✅ `database_module` — подключить к PostgreSQL
- [ ] ✅ `auth_module` — настроить JWT_SECRET
- [ ] ✅ Создать `src/index.ts` для запуска Fastify
- [ ] ✅ Запустить dev сервер (`npm run dev`)

### Фаза 4: Основные модули (1 неделя)

- [ ] ✅ `users_module` — тестировать CRUD пользователей
- [ ] ✅ `nutrition_module` — тестировать планы питания
- [ ] ✅ `knowledge_module` — тестировать курсы и уроки
- [ ] ✅ `diary_module` — тестировать дневник питания

### Фаза 5: Дополнительные модули (1 неделя)

- [ ] ✅ `lab_module` — тестировать анализы
- [ ] ✅ `survey_module` — тестировать опросники
- [ ] ✅ `ai_chat_module` — настроить OPENAI_API_KEY
- [ ] ✅ `subscription_module` — тестировать подписки
- [ ] ✅ `files_module` — настроить загрузку файлов
- [ ] ✅ `analytics_module` — тестировать статистику

### Фаза 6: Интеграции (1-2 недели)

- [ ] 🔌 OpenAI (AI консультант)
  - [ ] Настроить API ключ
  - [ ] Тестировать чат
  
- [ ] 🔌 Email (Resend)
  - [ ] Настроить API ключ
  - [ ] Тестировать отправку писем
  
- [ ] 🔌 SMS (Twilio / SMS.ru)
  - [ ] Настроить API ключ
  - [ ] Тестировать отправку SMS
  
- [ ] 🔌 Payments (Stripe)
  - [ ] Настроить API ключ
  - [ ] Тестировать платежи

### Фаза 7: Тестирование (1 неделя)

- [ ] ✅ Unit тесты (Jest)
- [ ] ✅ Integration тесты
- [ ] ✅ E2E тесты для основных endpoints
- [ ] ✅ Нагрузочное тестирование
- [ ] ✅ Безопасность (JWT, валидация)

**Итого:** ~3-4 недели настройки Backend

---

## 16. Сводная таблица всех модулей

### Flutter модули (dev_modules/)

| Модуль | Статус | Трудоемкость | Приоритет |
|--------|--------|--------------|-----------|
| `core_module` | ✅ Без изменений | 1 час | 1 |
| `ui_kit_module` | ⚠️ Изменения | 1 день | 1 |
| `auth_module` | ⚠️ Расширение | 1 неделя | 1 |
| `onboarding_module` | ⚠️ Изменения | 3 дня | 1 |
| `home_module` | 🔄 Переделка | 1 неделя | 2 |
| `plans_module` | ⚠️ Расширение | 2 недели | 2 |
| `diary_module` | ⚠️ Расширение | 1 неделя | 2 |
| `ai_chat_module` | ⚠️ Расширение | 1 неделя | 3 |
| `checkup_module` | ⚠️ Расширение | 1 неделя | 3 |
| `knowledge_module` | ⚠️ Расширение | 1 неделя | 3 |
| `subscription_module` | ✅ Без изменений | 1 день | 3 |
| `profile_module` | ✅ Без изменений | 1 день | 3 |
| `tab_bar_module` | ✅ Без изменений | 1 час | 1 |
| `blog_module` | 🆕 Новый | 1 неделя | 2 |
| `notifications_module` | 🆕 Новый | 1 неделя | 2 |

**Итого Flutter**: ~15 недель разработки

### React модули (admin_modules/)

| Модуль | Статус | Трудоемкость | Приоритет |
|--------|--------|--------------|-----------|
| `core_module` | ⚠️ Адаптация API | 3 дня | 1 |
| `ui_components_module` | ✅ Без изменений | 1 час | 1 |
| `dashboard_module` | ⚠️ Адаптация | 2 дня | 1 |
| `courses_module` | ⚠️ Интеграция | 1 неделя | 2 |
| `lessons_module` | ⚠️ Интеграция | 1 неделя | 2 |
| `categories_module` | ✅ Без изменений | 1 день | 2 |
| `nutrition_plans_module` | ⚠️ Адаптация | 1 неделя | 2 |
| `analytics_module` | ⚠️ Завершить | 1 неделя | 3 |
| `recipes_module` | 🆕 Новый | 2 недели | 1 |
| `lab_tests_module` | 🆕 Новый | 1 неделя | 3 |
| `blog_module` | 🆕 Новый | 1 неделя | 2 |
| `users_module` | 🆕 Новый | 1 неделя | 2 |
| `subscriptions_module` | 🆕 Новый | 1 неделя | 3 |

**Итого Admin**: ~10 недель разработки

### Backend модули (backend_modules/)

| Модуль | Статус | Трудоемкость | Приоритет |
|--------|--------|--------------|-----------|
| `core_module` | ✅ Готов | 1 день | 1 |
| `database_module` | ✅ Готов | 1 день | 1 |
| `auth_module` | ✅ Готов | 1 день | 1 |
| `users_module` | ✅ Готов | 1 день | 1 |
| `nutrition_module` | ✅ Готов | 1 день | 2 |
| `knowledge_module` | ✅ Готов | 1 день | 2 |
| `diary_module` | ✅ Готов | 1 день | 2 |
| `lab_module` | ✅ Готов | 1 день | 3 |
| `survey_module` | ✅ Готов | 1 день | 3 |
| `ai_chat_module` | ✅ Готов + настройка OpenAI | 2 дня | 3 |
| `subscription_module` | ✅ Готов + настройка Stripe | 2 дня | 3 |
| `files_module` | ✅ Готов + настройка storage | 1 день | 2 |
| `analytics_module` | ✅ Готов | 1 день | 3 |

**Итого Backend**: ~3-4 недели настройки и интеграций

---

## 17. Общие приоритеты

### Критичные (MVP) - Backend First!
1. ⚙️ **Backend**: Скопировать все модули → Запустить миграции БД → Тестировать endpoints
2. ✅ Flutter: Auth + SMS
3. ✅ Flutter: Onboarding
4. ✅ Flutter: Home
5. ✅ Flutter: Meal Plan (Рацион)
6. ✅ Flutter: Diary
7. ⚙️ Admin: Core + Dashboard
8. ⚙️ Admin: Courses + Lessons
9. ⚙️ Admin: Recipes

### Важные
10. ⚙️ Backend: Интеграция OpenAI
11. ⚙️ Backend: Интеграция SMS
12. ✅ Flutter: Blog
13. ✅ Flutter: Notifications
14. ⚙️ Admin: Nutrition Plans
15. ⚙️ Admin: Users
16. ⚙️ Admin: Blog

### Желательные
17. ⚙️ Backend: Интеграция Stripe
18. ✅ Flutter: AI Chat (базовый)
19. ✅ Flutter: Lab Tests (интерпретации)
20. ✅ Flutter: Knowledge (прогресс)
21. ⚙️ Admin: Lab Tests (справочник)
22. ⚙️ Admin: Subscriptions
23. ⚙️ Admin: Analytics

---

## 🎯 Приоритеты

### Критичные (MVP)
1. Auth + SMS
2. Onboarding
3. Home
4. Meal Plan (Рацион)
5. Diary

### Важные
6. Blog
7. Notifications
8. AI Chat (базовый)

### Желательные
9. Lab Tests (интерпретации)
10. Knowledge (прогресс)
11. Subscription
12. Profile

---

**Версия**: 3.0.0  
**Обновлено**: 10 октября 2025 (добавлены backend_modules)  
**Компоненты**: Backend (Fastify + 13 модулей) + Mobile (Flutter + 14 модулей) + Admin Web (Next.js + 8 модулей)  
**Всего модулей**: 35 (13 backend + 14 flutter + 8 react)

