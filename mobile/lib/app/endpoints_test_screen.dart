import 'package:flutter/material.dart';
import 'package:mobile/features/meal_plan/services/meal_plan_service.dart';
import 'package:mobile/features/diary/services/diary_service.dart';
import 'package:mobile/features/ai_chat/services/ai_chat_service.dart';
import 'package:mobile/features/lab_tests/services/lab_tests_service.dart';
import 'package:mobile/features/knowledge_base/services/knowledge_base_service.dart';
import 'package:mobile/features/blog_notifications/services/blog_notifications_service.dart';
import 'package:mobile/features/subscriptions/services/subscriptions_service.dart';
import 'package:mobile/dev_modules/core_module/services/token_manager.dart';

/// Тестовый экран для проверки всех API endpoints
///
/// Используется для:
/// - Тестирования подключения к Backend
/// - Проверки работы всех endpoints
/// - Отладки API запросов
class EndpointsTestScreen extends StatefulWidget {
  const EndpointsTestScreen({super.key});

  @override
  State<EndpointsTestScreen> createState() => _EndpointsTestScreenState();
}

class _EndpointsTestScreenState extends State<EndpointsTestScreen> {
  final List<String> _testResults = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Endpoints Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _testResults.clear();
              });
            },
            tooltip: 'Очистить логи',
          ),
        ],
      ),
      body: Column(
        children: [
          // Auth Status
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Backend: http://10.0.2.2:3000/api',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<bool>(
                        future: TokenManager.isAuthenticated(),
                        builder: (context, snapshot) {
                          final isAuth = snapshot.data ?? false;
                          return Text(
                            isAuth ? '✅ Токен установлен' : '⚠️ Токен НЕ установлен',
                            style: TextStyle(
                              fontSize: 12,
                              color: isAuth ? Colors.green : Colors.orange,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Test Buttons Grid
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildTestButton(
                  icon: Icons.restaurant_menu,
                  label: 'Meal Plan',
                  onPressed: _testMealPlan,
                ),
                _buildTestButton(
                  icon: Icons.book,
                  label: 'Diary',
                  onPressed: _testDiary,
                ),
                _buildTestButton(
                  icon: Icons.chat_bubble,
                  label: 'AI Chat',
                  onPressed: _testAiChat,
                ),
                _buildTestButton(
                  icon: Icons.science,
                  label: 'Lab Tests',
                  onPressed: _testLabTests,
                ),
                _buildTestButton(
                  icon: Icons.school,
                  label: 'Knowledge',
                  onPressed: _testKnowledge,
                ),
                _buildTestButton(
                  icon: Icons.article,
                  label: 'Blog',
                  onPressed: _testBlog,
                ),
                _buildTestButton(
                  icon: Icons.notifications,
                  label: 'Notifications',
                  onPressed: _testNotifications,
                ),
                _buildTestButton(
                  icon: Icons.card_membership,
                  label: 'Subscriptions',
                  onPressed: _testSubscriptions,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Test ALL button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testAllEndpoints,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Тестировать ВСЕ Endpoints'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _setMockToken,
                  icon: const Icon(Icons.key),
                  label: const Text('Set Token'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),

          // Results Log
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _testResults.isEmpty
                  ? const Center(
                      child: Text(
                        'Нажмите кнопку для тестирования endpoint',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        final result = _testResults[_testResults.length - 1 - index];
                        final isError = result.contains('❌');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            result,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: isError ? Colors.red : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: _isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _log(String message) {
    setState(() {
      _testResults.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
  }

  Future<void> _setMockToken() async {
    // Установить mock токен для тестирования
    await TokenManager.saveAuth(
      accessToken: 'mock_jwt_token_for_testing',
      userId: 'test-user-id',
      email: 'test@example.com',
      name: 'Test User',
    );
    _log('✅ Mock токен установлен');
    setState(() {});
  }

  Future<void> _testMealPlan() async {
    setState(() => _isLoading = true);
    _log('🍽️ Testing Meal Plan...');

    try {
      // Test 1: Get current plan
      final plan = await MealPlanService.getCurrentPlan();
      _log('✅ GET /meal-plan/current: ${plan.name}');

      // Test 2: Get plan for today
      final dayPlan = await MealPlanService.getPlanForDay(DateTime.now());
      _log('✅ GET /meal-plan/day: ${dayPlan.meals.length} meals');

      // Test 3: Get recipe
      if (dayPlan.meals.isNotEmpty) {
        final recipe = await MealPlanService.getRecipe(dayPlan.meals.first.recipe.id);
        _log('✅ GET /recipes/${recipe.id}: ${recipe.name}');
      }
    } catch (e) {
      _log('❌ Meal Plan Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testDiary() async {
    setState(() => _isLoading = true);
    _log('📔 Testing Diary...');

    try {
      // Test 1: Get today's diary
      final diary = await DiaryService.getDayDiary(DateTime.now());
      _log('✅ GET /diary/day: ${diary.meals.length} meals, ${diary.stats.totalCalories} kcal');

      // Test 2: Get history
      final history = await DiaryService.getHistory(
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now(),
      );
      _log('✅ GET /diary/history: ${history.length} days');
    } catch (e) {
      _log('❌ Diary Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testAiChat() async {
    setState(() => _isLoading = true);
    _log('🤖 Testing AI Chat...');

    try {
      // Test 1: Get sessions
      final sessions = await AiChatService.getSessions();
      _log('✅ GET /ai-chat/sessions: ${sessions.length} sessions');

      // Test 2: Create session and send message
      final message = await AiChatService.sendMessage(
        message: 'Привет! Какие продукты богаты белком?',
        context: null,
      );
      _log('✅ POST /ai-chat/message: Response ${message.content.substring(0, 50)}...');
    } catch (e) {
      _log('❌ AI Chat Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testLabTests() async {
    setState(() => _isLoading = true);
    _log('🧪 Testing Lab Tests...');

    try {
      // Test 1: Get user tests
      final tests = await LabTestsService.getMyTests();
      _log('✅ GET /lab-tests/my: ${tests.length} tests');

      // Test 2: Get parameters
      final params = await LabTestsService.getAvailableParameters();
      _log('✅ GET /lab-tests/parameters: ${params.length} parameters');
    } catch (e) {
      _log('❌ Lab Tests Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testKnowledge() async {
    setState(() => _isLoading = true);
    _log('📚 Testing Knowledge Base...');

    try {
      // Test 1: Get courses
      final courses = await KnowledgeBaseService.getCourses();
      _log('✅ GET /knowledge/courses: ${courses.length} courses');

      // Test 2: Get categories
      final categories = await KnowledgeBaseService.getCategories();
      _log('✅ GET /knowledge/categories: ${categories.length} categories');

      // Test 3: Get favorites
      final favorites = await KnowledgeBaseService.getFavorites();
      _log('✅ GET /knowledge/favorites: ${favorites.length} items');
    } catch (e) {
      _log('❌ Knowledge Base Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testBlog() async {
    setState(() => _isLoading = true);
    _log('📰 Testing Blog...');

    try {
      final articles = await BlogNotificationsService.getBlogArticles(limit: 10);
      _log('✅ GET /blog/articles: ${articles.length} articles');
    } catch (e) {
      _log('❌ Blog Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testNotifications() async {
    setState(() => _isLoading = true);
    _log('🔔 Testing Notifications...');

    try {
      // Test 1: Get notifications
      final notifications = await BlogNotificationsService.getNotifications();
      _log('✅ GET /notifications: ${notifications.length} notifications');

      // Test 2: Get stats
      final stats = await BlogNotificationsService.getNotificationStats();
      _log('✅ GET /notifications/stats: ${stats.unread} unread, ${stats.total} total');
    } catch (e) {
      _log('❌ Notifications Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testSubscriptions() async {
    setState(() => _isLoading = true);
    _log('💳 Testing Subscriptions...');

    try {
      // Test 1: Get plans
      final plans = await SubscriptionsService.getPlans();
      _log('✅ GET /subscriptions/plans: ${plans.length} plans');

      // Test 2: Get my subscription
      final mySub = await SubscriptionsService.getMySubscription();
      if (mySub != null) {
        _log('✅ GET /subscriptions/my: ${mySub.planName} - ${mySub.status}');
      } else {
        _log('ℹ️ GET /subscriptions/my: No active subscription');
      }
    } catch (e) {
      _log('❌ Subscriptions Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testAllEndpoints() async {
    _log('🚀 ========== TESTING ALL ENDPOINTS ==========');
    await _testMealPlan();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testDiary();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testAiChat();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testLabTests();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testKnowledge();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testBlog();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testNotifications();
    await Future.delayed(const Duration(milliseconds: 500));
    await _testSubscriptions();
    _log('🏁 ========== ALL TESTS COMPLETED ==========');
  }
}

