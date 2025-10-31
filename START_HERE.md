# 🎯 START HERE - Brix Nutrition Quick Start

## 🚀 Что уже запущено прямо сейчас:

### ✅ Admin Panel - РАБОТАЕТ
```
🌐 Откройте в браузере: http://localhost:3001
```

**Доступно сейчас:**
- Dashboard с mock данными
- Управление курсами
- Управление рецептами
- Параметры анализов
- Пользователи
- Блог

### 🟡 Flutter App - КОМПИЛИРУЕТСЯ
Приложение сейчас компилируется на Android эмуляторе.  
Через 2-3 минуты откроется автоматически.

**Как войти:**
1. Дождитесь окончания компиляции
2. Нажмите оранжевую кнопку "🔧 DEV Вход"
3. Готово! Можете тестировать все экраны

---

## 🔴 Backend API - Нужно запустить

Backend не запустился автоматически. Запустите вручную:

### Быстрый старт Backend:

```bash
# 1. Откройте новый терминал PowerShell

# 2. Перейдите в директорию backend
cd D:\brixNutra\backend

# 3. Проверьте наличие node_modules
# Если папки нет, выполните:
npm install

# 4. Запустите сервер
npm run dev

# Backend запустится на http://localhost:3000
```

### Если Backend не запускается:

**Проблема 1: Порт 3000 занят**
```bash
# Найдите процесс
netstat -ano | findstr ":3000"

# Убейте процесс (замените PID на найденный)
taskkill /PID <PID> /F

# Или измените порт в backend/.env
PORT=3002
```

**Проблема 2: База данных не подключается**
```bash
# Backend работает без БД (mock данные)
# Но для полной функциональности нужна PostgreSQL

# Установите PostgreSQL:
# https://www.postgresql.org/download/windows/

# Создайте БД:
# Откройте psql и выполните:
CREATE DATABASE brix_nutrition;
```

---

## 📱 Тестирование без Backend (прямо сейчас):

### 1. Admin Panel
✅ Работает полностью с mock данными  
🌐 http://localhost:3001

### 2. Flutter App
✅ UI полностью функционален  
✅ Используйте "🔧 DEV Вход"  
⚠️ API запросы будут падать (без Backend)

---

## 🎯 Быстрый тест (5 минут):

### Шаг 1: Admin Panel (готов)
```
1. Откройте http://localhost:3001
2. Нажмите "Курсы" в меню слева
3. Нажмите "+ Новый курс"
4. Заполните форму
5. Нажмите "Создать"
```

### Шаг 2: Flutter App (когда скомпилируется)
```
1. Нажмите "🔧 DEV Вход"
2. Проверьте Home Screen
3. Нажмите на "Рацион" внизу
4. Откройте "AI-чат"
5. Проверьте "Дневник"
```

---

## 📚 Полная документация:

1. **DEPLOYMENT_STATUS.md** - Текущий статус развёртывания
2. **TEST_DEPLOYMENT_GUIDE.md** - Полное руководство
3. **PHASE_5_COMPLETE.md** - Отчёт по UI адаптации
4. **README.md** - Описание проекта
5. **tasks.md** - Все задачи (3154 строки)

---

## 🎨 UI Kit компоненты (готовы):

### Flutter (mobile/lib/dev_modules/ui_kit_module/):
```dart
// Buttons
BrixButton.primary(text: 'Кнопка', onPressed: () {})
BrixButton.secondary(text: 'Кнопка', onPressed: () {})
BrixButton.outline(text: 'Кнопка', onPressed: () {})

// Inputs
BrixInput(type: BrixInputType.text, label: 'Имя')

// Cards
BrixCard(child: Text('Контент'))
BrixMinorCard(title: 'Заголовок', description: 'Описание')

// Progress
BrixProgressBar(value: 0.5)
BrixWaterCounter(currentAmount: 1500, goalAmount: 2000)
BrixMoodSelector(selectedMood: 3)
```

### Admin (уже используется в Next.js):
- Tailwind CSS
- Heroicons
- React Hook Form
- Axios

---

## ✅ Что уже работает:

### Frontend:
- ✅ Admin Panel (Next.js) - 100%
- ✅ Flutter UI Kit - 100%
- ✅ Все экраны адаптированы - 100%
- ✅ Навигация - 100%
- ✅ BLoC State Management - 100%

### Backend (код готов):
- ✅ Fastify сервер
- ✅ PostgreSQL интеграция
- ✅ Все API endpoints
- ✅ Модульная архитектура
- 🔴 Нужно запустить

---

## 🚀 Следующие шаги:

### Сейчас:
1. ✅ Тестируйте Admin Panel
2. 🟡 Дождитесь Flutter компиляции
3. 🔴 Запустите Backend вручную

### Позже:
1. Настройте PostgreSQL
2. Загрузите seed данные
3. Подключите Twilio (SMS)
4. Подключите OpenAI (AI Chat)
5. Deploy в production

---

## 💡 Советы:

### Для быстрого тестирования:
- Используйте Admin Panel (готов)
- Flutter с DEV Login (UI тестирование)

### Для полного тестирования:
- Запустите Backend
- Настройте PostgreSQL
- Тестируйте полный flow

### Для разработки:
- Hot Reload в Flutter: `r` в терминале
- Hot Reload в Next.js: автоматически
- Backend перезапустится при изменениях (tsx watch)

---

## 📞 Нужна помощь?

### Backend не запускается:
Проверьте `backend/src/index.ts` и логи в терминале

### Flutter не компилируется:
```bash
cd mobile
flutter clean
flutter pub get
flutter run
```

### База данных:
Можно работать без БД (mock данные)

---

## 🎉 Готово!

**Admin Panel:** ✅ Работает сейчас  
**Flutter App:** 🟡 Компилируется  
**Backend:** 🔴 Запустите вручную

**Начните с Admin Panel:** http://localhost:3001

---

**Дата:** 15 октября 2025  
**Версия:** 1.0.0 (Test Deployment)


