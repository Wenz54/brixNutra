# 🎨 Brix Nutrition UI Kit

Библиотека переиспользуемых UI компонентов для Brix Nutrition приложения.

## 📦 Структура

```
ui_kit_module/
├── theme/
│   └── brix_theme.dart         # Цвета, типографика, отступы, темаприложения
├── buttons/
│   ├── brix_button.dart        # Кнопки (primary, secondary, outline, text)
│   └── supply_button.dart      # [legacy] Старая Supply версия
├── inputs/
│   ├── brix_input.dart         # Текстовые поля с валидацией
│   └── supply_input.dart       # [legacy]
├── cards/
│   ├── brix_card.dart          # Карточки (base, minor, major)
│   └── supply_cards.dart       # [legacy]
├── alerts/
│   ├── brix_alert.dart         # Алерты (snackbar, dialog, toast, bottom sheet)
│   └── supply_alert.dart       # [legacy]
└── widgets/
    ├── brix_progress_bar.dart     # Линейные и круговые прогресс-бары
    ├── brix_meal_card.dart        # Карточки приемов пищи
    ├── brix_water_counter.dart    # Счетчик воды
    └── brix_mood_selector.dart    # Селектор настроения

```

---

## 🎨 Тема Brix

### Цвета

```dart
import 'package:mobile/dev_modules/ui_kit_module/theme/brix_theme.dart';

// Primary
BrixColors.primary      // #4CAF50 (зеленый)
BrixColors.secondary    // #FF9800 (оранжевый)
BrixColors.accent       // #2196F3 (синий)

// Status
BrixColors.success      // #4CAF50
BrixColors.error        // #EF5350
BrixColors.warning      // #FF9800
BrixColors.info         // #2196F3

// Macro nutrients
BrixColors.protein      // #E91E63 (розовый)
BrixColors.carbs        // #FFEB3B (желтый)
BrixColors.fats         // #FF9800 (оранжевый)
BrixColors.calories     // #9C27B0 (фиолетовый)
BrixColors.water        // #03A9F4 (голубой)
```

### Типографика

```dart
// Заголовки
BrixTypography.display1    // 32px, bold
BrixTypography.h1          // 28px, bold
BrixTypography.h2          // 24px, semibold
BrixTypography.h3          // 20px, semibold

// Body
BrixTypography.bodyLarge   // 16px
BrixTypography.bodyMedium  // 14px
BrixTypography.bodySmall   // 12px

// Labels
BrixTypography.labelLarge  // 14px, medium
BrixTypography.labelMedium // 12px, medium

// Buttons
BrixTypography.buttonLarge  // 16px, semibold
BrixTypography.buttonMedium // 14px, semibold
```

### Отступы

```dart
BrixSpacing.xs    // 4px
BrixSpacing.sm    // 8px
BrixSpacing.md    // 12px
BrixSpacing.lg    // 16px
BrixSpacing.xl    // 20px
BrixSpacing.xxl   // 24px
BrixSpacing.xxxl  // 32px

// Presets
BrixSpacing.paddingLG
BrixSpacing.paddingHorizontalLG
BrixSpacing.borderRadiusMD
```

---

## 🔘 Кнопки (BrixButton)

### Пример использования

```dart
import 'package:mobile/dev_modules/ui_kit_module/buttons/brix_button.dart';

// Primary (зеленая)
BrixButton.primary(
  text: 'Войти',
  onPressed: () => print('Pressed'),
  size: BrixButtonSize.large,
)

// Secondary (оранжевая)
BrixButton.secondary(
  text: 'Отправить',
  onPressed: () {},
  icon: Icons.send,
)

// Outline
BrixButton.outline(
  text: 'Отмена',
  onPressed: () {},
)

// Text button
BrixButton.textButton(
  text: 'Пропустить',
  onPressed: () {},
)

// С загрузкой
BrixButton.primary(
  text: 'Загрузка...',
  isLoading: true,
  onPressed: null,
)
```

### Типы

- **primary** - Зеленая кнопка (основная)
- **secondary** - Оранжевая кнопка
- **outline** - Белая с зеленой рамкой
- **text** - Текстовая без фона

### Размеры

- **small** - 40px высота
- **medium** - 48px высота (по умолчанию)
- **large** - 56px высота

---

## 📝 Поля ввода (BrixInput)

### Пример использования

```dart
import 'package:mobile/dev_modules/ui_kit_module/inputs/brix_input.dart';

// Email
BrixInput(
  label: 'Email',
  hintText: 'example@mail.com',
  type: BrixInputType.email,
  isRequired: true,
  controller: _emailController,
  onChanged: (value) => print(value),
)

// Пароль
BrixInput(
  label: 'Пароль',
  type: BrixInputType.password,
  controller: _passwordController,
  errorText: 'Неверный пароль',
)

// С иконкой
BrixInput(
  label: 'Поиск',
  prefixIcon: Icons.search,
  controller: _searchController,
)
```

### Типы

- **text** - Обычный текст
- **email** - Email (с клавиатурой email)
- **password** - Пароль (с кнопкой показать/скрыть)
- **number** - Числа
- **phone** - Телефон

---

## 🎴 Карточки (BrixCard)

### Базовая карточка

```dart
BrixCard(
  child: Text('Содержимое'),
  onTap: () => print('Tapped'),
)
```

### Малая карточка

```dart
BrixMinorCard(
  label: 'Новинка',
  title: 'Детокс диета',
  description: 'Очищение организма за 7 дней',
  imageUrl: 'https://...',
  onTap: () {},
)
```

### Большая карточка

```dart
BrixMajorCard(
  label: 'Рекомендуем',
  title: 'Персональный план питания',
  description: 'Создан специально для вас',
  imagePath: 'assets/images/plan_bg.png',
  buttonText: 'Начать',
  onButtonPressed: () {},
  height: 250.0,
)
```

---

## 🎯 Прогресс-бары (BrixProgressBar)

### Линейный прогресс

```dart
BrixProgressBar(
  progress: 0.65, // 0.0 - 1.0
  label: 'Прогресс дня',
  showPercentage: true,
  color: BrixColors.primary,
)
```

### Круговой прогресс

```dart
BrixCircularProgress(
  progress: 0.75,
  size: 120.0,
  centerText: '1850\nккал',
  color: BrixColors.calories,
)
```

### Макро прогресс (КБЖУ)

```dart
BrixMacroProgressBar(
  protein: 85.5,
  targetProtein: 150.0,
  carbs: 120.0,
  targetCarbs: 200.0,
  fats: 45.0,
  targetFats: 65.0,
)
```

---

## 🍽️ Карточки приемов пищи (BrixMealCard)

```dart
BrixMealCard(
  title: 'Овсянка с ягодами',
  imageUrl: 'https://...',
  mealType: 'breakfast',
  time: '08:00',
  calories: 350,
  protein: 12.0,
  carbs: 50.0,
  fats: 10.0,
  onTap: () => print('Открыть рецепт'),
  onReplace: () => print('Заменить'),
  isCompleted: false,
)
```

### Компактная версия

```dart
BrixMealListItem(
  title: 'Курица с овощами',
  time: '13:00',
  calories: 450,
  isCompleted: true,
  onTap: () {},
  onDelete: () {},
)
```

---

## 💧 Счетчик воды (BrixWaterCounter)

### Полная версия

```dart
BrixWaterCounter(
  currentAmount: 1200, // мл
  targetAmount: 2000,  // мл
  onAdd: (amount) => print('+ $amount'),
  onSubtract: (amount) => print('- $amount'),
)
```

### Компактная версия

```dart
BrixWaterCounterCompact(
  currentAmount: 1500,
  targetAmount: 2000,
  onTap: () => print('Открыть счетчик'),
)
```

---

## 😊 Селектор настроения (BrixMoodSelector)

### Полная версия

```dart
BrixMoodSelector(
  selectedMood: 4, // 1-5
  onMoodSelected: (mood) => print('Настроение: $mood'),
)
```

### Компактная версия

```dart
BrixMoodSelector(
  selectedMood: 3,
  isCompact: true,
  onMoodSelected: (mood) {},
)
```

### Индикатор (только показ)

```dart
BrixMoodIndicator(
  mood: 5, // 😄 Отлично
)
```

---

## 🔔 Алерты (BrixAlert)

### SnackBar

```dart
BrixAlert.showSnackBar(
  context,
  message: 'Данные сохранены',
  title: 'Успешно!',
  type: BrixAlertType.success,
)
```

### Toast (короткий)

```dart
BrixAlert.showToast(
  context,
  message: 'Скопировано',
  type: BrixAlertType.info,
)
```

### Диалог

```dart
await BrixAlert.showAlertDialog(
  context,
  title: 'Удалить запись?',
  message: 'Это действие нельзя отменить',
  type: BrixAlertType.warning,
  confirmText: 'Удалить',
  cancelText: 'Отмена',
  onConfirm: () => print('Confirmed'),
);
```

### Bottom Sheet

```dart
BrixAlert.showBottomSheetAlert(
  context,
  title: 'Ошибка',
  message: 'Не удалось загрузить данные',
  type: BrixAlertType.error,
  confirmText: 'OK',
  onConfirm: () {},
);
```

### Inline (на странице)

```dart
BrixInlineAlert(
  title: 'Внимание!',
  message: 'Ваша подписка истекает через 3 дня',
  type: BrixAlertType.warning,
  onDismiss: () => print('Dismissed'),
)
```

---

## 🚀 Быстрый старт

```dart
// 1. Импортируй тему
import 'package:mobile/dev_modules/ui_kit_module/theme/brix_theme.dart';

// 2. Примени тему к MaterialApp
void main() {
  runApp(MaterialApp(
    theme: BrixTheme.lightTheme,
    home: MyHomePage(),
  ));
}

// 3. Используй компоненты!
import 'package:mobile/dev_modules/ui_kit_module/buttons/brix_button.dart';
import 'package:mobile/dev_modules/ui_kit_module/inputs/brix_input.dart';
import 'package:mobile/dev_modules/ui_kit_module/cards/brix_card.dart';

BrixButton.primary(
  text: 'Начать',
  onPressed: () {},
)
```

---

## 📊 Статус миграции

✅ **Завершено:**
- Theme (colors, typography, spacing, shadows)
- BrixButton (4 типа, 3 размера)
- BrixInput (5 типов, валидация)
- BrixCard (3 варианта)
- BrixAlert (4 типа, 5 способов показа)
- BrixProgressBar (линейный, круговой, макро)
- BrixMealCard (полная + компактная)
- BrixWaterCounter (полный + компактный)
- BrixMoodSelector (полный + компактный + индикатор)

🔧 **Legacy (старые компоненты Supply):**
- supply_button.dart
- supply_input.dart
- supply_cards.dart
- supply_alert.dart

*Можно удалить после полной миграции на Brix*

---

## 📝 Примечания

- Все компоненты используют **BrixTheme** (цвета, типографика, отступы)
- Адаптивный дизайн для разных размеров экранов
- Анимации для плавных переходов
- Accessibility (доступность) support
- **0 linter errors** после flutter analyze! ✅

---

## 🎯 Следующие шаги

1. ✅ **Task 5.1**: Адаптация UI Kit (завершено)
2. **Task 5.2**: SMS Auth Screens (применить Brix компоненты)
3. **Task 5.3**: Onboarding Screens
4. **Task 5.4**: Home Screen
5. **Task 5.5**: Meal Plan & Recipe Screens
6. **Task 5.6**: Diary Screen
7. **Task 5.7**: AI Chat Screen

---

**Дата создания**: 15 октября 2025  
**Версия**: 1.0.0  
**Статус**: ✅ Готово к использованию
