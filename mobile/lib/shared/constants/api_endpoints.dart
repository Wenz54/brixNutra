/// API Endpoints для Brix Nutrition App
///
/// Централизованное хранение всех endpoints API
class ApiEndpoints {
  // ==================== AUTH ====================
  
  /// Email авторизация - отправка кода
  static const authEmailSendCode = '/auth/email/send-code';
  
  /// Email авторизация - проверка кода
  static const authEmailVerifyCode = '/auth/email/verify-code';
  
  /// Email авторизация - установка пароля для нового пользователя
  static const authEmailSetPassword = '/auth/email/set-password';
  
  /// Phone авторизация - отправка SMS кода
  static const authPhoneSendCode = '/auth/phone/send-code';
  
  /// Phone авторизация - проверка SMS кода
  static const authPhoneVerifyCode = '/auth/phone/verify-code';
  
  /// Refresh JWT token
  static const authRefreshToken = '/auth/refresh-token';
  
  /// Logout
  static const authLogout = '/auth/logout';

  // ==================== PROFILE ====================
  
  /// Получить профиль пользователя
  static const profileMe = '/profile/me';
  
  /// Обновить профиль
  static const profileUpdate = '/profile/update';
  
  /// Получить цели пользователя
  static const profileGoals = '/profile/goals';
  
  /// Обновить цели
  static const profileGoalsUpdate = '/profile/goals/update';
  
  /// Получить измерения (вес, рост и т.д.)
  static const profileMeasurements = '/profile/measurements';
  
  /// Добавить измерение
  static const profileMeasurementsAdd = '/profile/measurements/add';
  
  /// Получить активности пользователя
  static const profileActivities = '/profile/activities';

  // ==================== RECIPES ====================
  
  /// Список рецептов (с фильтрами)
  static const recipes = '/recipes';
  
  /// Детали рецепта
  static String recipe(String id) => '/recipes/$id';
  
  /// Альтернативные рецепты (замена)
  static String recipeAlternatives(String id) => '/recipes/$id/alternatives';

  // ==================== MEAL PLAN ====================
  
  /// Получить текущий план питания пользователя
  static const mealPlanCurrent = '/meal-plan/current';
  
  /// Получить план на конкретный день
  static String mealPlanDay(String date) => '/meal-plan/day/$date';
  
  /// Заменить блюдо в плане
  static const mealPlanReplace = '/meal-plan/replace';

  // ==================== DIARY ====================
  
  /// Получить дневник за день
  static String diaryDay(String date) => '/diary/day/$date';
  
  /// Добавить прием пищи в дневник
  static const diaryMeal = '/diary/meal';
  
  /// Удалить прием пищи
  static String diaryMealDelete(String id) => '/diary/meal/$id';
  
  /// Логирование воды
  static const diaryWater = '/diary/water';
  
  /// Получить потребление воды за день
  static String diaryWaterDay(String date) => '/diary/water/$date';
  
  /// Обновить настроение
  static const diaryMood = '/diary/mood';
  
  /// Завершить день
  static const diaryDayStatus = '/diary/day-status';
  
  /// История дневника
  static const diaryHistory = '/diary/history';
  
  /// Обновить дневные цели
  static String diaryGoals(String date) => '/diary/goals/$date';

  // ==================== KNOWLEDGE BASE ====================
  
  /// Список курсов
  static const knowledgeCourses = '/knowledge/courses';
  
  /// Детали курса
  static String knowledgeCourse(String id) => '/knowledge/courses/$id';
  
  /// Уроки курса
  static String knowledgeCourseLessons(String courseId) => 
      '/knowledge/courses/$courseId/lessons';
  
  /// Детали урока
  static String knowledgeLesson(String id) => '/knowledge/lessons/$id';
  
  /// Отметить урок как пройденный
  static String knowledgeLessonComplete(String id) => 
      '/knowledge/lessons/$id/complete';
  
  /// Прогресс по курсу
  static String knowledgeCourseProgress(String courseId) => 
      '/knowledge/courses/$courseId/progress';
  
  /// Категории курсов
  static const knowledgeCategories = '/knowledge/categories';
  
  /// Избранное (favorites)
  static const knowledgeFavorites = '/knowledge/favorites';
  
  /// Добавить в избранное
  static const knowledgeFavoritesAdd = '/knowledge/favorites';
  
  /// Удалить из избранного
  static String knowledgeFavoritesDelete(String id) => '/knowledge/favorites/$id';

  // ==================== LAB TESTS ====================
  
  /// Загрузить результаты анализов
  static const labTestsUpload = '/lab-tests/upload';
  
  /// Мои анализы
  static const labTestsMy = '/lab-tests/my';
  
  /// Детали анализа
  static String labTest(String id) => '/lab-tests/$id';
  
  /// Интерпретация анализа
  static String labTestInterpretation(String id) => '/lab-tests/$id/interpretation';
  
  /// Список доступных параметров
  static const labTestsParameters = '/lab-tests/parameters';
  
  /// Тренд показателя
  static String labTestParameterTrend(String code) => '/lab-tests/trend/$code';
  
  /// Удалить анализ
  static String labTestDelete(String id) => '/lab-tests/$id';

  // ==================== AI CHAT ====================
  
  /// Отправить сообщение AI
  static const aiChatMessage = '/ai-chat/message';
  
  /// История чатов
  static const aiChatHistory = '/ai-chat/sessions';
  
  /// Сообщения в чате
  static String aiChatMessages(String sessionId) => '/ai-chat/sessions/$sessionId';
  
  /// Удалить чат
  static String aiChatDelete(String sessionId) => '/ai-chat/sessions/$sessionId';
  
  /// Новая сессия
  static const aiChatNewSession = '/ai-chat/sessions';

  // ==================== BLOG ====================
  
  /// Список статей
  static const blogArticles = '/blog/articles';
  
  /// Детали статьи
  static String blogArticle(String id) => '/blog/articles/$id';

  // ==================== NOTIFICATIONS ====================
  
  /// Список уведомлений
  static const notifications = '/notifications';
  
  /// Отметить как прочитанное
  static String notificationRead(String id) => '/notifications/$id/read';
  
  /// Удалить уведомление
  static String notificationDelete(String id) => '/notifications/$id';

  // ==================== FILES ====================
  
  /// Загрузить один файл
  static const filesUpload = '/files/upload';
  
  /// Загрузить несколько файлов
  static const filesUploadMultiple = '/files/upload-multiple';

  // ==================== SUBSCRIPTIONS ====================
  
  /// Список тарифов
  static const subscriptionsPlans = '/subscriptions/plans';
  
  /// Моя подписка
  static const subscriptionsMy = '/subscriptions/my';
  
  /// Оформить подписку
  static const subscriptionsSubscribe = '/subscriptions/subscribe';
  
  /// Отменить подписку
  static const subscriptionsCancel = '/subscriptions/cancel';

  // ==================== HOME DASHBOARD ====================
  
  /// Данные для главного экрана
  static const homeDashboard = '/home/dashboard';
}


