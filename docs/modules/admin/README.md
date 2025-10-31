# Admin Modules - Модульная админ панель

Модульная структура админ панели Supply Diets для разработки и переиспользования в других проектах.

## 📋 Структура модулей

### Core Module
**Папка:** `core_module`  
**Описание:** Ядро приложения - Layout, API клиент, общие типы и утилиты

### UI Components Module
**Папка:** `ui_components_module`  
**Описание:** Переиспользуемые UI компоненты (FileUpload, модальные окна, формы)

### Dashboard Module
**Папка:** `dashboard_module`  
**Описание:** Главная страница с статистикой и быстрыми действиями

### Courses Module
**Папка:** `courses_module`  
**Описание:** Управление курсами базы знаний (создание, редактирование, удаление)

### Lessons Module
**Папка:** `lessons_module`  
**Описание:** Управление уроками (текстовые, аудио, видео уроки)

### Categories Module
**Папка:** `categories_module`  
**Описание:** Управление категориями для курсов и уроков

### Nutrition Plans Module
**Папка:** `nutrition_plans_module`  
**Описание:** Управление планами питания, продуктами и приемами пищи

### Analytics Module
**Папка:** `analytics_module`  
**Описание:** Аналитика и статистика (пользователи, активность, метрики)

## 🚀 Быстрый старт

### 1. Установка зависимостей

Каждый модуль является самостоятельным и может быть интегрирован в любое Next.js приложение.

```bash
cd admin_modules
npm install
```

### 2. Использование модуля

Каждый модуль содержит:
- `README.md` - описание модуля, API, компонентов
- `components/` - React компоненты
- `pages/` - страницы Next.js (если применимо)
- `types/` - TypeScript типы
- `api/` - API методы и клиенты
- `utils/` - утилиты и хелперы

### 3. Интеграция модуля

```typescript
// Пример: импорт компонентов из модуля
import { CoursesPage } from '@/admin_modules/courses_module'
import { FileUpload } from '@/admin_modules/ui_components_module'
import { apiClient } from '@/admin_modules/core_module'
```

## 📦 Зависимости

Все модули используют общие зависимости:
- **Next.js** 14.0.3
- **React** 18
- **TypeScript** 5
- **Tailwind CSS** 3.3.0
- **Heroicons** 2.0.18
- **Lucide React** 0.539.0
- **React Hook Form** 7.62.0
- **React Hot Toast** 2.5.2

## 🏗️ Архитектура

### Принципы модульности

1. **Независимость** - каждый модуль может работать отдельно
2. **Переиспользование** - компоненты и утилиты можно использовать в других проектах
3. **Типизация** - все модули полностью типизированы TypeScript
4. **Документация** - каждый модуль имеет подробное описание

### Структура модуля

```
module_name/
├── README.md           # Описание модуля
├── components/         # React компоненты
│   ├── ComponentName.tsx
│   └── ...
├── pages/             # Страницы Next.js
│   └── ...
├── types/             # TypeScript типы
│   └── index.ts
├── api/               # API методы
│   └── index.ts
├── utils/             # Утилиты
│   └── helpers.ts
└── hooks/             # Custom hooks
    └── useCustomHook.ts
```

## 🔧 Конфигурация

### Переменные окружения

```env
NEXT_PUBLIC_API_URL=https://your-api-url.com
```

### Tailwind Config

Модули используют стандартные цвета Tailwind CSS:
- **Primary:** lime (зеленый)
- **Secondary:** blue
- **Accent:** purple
- **Success:** green
- **Warning:** orange
- **Error:** red

## 📚 Документация модулей

Подробная документация по каждому модулю находится в соответствующей папке:

- [Core Module](./core_module/README.md)
- [UI Components Module](./ui_components_module/README.md)
- [Dashboard Module](./dashboard_module/README.md)
- [Courses Module](./courses_module/README.md)
- [Lessons Module](./lessons_module/README.md)
- [Categories Module](./categories_module/README.md)
- [Nutrition Plans Module](./nutrition_plans_module/README.md)
- [Analytics Module](./analytics_module/README.md)

## 🤝 Вклад в разработку

При добавлении нового модуля:

1. Создайте папку `module_name`
2. Добавьте `README.md` с описанием
3. Структурируйте файлы согласно архитектуре
4. Обновите этот README.md

## 📝 Примеры использования

### Создание новой админ панели

```typescript
// app/admin/layout.tsx
import { AdminLayout } from '@/admin_modules/core_module'

export default function AdminLayoutWrapper({ children }) {
  return <AdminLayout>{children}</AdminLayout>
}
```

```typescript
// app/admin/courses/page.tsx
import { CoursesPage } from '@/admin_modules/courses_module'

export default function Courses() {
  return <CoursesPage />
}
```

### Использование API клиента

```typescript
import { apiClient } from '@/admin_modules/core_module'

// Получение списка курсов
const courses = await apiClient.getCourses()

// Создание нового курса
const newCourse = await apiClient.createCourse({
  title: 'New Course',
  description: 'Course description'
})
```

## 🎯 Best Practices

1. **Типизация** - всегда используйте TypeScript типы
2. **Компоненты** - разбивайте на маленькие переиспользуемые компоненты
3. **API** - используйте единый API клиент из core_module
4. **Стили** - придерживайтесь Tailwind CSS утилит
5. **Валидация** - используйте React Hook Form для форм
6. **Уведомления** - используйте React Hot Toast для уведомлений

## 📄 Лицензия

MIT License - используйте свободно в ваших проектах

---

**Версия:** 1.0.0  
**Дата:** October 2025  
**Автор:** Supply Diets Team

