# Как использовать модули админки

Подробная инструкция по интеграции и использованию модулей админ панели.

## 🚀 Быстрый старт

### 1. Скопируйте нужный модуль

```bash
# Скопируйте модуль в ваш проект
cp -r admin_modules/core_module /path/to/your/project/src/admin_modules/
cp -r admin_modules/courses_module /path/to/your/project/src/admin_modules/
```

### 2. Установите зависимости

```bash
npm install next@14.0.3 react@18 react-dom@18
npm install @heroicons/react@2.0.18 lucide-react@0.539.0
npm install react-hook-form@7.62.0 react-hot-toast@2.5.2
npm install tailwindcss@3.3.0 autoprefixer@10.0.1 postcss@8
npm install typescript@5 @types/node @types/react @types/react-dom
```

### 3. Настройте конфигурацию

#### next.config.js
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['24supplydiets.ru', 'your-domain.com'],
  },
}

module.exports = nextConfig
```

#### tailwind.config.ts
```typescript
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/admin_modules/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f7fee7',
          100: '#ecfccb',
          200: '#d9f99d',
          300: '#bef264',
          400: '#a3e635',
          500: '#84cc16', // Основной lime
          600: '#65a30d',
          700: '#4d7c0f',
          800: '#3f6212',
          900: '#365314',
        },
      },
    },
  },
  plugins: [],
}
export default config
```

#### .env.local
```env
NEXT_PUBLIC_API_URL=https://your-api-url.com
```

### 4. Создайте страницы

#### app/layout.tsx
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

#### app/page.tsx
```tsx
import { DashboardPage } from '@/admin_modules/dashboard_module/components/DashboardPage'

export default function Home() {
  return <DashboardPage />
}
```

#### app/courses/page.tsx
```tsx
import { CoursesListPage } from '@/admin_modules/courses_module/pages/CoursesListPage'

export default function Courses() {
  return <CoursesListPage />
}
```

## 📦 Структура проекта

```
your-project/
├── src/
│   ├── admin_modules/           # Модули админки
│   │   ├── core_module/
│   │   ├── dashboard_module/
│   │   ├── courses_module/
│   │   ├── lessons_module/
│   │   ├── categories_module/
│   │   ├── nutrition_plans_module/
│   │   ├── ui_components_module/
│   │   └── analytics_module/
│   ├── app/                     # Next.js App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── courses/
│   │   │   └── page.tsx
│   │   ├── lessons/
│   │   │   └── page.tsx
│   │   └── ...
│   └── ...
├── public/
├── package.json
├── next.config.js
├── tailwind.config.ts
└── tsconfig.json
```

## 🔧 Настройка TypeScript

#### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"],
      "@/admin_modules/*": ["./src/admin_modules/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

## 🎨 Кастомизация

### Изменение цветов

Отредактируйте `tailwind.config.ts`:

```typescript
theme: {
  extend: {
    colors: {
      primary: {
        // Ваши цвета
        500: '#your-color',
      },
    },
  },
}
```

### Изменение API URL

Создайте `.env.local`:

```env
NEXT_PUBLIC_API_URL=https://your-api.com
```

### Добавление своих компонентов

```tsx
// src/components/MyComponent.tsx
export default function MyComponent() {
  return <div>My Custom Component</div>
}

// Используйте в модуле
import MyComponent from '@/components/MyComponent'
```

## 🔌 Интеграция с существующим проектом

### Вариант 1: Полная интеграция

1. Скопируйте все модули
2. Используйте AdminLayout как основной layout
3. Создайте маршруты для каждого модуля

### Вариант 2: Частичная интеграция

1. Скопируйте только нужные модули (например, core_module + courses_module)
2. Интегрируйте компоненты в свой layout
3. Используйте только нужные страницы

### Вариант 3: Использование отдельных компонентов

1. Скопируйте только ui_components_module
2. Импортируйте компоненты по необходимости
3. Адаптируйте под свой дизайн-систему

## 📝 Примеры использования

### Пример 1: Создание новой страницы с использованием модулей

```tsx
// app/my-page/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { apiClient } from '@/admin_modules/core_module'
import { FileUpload } from '@/admin_modules/ui_components_module'
import { Button, Card } from '@/admin_modules/ui_components_module'

export default function MyPage() {
  const [data, setData] = useState([])
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = async () => {
    setLoading(true)
    const response = await apiClient.getCourses()
    if (response.success) {
      setData(response.data)
    }
    setLoading(false)
  }

  return (
    <div className="max-w-7xl mx-auto p-8">
      <h1 className="text-3xl font-bold mb-8">My Custom Page</h1>
      
      <Card>
        <Card.Body>
          {loading ? (
            <p>Loading...</p>
          ) : (
            <div className="grid grid-cols-3 gap-4">
              {data.map(item => (
                <div key={item.id}>{item.title}</div>
              ))}
            </div>
          )}
        </Card.Body>
      </Card>
    </div>
  )
}
```

### Пример 2: Кастомная форма с FileUpload

```tsx
'use client'

import { useState } from 'react'
import { FileUpload } from '@/admin_modules/ui_components_module'
import { apiClient } from '@/admin_modules/core_module'
import toast from 'react-hot-toast'

export default function MyForm() {
  const [imageUrl, setImageUrl] = useState<string>('')
  const [uploading, setUploading] = useState(false)

  const handleFileSelect = async (file: File) => {
    setUploading(true)
    try {
      const response = await apiClient.uploadImage(file)
      if (response.success) {
        setImageUrl(response.data.url)
        toast.success('Изображение загружено')
      } else {
        toast.error('Ошибка загрузки')
      }
    } catch (error) {
      toast.error('Ошибка загрузки')
    } finally {
      setUploading(false)
    }
  }

  const handleSubmit = async () => {
    // Ваша логика отправки формы
  }

  return (
    <form onSubmit={handleSubmit}>
      <FileUpload
        fileType="image"
        accept="image/*"
        placeholder="Выберите изображение"
        onFileSelect={handleFileSelect}
        preview={imageUrl}
      />
      
      <button 
        type="submit" 
        disabled={uploading}
        className="mt-4 px-4 py-2 bg-lime-600 text-white rounded"
      >
        {uploading ? 'Загрузка...' : 'Сохранить'}
      </button>
    </form>
  )
}
```

## 🐛 Troubleshooting

### Проблема: Модули не импортируются

**Решение:** Проверьте paths в `tsconfig.json`:

```json
"paths": {
  "@/*": ["./src/*"],
  "@/admin_modules/*": ["./src/admin_modules/*"]
}
```

### Проблема: Стили не применяются

**Решение:** Убедитесь, что путь к модулям добавлен в `tailwind.config.ts`:

```typescript
content: [
  './src/admin_modules/**/*.{js,ts,jsx,tsx,mdx}',
]
```

### Проблема: API запросы не работают

**Решение:** Проверьте `.env.local`:

```env
NEXT_PUBLIC_API_URL=https://your-api.com
```

### Проблема: Ошибки типизации

**Решение:** Установите все необходимые @types пакеты:

```bash
npm install -D @types/node @types/react @types/react-dom
```

## 📚 Дополнительные ресурсы

- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [React Hook Form Documentation](https://react-hook-form.com)

---

**Версия:** 1.0.0  
**Обновлено:** October 2025

