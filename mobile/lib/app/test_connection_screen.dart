import 'package:flutter/material.dart';
import '../dev_modules/core_module/services/api_service.dart';
import '../shared/constants/api_endpoints.dart';
import '../dev_modules/core_module/config/api_config.dart';

/// Экран для тестирования подключения к Backend API
class TestConnectionScreen extends StatefulWidget {
  const TestConnectionScreen({super.key});

  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  String _status = 'Нажмите кнопку для проверки подключения';
  bool _isLoading = false;
  Color _statusColor = Colors.grey;

  /// Тест 1: Проверка доступности backend
  Future<void> _testBackendHealth() async {
    setState(() {
      _isLoading = true;
      _status = 'Проверяем подключение к backend...';
      _statusColor = Colors.orange;
    });

    try {
      // Пробуем простой GET запрос
      final response = await ApiService.get('/health');
      
      setState(() {
        _isLoading = false;
        _status = '✅ Backend доступен!\n\nResponse: ${response.toString()}';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Ошибка подключения:\n\n$e\n\n'
            'Убедитесь что:\n'
            '• Backend запущен (npm run dev)\n'
            '• Backend слушает localhost:3000\n'
            '• Android эмулятор настроен на 10.0.2.2';
        _statusColor = Colors.red;
      });
    }
  }

  /// Тест 2: Проверка получения рецептов
  Future<void> _testRecipesEndpoint() async {
    setState(() {
      _isLoading = true;
      _status = 'Получаем рецепты с backend...';
      _statusColor = Colors.orange;
    });

    try {
      final response = await ApiService.get(
        ApiEndpoints.recipes,
        queryParameters: {
          'limit': '5',
        },
      );
      
      final recipes = response['data'] ?? response['recipes'] ?? [];
      final total = response['total'] ?? response['pagination']?['total'] ?? 0;
      
      setState(() {
        _isLoading = false;
        _status = '✅ Рецепты получены!\n\n'
            'Всего: $total\n'
            'Получено: ${recipes.length}\n\n'
            'Первый рецепт:\n${recipes.isNotEmpty ? recipes[0].toString() : "Нет данных"}';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Ошибка получения рецептов:\n\n$e';
        _statusColor = Colors.red;
      });
    }
  }

  /// Тест 3: Проверка отправки SMS кода
  Future<void> _testSendSmsCode() async {
    setState(() {
      _isLoading = true;
      _status = 'Отправляем тестовый SMS код...';
      _statusColor = Colors.orange;
    });

    try {
      final response = await ApiService.post(
        ApiEndpoints.authEmailSendCode,
        {
          'email': 'test@example.com',
        },
      );
      
      setState(() {
        _isLoading = false;
        _status = '✅ SMS код отправлен!\n\nResponse:\n${response.toString()}';
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Ошибка отправки SMS:\n\n$e';
        _statusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // API Config Info
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'API Configuration:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Base URL: ${ApiConfig.baseUrl}'),
                      Text('Connect Timeout: ${ApiConfig.connectTimeout}s'),
                      Text('Receive Timeout: ${ApiConfig.receiveTimeout}s'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Test Buttons
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testBackendHealth,
                icon: const Icon(Icons.health_and_safety),
                label: const Text('Test 1: Backend Health Check'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              
              const SizedBox(height: 12),
              
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testRecipesEndpoint,
                icon: const Icon(Icons.restaurant),
                label: const Text('Test 2: Get Recipes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              
              const SizedBox(height: 12),
              
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testSendSmsCode,
                icon: const Icon(Icons.sms),
                label: const Text('Test 3: Send SMS Code'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Status Display
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    border: Border.all(color: _statusColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        Text(
                          _status,
                          style: TextStyle(
                            color: _statusColor.withOpacity(0.8),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


