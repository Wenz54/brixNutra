# 📱 API Connection Test Instructions

## ✅ Что сделано:

### 1. Backend Готов
- ✅ PostgreSQL запущен (Docker): `localhost:5432`
- ✅ Redis запущен (Docker): `localhost:6379`
- ✅ Миграции БД применены
- ✅ .env файл создан с правильными настройками
- ⚠️ Backend нужно перезапустить

### 2. Flutter App Готов
- ✅ API Service настроен для Android эмулятора (`10.0.2.2:3000`)
- ✅ Test Connection Screen создан
- ✅ Приложение компилируется на эмуляторе

## 🚀 Шаги для тестирования:

### Шаг 1: Перезапустить Backend
```powershell
# Закройте окно PowerShell с backend (если открыто)
# Или нажмите Ctrl+C в терминале backend

# Запустите заново:
cd D:\brixNutra\backend
npm run dev

# Должен вывести:
# [INFO] Server listening at http://0.0.0.0:3000
# [INFO] ✅ All routes registered
```

### Шаг 2: Проверить backend работает
```powershell
# В новом терминале:
curl http://localhost:3000/api/recipes?limit=1

# Ожидаемый ответ:
# {"success": true, "data": [...], "total": X}
```

### Шаг 3: Запустить/Проверить Flutter App
Приложение уже компилируется! После завершения компиляции:

1. **Откроется Test Connection Screen** с 3 кнопками:
   - Test 1: Backend Health Check
   - Test 2: Get Recipes
   - Test 3: Send SMS Code

2. **Нажмите Test 1** - проверит доступность backend
   - ✅ Успех: "Backend доступен!"
   - ❌ Ошибка: "Connection error - проверьте что backend запущен"

3. **Нажмите Test 2** - получит рецепты из БД
   - ✅ Успех: покажет количество и первый рецепт
   - ❌ Ошибка: если нет данных в БД

4. **Нажмите Test 3** - отправит тестовый SMS код
   - ✅ Успех: код отправлен (MOCK режим)

## 📊 Что вы увидите:

### В Flutter App:
```
┌─────────────────────────────────┐
│ API Configuration:              │
│ Base URL: http://10.0.2.2:3000/api
│ Connect Timeout: 10s            │
│ Receive Timeout: 10s            │
└─────────────────────────────────┘

[Test 1: Backend Health Check]
[Test 2: Get Recipes]
[Test 3: Send SMS Code]

Status:
✅ Backend доступен!

Response: {success: true, ...}
```

### В Backend Console (Debug Mode):
```
┌─────── DIO REQUEST ───────
│ GET http://10.0.2.2:3000/api/recipes
│ Headers: {Authorization: Bearer ...}
│ Query: {limit: 5}
└───────────────────────────

┌─────── DIO RESPONSE ──────
│ 200 http://10.0.2.2:3000/api/recipes
│ Data: {success: true, data: [...]}
└───────────────────────────
```

## 🔧 Если возникли проблемы:

### Problem 1: "Connection error"
```powershell
# Проверьте backend запущен:
netstat -ano | findstr ":3000"

# Должно показать:
# TCP    0.0.0.0:3000    ...    LISTENING
```

### Problem 2: "Database error"
```powershell
# Проверьте PostgreSQL:
docker ps --filter "name=brix_postgres"

# Должно показать:
# brix_postgres   Up X hours (healthy)
```

### Problem 3: Flutter не компилируется
```powershell
cd D:\brixNutra\mobile
flutter clean
flutter pub get
flutter run -d emulator-5554
```

## 📝 После успешного теста:

1. **Верните начальный экран обратно на Splash**:
   ```dart
   // В mobile/lib/app/app.dart измените:
   initialRoute: AppRoutes.testConnection, 
   // на:
   initialRoute: AppRoutes.splash,
   ```

2. **Переходите к Task 3.3**: SMS Auth (логика)

## ✨ Ready to test!

Backend: `http://localhost:3000/api`
Flutter: Android Emulator (компилируется...)
PostgreSQL: Docker (работает ✅)
Redis: Docker (работает ✅)

