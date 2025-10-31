# Список всех модулей Dev Modules

## 📦 Базовые модули (Обязательные)

### 1. core_module ⚡
**Базовые сервисы и конфигурация**
- API Service (Dio/HTTP клиент)
- Token Manager (JWT токены)
- App Theme (цвета, типографика, стили)
- App Constants
- API Config (настройка localhost)

📁 `dev_modules/core_module/`

---

### 2. ui_kit_module 🎨
**Переиспользуемые UI компоненты**
- SupplyButton (primary, outline, welcome)
- SupplyInput (text, email, password, number, phone)
- SupplyCard (minor, major)
- SupplyAlert (success, error, warning, info)
- Другие UI компоненты

📁 `dev_modules/ui_kit_module/`

---

## 🎯 Feature модули (По необходимости)

### 3. auth_module 🔐
**Авторизация и регистрация**
- Login / Register
- Email verification
- Forgot password
- Reset password
- JWT token management

📡 API: `/auth/*`
📁 `dev_modules/auth_module/`

---

### 4. tab_bar_module 📱
**Нижний таб-бар навигации**
- 4 анимированные вкладки
- Home, AI Chat, Diary, Knowledge Base
- Плавные переходы
- Кастомизируемый дизайн

📁 `dev_modules/tab_bar_module/`

---

### 5. diary_module 📊
**Дневник питания**
- Добавление приемов пищи
- Отслеживание воды (мл)
- Отслеживание настроения (1-5 звезд)
- Фото блюд
- Календарь
- AI анализ

📡 API: `/diary/*`
📁 `dev_modules/diary_module/`

---

### 6. profile_module 👤
**Профиль пользователя**
- Просмотр профиля
- Редактирование данных
- Смена email
- Смена пароля
- Настройки
- Удаление аккаунта

📡 API: `/users/*`
📁 `dev_modules/profile_module/`

---

### 7. plans_module 🎯
**Планы питания**
- Список планов
- Детали плана
- Фильтрация и поиск
- Активация плана
- Мои планы

📡 API: `/plans/*`
📁 `dev_modules/plans_module/`

---

### 8. home_module 🏠
**Главный экран**
- Приветствие
- Активный план
- Быстрые действия
- Статистика
- Рекомендации

📡 API: `/home/*`
📁 `dev_modules/home_module/`

---

### 9. knowledge_module 📚
**Курсы и база знаний**
- Список курсов
- Уроки
- Видео контент
- Аудио контент
- Прогресс обучения
- Авторские курсы

📡 API: `/courses/*`
📁 `dev_modules/knowledge_module/`

---

### 10. ai_chat_module 🤖
**AI чат ассистент**
- Чат с AI
- История разговоров
- Контекстные рекомендации
- Персонализация
- Создание/удаление чатов

📡 API: `/ai-chat/*`
📁 `dev_modules/ai_chat_module/`

---

### 11. checkup_module 🔬
**Лабораторные анализы**
- Добавление результатов
- История анализов
- Рекомендации
- Отслеживание показателей
- Типы тестов

📡 API: `/lab-tests/*`
📁 `dev_modules/checkup_module/`

---

### 12. onboarding_module 🎯
**Опросник при первом входе**
- Тип питания
- Пол и возраст
- Цели
- Персонализация
- Пропуск онбординга

📡 API: `/onboarding/*`
📁 `dev_modules/onboarding_module/`

---

### 13. subscription_module 💳
**Подписки и тарифы**
- Список тарифов
- Оформление подписки
- Управление подпиской
- История платежей
- Отмена подписки

📡 API: `/subscriptions/*`
📁 `dev_modules/subscription_module/`

---

### 14. survey_module 📝
**Опросы**
- Список опросов
- Прохождение опросов
- Результаты
- Анализ ответов
- Рекомендации

📡 API: `/surveys/*`
📁 `dev_modules/survey_module/`

---

## 🎨 Как выбрать модули?

### Минимальное приложение
```
core_module + ui_kit_module + auth_module
```

### Приложение с основным функционалом
```
core_module + ui_kit_module + auth_module + tab_bar_module + 
home_module + diary_module + profile_module
```

### Полное приложение Supply Diets
```
Все 14 модулей
```

---

## 📊 Статистика

- **Всего модулей:** 14
- **Базовых:** 2 (обязательные)
- **Feature:** 12 (по необходимости)
- **API Endpoints:** 50+
- **UI Components:** 20+
- **Services:** 14
- **Models:** 30+

---

## 🚀 Быстрый доступ

| Модуль | Папка | API | Docs |
|--------|-------|-----|------|
| Core | `core_module/` | - | ✅ |
| UI Kit | `ui_kit_module/` | - | ✅ |
| Auth | `auth_module/` | `/auth/*` | ✅ |
| Tab Bar | `tab_bar_module/` | - | ✅ |
| Diary | `diary_module/` | `/diary/*` | ✅ |
| Profile | `profile_module/` | `/users/*` | ✅ |
| Plans | `plans_module/` | `/plans/*` | ✅ |
| Home | `home_module/` | `/home/*` | ✅ |
| Knowledge | `knowledge_module/` | `/courses/*` | ✅ |
| AI Chat | `ai_chat_module/` | `/ai-chat/*` | ✅ |
| Checkup | `checkup_module/` | `/lab-tests/*` | ✅ |
| Onboarding | `onboarding_module/` | `/onboarding/*` | ✅ |
| Subscription | `subscription_module/` | `/subscriptions/*` | ✅ |
| Survey | `survey_module/` | `/surveys/*` | ✅ |

---

## 📚 Документация

- 📖 [Общий README](README.md)
- ⚡ [Быстрый старт](QUICK_START.md)
- 📘 [Как использовать](HOW_TO_USE.md)
- 📋 [Список модулей](MODULES_LIST.md) ← Вы здесь

Каждый модуль имеет свой `README.md` с подробной документацией!

---

**Все модули работают на localhost по умолчанию! 🎉**





