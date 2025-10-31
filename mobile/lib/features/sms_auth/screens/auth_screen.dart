import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../sms_auth.dart';
import '../../../dev_modules/core_module/services/token_manager.dart';
import '../../../app/routes.dart';
import '../../../dev_modules/ui_kit_module/theme/brix_theme.dart';
import '../../../dev_modules/ui_kit_module/inputs/brix_input.dart';
import '../../../dev_modules/ui_kit_module/buttons/brix_button.dart';

/// Экран авторизации по телефону или email
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isPhoneAuth = true; // Телефон или email
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  // Маска для телефона: +7 (XXX) XXX-XX-XX
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  String? _errorMessage;
  bool _codeSent = false;
  bool _needsPassword = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_isPhoneAuth) {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        setState(() => _errorMessage = 'Введите номер телефона');
        return;
      }
      context.read<SmsAuthBloc>().add(SendCodeToPhoneRequested(phone));
    } else {
      final email = _emailController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        setState(() => _errorMessage = 'Неверный e-mail');
        return;
      }
      context.read<SmsAuthBloc>().add(SendCodeToEmailRequested(email));
    }
  }

  void _verifyCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Введите код');
      return;
    }

    if (_isPhoneAuth) {
      context.read<SmsAuthBloc>().add(
            VerifyPhoneCodeRequested(
              phone: _phoneController.text.trim(),
              code: code,
            ),
          );
    } else {
      context.read<SmsAuthBloc>().add(
            VerifyEmailCodeRequested(
              email: _emailController.text.trim(),
              code: code,
            ),
          );
    }
  }

  void _setPassword() {
    final password = _passwordController.text.trim();
    if (password.length < 6) {
      setState(() => _errorMessage = 'Пароль минимум 6 символов');
      return;
    }

    context.read<SmsAuthBloc>().add(
          SetPasswordRequested(
            email: _emailController.text.trim(),
            password: password,
          ),
        );
  }

  // 🔧 DEV вход (для разработки)
  Future<void> _devLogin() async {
    await TokenManager.saveAuth(
      accessToken: 'dev-token-${DateTime.now().millisecondsSinceEpoch}',
      userId: '123e4567-e89b-12d3-a456-426614174000',
      email: 'dev@brixnutrition.com',
      name: 'DEV User',
    );
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      body: BlocConsumer<SmsAuthBloc, SmsAuthState>(
        listener: (context, state) async {
          if (state is CodeSentSuccess) {
            setState(() {
              _codeSent = true;
              _errorMessage = null;
            });
          } else if (state is CodeVerifiedNewUser) {
            // Новый пользователь - требуется установка пароля
            setState(() {
              _needsPassword = true;
              _errorMessage = null;
            });
          } else if (state is CodeVerifiedExistingUser) {
            // Существующий пользователь - входим
            await TokenManager.saveAuth(
              accessToken: state.token,
              userId: state.user.id,
              email: state.user.email,
              name: state.user.name,
            );
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          } else if (state is PasswordSetSuccess) {
            // Пароль установлен - входим
            await TokenManager.saveAuth(
              accessToken: state.token,
              userId: state.user.id,
              email: state.user.email,
              name: state.user.name,
            );
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          } else if (state is SmsAuthError) {
            setState(() => _errorMessage = state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                // Glass flowers (декоративные элементы)
                // Левый цветок (наполовину за экраном)
                Positioned(
                  top: 300,
                  left: -80,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/glass_flower.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Центральный цветок
                Positioned(
                  top: 280,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/images/glass_flower.jpg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Правый цветок (наполовину за экраном)
                Positioned(
                  top: 300,
                  right: -80,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/glass_flower.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Верхняя часть с логотипом
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Логотип
                      Image.asset(
                        'assets/images/brix_logo.jpg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: BrixSpacing.md),
                      Text(
                        'Brix Nutritional App',
                        style: BrixTypography.h4,
                      ),
                    ],
                  ),
                ),

                // Белая карточка с контентом
                Positioned(
                  top: 560,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        children: [
                          // Кнопки переключения
                          if (!_codeSent && !_needsPassword) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTabButton(
                                    'Телефон',
                                    _isPhoneAuth,
                                    () => setState(() => _isPhoneAuth = true),
                                  ),
                                ),
                                Expanded(
                                  child: _buildTabButton(
                                    'Почта',
                                    !_isPhoneAuth,
                                    () => setState(() => _isPhoneAuth = false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Ввод телефона/email
                          if (!_codeSent && !_needsPassword) ...[
                            BrixInput(
                              controller: _isPhoneAuth ? _phoneController : _emailController,
                              type: _isPhoneAuth ? BrixInputType.phone : BrixInputType.email,
                              hintText: _isPhoneAuth ? '+7 (___) ___ __ __' : 'E-mail',
                              inputFormatters: _isPhoneAuth ? [_phoneMaskFormatter] : null,
                              errorText: _errorMessage,
                            ),
                            SizedBox(height: BrixSpacing.lg),
                            BrixButton.primary(
                              text: 'Продолжить',
                              onPressed: state is SmsAuthLoading ? null : _sendCode,
                              isLoading: state is SmsAuthLoading,
                              size: BrixButtonSize.large,
                            ),
                          ],

                          // Ввод кода
                          if (_codeSent && !_needsPassword) ...[
                            Text(
                              'Введите код из SMS/E-mail',
                              style: BrixTypography.h5,
                            ),
                            SizedBox(height: BrixSpacing.lg),
                            BrixInput(
                              controller: _codeController,
                              type: BrixInputType.number,
                              hintText: '0000',
                              errorText: _errorMessage,
                            ),
                            SizedBox(height: BrixSpacing.lg),
                            BrixButton.primary(
                              text: 'Подтвердить',
                              onPressed: state is SmsAuthLoading ? null : _verifyCode,
                              isLoading: state is SmsAuthLoading,
                              size: BrixButtonSize.large,
                            ),
                          ],

                          // Установка пароля (для новых email пользователей)
                          if (_needsPassword) ...[
                            Text(
                              'Установите пароль',
                              style: BrixTypography.h5,
                            ),
                            SizedBox(height: BrixSpacing.lg),
                            BrixInput(
                              controller: _passwordController,
                              type: BrixInputType.password,
                              hintText: 'Минимум 6 символов',
                              errorText: _errorMessage,
                            ),
                            SizedBox(height: BrixSpacing.lg),
                            BrixButton.primary(
                              text: 'Начать',
                              onPressed: state is SmsAuthLoading ? null : _setPassword,
                              isLoading: state is SmsAuthLoading,
                              size: BrixButtonSize.large,
                            ),
                          ],

                          const Spacer(),

                          // Политика конфиденциальности
                          Text(
                            'Продолжая вы принимаете условия пользовательского соглашения и политику конфиденциальности',
                            textAlign: TextAlign.center,
                            style: BrixTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔧 DEV кнопка (для разработки)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: BrixButton.secondary(
                    text: '🔧 DEV Вход',
                    onPressed: _devLogin,
                    size: BrixButtonSize.large,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: BrixSpacing.md),
        decoration: BoxDecoration(
          color: isActive ? BrixColors.background : Colors.transparent,
          borderRadius: BrixSpacing.borderRadiusMD,
        ),
        child: Center(
          child: Text(
            text,
            style: BrixTypography.labelLarge.copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? BrixColors.textPrimary : BrixColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

