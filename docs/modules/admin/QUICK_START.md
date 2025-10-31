# Quick Start - Быстрый старт

Самый быстрый способ начать использовать модули админ панели.

## ⚡ 5-минутная установка

### Шаг 1: Клонируйте репозиторий

```bash
git clone https://github.com/your-repo/admin-modules.git
cd admin-modules
```

### Шаг 2: Установите зависимости

```bash
npm install
```

### Шаг 3: Создайте Next.js проект (если нет)

```bash
npx create-next-app@latest my-admin-panel --typescript --tailwind --app
cd my-admin-panel
```

### Шаг 4: Скопируйте модули

```bash
# Из корня проекта с модулями
cp -r admin_modules /path/to/my-admin-panel/src/
```

### Шаг 5: Настройте переменные окружения

Создайте `.env.local`:

```env
NEXT_PUBLIC_API_URL=https://24supplydiets.ru
```

### Шаг 6: Обновите конфигурацию

#### tailwind.config.ts

Добавьте путь к модулям:

```typescript
content: [
  './src/admin_modules/**/*.{js,ts,jsx,tsx,mdx}',
]
```

#### tsconfig.json

Добавьте алиас:

```json
"paths": {
  "@/*": ["./src/*"]
}
```

### Шаг 7: Создайте страницы

#### src/app/layout.tsx

```tsx
import { AdminLayout } from '@/admin_modules/core_module/components/Layout'
import '@/app/globals.css'

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return <AdminLayout>{children}</AdminLayout>
}
```

#### src/app/page.tsx

```tsx
import { DashboardPage } from '@/admin_modules/dashboard_module/components/DashboardPage'

export default function Home() {
  return <DashboardPage />
}
```

### Шаг 8: Запустите проект

```bash
npm run dev
```

Откройте [http://localhost:3000](http://localhost:3000)

## 🎯 Минимальная конфигурация

### package.json (минимальные зависимости)

```json
{
  "dependencies": {
    "next": "14.0.3",
    "react": "^18",
    "react-dom": "^18",
    "@heroicons/react": "^2.0.18",
    "lucide-react": "^0.539.0",
    "react-hot-toast": "^2.5.2"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "tailwindcss": "^3.3.0",
    "typescript": "^5"
  }
}
```

## 📋 Checklist

- [ ] Node.js 18+ установлен
- [ ] Next.js проект создан
- [ ] Модули скопированы в `src/admin_modules`
- [ ] `.env.local` создан с API URL
- [ ] `tailwind.config.ts` обновлен
- [ ] `tsconfig.json` обновлен
- [ ] Layout использует AdminLayout
- [ ] Главная страница использует DashboardPage
- [ ] Проект запускается без ошибок

## 🚦 Следующие шаги

### 1. Добавьте страницы модулей

```bash
mkdir -p src/app/courses src/app/lessons src/app/nutrition-plans
```

#### src/app/courses/page.tsx

```tsx
import { CoursesListPage } from '@/admin_modules/courses_module/pages/CoursesListPage'

export default function Courses() {
  return <CoursesListPage />
}
```

### 2. Настройте API

Обновите `admin_modules/core_module/api/apiClient.ts` если нужно изменить эндпоинты.

### 3. Кастомизируйте дизайн

Измените цвета в `tailwind.config.ts`:

```typescript
theme: {
  extend: {
    colors: {
      primary: {
        500: '#your-color',
      },
    },
  },
}
```

### 4. Добавьте аутентификацию

```tsx
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  // Проверка авторизации
  const token = request.cookies.get('token')
  
  if (!token) {
    return NextResponse.redirect(new URL('/login', request.url))
  }
  
  return NextResponse.next()
}

export const config = {
  matcher: ['/courses/:path*', '/lessons/:path*', '/nutrition-plans/:path*'],
}
```

## 💡 Полезные команды

```bash
# Запуск dev сервера
npm run dev

# Сборка для production
npm run build

# Запуск production сервера
npm start

# Линтинг
npm run lint

# Проверка типов
npx tsc --noEmit
```

## 📞 Помощь

Если возникли проблемы:

1. Проверьте [HOW_TO_USE.md](./HOW_TO_USE.md) для детальной информации
2. Изучите примеры в папках модулей
3. Проверьте консоль браузера на ошибки
4. Убедитесь, что API URL правильный

## 🎉 Готово!

Теперь у вас работающая админ панель с:
- ✅ Dashboard со статистикой
- ✅ Управление курсами
- ✅ Управление уроками
- ✅ Управление планами питания
- ✅ И многое другое!

---

**Время установки:** ~5 минут  
**Сложность:** Легко  
**Версия:** 1.0.0

