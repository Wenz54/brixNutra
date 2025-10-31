# Список модулей Backend

## ✅ Реализованные модули

### 1. Core Module
- ✅ Auth middleware (JWT)
- ✅ Валидация (Zod)
- ✅ Утилиты и хелперы
- ✅ Общие типы TypeScript
- ✅ Стандартизация ответов API

### 2. Database Module  
- ✅ Подключение к PostgreSQL
- ✅ Миграции
- ✅ Инициализация таблиц
- ✅ Connection pooling

### 3. Auth Module
- ✅ Регистрация пользователей
- ✅ Вход/выход
- ✅ JWT токены
- ✅ Подтверждение email
- ✅ Сброс пароля

### 4. Users Module
- ✅ Профили пользователей
- ✅ Загрузка аватаров
- ✅ Обновление данных
- ✅ Настройки пользователя

### 5. Nutrition Module
- ✅ Планы питания (CRUD)
- ✅ Продукты
- ✅ Приемы пищи
- ✅ Калькулятор КБЖУ
- ✅ Фильтрация (вегетарианское, веганское, без глютена)

### 6. Knowledge Module
- ✅ Курсы базы знаний
- ✅ Уроки (текст, аудио, видео)
- ✅ Категории
- ✅ Типы уроков (основные, подписка, авторские)

### 7. Diary Module
- ✅ Дневник питания
- ✅ Трекинг воды
- ✅ Статистика по дням
- ✅ КБЖУ анализ

### 8. Lab Module
- ✅ Лабораторные анализы
- ✅ Результаты тестов
- ✅ Референсные значения
- ✅ История анализов

### 9. Survey Module
- ✅ Опросники
- ✅ Вопросы и ответы
- ✅ Результаты опросов
- ✅ Анализ ответов

### 10. AI Chat Module
- ✅ OpenAI интеграция
- ✅ История чата
- ✅ Контекст диалога
- ✅ Streaming ответов

### 11. Subscription Module
- ✅ Подписки (планы)
- ✅ Платежи
- ✅ Премиум доступ
- ✅ Управление подписками

### 12. Files Module
- ✅ Загрузка изображений
- ✅ Загрузка видео
- ✅ Загрузка аудио
- ✅ Валидация файлов
- ✅ Очистка старых файлов

### 13. Analytics Module
- ✅ Статистика пользователей
- ✅ Метрики контента
- ✅ Daily stats
- ✅ Активность

## 🔄 Зависимости между модулями

```
core_module (базовый)
  ↓
database_module
  ↓
auth_module → users_module
  ↓              ↓
nutrition_module, knowledge_module, diary_module
  ↓
lab_module, survey_module
  ↓
ai_chat_module
  ↓
subscription_module
  ↓
files_module, analytics_module
```

## 📊 Статистика

- **Всего модулей:** 13
- **Реализовано:** 13
- **API endpoints:** ~100+
- **Таблиц БД:** ~30+
- **Миграций:** 27+

## 🎯 Roadmap

### Фаза 1 (завершена)
- ✅ Структура модулей
- ✅ Core, Database, Auth
- ✅ Users, Nutrition

### Фаза 2 (завершена)
- ✅ Knowledge (курсы, уроки)
- ✅ Diary, Lab, Survey
- ✅ AI Chat, Subscriptions

### Фаза 3 (завершена)
- ✅ Files, Analytics
- ✅ Документация
- ✅ Примеры использования

### Фаза 4 (планируется)
- ⏳ Unit тесты для всех модулей
- ⏳ E2E тесты
- ⏳ API документация (Swagger)
- ⏳ Performance оптимизация
- ⏳ Caching (Redis)
- ⏳ Rate limiting
- ⏳ WebSocket поддержка

## 📦 Технологии

- **Framework:** Fastify 4.24.3
- **Language:** TypeScript 5.2.2
- **Database:** PostgreSQL
- **ORM:** Raw SQL (pg)
- **Validation:** Zod
- **Auth:** JWT (@fastify/jwt)
- **Testing:** Jest
- **AI:** OpenAI API
- **Email:** Resend

## 🔗 Связи модулей

### Core Module
Используется всеми модулями

### Auth Module
- Используется: Users, все защищенные endpoints
- Зависит от: Core, Database

### Nutrition Module
- Используется: Diary, Analytics
- Зависит от: Core, Auth, Database

### Knowledge Module
- Используется: Subscription (премиум контент)
- Зависит от: Core, Auth, Database

### Diary Module
- Используется: Analytics
- Зависит от: Core, Auth, Nutrition

### AI Chat Module
- Использует: OpenAI API
- Зависит от: Core, Auth, Database

---

**Версия:** 1.0.0  
**Дата:** October 2025  
**Автор:** Supply Diets Team

