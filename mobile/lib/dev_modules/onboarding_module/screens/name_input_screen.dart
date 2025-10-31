import 'package:flutter/material.dart';
import '../../ui_kit_module/theme/brix_theme.dart';
import '../../ui_kit_module/buttons/brix_button.dart';
import '../../ui_kit_module/inputs/brix_input.dart';

/// Экран ввода имени (Onboarding Шаг 2)
class NameInputScreen extends StatefulWidget {
  final String goalId;

  const NameInputScreen({
    super.key,
    required this.goalId,
  });

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _nameController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Введите имя');
      return;
    }

    if (name.length < 2) {
      setState(() => _errorMessage = 'Имя должно содержать минимум 2 символа');
      return;
    }

    // Переход к следующему экрану
    Navigator.pushNamed(
      context,
      '/onboarding/birthdate',
      arguments: {
        'goal': widget.goalId,
        'name': name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BrixColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(BrixSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Индикатор прогресса
              LinearProgressIndicator(
                value: 2 / 3, // Шаг 2 из 3
                backgroundColor: BrixColors.surfaceDark,
                valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.primary),
                minHeight: 4,
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Заголовок
              Text(
                'Как вас зовут?',
                style: BrixTypography.display1,
              ),
              SizedBox(height: BrixSpacing.sm),
              Text(
                'Это поможет нам персонализировать опыт',
                style: BrixTypography.bodyLarge.copyWith(
                  color: BrixColors.textSecondary,
                ),
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Поле ввода имени
              BrixInput(
                controller: _nameController,
                type: BrixInputType.text,
                label: 'Ваше имя',
                hintText: 'Введите имя',
                errorText: _errorMessage,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                onSubmitted: (_) => _continue(),
              ),

              const Spacer(),

              // Кнопка продолжить
              BrixButton.primary(
                text: 'Продолжить',
                onPressed: _continue,
                size: BrixButtonSize.large,
              ),

              SizedBox(height: BrixSpacing.md),

              // Кнопка пропустить
              BrixButton.textButton(
                text: 'Пропустить',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/onboarding/birthdate',
                    arguments: {
                      'goal': widget.goalId,
                      'name': 'Пользователь',
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



