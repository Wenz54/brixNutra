# 🚀 Быстрый старт: Brix Nutritional App

Краткое руководство для быстрого запуска **трёх компонентов** проекта (10-15 минут):
- ⚙️ **Backend** (Strapi)
- 📱 **Mobile App** (Flutter)
- 🖥️ **Admin Web Panel** (Next.js)

## 📋 Требования

Убедитесь, что установлено:

- ✅ **Node.js** 18+ ([скачать](https://nodejs.org/))
- ✅ **npm** 9+ (идёт с Node.js)
- ✅ **Flutter** 3.24+ ([установка](https://docs.flutter.dev/get-started/install))
- ✅ **Docker** + Docker Compose (рекомендуется)
- ✅ **Git**

Проверка версий:

```bash
node --version    # должно быть >= 18
npm --version     # должно быть >= 9
flutter --version # должно быть >= 3.24
docker --version  # (если используете Docker)
```

---

## ⚡ Вариант 1: Docker (Рекомендуется)

Самый быстрый способ запустить backend окружение.

### 1. Clone репозиторий

```bash
git clone https://github.com/your-org/brix-nutrition.git
cd brix-nutrition
```

### 2. Настроить environment variables

```bash
# Копировать шаблон
cp .env.example .env

# Отредактировать .env (минимум):
# - JWT_SECRET (openssl rand -base64 32)
# - OPENAI_API_KEY (если есть)
# - TWILIO_ACCOUNT_SID и TWILIO_AUTH_TOKEN (если есть)
```

### 3. Запустить Docker

```bash
docker-compose up -d
```

Это запустит:
- ✅ PostgreSQL (порт 5432)
- ✅ Redis (порт 6379)
- ✅ PgAdmin (http://localhost:5050)
- ✅ Redis Commander (http://localhost:8081)

### 4. Создать Strapi приложение

```bash
cd backend
npx create-strapi-app@latest strapi --quickstart --no-run
cd strapi
```

### 5. Настроить Strapi для PostgreSQL

Отредактировать `backend/strapi/config/database.js`:

```javascript
module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'localhost'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'brix_nutrition'),
      user: env('DATABASE_USERNAME', 'postgres'),
      password: env('DATABASE_PASSWORD', 'postgres'),
      ssl: env.bool('DATABASE_SSL', false),
    },
  },
});
```

Установить PostgreSQL клиент:

```bash
npm install pg
```

### 6. Запустить Strapi

```bash
npm run develop
```

Strapi Admin будет доступен: **http://localhost:1337/admin**

При первом запуске создайте admin пользователя.

### 7. Создать Admin Web Panel (Next.js)

Откройте новый терминал:

```bash
cd admin

# Создать Next.js проект
npm create next-app@14 . --typescript --tailwind --app --no-src-dir

# Установить зависимости
npm install @heroicons/react lucide-react react-hook-form react-hot-toast

# Скопировать admin_modules
cp -r ../admin_modules ./src/admin_modules

# Создать .env.local
echo "NEXT_PUBLIC_API_URL=http://localhost:1337/api" > .env.local

# Запустить dev server
npm run dev
```

Admin Panel будет доступен: **http://localhost:3000**

### 8. Запустить Flutter app

Откройте новый терминал:

```bash
cd mobile

# Создать Flutter проект (если еще не создан)
flutter create .

# Скопировать dev_modules
cp -r ../dev_modules lib/dev_modules

# Установить зависимости
flutter pub get

# Запустить
flutter run
```

Выберите устройство (эмулятор или физическое устройство).

---

## 🛠️ Вариант 2: Локальная установка (без Docker)

Если не хотите использовать Docker.

### 1. Установить PostgreSQL

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
createdb brix_nutrition
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo -u postgres createdb brix_nutrition
```

**Windows:**
[Скачать PostgreSQL](https://www.postgresql.org/download/windows/)

### 2. Установить Redis

**macOS:**
```bash
brew install redis
brew services start redis
```

**Ubuntu/Debian:**
```bash
sudo apt install redis-server
sudo systemctl start redis
```

**Windows:**
[Скачать Redis](https://github.com/microsoftarchive/redis/releases)

### 3. Создать Strapi приложение

```bash
cd backend
npx create-strapi-app@latest strapi --quickstart --no-run
cd strapi
```

### 4. Настроить .env

Создать `backend/strapi/.env`:

```env
DATABASE_CLIENT=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=brix_nutrition
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres

REDIS_HOST=localhost
REDIS_PORT=6379

JWT_SECRET=your-secret-here
API_TOKEN_SALT=your-salt-here
ADMIN_JWT_SECRET=your-admin-secret-here
```

### 5. Установить зависимости

```bash
npm install pg
```

### 6. Запустить Strapi

```bash
npm run develop
```

### 7. Запустить Flutter

```bash
cd ../../mobile
flutter pub get
flutter run
```

---

## 📱 Настройка Flutter приложения

### 1. Скопировать dev_modules

```bash
cd mobile
cp -r ../dev_modules lib/
```

### 2. Обновить API URL

Отредактировать `lib/dev_modules/core_module/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:1337/api';

// Для iOS симулятора используйте localhost
// Для Android эмулятора используйте 10.0.2.2
// static const String baseUrl = 'http://10.0.2.2:1337/api';
```

### 3. Установить зависимости

```bash
flutter pub get
```

### 4. Запустить на устройстве

```bash
# Список доступных устройств
flutter devices

# Запустить на конкретном устройстве
flutter run -d <device-id>

# Или просто
flutter run
```

---

## 🧪 Проверка работоспособности

### ⚙️ Backend (Strapi)

1. **Strapi Admin**: http://localhost:1337/admin
   - ✅ Должна открыться встроенная админка Strapi
   - ✅ Создайте admin пользователя при первом запуске
   
2. **API Health Check**: http://localhost:1337/api
   - ✅ Должен вернуть JSON с информацией об API

3. **PostgreSQL** (через PgAdmin): http://localhost:5050
   - Login: `admin@brix-nutrition.com`
   - Password: `admin`
   - ✅ Должна открыться админка PostgreSQL
   
4. **Redis** (через Redis Commander): http://localhost:8081
   - ✅ Должна открыться админка Redis

### 🖥️ Admin Web Panel (Next.js)

1. **Admin Panel**: http://localhost:3000
   - ✅ Должна открыться кастомная Next.js админка
   - ✅ Проверьте, что страница загружается без ошибок
   - ✅ Откройте консоль браузера — не должно быть критичных ошибок

2. **API подключение**:
   - Проверьте `.env.local` — должен быть `NEXT_PUBLIC_API_URL=http://localhost:1337/api`
   - Проверьте network tab в DevTools — запросы должны уходить на Strapi

### 📱 Flutter App

1. ✅ Приложение должно запуститься на эмуляторе/устройстве
2. ✅ Попробуйте перейти на Welcome Screen
3. ✅ Проверьте логи — API запросы должны проходить
4. ✅ Проверьте `lib/dev_modules/core_module/config/api_config.dart` — должен быть правильный URL

---

## 🔧 Частые проблемы

### PostgreSQL connection error

```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Решение:**
```bash
# Проверить, что PostgreSQL запущен
docker ps  # (если Docker)
# или
pg_isready  # (если локальная установка)
```

### Flutter API error

```
DioError [DioErrorType.connectTimeout]
```

**Решение:**
1. Проверьте, что Strapi запущен: http://localhost:1337
2. Для Android эмулятора используйте `10.0.2.2` вместо `localhost`
3. Проверьте `api_config.dart`

### Port already in use

```
Error: listen EADDRINUSE: address already in use :::1337
```

**Решение:**
```bash
# Убить процесс на порту 1337
# macOS/Linux:
lsof -ti:1337 | xargs kill -9

# Windows:
netstat -ano | findstr :1337
taskkill /PID <PID> /F
```

---

## 📚 Следующие шаги

После успешного запуска:

1. 📖 Прочитайте [Техническое задание](./TECHNICAL_SPECIFICATION.md)
2. 🛠️ Изучите [Руководство по разработке](./DEVELOPMENT_GUIDE.md)
3. 🔄 Ознакомьтесь с [Планом миграции](./MIGRATION_PLAN.md)
4. 🔌 Посмотрите [API спецификацию](./API_SPECIFICATION.yaml)

---

## 🆘 Помощь

Если что-то не работает:

1. Проверьте логи:
   - Strapi: смотрите вывод терминала
   - Flutter: `flutter logs`
   - Docker: `docker-compose logs`

2. Перезапустите сервисы:
   ```bash
   # Docker
   docker-compose restart
   
   # Strapi
   npm run develop
   
   # Flutter
   flutter run
   ```

3. Полная очистка и перезапуск:
   ```bash
   # Docker
   docker-compose down -v
   docker-compose up -d
   
   # Flutter
   flutter clean
   flutter pub get
   ```

---

## ✅ Checklist первого запуска

### Подготовка
- [ ] Node.js 18+ установлен
- [ ] npm 9+ установлен
- [ ] Flutter 3.24+ установлен
- [ ] Docker запущен (если используете)

### Backend (Strapi)
- [ ] PostgreSQL работает (порт 5432)
- [ ] Redis работает (порт 6379)
- [ ] Strapi запущен (порт 1337)
- [ ] Strapi Admin открывается: http://localhost:1337/admin
- [ ] Admin пользователь создан в Strapi
- [ ] API отвечает: http://localhost:1337/api

### Admin Web Panel (Next.js)
- [ ] Next.js проект создан в папке `admin/`
- [ ] admin_modules скопированы в `admin/src/admin_modules/`
- [ ] Зависимости установлены (`npm install`)
- [ ] `.env.local` создан с NEXT_PUBLIC_API_URL
- [ ] Dev server запущен (`npm run dev`)
- [ ] Admin Panel открывается: http://localhost:3000
- [ ] Нет критичных ошибок в консоли браузера

### Mobile App (Flutter)
- [ ] Flutter проект создан в папке `mobile/`
- [ ] dev_modules скопированы в `mobile/lib/dev_modules/`
- [ ] `api_config.dart` настроен с правильным baseUrl
- [ ] Зависимости установлены (`flutter pub get`)
- [ ] Flutter app запускается на эмуляторе/устройстве
- [ ] API запросы проходят (смотрите логи)

---

Готово! 🎉 Теперь вы можете начать разработку **Brix Nutritional App**.

### Следующие шаги:

1. 📖 Изучите [TECHNICAL_SPECIFICATION.md](./TECHNICAL_SPECIFICATION.md) для понимания архитектуры
2. 🛠️ Прочитайте [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md) для разработки
3. 🔄 Ознакомьтесь с [MIGRATION_PLAN.md](./MIGRATION_PLAN.md) для адаптации модулей
4. 🔌 Используйте [API_SPECIFICATION.yaml](./API_SPECIFICATION.yaml) как reference

---

**Версия**: 2.0.0  
**Обновлено**: 10 октября 2025 (добавлен Admin Web Panel)  
**Компоненты**: Backend (Strapi) + Mobile (Flutter) + Admin Web (Next.js)

