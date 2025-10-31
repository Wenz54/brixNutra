# 🎨 Brix Nutrition Admin Panel

Админ-панель для управления приложением Brix Nutrition.

## 🚀 Технологии

- **Next.js 14** - React framework с App Router
- **TypeScript** - типизация
- **Tailwind CSS** - стилизация
- **Heroicons** - иконки
- **Axios** - HTTP клиент
- **React Hook Form** - формы
- **React Hot Toast** - уведомления

## 📋 Структура проекта

```
admin/
├── app/                  # Next.js App Router
│   ├── layout.tsx        # Root layout (Sidebar + Header)
│   ├── page.tsx          # Dashboard
│   ├── courses/          # Управление курсами (TODO)
│   ├── recipes/          # Управление рецептами (TODO)
│   ├── users/            # Управление пользователями (TODO)
│   ├── lab-tests/        # Управление анализами (TODO)
│   ├── blog/             # Управление блогом (TODO)
│   └── analytics/        # Аналитика (TODO)
├── components/           # React компоненты
│   ├── Sidebar.tsx       # Боковое меню
│   └── Header.tsx        # Хедер с поиском
├── lib/                  # Утилиты
│   ├── api.ts            # API client (Axios)
│   └── types.ts          # TypeScript types
└── .env.local            # Environment variables
```

## 🔧 Установка и запуск

### 1. Установка зависимостей

```bash
cd admin
npm install
```

### 2. Настройка переменных окружения

Создайте файл `.env.local` (уже создан):

```env
NEXT_PUBLIC_API_URL=http://localhost:3000/api
```

### 3. Запуск dev сервера

```bash
npm run dev
```

Админ-панель будет доступна на **http://localhost:3001** (или 3000, если 3001 занят).

## 📊 Dashboard

### Текущие метрики

- **Пользователи**: общее количество + новые за неделю
- **Подписки**: активные + отмененные + MRR
- **Контент**: курсы, рецепты, планы питания, статьи
- **Активность**: записи в дневнике, AI чаты

### Mock данные

Сейчас Dashboard использует mock данные. Когда backend endpoint `/home/dashboard` будет готов, раскомментируйте строку в `app/page.tsx`:

```typescript
// Раскомментировать:
const data = await api.get<DashboardStats>('/home/dashboard');
setStats(data);
```

## 🔌 API Client

API client настроен для работы с Fastify backend (`http://localhost:3000/api`).

### Использование

```typescript
import { api } from '@/lib/api';

// GET request
const courses = await api.get('/knowledge/courses');

// POST request
const newCourse = await api.post('/knowledge/courses', {
  title: 'Новый курс',
  description: 'Описание...',
});

// PUT request
await api.put(`/knowledge/courses/${id}`, { title: 'Обновленное название' });

// DELETE request
await api.delete(`/knowledge/courses/${id}`);
```

### Endpoints

Все endpoints определены в `lib/api.ts`:

```typescript
import { endpoints } from '@/lib/api';

// Примеры:
endpoints.courses // '/knowledge/courses'
endpoints.course('123') // '/knowledge/courses/123'
endpoints.recipes // '/recipes'
```

## 🎯 Следующие шаги (TODO)

### Task 4.3: Dashboard со статистикой ✅ ГОТОВО
- [x] Создан Dashboard с карточками метрик
- [x] Mock данные для демонстрации
- [ ] Подключить к реальному API когда `/home/dashboard` будет готов

### Task 4.4: Courses & Lessons Management
- [ ] Создать страницу `/courses` (список курсов)
- [ ] Создать страницу `/courses/new` (создание курса)
- [ ] Создать страницу `/courses/[id]` (редактирование)
- [ ] Создать страницу `/courses/[id]/lessons` (уроки курса)
- [ ] CRUD операции для курсов
- [ ] CRUD операции для уроков
- [ ] Загрузка изображений
- [ ] Сортировка уроков (drag & drop)

### Task 4.5: Recipes Management
- [ ] Создать страницу `/recipes` (список рецептов)
- [ ] Создать страницу `/recipes/new` (создание)
- [ ] Создать страницу `/recipes/[id]` (редактирование)
- [ ] Формы для ингредиентов и шагов
- [ ] Загрузка фото
- [ ] Расчет КБЖУ

### Task 4.6: Lab Tests Parameters
- [ ] Создать страницу `/lab-tests` (справочник параметров)
- [ ] Форма для добавления показателей
- [ ] Референсные значения (по полу/возрасту)
- [ ] Причины отклонений и рекомендации

### Task 4.7: Blog Management
- [ ] Создать страницу `/blog` (список статей)
- [ ] Markdown editor для статей
- [ ] Категории и теги
- [ ] Draft/Published статус

### Task 4.8: Users Management
- [ ] Создать страницу `/users` (список пользователей)
- [ ] Фильтрация и пагинация
- [ ] Детали профиля
- [ ] История активности
- [ ] Блокировка/разблокировка

## 🎨 UI/UX

### Цветовая схема

- **Primary**: Green (#10b981, #22c55e)
- **Secondary**: Blue (#3b82f6)
- **Success**: Green (#10b981)
- **Error**: Red (#ef4444)
- **Warning**: Orange (#f59e0b)

### Компоненты

- **Sidebar**: Темная тема (gray-900)
- **Header**: Светлая тема с поиском
- **Cards**: Белый фон с тенью
- **Buttons**: Зеленые (primary), серые (secondary)

## 📝 Заметки

1. **Backend**: Админ-панель подключается к Fastify backend на `http://localhost:3000/api`
2. **Порты**: Next.js запускается на порту **3001** (3000 занят backend'ом)
3. **Авторизация**: TODO - добавить JWT authentication
4. **Mock данные**: Сейчас используются mock данные, нужно подключить реальный API

## 🔐 Безопасность

⚠️ **ВАЖНО**: Добавить авторизацию перед деплоем в production!

- [ ] JWT authentication
- [ ] Protected routes
- [ ] Role-based access control (RBAC)
- [ ] CSRF protection

## 🚢 Деплой

### Vercel (рекомендуется)

```bash
npx vercel --prod
```

### Netlify

```bash
npm run build
npx netlify deploy --prod --dir=.next
```

---

Создано для **Brix Nutrition** 🥗
