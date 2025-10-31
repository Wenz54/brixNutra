# 🚀 Test Deployment Guide - Brix Nutrition App

## 📋 Статус развёртывания

### ✅ Запущенные сервисы:

1. **Backend (Fastify)** 
   - URL: http://localhost:3000
   - Статус: 🟢 Running
   - База данных: PostgreSQL (localhost:5432)

2. **Admin Panel (Next.js)**
   - URL: http://localhost:3001
   - Статус: 🟢 Running
   - Технологии: Next.js 14, React, Tailwind CSS

3. **Mobile App (Flutter)**
   - Устройство: Android Emulator (emulator-5554)
   - Статус: 🟢 Compiling/Running
   - API URL: http://10.0.2.2:3000 (эмулятор Android)

---

## 🎯 Как проверить работу

### 1. Backend API
```bash
# Health check
curl http://localhost:3000/api/health

# Home dashboard
curl http://localhost:3000/api/home/dashboard

# Meal plan
curl http://localhost:3000/api/meal-plan/today

# Recipes
curl http://localhost:3000/api/recipes
```

### 2. Admin Panel
Откройте в браузере:
```
http://localhost:3001
```

**Страницы для проверки:**
- `/` - Dashboard
- `/courses` - Курсы
- `/recipes` - Рецепты
- `/lab-tests` - Параметры анализов
- `/users` - Пользователи
- `/blog` - Блог

### 3. Flutter App

**Вход в приложение:**
1. Откройте приложение на эмуляторе
2. Нажмите кнопку "🔧 DEV Вход" (оранжевая внизу экрана)
3. Приложение автоматически войдет с тестовым пользователем

**Экраны для проверки:**
- ✅ Home Screen (Главный)
- ✅ Meal Plan (Рацион)
- ✅ AI Chat (AI Чат)
- ✅ Diary (Дневник)
- ✅ Profile (Профиль)

---

## 🔑 Тестовые данные

### Тестовый пользователь:
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "email": "dev@brixnutrition.com",
  "name": "DEV User"
}
```

### База данных уже содержит:
- ✅ 10+ рецептов
- ✅ Meal plan на 7 дней
- ✅ Параметры лабораторных анализов
- ✅ Курсы и уроки
- ✅ Статьи блога

---

## 🐛 Решение проблем

### Backend не запускается
```bash
cd backend
npm install
npm run dev
```

### Admin Panel не запускается
```bash
cd admin
npm install
npm run dev
```

### Flutter не компилируется
```bash
cd mobile
flutter clean
flutter pub get
flutter run -d emulator-5554
```

### База данных не подключается
Проверьте PostgreSQL:
```bash
# Убедитесь что PostgreSQL запущен
# Проверьте .env файл в backend/
```

---

## 📱 API Endpoints в Flutter

Flutter использует специальный URL для доступа к localhost с эмулятора Android:
```dart
// В mobile/lib/dev_modules/core_module/services/api_service.dart
static const String _baseUrl = 'http://10.0.2.2:3000/api';
```

`10.0.2.2` - это специальный IP для доступа к localhost хоста с Android эмулятора.

---

## 🎨 UI Kit компоненты (готовы к использованию)

### Buttons:
```dart
BrixButton.primary(text: 'Кнопка', onPressed: () {})
BrixButton.secondary(text: 'Кнопка', onPressed: () {})
BrixButton.outline(text: 'Кнопка', onPressed: () {})
BrixButton.textButton(text: 'Кнопка', onPressed: () {})
```

### Inputs:
```dart
BrixInput(
  type: BrixInputType.text,
  label: 'Имя',
  hintText: 'Введите имя',
  controller: _controller,
)
```

### Cards:
```dart
BrixCard(child: Text('Контент'))
BrixMinorCard(title: 'Заголовок', description: 'Описание')
BrixMajorCard(title: 'Большая карточка', onButtonPressed: () {})
```

### Progress:
```dart
BrixProgressBar(value: 0.5)
BrixWaterCounter(currentAmount: 1500, goalAmount: 2000)
BrixMoodSelector(selectedMood: 3, onMoodSelected: (mood) {})
```

---

## 🔄 Hot Reload (Flutter)

Во время разработки вы можете использовать hot reload:
- `r` - hot reload
- `R` - hot restart
- `q` - quit
- `p` - show performance overlay

---

## 📊 Мониторинг

### Backend логи:
Смотрите в терминале где запущен `npm run dev` (backend)

### Admin Panel логи:
Смотрите в терминале где запущен `npm run dev` (admin)

### Flutter логи:
```bash
flutter logs
```

---

## 🎯 Следующие шаги

### Для production:
1. Настроить реальную базу данных (не localhost)
2. Добавить Twilio для SMS
3. Добавить OpenAI для AI Chat
4. Настроить Stripe для оплаты
5. Deploy на AWS/GCP/Azure

### Для разработки:
1. Писать E2E тесты
2. Добавить больше данных в БД
3. Улучшить UI/UX
4. Оптимизировать запросы к API

---

## ✅ Готово к тестированию!

Все сервисы запущены и готовы к работе. Используйте **DEV Вход** в мобильном приложении для быстрого доступа.

**Дата:** 15 октября 2025  
**Статус:** 🟢 All systems operational


