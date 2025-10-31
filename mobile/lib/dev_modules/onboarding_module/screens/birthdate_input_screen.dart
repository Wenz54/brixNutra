import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ui_kit_module/theme/brix_theme.dart';
import '../../ui_kit_module/buttons/brix_button.dart';
import '../../ui_kit_module/inputs/brix_input.dart';

/// Экран ввода даты рождения (Onboarding Шаг 3)
class BirthdateInputScreen extends StatefulWidget {
  final String goalId;
  final String name;

  const BirthdateInputScreen({
    super.key,
    required this.goalId,
    required this.name,
  });

  @override
  State<BirthdateInputScreen> createState() => _BirthdateInputScreenState();
}

class _BirthdateInputScreenState extends State<BirthdateInputScreen> {
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _errorMessage;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? DateTime(now.year - 25, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BrixColors.primary,
              onPrimary: BrixColors.textOnPrimary,
              surface: BrixColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
        _errorMessage = null;
      });
    }
  }

  void _complete() {
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Выберите дату рождения');
      return;
    }

    // Проверка возраста (минимум 16 лет)
    final age = DateTime.now().difference(_selectedDate!).inDays ~/ 365;
    if (age < 16) {
      setState(() => _errorMessage = 'Возраст должен быть не менее 16 лет');
      return;
    }

    // Сохраняем данные онбординга и переходим в приложение
    _saveOnboardingData();
  }

  Future<void> _saveOnboardingData() async {
    // TODO: Сохранить данные онбординга в БД через API
    // await OnboardingService.saveSurveyAnswers({
    //   'goal': widget.goalId,
    //   'name': widget.name,
    //   'birthdate': _selectedDate!.toIso8601String(),
    // });

    if (!mounted) return;

    // Переход на главный экран
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false, // Удаляем все предыдущие роуты
    );
  }

  void _skip() {
    // Пропускаем ввод даты рождения
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
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
                value: 3 / 3, // Шаг 3 из 3
                backgroundColor: BrixColors.surfaceDark,
                valueColor: const AlwaysStoppedAnimation<Color>(BrixColors.primary),
                minHeight: 4,
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Заголовок
              Text(
                'Когда вы родились?',
                style: BrixTypography.display1,
              ),
              SizedBox(height: BrixSpacing.sm),
              Text(
                'Нам нужна эта информация для расчета калорий',
                style: BrixTypography.bodyLarge.copyWith(
                  color: BrixColors.textSecondary,
                ),
              ),

              SizedBox(height: BrixSpacing.xxxl),

              // Поле выбора даты
              BrixInput(
                controller: _dateController,
                type: BrixInputType.text,
                label: 'Дата рождения',
                hintText: 'ДД.ММ.ГГГГ',
                errorText: _errorMessage,
                suffixIcon: Icons.calendar_today,
                isEnabled: false, // Только через DatePicker
                onTap: _selectDate,
                onSuffixIconPressed: _selectDate,
              ),

              SizedBox(height: BrixSpacing.lg),

              // Подсказка о возрасте
              if (_selectedDate != null) ...[
                Container(
                  padding: EdgeInsets.all(BrixSpacing.md),
                  decoration: BoxDecoration(
                    color: BrixColors.primary.withValues(alpha: 0.1),
                    borderRadius: BrixSpacing.borderRadiusMD,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: BrixColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: BrixSpacing.sm),
                      Text(
                        'Ваш возраст: ${DateTime.now().difference(_selectedDate!).inDays ~/ 365} лет',
                        style: BrixTypography.bodySmall.copyWith(
                          color: BrixColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Кнопка завершить
              BrixButton.primary(
                text: 'Завершить',
                onPressed: _complete,
                size: BrixButtonSize.large,
                icon: Icons.check,
              ),

              SizedBox(height: BrixSpacing.md),

              // Кнопка пропустить
              BrixButton.textButton(
                text: 'Пропустить',
                onPressed: _skip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



