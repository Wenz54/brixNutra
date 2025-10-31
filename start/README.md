# 🚀 Start Scripts

Скрипты для запуска, тестирования и деплоя Brix Nutrition.

## 📁 Структура

```
start/
├── dev/              # Разработка
│   ├── start-backend.bat
│   ├── setup-env.ps1
│   ├── setup-env.sh
│   └── setup-env.js
├── test/             # Тестирование
│   ├── start-backend-test.bat
│   └── run-and-test.bat
└── deploy/           # Деплой (будущее)
    └── (пока пусто)
```

## 🛠️ Разработка

### Первый запуск

**Windows PowerShell:**
```powershell
cd start/dev
.\setup-env.ps1
```

**Linux/Mac:**
```bash
cd start/dev
chmod +x setup-env.sh
./setup-env.sh
```

**Node.js (кросс-платформа):**
```bash
cd start/dev
node setup-env.js
```

### Запуск Backend

**Windows:**
```cmd
cd start/dev
.\start-backend.bat
```

**Manual (из корня):**
```bash
cd backend
npm install
npm run dev
```

## 🧪 Тестирование

### Запуск Backend в тестовом режиме

```cmd
cd start/test
.\start-backend-test.bat
```

### Запуск тестов API

```cmd
cd start/test
.\run-and-test.bat
```

## 🚢 Деплой

_(будет добавлено позже)_

Планируемые скрипты:
- `deploy-backend.sh` - Деплой Backend на production
- `deploy-admin.sh` - Деплой Admin Panel
- `deploy-mobile.sh` - Build и публикация Mobile App

## ⚙️ Переменные окружения

Все скрипты используют `.env` файлы:
- Backend: `backend/.env`
- Admin: `admin/.env.local`
- Mobile: `mobile/.env`

См. `env.example.txt` в корне проекта для шаблона.

## ❓ Помощь

Если возникли проблемы:
1. Проверьте наличие `.env` файлов
2. Убедитесь, что PostgreSQL и Redis запущены
3. Проверьте версию Node.js (требуется 18+)
4. См. `docs/QUICK_START.md` для детальных инструкций

