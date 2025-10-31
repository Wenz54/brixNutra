import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/sms_auth/sms_auth.dart';

/// Тестовый экран для проверки SMS Auth логики (Mock режим)
///
/// Простой UI для тестирования всех флоу авторизации без реального backend
class TestSmsAuthScreen extends StatefulWidget {
  const TestSmsAuthScreen({super.key});

  @override
  State<TestSmsAuthScreen> createState() => _TestSmsAuthScreenState();
}

class _TestSmsAuthScreenState extends State<TestSmsAuthScreen> {
  final _identifierController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isEmail = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SmsAuthBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🎭 SMS Auth Test (Mock)'),
          centerTitle: true,
        ),
        body: BlocListener<SmsAuthBloc, SmsAuthState>(
          listener: (context, state) {
            // Показываем SnackBar для информирования
            if (state is SmsAuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            
            if (state is CodeVerifiedExistingUser) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Вход выполнен: ${state.user.email}'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            
            if (state is PasswordSetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Регистрация завершена: ${state.user.email}'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: BlocBuilder<SmsAuthBloc, SmsAuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Подсказка о mock режиме
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎭 Mock Режим',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Используйте код: 1234\n'
                            'Email с "new" → новый пользователь (нужен пароль)\n'
                            'Phone → всегда существующий (без пароля)',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Выбор типа авторизации
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('📧 Email'),
                            selected: _isEmail,
                            onSelected: (selected) {
                              setState(() => _isEmail = true);
                              _identifierController.clear();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('📱 Phone'),
                            selected: !_isEmail,
                            onSelected: (selected) {
                              setState(() => _isEmail = false);
                              _identifierController.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Текущее состояние
                    _buildCurrentState(state),
                    
                    const SizedBox(height: 24),
                    
                    // Контент в зависимости от состояния
                    _buildContent(context, state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentState(SmsAuthState state) {
    String stateText;
    Color stateColor;
    
    if (state is SmsAuthInitial) {
      stateText = '🔵 Начальное состояние';
      stateColor = Colors.blue;
    } else if (state is SmsAuthLoading) {
      stateText = '⏳ ${state.message ?? "Загрузка..."}';
      stateColor = Colors.orange;
    } else if (state is CodeSentSuccess) {
      stateText = '✅ Код отправлен';
      stateColor = Colors.green;
    } else if (state is CodeVerifiedNewUser) {
      stateText = '🆕 Новый пользователь';
      stateColor = Colors.purple;
    } else if (state is CodeVerifiedExistingUser) {
      stateText = '✅ Вход выполнен';
      stateColor = Colors.green;
    } else if (state is PasswordSetSuccess) {
      stateText = '✅ Регистрация завершена';
      stateColor = Colors.green;
    } else if (state is SmsAuthError) {
      stateText = '❌ Ошибка';
      stateColor = Colors.red;
    } else {
      stateText = state.toString();
      stateColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: stateColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: stateColor),
      ),
      child: Text(
        'Состояние: $stateText',
        style: TextStyle(
          color: stateColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, SmsAuthState state) {
    // Начальное состояние или ошибка - ввод email/phone
    if (state is SmsAuthInitial || state is SmsAuthError) {
      return _buildSendCodeForm(context);
    }
    
    // Код отправлен - ввод кода
    if (state is CodeSentSuccess) {
      return _buildVerifyCodeForm(context, state);
    }
    
    // Новый пользователь - создание пароля
    if (state is CodeVerifiedNewUser) {
      return _buildSetPasswordForm(context, state);
    }
    
    // Вход выполнен - успешная авторизация
    if (state is CodeVerifiedExistingUser || state is PasswordSetSuccess) {
      return _buildSuccessScreen(context, state);
    }
    
    // Загрузка
    if (state is SmsAuthLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка...'),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  // Форма отправки кода
  Widget _buildSendCodeForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _identifierController,
          decoration: InputDecoration(
            labelText: _isEmail ? 'Email' : 'Телефон',
            hintText: _isEmail 
                ? 'test@example.com или new@example.com' 
                : '+79991234567',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(_isEmail ? Icons.email : Icons.phone),
          ),
          keyboardType: _isEmail 
              ? TextInputType.emailAddress 
              : TextInputType.phone,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final identifier = _identifierController.text.trim();
            if (identifier.isEmpty) return;
            
            if (_isEmail) {
              context.read<SmsAuthBloc>().add(
                SendCodeToEmailRequested(identifier),
              );
            } else {
              context.read<SmsAuthBloc>().add(
                SendCodeToPhoneRequested(identifier),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(_isEmail ? 'Отправить код на Email' : 'Отправить SMS'),
        ),
      ],
    );
  }
  
  // Форма проверки кода
  Widget _buildVerifyCodeForm(BuildContext context, CodeSentSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Код отправлен на:\n${state.identifier}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Код верификации',
            hintText: '1234',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          keyboardType: TextInputType.number,
          maxLength: 4,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final code = _codeController.text.trim();
            if (code.isEmpty) return;
            
            if (state.isEmail) {
              context.read<SmsAuthBloc>().add(
                VerifyEmailCodeRequested(
                  email: state.identifier,
                  code: code,
                ),
              );
            } else {
              context.read<SmsAuthBloc>().add(
                VerifyPhoneCodeRequested(
                  phone: state.identifier,
                  code: code,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Проверить код'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            context.read<SmsAuthBloc>().add(const ResetAuthState());
            _codeController.clear();
          },
          child: const Text('Вернуться назад'),
        ),
      ],
    );
  }
  
  // Форма установки пароля
  Widget _buildSetPasswordForm(BuildContext context, CodeVerifiedNewUser state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '🆕 Вы новый пользователь!\nСоздайте пароль:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Пароль',
            hintText: 'Минимум 8 символов',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final password = _passwordController.text.trim();
            if (password.isEmpty || password.length < 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Пароль должен быть минимум 8 символов'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            
            context.read<SmsAuthBloc>().add(
              SetPasswordRequested(
                email: state.email,
                password: password,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Создать пароль'),
        ),
      ],
    );
  }
  
  // Экран успешной авторизации
  Widget _buildSuccessScreen(BuildContext context, SmsAuthState state) {
    String userName = '';
    String userEmail = '';
    
    if (state is CodeVerifiedExistingUser) {
      userName = state.user.name ?? '';
      userEmail = state.user.email;
    } else if (state is PasswordSetSuccess) {
      userName = state.user.name ?? '';
      userEmail = state.user.email;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        Text(
          'Добро пожаловать!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          userName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // TODO: Навигация на главный экран
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Здесь будет переход на главный экран'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('На главный экран'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            context.read<SmsAuthBloc>().add(const ResetAuthState());
            _identifierController.clear();
            _codeController.clear();
            _passwordController.clear();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Попробовать снова'),
        ),
      ],
    );
  }
}

