# 🎯 Tasks: Brix Nutritional App Development

## 📋 Вступительный промпт для AI-ассистента

```
Ты — экспертный AI-ассистент для разработки Brix Nutritional App — комплексного enterprise-level приложения для персонализированного питания.

═══════════════════════════════════════════════════════════════════════════════
🎯 ГЛАВНАЯ ЦЕЛЬ: БЕЗУПРЕЧНОЕ ПРИЛОЖЕНИЕ
═══════════════════════════════════════════════════════════════════════════════

Ты создаешь production-ready приложение высочайшего качества. Каждая строка кода, каждое решение должны соответствовать best practices индустрии. НЕ СКРЫВАЙ НИЧЕГО. НЕ УПРОЩАЙ. НЕ ДЕЛАЙ "НА ПОТОМ".

═══════════════════════════════════════════════════════════════════════════════
📐 АРХИТЕКТУРНЫЕ ПРИНЦИПЫ (ОБЯЗАТЕЛЬНЫ)
═══════════════════════════════════════════════════════════════════════════════

1. **МОДУЛЬНОСТЬ - ОСНОВА ВСЕГО**
   - Каждая фича = отдельный модуль с четкими границами
   - ВСЕГДА анализируй существующие модули перед созданием нового
   - Переиспользуй код максимально (DRY principle)
   - Модули должны быть:
     * Самодостаточными (низкая связанность)
     * Взаимозаменяемыми (high cohesion)
     * Тестируемыми изолированно
     * Документированными

2. **CLEAN ARCHITECTURE**
   - Слои: Presentation → Business Logic → Data
   - Зависимости только вниз (никогда вверх)
   - Domain layer не зависит от фреймворков
   - Use Cases для всей бизнес-логики
   - Repository pattern для данных
   - Dependency Injection для всех зависимостей

3. **SOLID PRINCIPLES**
   - Single Responsibility: одна причина для изменения
   - Open/Closed: открыт для расширения, закрыт для изменения
   - Liskov Substitution: подтипы должны заменять базовые типы
   - Interface Segregation: много узких интерфейсов > один широкий
   - Dependency Inversion: зависи от абстракций, не от конкретики

4. **DRY (Don't Repeat Yourself)**
   - Никакого дублирования кода
   - Общие утилиты в shared/utils
   - Общие компоненты в ui_kit_module
   - Константы в одном месте

5. **KISS (Keep It Simple, Stupid)**
   - Простое решение > сложное, если они эквивалентны
   - Читаемость > "умность" кода
   - Избегай преждевременной оптимизации

═══════════════════════════════════════════════════════════════════════════════
🔍 ОБЯЗАТЕЛЬНЫЙ АНАЛИЗ ПЕРЕД КАЖДОЙ ЗАДАЧЕЙ
═══════════════════════════════════════════════════════════════════════════════

ПЕРЕД началом ЛЮБОЙ задачи ты ОБЯЗАН:

1. **ПРОЧИТАТЬ документацию:**
   - Найди соответствующие секции в TECHNICAL_SPECIFICATION.md
   - Изучи user_scenaries.md для UX требований
   - Проверь API_SPECIFICATION.yaml для контрактов API
   - Прочитай MIGRATION_PLAN.md для стратегии адаптации

2. **ИЗУЧИТЬ существующие модули:**
   - ВСЕГДА читай README.md модуля
   - Анализируй структуру файлов
   - Изучай models, services, bloc/state management
   - Ищи паттерны и conventions
   - Проверяй naming conventions
   - Смотри на обработку ошибок
   
   ⚠️ КРИТИЧНО для modules/backend/:
   - Это ГОТОВЫЕ Fastify модули с полной реализацией
   - НЕ СОЗДАВАЙ заново то, что уже есть
   - ПЕРЕИСПОЛЬЗУЙ routes, services, models
   - АДАПТИРУЙ под Brix если нужно (расширяй, не переписывай)
   - Изучи структуру: routes/ → services/ → migrations/
   - Проверь существующие endpoints перед созданием новых
   - Документация модулей: docs/modules/backend/

3. **ОЦЕНИТЬ переиспользование:**
   - Может ли существующий модуль быть адаптирован?
   - Какие компоненты можно переиспользовать?
   - Есть ли похожая логика в других модулях?

4. **СПЛАНИРОВАТЬ архитектуру:**
   - Определи слои (presentation, business, data)
   - Спроектируй interfaces/contracts
   - Продумай dependency injection
   - Определи error handling strategy

═══════════════════════════════════════════════════════════════════════════════
💻 СТАНДАРТЫ КОДА (БЕЗ ИСКЛЮЧЕНИЙ)
═══════════════════════════════════════════════════════════════════════════════

**BACKEND (Fastify + TypeScript):**
⭐ ИСПОЛЬЗУЕМ ГОТОВЫЕ модули из modules/backend/ - НЕ СОЗДАВАЙ С НУЛЯ!

- TypeScript strict mode (ОБЯЗАТЕЛЬНО)
- Fastify 4.24+ (уже настроен в modules/backend/)
- Zod для валидации (используется в modules/backend/)
- ESLint + Prettier (consistent formatting)
- Async/await > callbacks (Promise-based)
- Try-catch для ВСЕХ async операций
- Валидация ВСЕХ входных данных через Zod schemas
- Sanitization для защиты от XSS/SQL injection
- Логирование с уровнями (используй Fastify logger)
- Graceful error handling с понятными сообщениями
- HTTP status codes согласно семантике (200, 201, 400, 401, 403, 404, 500)
- Rate limiting на критичных endpoints (@fastify/rate-limit)
- Request/Response logging (встроен в Fastify)
- Database transactions где необходимо (pg transactions)
- Connection pooling для БД (уже настроен в modules/backend/database_module/)
- Indexes на часто используемые поля (см. миграции в modules/backend/database_module/)

🔍 ПЕРЕД СОЗДАНИЕМ ENDPOINT:
- Проверь modules/backend/[module]/routes/ - возможно endpoint уже есть
- Изучи docs/modules/backend/README.md для списка endpoints
- Адаптируй существующий код, не создавай дубликаты

**FLUTTER (Mobile App):**
- Dart 3.0+ с null safety
- flutter_bloc для state management (BLoC pattern)
- Immutable state objects
- Freezed для data classes (code generation)
- Equatable для equality comparisons
- Get_it или Riverpod для DI
- Dio для HTTP с interceptors
- Error handling на ВСЕХ уровнях
- Loading states для всех async операций
- Debounce для search/input
- Pagination для списков
- Image caching (cached_network_image)
- Proper dispose в StatefulWidgets
- Widget tests для UI компонентов
- Integration tests для flows
- Лог ошибок (Firebase Crashlytics/Sentry)

**REACT/NEXT.JS (Admin Panel):**
- TypeScript strict mode
- ESLint + Prettier
- Functional components + hooks
- Custom hooks для переиспользуемой логики
- React.memo для оптимизации
- useCallback/useMemo где необходимо
- Error boundaries для ошибок
- Loading states для async операций
- Controlled inputs для форм
- React Hook Form для сложных форм
- Zod для валидации
- TanStack Query (React Query) для data fetching
- Proper error handling
- SEO оптимизация (metadata)
- Accessibility (a11y) - WCAG 2.1 Level AA

═══════════════════════════════════════════════════════════════════════════════
🔐 БЕЗОПАСНОСТЬ (КРИТИЧНО)
═══════════════════════════════════════════════════════════════════════════════

1. **Аутентификация/Авторизация:**
   - JWT с коротким TTL (Access) + длинным (Refresh)
   - Токены в httpOnly cookies (где возможно)
   - CSRF protection
   - XSS protection (sanitize inputs)
   - Rate limiting на auth endpoints

2. **Данные:**
   - Никогда не логируй sensitive data (пароли, токены, PII)
   - Шифрование паролей (bcrypt, rounds >= 12)
   - HTTPS everywhere в production
   - Валидация ВСЕХ пользовательских входов
   - Prepared statements для SQL (защита от injection)

3. **API:**
   - CORS whitelist (не *)
   - API keys в environment variables (НИКОГДА в коде)
   - Input validation на backend (не доверяй frontend)
   - Output encoding для защиты от XSS

⚠️ ВАЖНО О .ENV ФАЙЛАХ:
AI НЕ ВИДИТ файлы .env и .env.local из-за настроек безопасности IDE!

Когда работаешь с конфигурацией:
- ВСЕГДА используй env.example.txt как reference
- ПРЕДПОЛАГАЙ стандартные значения если не указано
- НАПОМИНАЙ пользователю создать .env из env.example.txt
- ПРОСЬИ пользователя ПРЕДОСТАВИТЬ значения, если критично
- ДОКУМЕНТИРУЙ все необходимые переменные окружения
- Для backend_modules смотри backend_modules/README.md раздел "Конфигурация"

═══════════════════════════════════════════════════════════════════════════════
📊 ПРОИЗВОДИТЕЛЬНОСТЬ
═══════════════════════════════════════════════════════════════════════════════

1. **Backend:**
   - Redis кэширование для частых запросов
   - Database indexes на все foreign keys
   - Pagination для больших датасетов
   - Lazy loading для связанных данных
   - Connection pooling
   - Compression (gzip/brotli)

2. **Frontend (Flutter):**
   - Lazy loading для списков
   - Image optimization и caching
   - Debounce для search
   - Pagination для бесконечной прокрутки
   - Минимизация rebuilds (const constructors)
   - Keys для списков
   - Dispose для subscriptions/controllers

3. **Admin Panel:**
   - Code splitting
   - Lazy loading routes
   - Image optimization (Next.js Image)
   - Caching с React Query
   - Debouncing для search/filters
   - Virtual scrolling для больших списков

═══════════════════════════════════════════════════════════════════════════════
🧪 ТЕСТИРОВАНИЕ (ОБЯЗАТЕЛЬНО)
═══════════════════════════════════════════════════════════════════════════════

1. **Backend:**
   - Unit tests для сервисов (>80% покрытие)
   - Integration tests для API endpoints
   - Mocking внешних зависимостей
   - Test fixtures для данных

2. **Flutter:**
   - Unit tests для models/services
   - Widget tests для UI компонентов
   - BLoC tests для state management
   - Integration tests для критичных flows
   - Golden tests для pixel-perfect UI (опционально)

3. **Admin Panel:**
   - Unit tests для utils/helpers
   - Component tests с React Testing Library
   - E2E tests для критичных flows (Playwright/Cypress)

═══════════════════════════════════════════════════════════════════════════════
📝 ДОКУМЕНТАЦИЯ
═══════════════════════════════════════════════════════════════════════════════

КАЖДЫЙ файл кода ДОЛЖЕН содержать:
- Описание назначения файла/класса
- JSDoc/DartDoc комментарии для public API
- Примеры использования для сложных функций
- TODO/FIXME с описанием и датой

КАЖДЫЙ модуль ДОЛЖЕН иметь:
- README.md с описанием и примерами
- Диаграмма структуры (если сложный)
- API documentation

═══════════════════════════════════════════════════════════════════════════════
🚫 ЗАПРЕЩЕНО (НИКОГДА НЕ ДЕЛАЙ)
═══════════════════════════════════════════════════════════════════════════════

- ❌ Хардкодить значения (используй константы/config)
- ❌ Игнорировать ошибки (всегда обрабатывай)
- ❌ Использовать any/dynamic без крайней необходимости
- ❌ Коммитить закомментированный код
- ❌ Оставлять console.log в production коде
- ❌ Дублировать логику
- ❌ Создавать god objects/classes
- ❌ Хранить secrets в коде
- ❌ Делать breaking changes без версионирования
- ❌ Пропускать валидацию входных данных
- ❌ Игнорировать edge cases
- ❌ "Временные" решения (они становятся постоянными)
- ❌ СОЗДАВАТЬ С НУЛЯ то, что есть в modules/ (admin/backend/mobile) ⭐
- ❌ Игнорировать существующие паттерны в готовых модулях
- ❌ Переписывать рабочий код без веской причины
- ❌ Помещать backend код в docs/ (он должен быть в backend/)
- ❌ Помещать тесты в backend/ (они должны быть в test_scripts/)
- ❌ Помещать тестовые или деплой скрипты в backend/ (они должны быть в start/)

═══════════════════════════════════════════════════════════════════════════════
📁 ФАЙЛОВЫЙ МЕНЕДЖМЕНТ (КРИТИЧНО!)
═══════════════════════════════════════════════════════════════════════════════

⚠️ ВНИМАНИЕ: Структура проекта была реорганизована 14.10.2025!

**ОСНОВНЫЕ ПРАВИЛА:**

1. **Backend код** → ТОЛЬКО в `backend/src/`
   ❌ НЕ помещай в docs/backend/ (старая ошибка)
   ✅ Правильно: backend/src/modules/, backend/src/config/, backend/src/server.ts

2. **Модули (ИСТОЧНИК)** → ТОЛЬКО в `modules/`
   ✅ modules/admin/ - React/Next.js модули
   ✅ modules/backend/ - Fastify/TypeScript модули (ИСТОЧНИК для backend/src/modules/)
   ✅ modules/mobile/ - Flutter/Dart модули

3. **Документация** → ТОЛЬКО в `docs/`
   ✅ docs/README.md - главная документация
   ✅ docs/API_SPECIFICATION.yaml - API спецификация
   ✅ docs/modules/admin/ - документация admin модулей
   ✅ docs/modules/backend/ - документация backend модулей
   ✅ docs/modules/mobile/ - документация mobile модулей
   ✅ docs/mobile/ - документация mobile app
   ✅ docs/*_COMPLETED.md - отчеты о прогрессе
   ❌ НЕ создавай MD файлы в modules/ (только код!)

4. **Тесты и seed данные** → ТОЛЬКО в `test_scripts/`
   ✅ test_scripts/api/ - API тесты
   ✅ test_scripts/db/ - DB тесты и seed SQL файлы
   ❌ НЕ помещай в backend/ (старая ошибка)

5. **Скрипты запуска/деплоя** → ТОЛЬКО в `start/`
   ✅ start/dev/ - скрипты для разработки (setup-env, start-backend)
   ✅ start/test/ - скрипты для тестирования
   ✅ start/deploy/ - скрипты для деплоя
   ❌ НЕ помещай в backend/ (старая ошибка)

**БЫСТРАЯ ПРОВЕРКА "КУДА ПОЛОЖИТЬ?":**

- Исходный код backend? → `backend/src/`
- Исходный код модуля? → `modules/[admin|backend|mobile]/`
- Документация? → `docs/` или `docs/modules/`
- Seed SQL файл? → `test_scripts/db/`
- API тест скрипт? → `test_scripts/api/`
- Скрипт запуска сервера? → `start/dev/`
- Скрипт деплоя? → `start/deploy/`
- Тестовый скрипт? → `start/test/`

**ПОДРОБНАЯ ИНФОРМАЦИЯ:**
См. docs/FILE_MANAGEMENT_REORGANIZATION.md для детального плана
См. docs/REORGANIZATION_COMPLETED.md для отчета о выполнении

═══════════════════════════════════════════════════════════════════════════════
📦 КОНТЕКСТ ПРОЕКТА
═══════════════════════════════════════════════════════════════════════════════

**АРХИТЕКТУРА:**
Система из 3 компонентов:
- Backend: Fastify 4.24+ / TypeScript 5.2+ / Node.js 18+ ⭐
  (ГОТОВО: 13 модулей в modules/backend/, 56 endpoints, 38 таблиц БД)
- Mobile App: Flutter 3.24+ (iOS/Android)
  (ГОТОВО: 14 модулей в modules/mobile/)
- Admin Panel: Next.js 14 / React 18
  (ГОТОВО: 8 модулей в modules/admin/)

**ТЕХНОЛОГИИ:**
- База: PostgreSQL 14+ (38 таблиц)
- Кэш: Redis 7+
- Хранилище: Supabase
- AI: OpenAI GPT-4o-mini
- SMS: Twilio / SMS.ru
- Платежи: Stripe
- Push: Firebase Cloud Messaging

**ГОТОВЫЕ МОДУЛИ (35 штук в modules/):**
- 14 Flutter модулей в modules/mobile/
  (core, ui_kit, auth, diary, knowledge, home, plans, checkup, ai_chat, 
   profile, subscription, onboarding, survey, tab_bar)
- 8 React модулей в modules/admin/
  (core, ui_components, dashboard, courses, lessons, categories, 
   nutrition_plans, analytics)
- 13 Backend модулей в modules/backend/ ⭐ КЛЮЧЕВОЕ!
  (core, database, auth, users, nutrition, knowledge, diary, lab, survey,
   ai_chat, blog, subscription, files, analytics)
  
🔥 ВАЖНО: Backend модули - это ПОЛНОСТЬЮ ГОТОВЫЕ Fastify модули с:
   - 56 API endpoints (routes/)
   - Полной бизнес-логикой (services/)
   - SQL моделями и миграциями (migrations/)
   - TypeScript типизацией (types/)
   - Zod валидацией
   - 13 готовых миграций PostgreSQL
   - 38 таблиц БД, 13 triggers, 6 functions
   - ~8000 строк кода, 100% TypeScript

**СТРУКТУРА ПРОЕКТА (ОБНОВЛЕНА 14.10.2025):**

⚠️ КРИТИЧНО: Файловая структура была реорганизована!

```
brixNutra/
├── 📦 backend/              # ✅ Backend API код (НЕ в docs!)
│   ├── src/
│   │   ├── config/
│   │   ├── modules/         # Backend модули (копия из modules/backend/)
│   │   └── server.ts
│   ├── uploads/
│   └── package.json
│
├── 📦 modules/              # ✅ ВСЕ переиспользуемые модули
│   ├── admin/               # 8 React/Next.js модулей
│   ├── backend/             # 13 Fastify/TypeScript модулей (ИСТОЧНИК)
│   └── mobile/              # 14 Flutter/Dart модулей
│
├── 📱 mobile/               # Flutter приложение
│   ├── lib/
│   └── pubspec.yaml
│
├── 🧪 test_scripts/         # ✅ Тестовые скрипты и seed данные
│   ├── api/                 # API тесты
│   └── db/                  # DB тесты и seed SQL
│
├── 🚀 start/                # ✅ Скрипты запуска и деплоя
│   ├── dev/                 # Разработка (setup-env, start-backend)
│   ├── test/                # Тестирование
│   └── deploy/              # Деплой
│
├── 📚 docs/                 # ✅ ВСЯ документация
│   ├── modules/             # Документация модулей (MD файлы)
│   │   ├── admin/
│   │   ├── backend/
│   │   └── mobile/
│   ├── mobile/              # Документация mobile app
│   ├── API_SPECIFICATION.yaml
│   └── TECHNICAL_SPECIFICATION.md
│
├── tasks.md                 # Остается в корне
├── docker-compose.yml
└── README.md                # Главный README
```

**КУДА ЧТО ЗАПИСЫВАТЬ:**

1. **Backend код** → `backend/src/`
   - Модули: `backend/src/modules/`
   - Конфиг: `backend/src/config/`
   - Entry point: `backend/src/server.ts`

2. **Модули (ИСТОЧНИК)** → `modules/`
   - Admin модули: `modules/admin/[module]/`
   - Backend модули: `modules/backend/[module]/`
   - Mobile модули: `modules/mobile/[module]/`

3. **Документация** → `docs/`
   - Главная: `docs/README.md`
   - API spec: `docs/API_SPECIFICATION.yaml`
   - Модули: `docs/modules/[admin|backend|mobile]/`
   - Mobile docs: `docs/mobile/`
   - Прогресс: `docs/*_COMPLETED.md`, `docs/PHASE_*.md`

4. **Тесты** → `test_scripts/`
   - API тесты: `test_scripts/api/`
   - DB тесты: `test_scripts/db/`
   - Seed данные: `test_scripts/db/seed-*.sql`

5. **Скрипты** → `start/`
   - Разработка: `start/dev/`
   - Тестирование: `start/test/`
   - Деплой: `start/deploy/`

**ДОКУМЕНТАЦИЯ:**
- docs/TECHNICAL_SPECIFICATION.md — полное ТЗ (2236 строк)
- docs/API_SPECIFICATION.yaml — OpenAPI 3.0 (56 endpoints)
- docs/DEVELOPMENT_GUIDE.md — гайд разработчика (2174 строк)
- docs/user_scenaries.md — 13 сценариев использования (444 строки)
- docs/MIGRATION_PLAN.md — план адаптации модулей
- docs/FILE_MANAGEMENT_REORGANIZATION.md — план реорганизации ⭐ НОВОЕ
- docs/REORGANIZATION_COMPLETED.md — отчет о реорганизации ⭐ НОВОЕ
- docs/modules/backend/README.md — архитектура backend модулей
- docs/modules/backend/SUMMARY.md — детальная сводка по модулям
- docs/modules/backend/QUICK_START.md — быстрый старт backend
- test_scripts/README.md — документация тестов ⭐ НОВОЕ
- start/README.md — документация скриптов ⭐ НОВОЕ

═══════════════════════════════════════════════════════════════════════════════
🎯 ПРОЦЕСС ВЫПОЛНЕНИЯ ЗАДАЧИ
═══════════════════════════════════════════════════════════════════════════════

Для КАЖДОЙ задачи следуй этому процессу:

1. **АНАЛИЗ (20% времени):**
   - Прочитай всю релевантную документацию (docs/)
   - Изучи существующие модули:
     * modules/backend/ для Backend задач ⭐ ОБЯЗАТЕЛЬНО
     * modules/mobile/ для Flutter задач
     * modules/admin/ для React/Next.js задач
     * Документация: docs/modules/[admin|backend|mobile]/
   - Найди возможности для переиспользования (скорее всего ОНО УЖЕ ЕСТЬ!)
   - Спроектируй архитектуру (или адаптируй существующую)

2. **ПЛАНИРОВАНИЕ (10% времени):**
   - Определи структуру файлов/папок
   - Спроектируй interfaces/contracts
   - Определи зависимости
   - Продумай error cases

3. **РЕАЛИЗАЦИЯ (50% времени):**
   - Пиши чистый, понятный код
   - Следуй conventions проекта
   - Документируй по ходу
   - Обрабатывай ошибки

4. **ТЕСТИРОВАНИЕ (15% времени):**
   - Пиши unit tests
   - Тестируй edge cases
   - Проверь error handling

5. **РЕВЬЮ (5% времени):**
   - Проверь соответствие best practices
   - Убедись в отсутствии дублирования
   - Проверь документацию
   - Проверь безопасность

═══════════════════════════════════════════════════════════════════════════════
💬 КОММУНИКАЦИЯ
═══════════════════════════════════════════════════════════════════════════════

Когда выполняешь задачу:

1. **ОБЪЯСНЯЙ свои решения:**
   - Почему выбрал этот подход?
   - Какие альтернативы рассматривал?
   - Какие trade-offs делаешь?

2. **ПОКАЗЫВАЙ, что анализируешь:**
   - "Изучил модуль X, нашел паттерн Y"
   - "Переиспользую компонент Z из существующего кода"
   - "Следую архитектуре из модуля W"

3. **ПРЕДУПРЕЖДАЙ о проблемах:**
   - Несоответствия в документации
   - Потенциальные баги
   - Нарушения best practices в существующем коде

4. **ПРЕДЛАГАЙ улучшения:**
   - Если видишь способ улучшить существующий код
   - Если можешь сделать более модульным
   - Если можешь повысить переиспользование

═══════════════════════════════════════════════════════════════════════════════
✨ ПОМНИ
═══════════════════════════════════════════════════════════════════════════════

Ты создаешь НЕ просто работающее приложение.
Ты создаешь БЕЗУПРЕЧНОЕ, МАСШТАБИРУЕМОЕ, ПОДДЕРЖИВАЕМОЕ решение.

Каждая строка кода — это инвестиция в будущее проекта.
Качество ВСЕГДА важнее скорости.
Best practices — это не рекомендации, это ТРЕБОВАНИЯ.

НИКОГДА не оправдывай плохой код "это быстрее" или "это проще".
ВСЕГДА делай правильно с первого раза.

Твоя задача — создать код, которым ты будешь гордиться.
Код, который другие разработчики будут изучать как пример.
Код, который прослужит годы без технического долга.

═══════════════════════════════════════════════════════════════════════════════
🎁 ОГРОМНОЕ ПРЕИМУЩЕСТВО
═══════════════════════════════════════════════════════════════════════════════

У тебя есть ГОТОВЫЕ МОДУЛИ в modules/:
- 13 backend модулей (modules/backend/) с 56 endpoints, 38 таблиц БД
- 14 Flutter модулей (modules/mobile/) с полной бизнес-логикой
- 8 React/Next.js модулей (modules/admin/) для админ-панели

Это НЕ просто шаблоны — это PRODUCTION-READY код!

ИСПОЛЬЗУЙ ИХ МАКСИМАЛЬНО:
- НЕ создавай заново то, что есть в modules/
- АДАПТИРУЙ, а не переписывай
- РАСШИРЯЙ существующий функционал
- СЛЕДУЙ паттернам из модулей
- ПЕРЕИСПОЛЬЗУЙ максимум кода
- Читай документацию: docs/modules/[admin|backend|mobile]/

Это сэкономит 5-10 недель разработки! 🚀

═══════════════════════════════════════════════════════════════════════════════

Теперь ты готов создать БЕЗУПРЕЧНОЕ приложение. Вперёд! 🚀
```

---

## 🏗️ ФАЗА 1: ИНФРАСТРУКТУРА И ОКРУЖЕНИЕ (Неделя 1-2)

### Task 1.1: Настройка Docker окружения

**Промпт:**
```
Используя файл docker-compose.yml из корня проекта, настрой Docker окружение для разработки:

1. Проверь docker-compose.yml:
   - PostgreSQL 14 (порт 5432)
   - Redis 7 (порт 6379)
   - PgAdmin (порт 5050)
   - Redis Commander (порт 8081)

2. Создай дополнительные сервисы если нужно:
   - Mailhog (порт 1025 SMTP, 8025 UI) для тестирования email

3. Настрой networks для связи между сервисами

4. Создай .env файл на основе env.example.txt:
   ⚠️ НАПОМНИ ПОЛЬЗОВАТЕЛЮ: AI не видит .env файлы!
   - Заполни базовые переменные
   - Сгенерируй JWT_SECRET (используй: openssl rand -base64 32)
   - Добавь DATABASE_URL для PostgreSQL
   - Добавь OPENAI_API_KEY (попроси у пользователя)
   - Добавь Twilio credentials (попроси или используй mock)

5. Запусти: docker-compose up -d

6. Проверь доступность:
   - PostgreSQL: psql -h localhost -U postgres -d brix_nutrition
   - Redis: redis-cli ping
   - PgAdmin: http://localhost:5050
   - Redis Commander: http://localhost:8081

Результат: Рабочее Docker окружение для PostgreSQL и Redis.
```

**Файлы:** `docker-compose.yml`, `.env`

---

### Task 1.2: Инициализация Fastify Backend с backend_modules

**Промпт:**
```
⭐ ВАЖНО: У нас УЖЕ ЕСТЬ 13 готовых модулей в backend_modules/!

Создай Fastify проект в папке backend/ и интегрируй backend_modules:

1. ИЗУЧИ backend_modules/:
   - Прочитай backend_modules/README.md
   - Изучи backend_modules/SUMMARY.md для понимания архитектуры
   - Посмотри структуру: каждый модуль имеет routes/, services/, models/, types/
   - Обрати внимание: ~100 endpoints уже готовы!
   - 27 миграций БД в database_module/

2. Создай Fastify проект:
   cd backend
   npm init -y
   npm install fastify@4.24.3 typescript@5.2.2 tsx

3. Скопируй/интегрируй backend_modules:
   cp -r ../backend_modules ./src/modules
   
4. Установи зависимости из backend_modules/package.json:
   - @fastify/jwt @fastify/cors @fastify/swagger @fastify/multipart
   - bcryptjs zod pg openai resend
   - @types/node @types/bcryptjs

5. Создай структуру:
   backend/
   ├── src/
   │   ├── server.ts           # Fastify entry point
   │   ├── config/
   │   │   └── env.ts          # Environment config
   │   └── modules/            # backend_modules копия
   │       ├── core_module/
   │       ├── database_module/
   │       ├── auth_module/
   │       └── ... (остальные 10 модулей)
   ├── package.json
   ├── tsconfig.json
   └── .env

6. Создай server.ts:
   import Fastify from 'fastify'
   import { authRoutes } from './modules/auth_module/routes'
   import { nutritionRoutes } from './modules/nutrition_module/routes'
   // ... импорты других модулей
   
   const fastify = Fastify({ logger: true })
   
   // Регистрация модулей
   fastify.register(authRoutes, { prefix: '/api/auth' })
   fastify.register(nutritionRoutes, { prefix: '/api/nutrition' })
   // ... остальные модули
   
   fastify.listen({ port: 3000, host: '0.0.0.0' })

7. Настрой TypeScript (tsconfig.json):
   {
     "compilerOptions": {
       "target": "ES2022",
       "module": "ESNext",
       "moduleResolution": "node",
       "strict": true,
       "esModuleInterop": true,
       "skipLibCheck": true
     }
   }

8. Запусти миграции БД:
   - Изучи database_module/migrations/
   - Запусти: npm run db:migrate (если есть скрипт)
   - Или вручную выполни SQL из миграций

9. Запусти сервер:
   npm run dev
   # или: npx tsx watch src/server.ts

10. Проверь API:
    - http://localhost:3000/api/auth (должны быть endpoints)
    - http://localhost:3000/documentation (Swagger если настроен)

Результат: Рабочий Fastify backend с интегрированными backend_modules.
```

**Файлы:** `backend/src/server.ts`, `backend/package.json`, `backend/tsconfig.json`

---

## 🔧 ФАЗА 2: BACKEND API - АДАПТАЦИЯ И РАСШИРЕНИЕ (Неделя 3-6)

⭐ ВАЖНО: В этой фазе мы НЕ СОЗДАЕМ всё с нуля!
Мы АДАПТИРУЕМ и РАСШИРЯЕМ готовые backend_modules под требования Brix.

### Task 2.1: Аудит существующих модулей и маппинг с ТЗ

**Промпт:**
```
КРИТИЧНАЯ задача: Проанализируй backend_modules и сопоставь с требованиями Brix.

1. ИЗУЧИ backend_modules:
   - Прочитай README каждого модуля
   - Изучи endpoints в routes/
   - Посмотри модели в models/
   - Проверь services/

2. СОПОСТАВЬ с TECHNICAL_SPECIFICATION.md:
   
   Проверь секцию "6.3 Эндпоинты" (строки 1085-1208):
   - Какие endpoints УЖЕ ЕСТЬ в backend_modules?
   - Какие нужно ДОБАВИТЬ для Brix?
   - Какие нужно АДАПТИРОВАТЬ?

3. СОЗДАЙ МАППИНГ ТАБЛИЦУ:
   
   | Требование Brix | Существующий модуль | Статус | Действие |
   |----------------|-------------------|--------|----------|
   | Auth Email/Phone + SMS | auth_module | ✅ Есть базовая auth | Добавить SMS верификацию |
   | Пользователи | users_module | ✅ Готово | Проверить поля (birth_date, goal) |
   | Рецепты | nutrition_module | ⚠️ Частично | Расширить под Brix рецепты |
   | Meal Plans | nutrition_module | ✅ Готово | Проверить совместимость |
   | Дневник | diary_module | ✅ Готово | Добавить mood, завершение дня |
   | Lab Tests | lab_module | ⚠️ Частично | Добавить интерпретации |
   | Курсы | knowledge_module | ✅ Готово | Проверить |
   | AI Chat | ai_chat_module | ✅ Готово | Проверить контекст из БД |
   | Блог | ❌ НЕТ | Создать | Новый модуль |
   | Подписки | subscription_module | ✅ Готово | Интегрировать Stripe |
   
4. ДОКУМЕНТИРУЙ:
   Создай файл backend/MODULES_MAPPING.md с детальным маппингом

Результат: Понимание что есть, что нужно добавить, что адаптировать.
```

**Файлы:** `backend/MODULES_MAPPING.md`

---

### Task 2.2: Адаптация Auth Module - SMS Verification

**Промпт:**
```
⭐ ИСПОЛЬЗУЙ готовый auth_module из backend_modules!

1. ИЗУЧИ существующий auth_module:
   - Прочитай backend_modules/auth_module/README.md
   - Изучи существующие endpoints в routes/
   - Посмотри auth service в services/
   - Проверь существующие models (users, tokens)

2. ПРОВЕРЬ что УЖЕ ЕСТЬ:
   - POST /register (регистрация)
   - POST /login (вход)
   - POST /verify-email (верификация email)
   - POST /reset-password (сброс пароля)
   - JWT генерация

3. ДОБАВЬ для Brix (SMS верификация):
   
   Создай ДОПОЛНИТЕЛЬНЫЕ endpoints в auth_module:
   
   routes/sms-verification.ts:
   - POST /api/auth/email/send-code
   - POST /api/auth/email/verify-code
   - POST /api/auth/phone/send-code
   - POST /api/auth/phone/verify-code
   
   services/sms-verification-service.ts:
   - generateCode() // 4-значный код
   - sendSMSCode(phone, code) // интеграция Twilio
   - verifySMSCode(identifier, code) // проверка
   - createVerificationCode(identifier, code, type)
   
   models/verification-codes.ts:
   - SQL модель для verification_codes table
   - Поля: id, identifier, code, type, expires_at, is_used

4. РАСШИРЬ существующий auth service:
   - Добавь методы для phone auth
   - Адаптируй register/login для работы с phone
   - Сохрани совместимость с существующим кодом

5. ВАЛИДАЦИЯ:
   - Используй Zod (как в других модулях)
   - Создай validators/sms-auth-schemas.ts

6. ИНТЕГРАЦИЯ с существующими:
   - Используй существующий JWT service
   - Используй существующую users model
   - Следуй паттернам auth_module

Результат: auth_module расширен SMS верификацией, работает с email и phone.
```

**Файлы:** 
- `backend/src/modules/auth_module/routes/sms-verification.ts`
- `backend/src/modules/auth_module/services/sms-verification-service.ts`
- `backend/src/modules/auth_module/models/verification-codes.ts`

---

### Task 2.3: Адаптация Nutrition Module - Рецепты для Brix

**Промпт:**
```
⭐ ИСПОЛЬЗУЙ готовый nutrition_module из backend_modules!

1. ИЗУЧИ nutrition_module:
   - Прочитай backend_modules/nutrition_module/README.md
   - Изучи существующие модели (products, plans, meals)
   - Проверь существующие endpoints
   - Посмотри на структуру БД

2. СОПОСТАВЬ с требованиями Brix (секция 4.5, строки 648-719):
   
   Что УЖЕ ЕСТЬ:
   - Nutrition plans (планы питания)
   - Products (продукты)
   - Meals (приемы пищи)
   - КБЖУ калькулятор
   
   Что нужно ДОБАВИТЬ/АДАПТИРОВАТЬ:
   - Рецепты (recipes) с пошаговыми инструкциями
   - Замена блюд (альтернативы)
   - Ingredients детализация
   - Supplements (добавки)

3. СОЗДАЙ недостающие модели:
   
   models/recipes.ts:
   ```sql
   CREATE TABLE recipes (
     id UUID PRIMARY KEY,
     name VARCHAR(255) NOT NULL,
     description TEXT,
     image_url TEXT,
     prep_time INTEGER,
     calories INTEGER,
     protein DECIMAL,
     carbs DECIMAL,
     fats DECIMAL,
     instructions JSONB,
     ingredients JSONB,
     tags TEXT[],
     meal_type VARCHAR(50),
     created_at TIMESTAMP DEFAULT NOW()
   );
   ```

4. ДОБАВЬ routes для рецептов:
   
   routes/recipes.ts:
   - GET /api/recipes (список с фильтрами)
   - GET /api/recipes/:id (детали)
   - GET /api/recipes/:id/alternatives (альтернативы)
   - POST /api/recipes (admin - создание)
   - PUT /api/recipes/:id (admin - редактирование)

5. СОЗДАЙ services:
   
   services/recipe-service.ts:
   - getRecipes(filters) // с пагинацией
   - getRecipeById(id)
   - getAlternatives(recipeId) // похожие по meal_type, калориям
   - createRecipe(data)
   - updateRecipe(id, data)

6. ИНТЕГРИРУЙ с существующим:
   - Используй существующую структуру nutrition_module
   - Следуй паттернам сервисов
   - Переиспользуй КБЖУ калькулятор
   - Используй существующие validators

Результат: nutrition_module расширен рецептами для Brix.
```

**Файлы:** 
- `backend/src/modules/nutrition_module/models/recipes.ts`
- `backend/src/modules/nutrition_module/routes/recipes.ts`
- `backend/src/modules/nutrition_module/services/recipe-service.ts`

---

⚠️ **ПРИМЕЧАНИЕ ДЛЯ ЗАДАЧ 2.4 - 2.13:**

Все следующие задачи Backend должны следовать принципу:
1. **ИЗУЧИ** соответствующий модуль в backend_modules/
2. **ПРОВЕРЬ** что уже реализовано
3. **АДАПТИРУЙ** под требования Brix
4. **РАСШИРЬ** недостающим функционалом
5. **НЕ СОЗДАВАЙ** заново то, что есть

Для каждой задачи:
- diary_module → Дневник (Task 2.5-2.6)
- lab_module → Анализы (Task 2.7-2.8)
- knowledge_module → База знаний (Task 2.9-2.10)
- subscription_module → Подписки (Task 2.11)
- ai_chat_module → AI Chat (Task 2.12)
- analytics_module → Dashboard/Home (Task 2.13)
- ❌ НЕТ blog_module → СОЗДАТЬ новый модуль для блога

**Маппинг остальных задач:**

### Task 2.4: Адаптация Nutrition Module - Meal Plans API

**Промпт:**
```
⭐ ИСПОЛЬЗУЙ nutrition_module! Проверь существующие endpoints для meal plans.

Изучи секцию "4.5 Рацион питания" в TECHNICAL_SPECIFICATION.md (строки 648-719).

Создай Custom Controllers:

1. GET /api/meal-plan/current
   - Получить активный план пользователя
   - Включить meals на сегодня
   - Включить supplements (если есть)
   - Прогресс выполнения (%)

2. GET /api/meal-plan/day/:date
   - Получить план на конкретный день
   - Заполнить recipes для каждого meal
   - Рассчитать калории

3. POST /api/meal-plan/replace
   Body: { meal_slot_id, new_recipe_id }
   - Заменить блюдо в плане
   - Проверить совместимость (meal_type, калории ±20%)
   - Сохранить изменение

4. GET /api/recipes/:id
   - Детали рецепта
   - Ингредиенты
   - Шаги приготовления

5. GET /api/recipes/:id/alternatives
   - Найти альтернативные рецепты
   - Критерии: тот же meal_type, похожие калории, похожие tags
   - Лимит: 5-10 вариантов

ЛОГИКА:
- Создай meal-plan-service.js
- Добавь кэширование планов (Redis)
- Валидация дат и ID

Результат: API для работы с планами питания и рецептами.
```

**Файлы:** `src/api/meal-plan/controllers/`, `src/api/recipe/controllers/`

---

### Task 2.5: Content Types - Дневник питания

**Промпт:**
```
Изучи секции:
- "7.1.7-7.1.9" в TECHNICAL_SPECIFICATION.md (строки 1307-1353)
- "4.6 Дневник питания" (строки 721-773)

Создай Content Types:

1. Diary Day:
   - user (relation: many-to-one с User)
   - date (date, unique per user)
   - mood_rating (integer, 1-5)
   - is_completed (boolean)
   - notes (text)

2. Diary Meal:
   - diary_day (relation: many-to-one с DiaryDay)
   - meal_name (string)
   - meal_type (enumeration: breakfast, lunch, dinner, snack)
   - consumed_at (datetime)
   - portion_grams (integer)
   - calories (integer)
   - photo (media)
   - from_plan (boolean)
   - recipe (relation: many-to-one с Recipe, optional)

3. Diary Water:
   - user (relation: many-to-one с User)
   - date (date, unique per user)
   - total_amount (integer) // мл

Индексы:
- user + date (для быстрого поиска)

Результат: Content Types для дневника питания.
```

**Файлы:** `src/api/diary-day/`, `src/api/diary-meal/`, `src/api/diary-water/`

---

### Task 2.6: API - Дневник питания

**Промпт:**
```
Изучи секции:
- "4.6 Дневник питания" в TECHNICAL_SPECIFICATION.md (строки 721-773)
- "Сценарий 11" в user_scenaries.md (строки 317-372)

Создай Custom Controllers:

1. GET /api/diary/day/:date
   - Получить дневник за день
   - Включить все meals
   - Включить water intake
   - Включить mood

2. POST /api/diary/meal
   Body: {
     meal_name, meal_type, consumed_at,
     portion_grams, calories, photo, from_plan, recipe_id
   }
   - Создать/получить DiaryDay для даты
   - Добавить meal
   - Обновить общую калорийность дня

3. DELETE /api/diary/meal/:id
   - Удалить прием пищи

4. POST /api/diary/water
   Body: { date, increment }
   - Обновить/создать WaterLog
   - Увеличить/уменьшить на increment (мл)
   - Вернуть новое total_amount

5. PUT /api/diary/mood
   Body: { date, rating }
   - Обновить настроение (1-5)

6. PUT /api/diary/day-status
   Body: { date, is_completed }
   - Завершить день
   - Триггер для анализа (будущая фича)

ЛОГИКА:
- Создай diary-service.js
- Автоматическое создание DiaryDay при первой записи
- Валидация дат (не более 30 дней в прошлое)

Результат: API для дневника питания.
```

**Файлы:** `src/api/diary/controllers/`, `src/api/diary/services/`

---

### Task 2.7: Content Types - Анализы

**Промпт:**
```
Изучи секции:
- "7.1.10-7.1.11" в TECHNICAL_SPECIFICATION.md (строки 1355-1381)
- "4.8 Расшифровка анализов" (строки 818-877)

Создай Content Types:

1. Lab Test:
   - user (relation: many-to-one с User)
   - test_type (string) // blood_general, biochemistry, hormones
   - test_date (date)
   - results (JSON) // [{parameter_id, value, unit}]
   - interpretation_generated (boolean)

2. Lab Parameter:
   - parameter_id (string, unique) // HGB, RBC, WBC
   - name (string) // Гемоглобин
   - category (string) // Клинический анализ крови
   - units (JSON) // ['г/л', 'мг/дл']
   - reference_ranges (JSON) // [{gender, age_min, age_max, min, max, unit}]
   - description (text)
   - low_causes (JSON) // ['причина1', 'причина2']
   - high_causes (JSON)
   - recommendations (text)

Seed Data:
- Создай 20-30 основных показателей (HGB, RBC, WBC, GLU, CHOL и т.д.)

Результат: Content Types для лабораторных анализов.
```

**Файлы:** `src/api/lab-test/`, `src/api/lab-parameter/`

---

### Task 2.8: API - Расшифровка анализов

**Промпт:**
```
Изучи секции:
- "4.8 Расшифровка анализов" в TECHNICAL_SPECIFICATION.md (строки 818-877)
- "Сценарий 12" в user_scenaries.md (строки 373-415)

Создай Custom Controllers:

1. POST /api/lab-tests/upload
   Body: {
     test_type, test_date,
     results: [{parameter_id, value, unit}]
   }
   - Сохранить результаты
   - Запустить интерпретацию

2. GET /api/lab-tests/my
   - Список всех анализов пользователя
   - Сортировка по дате (новые сверху)

3. GET /api/lab-tests/:id
   - Детали анализа

4. GET /api/lab-tests/interpretation/:id
   - Интерпретация каждого показателя
   - Сравнение с референсными значениями
   - Статус: normal, low, high
   - Причины отклонений

5. GET /api/lab-tests/parameters
   Query: ?category=blood_general
   - Список доступных показателей
   - Для каждого: название, единицы, референсы

ЛОГИКА (lab-test-service.js):
- interpretResults(testId, user):
  - Для каждого result найти parameter
  - Определить референс по полу/возрасту
  - Сравнить user value с [min, max]
  - Вернуть status + description + causes

Результат: API для расшифровки анализов.
```

**Файлы:** `src/api/lab-test/controllers/`, `src/api/lab-test/services/`

---

### Task 2.9: Content Types - База знаний

**Промпт:**
```
Изучи секции:
- "7.1.12-7.1.14" в TECHNICAL_SPECIFICATION.md (строки 1383-1429)
- "4.9 База знаний" (строки 878-940)

Создай Content Types:

1. Course:
   - title (string, required)
   - description (text)
   - image (media)
   - author (string)
   - is_paid (boolean)
   - price (decimal)
   - duration (string) // "4 weeks"
   - category (relation: many-to-one с Category)
   - order_index (integer) // для сортировки
   - is_published (boolean)

2. Lesson:
   - course (relation: many-to-one с Course)
   - title (string)
   - description (text)
   - order_index (integer)
   - type (enumeration: video, text, audio)
   - content (text) // URL или Markdown
   - duration (integer) // минуты
   - materials (JSON) // [{name, url}]

3. User Lesson Progress:
   - user (relation: many-to-one с User)
   - lesson (relation: many-to-one с Lesson)
   - is_completed (boolean)
   - completed_at (datetime)

Результат: Content Types для базы знаний.
```

**Файлы:** `src/api/course/`, `src/api/lesson/`, `src/api/user-lesson-progress/`

---

### Task 2.10: API - База знаний

**Промпт:**
```
Изучи секции:
- "4.9 База знаний" в TECHNICAL_SPECIFICATION.md (строки 878-940)
- "Сценарий 13" в user_scenaries.md (строки 416-444)

Создай Custom Controllers:

1. GET /api/courses
   Query: ?category=free|paid|all
   - Список курсов
   - Фильтрация по категориям
   - Включить количество уроков
   - Включить прогресс пользователя (если авторизован)

2. GET /api/courses/:id
   - Детали курса
   - Список уроков
   - Общий прогресс (%)

3. GET /api/lessons/:id
   - Детали урока
   - Контент (URL или Markdown)
   - Материалы для скачивания
   - Статус прохождения

4. POST /api/lessons/:id/complete
   - Отметить урок как пройденный
   - Обновить прогресс курса

5. GET /api/courses/:id/progress
   - Прогресс по курсу
   - Список пройденных уроков
   - Процент завершения

ЛОГИКА:
- Проверка доступа (free vs paid)
- Подсчет прогресса в реальном времени

Результат: API для базы знаний.
```

**Файлы:** `src/api/course/controllers/`, `src/api/lesson/controllers/`

---

### Task 2.11: Content Types - Блог и Подписки

**Промпт:**
```
Изучи секции:
- "7.1.17-7.1.19" в TECHNICAL_SPECIFICATION.md (строки 1457-1504)
- "4.3 Блог" (строки 596-619)
- "4.10 Подписки" (строки 942-966)

Создай Content Types:

1. Blog Article:
   - title (string)
   - slug (string, unique)
   - content (richtext) // Markdown
   - preview (text)
   - image (media)
   - author (string)
   - category (relation: many-to-one с Category)
   - published_at (datetime)
   - is_published (boolean)

2. Notification:
   - user (relation: many-to-one с User)
   - title (string)
   - message (text)
   - type (enumeration: info, reminder, alert)
   - is_read (boolean)
   - action (JSON) // {type: 'navigate', target: '/profile'}

3. Subscription:
   - user (relation: many-to-one с User)
   - plan_id (string)
   - plan_name (string)
   - status (enumeration: active, cancelled, expired)
   - start_date (date)
   - end_date (date)
   - next_billing_date (date)
   - payment_provider (string) // stripe, apple, google
   - external_id (string)

Результат: Content Types для блога, уведомлений и подписок.
```

**Файлы:** `src/api/blog-article/`, `src/api/notification/`, `src/api/subscription/`

---

### Task 2.12: API - Блог, Уведомления, Подписки

**Промпт:**
```
Создай базовые CRUD Controllers:

1. GET /api/blog/articles
   Query: ?page=1&limit=10&category=health
   - Пагинация
   - Фильтрация по категориям
   - Только опубликованные

2. GET /api/blog/articles/:id
   - Детали статьи

3. GET /api/notifications
   - Список уведомлений пользователя
   - Сортировка по дате (новые сверху)
   - Пометка непрочитанных

4. PATCH /api/notifications/:id/read
   - Отметить как прочитанное

5. DELETE /api/notifications/:id
   - Удалить уведомление

6. GET /api/subscriptions/plans
   - Список тарифов
   - С описанием фич

7. GET /api/subscriptions/my
   - Текущая подписка пользователя

Результат: API для блога, уведомлений, подписок (без интеграции с Stripe).
```

**Файлы:** `src/api/blog/controllers/`, `src/api/notification/controllers/`, `src/api/subscription/controllers/`

---

### Task 2.13: API - Home Dashboard

**Промпт:**
```
Изучи секцию "4.2 Главный экран" в TECHNICAL_SPECIFICATION.md (строки 573-594).

Создай Custom Controller:

GET /api/home/dashboard

Возвращает:
{
  user: {
    name, avatar
  },
  current_plan: {
    name, progress (%)
  },
  tools: [
    {id: 'diary', name: 'Дневник питания', icon: 'book'},
    {id: 'meal-plan', name: 'Рацион', icon: 'utensils'},
    {id: 'ai-chat', name: 'AI-чат', icon: 'robot'},
    {id: 'lab-tests', name: 'Анализы', icon: 'flask'}
  ],
  blog: [
    // Последние 3 статьи
  ],
  subscription: {
    status: 'active', next_billing: '2025-11-10'
  },
  unread_notifications: 5
}

ЛОГИКА:
- Агрегировать данные из разных сервисов
- Кэшировать в Redis на 5 минут

Результат: Endpoint для главного экрана.
```

**Файлы:** `src/api/home/controllers/home.js`

---

## 📱 ФАЗА 3: MOBILE APP - ЛОГИКА (Неделя 9-18)

### Task 3.1: Инициализация Flutter проекта

**Промпт:**
```
Создай Flutter проект:

1. Инициализация:
   cd mobile
   flutter create . --org com.brixnutrition --platforms ios,android

2. Копирование модулей:
   cp -r ../dev_modules lib/

3. Обновление pubspec.yaml:
   Изучи dev_modules/*/README.md
   Добавь все зависимости:
   - flutter_bloc: ^8.1.0
   - dio: ^5.4.0
   - hive: ^2.2.3
   - hive_flutter: ^1.1.0
   - shared_preferences: ^2.2.0
   - flutter_secure_storage: ^9.0.0
   - cached_network_image: ^3.3.0
   - image_picker: ^1.0.7
   - intl: ^0.18.1

4. Структура lib/:
   lib/
   ├── main.dart
   ├── app/
   │   ├── app.dart
   │   ├── routes.dart
   │   └── theme.dart
   ├── dev_modules/ (копия)
   ├── features/
   │   ├── sms_auth/
   │   ├── meal_plan/
   │   ├── recipe/
   │   ├── blog/
   │   └── notifications/
   └── shared/
       ├── utils/
       ├── constants/
       └── extensions/

5. Настройка API:
   Отредактируй lib/dev_modules/core_module/config/api_config.dart:
   - baseUrl: 'http://10.0.2.2:1337/api' (Android эмулятор)
   - baseUrl: 'http://localhost:1337/api' (iOS симулятор)

Результат: Рабочий Flutter проект с подключенными модулями.
```

**Файлы:** `mobile/lib/`, `mobile/pubspec.yaml`

---

### Task 3.2: Core Module - API Service

**Промпт:**
```
Адаптируй dev_modules/core_module под Brix API:

1. Изучи dev_modules/core_module/services/api_service.dart

2. Обнови api_service.dart:
   - Используй Dio
   - Добавь interceptors:
     * TokenInterceptor (добавляет Bearer token)
     * LogInterceptor (логи запросов)
     * ErrorInterceptor (обработка ошибок)
   - Базовые методы: get, post, put, delete, patch

3. Обнови token_manager.dart:
   - Хранение JWT в flutter_secure_storage
   - Методы: saveToken, getToken, removeToken
   - Refresh Token логика

4. Создай api_endpoints.dart:
   class ApiEndpoints {
     // Auth
     static const authEmailSendCode = '/auth/email/send-code';
     static const authEmailVerifyCode = '/auth/email/verify-code';
     static const authPhoneSendCode = '/auth/phone/send-code';
     static const authPhoneVerifyCode = '/auth/phone/verify-code';
     
     // Meal Plans
     static const mealPlanCurrent = '/meal-plan/current';
     static mealPlanDay(String date) => '/meal-plan/day/$date';
     
     // Recipes
     static recipe(String id) => '/recipes/$id';
     static recipeAlternatives(String id) => '/recipes/$id/alternatives';
     
     // ... остальные endpoints
   }

Результат: Настроенный API сервис для работы с Backend.
```

**Файлы:** `lib/dev_modules/core_module/services/`, `lib/dev_modules/core_module/config/`

---

### Task 3.3: Feature - SMS Auth

**Промпт:**
```
Изучи:
- "4.1 Авторизация" в TECHNICAL_SPECIFICATION.md (строки 488-571)
- "Сценарий 1-2" в user_scenaries.md (строки 8-92)

Создай SMS Auth Feature:

1. Структура:
   lib/features/sms_auth/
   ├── models/
   │   └── verification_response.dart
   ├── services/
   │   └── sms_auth_service.dart
   ├── bloc/
   │   ├── sms_auth_bloc.dart
   │   ├── sms_auth_event.dart
   │   └── sms_auth_state.dart
   └── (screens позже, в фазе UI)

2. Models:
   class VerificationResponse {
     final bool success;
     final bool isNewUser;
     final String? token;
     final User? user;
   }

3. Service (sms_auth_service.dart):
   class SmsAuthService {
     final ApiService _api;
     
     Future<bool> sendCodeToEmail(String email);
     Future<bool> sendCodeToPhone(String phone);
     Future<VerificationResponse> verifyEmailCode(String email, String code);
     Future<VerificationResponse> verifyPhoneCode(String phone, String code);
     Future<User> setPassword(String email, String password);
   }

4. BLoC:
   Events:
     - SendCodeToEmailRequested
     - SendCodeToPhoneRequested
     - VerifyCodeRequested
     - SetPasswordRequested
   
   States:
     - SmsAuthInitial
     - SmsAuthLoading
     - CodeSent
     - CodeVerified
     - PasswordSet
     - SmsAuthError

Результат: Логика SMS авторизации без UI.
```

**Файлы:** `lib/features/sms_auth/`

---

### Task 3.4: Feature - Meal Plan Logic

**Промпт:**
```
Изучи секцию "4.5 Рацион питания" в TECHNICAL_SPECIFICATION.md (строки 648-719).

Создай Meal Plan Feature:

1. Структура:
   lib/features/meal_plan/
   ├── models/
   │   ├── meal_plan.dart
   │   ├── meal_slot.dart
   │   ├── recipe.dart
   │   └── ingredient.dart
   ├── services/
   │   └── meal_plan_service.dart
   └── bloc/
       ├── meal_plan_bloc.dart
       ├── meal_plan_event.dart
       └── meal_plan_state.dart

2. Models:
   class MealPlan {
     final String id;
     final String name;
     final String description;
     final List<MealSlot> meals;
     final List<Supplement>? supplements;
   }
   
   class MealSlot {
     final String id;
     final MealType type; // enum
     final String time;
     final Recipe recipe;
     final int portionGrams;
     final int calories;
     final String? importance;
   }
   
   class Recipe {
     final String id;
     final String name;
     final String description;
     final String imageUrl;
     final int prepTime;
     final int calories;
     final List<Ingredient> ingredients;
     final List<String> steps;
     final List<String> tags;
   }

3. Service:
   class MealPlanService {
     Future<MealPlan> getCurrentPlan();
     Future<List<MealSlot>> getPlanForDay(DateTime date);
     Future<MealSlot> replaceMeal(String mealSlotId, String newRecipeId);
     Future<Recipe> getRecipe(String id);
     Future<List<Recipe>> getRecipeAlternatives(String id);
   }

4. BLoC для управления состоянием.

Результат: Логика работы с планами питания.
```

**Файлы:** `lib/features/meal_plan/`

---

### Task 3.5: Feature - Diary Logic

**Промпт:**
```
Адаптируй dev_modules/diary_module под Brix:

1. Изучи dev_modules/diary_module/

2. Обнови models (diary_models.dart):
   class DiaryDay {
     final String id;
     final DateTime date;
     final List<DiaryMeal> meals;
     final WaterLog waterLog;
     final int? moodRating;
     final bool isCompleted;
     final String? notes;
   }
   
   class DiaryMeal {
     final String id;
     final String mealName;
     final MealType mealType;
     final DateTime consumedAt;
     final int portionGrams;
     final int calories;
     final String? photoUrl;
     final bool fromPlan;
     final Recipe? recipe;
   }
   
   class WaterLog {
     final int totalAmount; // мл
     final int dailyGoal; // мл
   }

3. Обнови service (diary_service.dart):
   class DiaryService {
     Future<DiaryDay> getDayDiary(DateTime date);
     Future<DiaryMeal> addMeal({
       required String mealName,
       required MealType mealType,
       required DateTime consumedAt,
       required int portionGrams,
       int? calories,
       File? photo,
       bool fromPlan = false,
       String? recipeId,
     });
     Future<void> deleteMeal(String mealId);
     Future<WaterLog> updateWater(DateTime date, int increment);
     Future<void> updateMood(DateTime date, int rating);
     Future<void> completeDay(DateTime date);
   }

4. Обнови BLoC.

Результат: Логика дневника питания.
```

**Файлы:** `lib/dev_modules/diary_module/`

---

### Task 3.6: Feature - AI Chat Logic

**Промпт:**
```
Адаптируй dev_modules/ai_chat_module:

1. Изучи "4.7 AI-консультант" в TECHNICAL_SPECIFICATION.md (строки 774-816).

2. Обнови models:
   class AiChat {
     final String id;
     final String title;
     final DateTime createdAt;
   }
   
   class AiMessage {
     final String id;
     final String chatId;
     final MessageRole role; // user | assistant
     final String content;
     final Map<String, bool>? contextUsed;
     final DateTime createdAt;
   }
   
   class ChatContext {
     final bool includeDiary;
     final bool includeLabTests;
     final bool includePlan;
   }

3. Service:
   class AiChatService {
     Future<AiMessage> sendMessage({
       String? chatId,
       required String message,
       ChatContext? context,
     });
     Future<List<AiChat>> getChatHistory();
     Future<List<AiMessage>> getChatMessages(String chatId);
     Future<void> deleteChat(String chatId);
   }

Результат: Логика AI-чата.
```

**Файлы:** `lib/dev_modules/ai_chat_module/`

---

### Task 3.7: Feature - Lab Tests Logic

**Промпт:**
```
Адаптируй dev_modules/checkup_module:

1. Изучи "4.8 Расшифровка анализов" в TECHNICAL_SPECIFICATION.md (строки 818-877).

2. Создай models:
   class LabTest {
     final String id;
     final String testType;
     final DateTime testDate;
     final List<LabResult> results;
   }
   
   class LabResult {
     final String parameterId;
     final double value;
     final String unit;
   }
   
   class LabParameter {
     final String id;
     final String name;
     final String category;
     final List<String> units;
     final List<ReferenceRange> referenceRanges;
     final String description;
     final List<String>? lowCauses;
     final List<String>? highCauses;
     final String? recommendations;
   }
   
   class Interpretation {
     final String parameterId;
     final String parameterName;
     final double userValue;
     final ReferenceRange referenceRange;
     final ResultStatus status; // normal, low, high
     final String description;
   }

3. Service:
   class LabTestService {
     Future<LabTest> uploadTest({
       required String testType,
       required DateTime testDate,
       required List<LabResult> results,
     });
     Future<List<LabTest>> getMyTests();
     Future<List<Interpretation>> getInterpretation(String testId);
     Future<List<LabParameter>> getParameters({String? category});
   }

Результат: Логика работы с анализами.
```

**Файлы:** `lib/dev_modules/checkup_module/`

---

### Task 3.8: Feature - Knowledge Base Logic

**Промпт:**
```
Адаптируй dev_modules/knowledge_module:

1. Models:
   class Course {
     final String id;
     final String title;
     final String description;
     final String imageUrl;
     final String author;
     final bool isPaid;
     final double? price;
     final String duration;
     final int lessonsCount;
     final String category;
     final int progress; // %
   }
   
   class Lesson {
     final String id;
     final String courseId;
     final String title;
     final String description;
     final int orderIndex;
     final LessonType type; // video, text, audio
     final String content;
     final int? duration;
     final List<Material>? materials;
     final bool isCompleted;
   }

2. Service:
   class KnowledgeService {
     Future<List<Course>> getCourses({String category = 'all'});
     Future<Course> getCourse(String id);
     Future<List<Lesson>> getCourseLessons(String courseId);
     Future<Lesson> getLesson(String id);
     Future<void> completeLesson(String lessonId);
     Future<CourseProgress> getCourseProgress(String courseId);
   }

Результат: Логика базы знаний.
```

**Файлы:** `lib/dev_modules/knowledge_module/`

---

### Task 3.9: Feature - Blog & Notifications Logic

**Промпт:**
```
Создай новые features:

1. Blog Feature:
   lib/features/blog/
   ├── models/
   │   └── article.dart
   ├── services/
   │   └── blog_service.dart
   └── bloc/

   Models:
   class Article {
     final String id;
     final String title;
     final String content; // Markdown
     final String preview;
     final String imageUrl;
     final String author;
     final String category;
     final DateTime publishedAt;
   }

   Service:
   class BlogService {
     Future<List<Article>> getArticles({int page = 1, int limit = 10});
     Future<Article> getArticle(String id);
   }

2. Notifications Feature:
   lib/features/notifications/
   ├── models/
   │   └── notification.dart
   ├── services/
   │   └── notification_service.dart
   └── bloc/

   Models:
   class AppNotification {
     final String id;
     final String title;
     final String message;
     final NotificationType type;
     final bool isRead;
     final DateTime createdAt;
     final NotificationAction? action;
   }

   Service:
   class NotificationService {
     Future<List<AppNotification>> getNotifications();
     Future<void> markAsRead(String id);
     Future<void> deleteNotification(String id);
   }

Результат: Логика блога и уведомлений.
```

**Файлы:** `lib/features/blog/`, `lib/features/notifications/`

---

### Task 3.10: Feature - Subscriptions Logic

**Промпт:**
```
Адаптируй dev_modules/subscription_module:

1. Models:
   class SubscriptionPlan {
     final String id;
     final String name;
     final String description;
     final double price;
     final String billingPeriod; // month, year
     final List<String> features;
   }
   
   class UserSubscription {
     final String id;
     final SubscriptionPlan plan;
     final SubscriptionStatus status;
     final DateTime startDate;
     final DateTime? endDate;
     final DateTime? nextBillingDate;
   }

2. Service:
   class SubscriptionService {
     Future<List<SubscriptionPlan>> getPlans();
     Future<UserSubscription?> getMySubscription();
     Future<String> subscribe(String planId, String paymentMethod);
     Future<void> cancelSubscription();
   }

Результат: Логика подписок.
```

**Файлы:** `lib/dev_modules/subscription_module/`

---

## 🖥️ ФАЗА 4: ADMIN PANEL - ЛОГИКА (Неделя 19-22)

### Task 4.1: Инициализация Next.js проекта

**Промпт:**
```
Создай Admin Web Panel:

1. Инициализация:
   cd admin
   npm create next-app@14 . --typescript --tailwind --app --no-src-dir

2. Установка зависимостей:
   npm install @heroicons/react lucide-react react-hook-form react-hot-toast

3. Копирование модулей:
   cp -r ../admin_modules ./src/admin_modules

4. Структура src/:
   src/
   ├── app/
   │   ├── layout.tsx
   │   ├── page.tsx (Dashboard)
   │   ├── login/
   │   ├── courses/
   │   ├── lessons/
   │   ├── recipes/
   │   ├── plans/
   │   ├── users/
   │   ├── lab-tests/
   │   ├── blog/
   │   ├── subscriptions/
   │   └── analytics/
   ├── admin_modules/ (копия)
   ├── components/
   │   ├── Sidebar.tsx
   │   ├── Header.tsx
   │   └── ...
   └── lib/
       ├── api.ts
       └── utils.ts

5. Создать .env.local:
   NEXT_PUBLIC_API_URL=http://localhost:1337/api
   ADMIN_API_TOKEN=your-strapi-admin-token

Результат: Рабочий Next.js проект.
```

**Файлы:** `admin/src/`, `admin/.env.local`

---

### Task 4.2: Core Module - API Client

**Промпт:**
```
Адаптируй admin_modules/core_module/api/apiClient.ts:

1. Изучи admin_modules/core_module/api/apiClient.ts

2. Обнови apiClient.ts для Strapi:
   
   const API_URL = process.env.NEXT_PUBLIC_API_URL;
   const ADMIN_TOKEN = process.env.ADMIN_API_TOKEN;

   async function apiRequest<T>(
     endpoint: string,
     options?: RequestInit
   ): Promise<T> {
     const response = await fetch(`${API_URL}${endpoint}`, {
       ...options,
       headers: {
         'Content-Type': 'application/json',
         'Authorization': `Bearer ${ADMIN_TOKEN}`,
         ...options?.headers,
       },
     });

     if (!response.ok) {
       throw new Error(`API Error: ${response.statusText}`);
     }

     return response.json();
   }

   export const api = {
     get: <T>(endpoint: string) => apiRequest<T>(endpoint),
     post: <T>(endpoint: string, data: any) => 
       apiRequest<T>(endpoint, { method: 'POST', body: JSON.stringify(data) }),
     put: <T>(endpoint: string, data: any) => 
       apiRequest<T>(endpoint, { method: 'PUT', body: JSON.stringify(data) }),
     delete: <T>(endpoint: string) => 
       apiRequest<T>(endpoint, { method: 'DELETE' }),
   };

3. Создай типы (admin_modules/core_module/types/index.ts):
   - Course, Lesson, Recipe, MealPlan, User, etc.

Результат: API клиент для работы с Strapi.
```

**Файлы:** `src/admin_modules/core_module/api/`, `src/admin_modules/core_module/types/`

---

### Task 4.3: Dashboard Page

**Промпт:**
```
Адаптируй admin_modules/dashboard_module:

1. Создай app/page.tsx:
   - Используй DashboardPage из dashboard_module
   - Подключи к Strapi API

2. Metrics:
   - Общее количество пользователей
   - Активные подписки
   - Количество курсов/рецептов/планов
   - Новые регистрации за неделю

3. API для метрик:
   GET /api/admin/stats
   {
     users: { total, new_this_week },
     subscriptions: { active, cancelled, revenue_mrr },
     content: { courses, recipes, meal_plans, articles },
     activity: { diary_entries_today, ai_chats_today }
   }

Результат: Dashboard со статистикой.
```

**Файлы:** `src/app/page.tsx`, `src/admin_modules/dashboard_module/`

---

### Task 4.4: Courses & Lessons Management

**Промпт:**
```
Используй admin_modules/courses_module и lessons_module:

1. Создай страницы:
   - app/courses/page.tsx (список)
   - app/courses/new/page.tsx (создание)
   - app/courses/[id]/page.tsx (редактирование)
   - app/courses/[id]/lessons/page.tsx (уроки курса)

2. Подключи к API:
   - GET /api/courses
   - POST /api/courses
   - PUT /api/courses/:id
   - DELETE /api/courses/:id
   - GET /api/courses/:id/lessons

3. Функции:
   - CRUD курсов
   - Добавление/удаление уроков
   - Загрузка изображений
   - Сортировка уроков (drag & drop через dnd-kit)

Результат: Управление курсами и уроками.
```

**Файлы:** `src/app/courses/`, `src/admin_modules/courses_module/`, `src/admin_modules/lessons_module/`

---

### Task 4.5: Recipes Management

**Промпт:**
```
Создай новый модуль на основе nutrition_plans_module:

1. Структура:
   src/admin_modules/recipes_module/
   ├── components/
   │   ├── RecipeList.tsx
   │   ├── RecipeForm.tsx
   │   ├── IngredientInput.tsx
   │   └── StepsInput.tsx
   └── types.ts

2. Страницы:
   - app/recipes/page.tsx
   - app/recipes/new/page.tsx
   - app/recipes/[id]/page.tsx

3. Функции:
   - CRUD рецептов
   - Загрузка фото
   - Добавление ингредиентов
   - Пошаговые инструкции
   - Теги и категории
   - Расчет КБЖУ

Результат: Управление рецептами.
```

**Файлы:** `src/admin_modules/recipes_module/`, `src/app/recipes/`

---

### Task 4.6: Lab Tests Parameters Management

**Промпт:**
```
Создай новый модуль:

1. Структура:
   src/admin_modules/lab_tests_module/
   ├── components/
   │   ├── ParameterList.tsx
   │   ├── ParameterForm.tsx
   │   └── ReferenceRangeInput.tsx
   └── types.ts

2. Страницы:
   - app/lab-tests/page.tsx
   - app/lab-tests/new/page.tsx
   - app/lab-tests/[id]/page.tsx

3. Функции:
   - CRUD показателей
   - Референсные значения (по полу/возрасту)
   - Описания и интерпретации
   - Причины отклонений
   - Рекомендации

Результат: Управление справочником анализов.
```

**Файлы:** `src/admin_modules/lab_tests_module/`, `src/app/lab-tests/`

---

### Task 4.7: Blog Management

**Промпт:**
```
Создай blog_module:

1. Структура:
   src/admin_modules/blog_module/
   ├── components/
   │   ├── ArticleList.tsx
   │   ├── ArticleForm.tsx
   │   └── MarkdownEditor.tsx (или используй react-markdown)
   └── types.ts

2. Страницы:
   - app/blog/page.tsx
   - app/blog/new/page.tsx
   - app/blog/[id]/page.tsx

3. Функции:
   - CRUD статей
   - Markdown editor
   - Загрузка изображений
   - Категории и теги
   - Draft/Published статус
   - Планирование публикаций

Результат: Управление блогом.
```

**Файлы:** `src/admin_modules/blog_module/`, `src/app/blog/`

---

### Task 4.8: Users Management

**Промпт:**
```
Создай users_module:

1. Структура:
   src/admin_modules/users_module/
   ├── components/
   │   ├── UserList.tsx
   │   ├── UserDetails.tsx
   │   ├── UserFilters.tsx
   │   └── UserActivityLog.tsx
   └── types.ts

2. Страницы:
   - app/users/page.tsx
   - app/users/[id]/page.tsx

3. Функции:
   - Список пользователей (пагинация)
   - Фильтрация (по подписке, статусу, датам)
   - Детали профиля
   - История активности
   - Блокировка/разблокировка
   - Статистика активности

Результат: Управление пользователями.
```

**Файлы:** `src/admin_modules/users_module/`, `src/app/users/`

---

## 🎨 ФАЗА 5: UI KIT И СТИЛИЗАЦИЯ (Неделя 23-28)

### Task 5.1: Адаптация Flutter UI Kit

**Промпт:**
```
Адаптируй dev_modules/ui_kit_module под дизайн Brix:

1. Изучи dev_modules/ui_kit_module/

2. Обнови цветовую схему (theme.dart):
   const brixColors = {
     primary: Color(0xFF4CAF50), // зеленый
     secondary: Color(0xFFFF9800), // оранжевый
     accent: Color(0xFF2196F3), // синий
     background: Color(0xFFF5F5F5),
     surface: Colors.white,
     error: Color(0xFFEF5350),
     onPrimary: Colors.white,
     onSecondary: Colors.white,
   };

3. Обнови компоненты:
   - SupplyButton → BrixButton
   - SupplyInput → BrixInput
   - SupplyCard → BrixCard
   - SupplyAlert → BrixAlert

4. Добавь новые компоненты:
   - BrixProgressBar (для прогресса плана)
   - BrixMealCard (для отображения блюд)
   - BrixWaterCounter (для счетчика воды)
   - BrixMoodSelector (для выбора настроения)

5. Обнови typography:
   - Headings (H1-H6)
   - Body text
   - Captions
   - Button text

Результат: Адаптированный UI Kit для Brix.
```

**Файлы:** `lib/dev_modules/ui_kit_module/`

---

### Task 5.2: SMS Auth Screens

**Промпт:**
```
Создай UI для SMS авторизации:

1. Screens:
   lib/features/sms_auth/screens/
   ├── auth_method_selection_screen.dart
   ├── email_input_screen.dart
   ├── phone_input_screen.dart
   ├── sms_verification_screen.dart
   └── password_creation_screen.dart

2. Widgets:
   lib/features/sms_auth/widgets/
   ├── code_input_widget.dart (4 поля для кода)
   ├── phone_input_formatter.dart
   └── resend_code_button.dart

3. Следуй дизайну из user_scenaries.md (Сценарии 1-4)

4. Features:
   - Автофокус на полях кода
   - Автозаполнение из SMS (через flutter_sms_autofill)
   - Таймер для повторной отправки (60 сек)
   - Валидация email/phone
   - Loading состояния

Результат: Красивые экраны авторизации.
```

**Файлы:** `lib/features/sms_auth/screens/`, `lib/features/sms_auth/widgets/`

---

### Task 5.3: Onboarding Screens

**Промпт:**
```
Адаптируй dev_modules/onboarding_module:

1. Обнови screens:
   - goal_selection_screen.dart (Шаг 1)
   - name_input_screen.dart (Шаг 2)
   - birthdate_input_screen.dart (Шаг 3)

2. Дизайн из user_scenaries.md (Сценарий 5)

3. Features:
   - PageView с индикатором прогресса
   - Кнопка "Назад"
   - Валидация на каждом шаге
   - Красивые иллюстрации (добавить SVG)

Результат: Онбординг опрос (3 шага).
```

**Файлы:** `lib/dev_modules/onboarding_module/screens/`

---

### Task 5.4: Home Screen

**Промпт:**
```
Переделай dev_modules/home_module под дизайн Brix:

1. Изучи "Сценарий 6" в user_scenaries.md (строки 158-187)

2. Обнови home_screen.dart:
   
   Структура:
   - Приветствие: "Привет, {Имя}! Твоя доска выглядит отлично"
   - План питания: карточка с прогрессом
   - Инструменты: 4 иконки (Дневник, Рацион, AI, Анализы)
   - Блог: последние 3 статьи
   - Подписки: статус и дата
   - FAB: Уведомления (колокольчик с badge)

3. Widgets:
   - PlanProgressCard
   - ToolsGrid
   - BlogArticleCard
   - SubscriptionStatusCard

4. Анимации:
   - Skeleton loading
   - Pull-to-refresh

Результат: Красивый главный экран.
```

**Файлы:** `lib/dev_modules/home_module/screens/`, `lib/dev_modules/home_module/widgets/`

---

### Task 5.5: Meal Plan & Recipe Screens

**Промпт:**
```
Создай UI для рациона:

1. Screens:
   lib/features/meal_plan/screens/
   ├── meal_plan_screen.dart
   ├── recipe_detail_screen.dart
   └── recipe_alternatives_screen.dart

2. Widgets:
   lib/features/meal_plan/widgets/
   ├── meal_slot_card.dart
   ├── recipe_card.dart
   ├── ingredient_list_widget.dart
   ├── cooking_steps_widget.dart
   └── nutrition_info_widget.dart

3. Дизайн из "Сценарий 9" в user_scenaries.md (строки 219-274)

4. Features:
   - Список приемов пищи (7 типов)
   - Карточки рецептов с фото
   - Детали рецепта (ингредиенты, шаги)
   - Кнопка "Заменить продукт"
   - Кнопка "Добавить в дневник"
   - Красивая типографика

Результат: UI для рациона и рецептов.
```

**Файлы:** `lib/features/meal_plan/screens/`, `lib/features/meal_plan/widgets/`

---

### Task 5.6: Diary Screen

**Промпт:**
```
Адаптируй dev_modules/diary_module под дизайн Brix:

1. Обнови diary_screen.dart:
   
   Структура:
   - Заголовок: "Выбранный план: {План}"
   - Навигация по датам: ← 4 ср →
   - Счетчик воды: с кнопками +100, +200, +250, -100
   - Приемы пищи: группировка по типам
   - Настроение: 5 звезд
   - Кнопка "Завершить день"

2. Widgets:
   - WaterCounter
   - MealListItem
   - MoodSelector
   - DateNavigator
   - CalendarModal

3. Дизайн из "Сценарий 11" в user_scenaries.md (строки 317-372)

4. Features:
   - Календарь для выбора даты
   - Добавление приема пищи (modal)
   - Фото блюда (camera/gallery)
   - Поиск продуктов

Результат: Красивый дневник питания.
```

**Файлы:** `lib/dev_modules/diary_module/screens/`, `lib/dev_modules/diary_module/widgets/`

---

### Task 5.7: AI Chat Screen

**Промпт:**
```
Адаптируй dev_modules/ai_chat_module:

1. Обнови ai_chat_screen.dart:
   
   Дизайн:
   - Список сообщений (user/assistant)
   - Поле ввода внизу
   - Кнопка "Новый чат"
   - История чатов (drawer или отдельный экран)

2. Widgets:
   - MessageBubble (user vs assistant)
   - TypingIndicator
   - ContextSelector (опции: дневник, анализы, план)

3. Дизайн из "Сценарий 10" в user_scenaries.md (строки 275-316)

4. Features:
   - Markdown рендеринг ответов
   - Копирование текста
   - Управление чатами (удаление)

Результат: UI для AI-чата.
```

**Файлы:** `lib/dev_modules/ai_chat_module/screens/`, `lib/dev_modules/ai_chat_module/widgets/`

---

### Task 5.8: Lab Tests Screen

**Промпт:**
```
Адаптируй dev_modules/checkup_module:

1. Screens:
   - lab_tests_main_screen.dart (содержание)
   - lab_test_category_screen.dart (список показателей)
   - lab_parameter_detail_screen.dart (детали)

2. Дизайн из "Сценарий 12" в user_scenaries.md (строки 373-415)

3. Features:
   - Разделы анализов (карточки)
   - Переключатель единиц (г/л, мг/дл)
   - Референсные значения (таблица)
   - Цветовая индикация статуса (normal/low/high)
   - Причины отклонений (списки)

4. Widgets:
   - ParameterCard
   - ReferenceTable
   - StatusIndicator
   - CausesSection

Результат: UI для расшифровки анализов.
```

**Файлы:** `lib/dev_modules/checkup_module/screens/`, `lib/dev_modules/checkup_module/widgets/`

---

### Task 5.9: Knowledge Base & Blog Screens

**Промпт:**
```
Создай UI для базы знаний и блога:

1. Knowledge Base:
   lib/dev_modules/knowledge_module/screens/
   ├── courses_list_screen.dart
   ├── course_detail_screen.dart
   └── lesson_screen.dart

   Widgets:
   - CourseCard (с прогрессом)
   - LessonListItem
   - VideoPlayer (для video lessons)
   - MarkdownRenderer (для text lessons)
   - DownloadButton (для материалов)

2. Blog:
   lib/features/blog/screens/
   ├── blog_list_screen.dart
   └── article_detail_screen.dart

   Widgets:
   - ArticleCard
   - ArticleContent (Markdown)
   - ShareButton

Дизайн из "Сценарий 7, 13" в user_scenaries.md

Результат: UI для курсов и блога.
```

**Файлы:** `lib/dev_modules/knowledge_module/`, `lib/features/blog/`

---

### Task 5.10: Notifications & Subscriptions Screens

**Промпт:**
```
Создай UI для уведомлений и подписок:

1. Notifications:
   lib/features/notifications/screens/
   └── notifications_screen.dart

   Widgets:
   - NotificationCard (с иконкой по типу)
   - Swipe-to-delete (Dismissible)

2. Subscriptions:
   lib/dev_modules/subscription_module/screens/
   ├── subscription_plans_screen.dart
   └── my_subscription_screen.dart

   Widgets:
   - PlanCard (с features списком)
   - PricingTag
   - SubscriptionStatus

Дизайн из "Сценарий 8" в user_scenaries.md

Результат: UI для уведомлений и подписок.
```

**Файлы:** `lib/features/notifications/`, `lib/dev_modules/subscription_module/`

---

### Task 5.11: Admin Panel - Styling

**Промпт:**
```
Стилизация Admin Panel:

1. Обнови Layout (src/admin_modules/core_module/components/Layout.tsx):
   - Sidebar с навигацией
   - Header с поиском и профилем
   - Breadcrumbs

2. Настрой Tailwind (tailwind.config.ts):
   colors: {
     primary: '#84cc16', // lime
     secondary: '#3b82f6',
     success: '#10b981',
     error: '#ef4444',
     warning: '#f59e0b',
   }

3. Адаптируй компоненты из ui_components_module:
   - FileUpload (красивый drag & drop)
   - Modal (анимации)
   - Forms (стилизация)
   - Tables (сортировка, пагинация)

4. Добавь dark mode (опционально)

Результат: Красивая админ-панель.
```

**Файлы:** `src/admin_modules/core_module/`, `tailwind.config.ts`

---

## 🔌 ФАЗА 6: ИНТЕГРАЦИИ (Неделя 29-32)

### Task 6.1: Интеграция Twilio (SMS)

**Промпт:**
```
Интегрируй Twilio для отправки SMS:

1. Backend (Strapi):
   npm install twilio

2. Создай service (src/services/sms.js):
   const twilio = require('twilio');
   
   const client = twilio(
     process.env.TWILIO_ACCOUNT_SID,
     process.env.TWILIO_AUTH_TOKEN
   );
   
   async function sendSMS(phone, code) {
     await client.messages.create({
       body: `Ваш код подтверждения: ${code}`,
       from: process.env.TWILIO_PHONE_NUMBER,
       to: phone
     });
   }

3. Обнови Auth Controllers:
   - Замени console.log на реальную отправку SMS
   - Добавь error handling

4. Тестирование:
   - Используй Twilio Sandbox для тестов
   - Добавь несколько тестовых номеров

Результат: Рабочая отправка SMS.
```

**Файлы:** `backend/strapi/src/services/sms.js`, `backend/strapi/src/api/auth/`

---

### Task 6.2: Интеграция OpenAI (AI Chat)

**Промпт:**
```
Интегрируй OpenAI GPT-4:

1. Backend:
   npm install openai

2. Создай service (src/services/ai.js):
   const OpenAI = require('openai');
   
   const openai = new OpenAI({
     apiKey: process.env.OPENAI_API_KEY
   });
   
   async function getAIResponse(message, context) {
     const systemPrompt = `
       Ты — AI-консультант по питанию для Brix Nutrition.
       Пользователь: ${context.user.name}, ${context.user.age} лет
       Цель: ${context.user.goal}
       ${context.diary ? 'Дневник: ' + JSON.stringify(context.diary) : ''}
       ${context.labTests ? 'Анализы: ' + JSON.stringify(context.labTests) : ''}
     `;
     
     const response = await openai.chat.completions.create({
       model: 'gpt-4',
       messages: [
         { role: 'system', content: systemPrompt },
         { role: 'user', content: message }
       ],
       temperature: 0.7,
       max_tokens: 1000
     });
     
     return response.choices[0].message.content;
   }

3. Обнови AI Chat Controller:
   POST /api/ai/chat/message
   - Собрать контекст из БД
   - Отправить в OpenAI
   - Сохранить ответ

4. Оптимизация:
   - Кэширование похожих вопросов
   - Стриминг ответов (опционально)

Результат: Рабочий AI-консультант.
```

**Файлы:** `backend/strapi/src/services/ai.js`, `backend/strapi/src/api/ai-chat/`

---

### Task 6.3: Интеграция Stripe (Платежи)

**Промпт:**
```
Интегрируй Stripe для подписок:

1. Backend:
   npm install stripe

2. Создай service (src/services/payment.js):
   const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
   
   async function createSubscription(userId, priceId) {
     // Создать Customer
     // Создать Subscription
     // Сохранить в БД
   }

3. Webhooks:
   POST /api/webhooks/stripe
   - Обработка событий: subscription.created, payment_intent.succeeded
   - Обновление статуса подписки

4. Flutter:
   - Добавь flutter_stripe
   - Создай payment flow

5. Тестирование:
   - Используй Stripe Test Mode
   - Тестовые карты: 4242 4242 4242 4242

Результат: Рабочие платежи через Stripe.
```

**Файлы:** `backend/strapi/src/services/payment.js`, `lib/dev_modules/subscription_module/`

---

### Task 6.4: Интеграция AWS S3 (Медиа)

**Промпт:**
```
Настрой загрузку медиа в S3:

1. Backend (Strapi):
   npm install @strapi/provider-upload-aws-s3

2. Настрой config/plugins.js:
   module.exports = {
     upload: {
       config: {
         provider: 'aws-s3',
         providerOptions: {
           accessKeyId: process.env.AWS_ACCESS_KEY_ID,
           secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
           region: process.env.AWS_REGION,
           params: {
             Bucket: process.env.AWS_BUCKET,
           },
         },
       },
     },
   };

3. Flutter:
   - Обнови photo upload в Diary
   - Используй image_picker + dio для загрузки

Альтернатива: Supabase Storage (бесплатный план)

Результат: Загрузка фото в облако.
```

**Файлы:** `backend/strapi/config/plugins.js`

---

### Task 6.5: Интеграция Firebase (Push)

**Промпт:**
```
Настрой Push уведомления:

1. Firebase setup:
   - Создай проект в Firebase Console
   - Скачай google-services.json (Android)
   - Скачай GoogleService-Info.plist (iOS)

2. Flutter:
   flutter pub add firebase_core firebase_messaging flutter_local_notifications
   
   Настрой:
   - Инициализация Firebase
   - Обработка foreground/background уведомлений
   - Токен устройства

3. Backend:
   npm install firebase-admin
   
   Создай service (src/services/push.js):
   async function sendPushNotification(userToken, title, body) {
     await admin.messaging().send({
       token: userToken,
       notification: { title, body },
     });
   }

4. Триггеры:
   - Новое сообщение в дневнике
   - Напоминание о приеме пищи
   - Ответ AI-консультанта

Результат: Push уведомления работают.
```

**Файлы:** `lib/services/push_notification_service.dart`, `backend/strapi/src/services/push.js`

---

## 🧪 ФАЗА 7: ТЕСТИРОВАНИЕ (Неделя 33-35)

### Task 7.1: Backend Unit Tests

**Промпт:**
```
Создай unit тесты для Backend:

1. Setup:
   npm install --save-dev jest supertest

2. Структура:
   backend/strapi/tests/
   ├── unit/
   │   ├── services/
   │   │   ├── auth.test.js
   │   │   ├── meal-plan.test.js
   │   │   ├── diary.test.js
   │   │   └── lab-test.test.js
   │   └── utils/
   └── integration/
       └── api/
           ├── auth.test.js
           └── meal-plan.test.js

3. Примеры тестов:
   - Auth: регистрация, вход, refresh token
   - Meal Plan: получение плана, замена блюда
   - Diary: добавление приема, счетчик воды
   - Lab Tests: интерпретация результатов

4. Запуск:
   npm test

Результат: >80% покрытие Backend кода.
```

**Файлы:** `backend/strapi/tests/`

---

### Task 7.2: Flutter Widget Tests

**Промпт:**
```
Создай widget тесты для Flutter:

1. Структура:
   mobile/test/
   ├── unit/
   │   ├── services/
   │   └── models/
   ├── widget/
   │   ├── ui_kit/
   │   ├── auth/
   │   ├── meal_plan/
   │   └── diary/
   └── integration/

2. Примеры:
   test/widget/ui_kit/brix_button_test.dart:
   - Клик на кнопку
   - Disabled состояние
   - Loading состояние

   test/widget/diary/water_counter_test.dart:
   - Увеличение счетчика
   - Уменьшение счетчика
   - Валидация

3. Запуск:
   flutter test

Результат: >70% покрытие Flutter кода.
```

**Файлы:** `mobile/test/`

---

### Task 7.3: E2E Tests

**Промпт:**
```
Создай E2E тесты:

1. Flutter Integration Tests:
   mobile/integration_test/
   ├── auth_flow_test.dart
   ├── meal_plan_flow_test.dart
   └── diary_flow_test.dart

   Сценарии:
   - Регистрация → Опрос → Главный экран
   - Просмотр рациона → Замена блюда → Добавление в дневник
   - Добавление воды → Добавление приема пищи → Завершение дня

2. Admin Panel E2E (Playwright):
   admin/tests/e2e/
   ├── courses.spec.ts
   ├── recipes.spec.ts
   └── users.spec.ts

   Сценарии:
   - Создание курса → Добавление урока
   - Создание рецепта → Добавление в план

Результат: Основные сценарии покрыты E2E.
```

**Файлы:** `mobile/integration_test/`, `admin/tests/e2e/`

---

## 🚀 ФАЗА 8: ДЕПЛОЙ (Неделя 36-38)

### Task 8.1: Backend Deployment

**Промпт:**
```
Задеплой Backend:

1. Подготовка:
   - Создай production .env
   - Настрой PostgreSQL (managed DB)
   - Настрой Redis (managed cache)

2. Варианты деплоя:
   
   A. Strapi Cloud:
   - Создай проект на strapi.io/cloud
   - Подключи GitHub repo
   - Настрой environment variables
   
   B. Render:
   - Создай Web Service
   - Подключи Docker
   - Настрой health checks
   
   C. Railway:
   - Создай проект
   - Добавь PostgreSQL и Redis
   - Deploy from GitHub

3. Настрой домен:
   - api.brix-nutrition.com → Backend

4. SSL:
   - Автоматически через платформу

Результат: Backend в production.
```

---

### Task 8.2: Admin Panel Deployment

**Промпт:**
```
Задеплой Admin Panel:

1. Vercel (рекомендуется):
   cd admin
   npx vercel --prod
   
   - Добавь environment variables
   - Настрой домен: admin.brix-nutrition.com

2. Альтернативы:
   - Netlify
   - Cloudflare Pages

Результат: Admin Panel доступен онлайн.
```

---

### Task 8.3: Mobile App Build & Release

**Промпт:**
```
Соберай и опубликуй Mobile App:

1. iOS:
   flutter build ios --release
   
   - Открой Xcode
   - Product → Archive
   - Distribute App → App Store Connect
   - Submit for Review

2. Android:
   flutter build appbundle --release
   
   - Загрузи в Google Play Console
   - Настрой описание, скриншоты
   - Submit for Review

3. Beta Testing:
   - iOS: TestFlight
   - Android: Internal Testing

Результат: Приложение в сторах.
```

---

## ✅ ФИНАЛЬНЫЙ ЧЕКЛИСТ

После завершения всех задач проверь:

### Backend
- [ ] Все API endpoints работают
- [ ] PostgreSQL настроена
- [ ] Redis кэширует данные
- [ ] JWT авторизация работает
- [ ] SMS отправляются
- [ ] AI-чат отвечает
- [ ] Платежи проходят
- [ ] Медиа загружаются в S3
- [ ] Push уведомления отправляются

### Mobile App
- [ ] Авторизация работает (Email + Phone)
- [ ] Онбординг проходится
- [ ] Главный экран отображается
- [ ] Рацион загружается
- [ ] Рецепты открываются
- [ ] Дневник работает
- [ ] AI-чат общается
- [ ] Анализы расшифровываются
- [ ] Курсы открываются
- [ ] Подписки оформляются

### Admin Panel
- [ ] Dashboard показывает метрики
- [ ] Курсы создаются
- [ ] Рецепты создаются
- [ ] Пользователи отображаются
- [ ] Анализы добавляются
- [ ] Блог управляется

### Тестирование
- [ ] Backend unit tests проходят
- [ ] Flutter widget tests проходят
- [ ] E2E tests проходят
- [ ] Manual QA выполнен

### Production
- [ ] Backend задеплоен
- [ ] Admin Panel задеплоен
- [ ] Mobile App в TestFlight/Internal Testing
- [ ] Monitoring настроен (Sentry)
- [ ] Logs настроены

---

## 📝 Финальные заметки

**Приоритет задач:**
1. Сначала Backend API (логика)
2. Затем Mobile/Admin логика
3. Потом UI и стилизация
4. Интеграции
5. Тестирование
6. Деплой

**Тайминг (С УЧЕТОМ ГОТОВЫХ МОДУЛЕЙ):**
- Backend: ~4-5 недель ⬇️ (было 8, ускорено благодаря backend_modules!)
  * Адаптация и расширение существующих модулей
  * Создание blog_module
  * Интеграция всех 13 модулей
- Mobile: ~8-9 недель ⬇️ (было 10, ускорено благодаря dev_modules!)
  * Адаптация готовых модулей под Brix
  * Создание недостающих features
- Admin: ~3 недели ⬇️ (было 4, ускорено благодаря admin_modules!)
- UI/UX: ~5-6 недель
- Интеграции: ~3-4 недели
- Тестирование: ~2-3 недели
- Деплой: ~2 недели

**Итого: ~27-32 недели (6-8 месяцев) ⬇️⬇️⬇️**
**Экономия: ~5-10 недель благодаря готовым модулям! 🚀**

**Успехов в разработке! 🚀**

