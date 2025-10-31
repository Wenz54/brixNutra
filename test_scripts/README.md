# 🧪 Test Scripts

Тестовые скрипты и seed данные для Brix Nutrition Backend.

## 📁 Структура

```
test_scripts/
├── api/              # API тестовые скрипты
│   └── quick-test.ps1
└── db/               # База данных тесты и seed
    ├── diagnose-db.cjs
    ├── diagnose-startup.ts
    ├── diagnose.js
    ├── seed-recipes.sql
    ├── seed-meal-plan.sql
    ├── seed-knowledge.sql
    ├── seed-lab-parameters.sql
    └── seed-diary.sql
```

## 🚀 Использование

### API Тесты

```powershell
# Быстрый тест API
cd test_scripts/api
.\quick-test.ps1
```

### Database Seeds

```bash
# Загрузить seed данные (из backend/)
cd backend
psql -U postgres -d brix_nutrition -f ../test_scripts/db/seed-recipes.sql
psql -U postgres -d brix_nutrition -f ../test_scripts/db/seed-meal-plan.sql
psql -U postgres -d brix_nutrition -f ../test_scripts/db/seed-knowledge.sql
psql -U postgres -d brix_nutrition -f ../test_scripts/db/seed-lab-parameters.sql
psql -U postgres -d brix_nutrition -f ../test_scripts/db/seed-diary.sql
```

### Database Diagnostics

```bash
# Диагностика подключения к БД
node test_scripts/db/diagnose-db.cjs

# Диагностика запуска сервера
npx tsx test_scripts/db/diagnose-startup.ts
```

## 📝 Seed Данные

| Файл | Описание | Записей |
|------|----------|---------|
| `seed-recipes.sql` | Рецепты блюд | ~5 рецептов |
| `seed-meal-plan.sql` | Планы питания | 1 план (7 дней) |
| `seed-knowledge.sql` | Курсы и уроки | 2 курса, 8 уроков |
| `seed-lab-parameters.sql` | Параметры анализов | 21 параметр |
| `seed-diary.sql` | Тестовые записи дневника | 2 дня |

## ✅ Требования

- PostgreSQL 14+
- Node.js 18+
- Backend должен быть запущен для API тестов

