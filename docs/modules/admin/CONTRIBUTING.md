# Contributing - Вклад в разработку

Спасибо за интерес к развитию Admin Modules! Мы приветствуем любой вклад.

## 🤝 Как внести вклад

### 1. Создайте issue

Прежде чем начать работу, создайте issue с описанием:
- Что вы хотите добавить/исправить
- Зачем это нужно
- Как вы планируете это реализовать

### 2. Fork репозитория

```bash
git clone https://github.com/your-username/admin-modules.git
cd admin-modules
```

### 3. Создайте ветку

```bash
git checkout -b feature/your-feature-name
# или
git checkout -b fix/your-bug-fix
```

### 4. Внесите изменения

Следуйте принципам:
- Пишите чистый, читаемый код
- Добавляйте комментарии для сложной логики
- Используйте TypeScript типы
- Следуйте существующему стилю кода

### 5. Обновите документацию

- Обновите README модуля
- Добавьте примеры использования
- Обновите CHANGELOG.md

### 6. Протестируйте изменения

```bash
npm run type-check
npm run lint
```

### 7. Commit изменения

Используйте [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat: добавлен новый компонент Button"
git commit -m "fix: исправлена ошибка в FileUpload"
git commit -m "docs: обновлена документация core_module"
```

Типы коммитов:
- `feat` - новая функциональность
- `fix` - исправление бага
- `docs` - изменения в документации
- `style` - форматирование кода
- `refactor` - рефакторинг
- `test` - добавление тестов
- `chore` - обновление зависимостей

### 8. Push и создание Pull Request

```bash
git push origin feature/your-feature-name
```

Создайте Pull Request с описанием:
- Что было сделано
- Какую проблему решает
- Скриншоты (если применимо)

## 📝 Правила кода

### TypeScript

```typescript
// ✅ Хорошо
interface UserProps {
  name: string
  age: number
  isActive?: boolean
}

function getUserName(user: UserProps): string {
  return user.name
}

// ❌ Плохо
function getUserName(user: any) {
  return user.name
}
```

### React компоненты

```tsx
// ✅ Хорошо
interface ButtonProps {
  onClick: () => void
  children: React.ReactNode
  variant?: 'primary' | 'secondary'
}

export default function Button({ onClick, children, variant = 'primary' }: ButtonProps) {
  return (
    <button onClick={onClick} className={`btn-${variant}`}>
      {children}
    </button>
  )
}

// ❌ Плохо
export default function Button(props: any) {
  return <button onClick={props.onClick}>{props.children}</button>
}
```

### Стили (Tailwind CSS)

```tsx
// ✅ Хорошо - используем утилиты
<div className="flex items-center justify-between p-4 bg-white rounded-lg shadow">

// ❌ Плохо - inline стили
<div style={{ display: 'flex', padding: '16px' }}>
```

### Именование

- **Компоненты:** PascalCase (`UserCard`, `FileUpload`)
- **Функции:** camelCase (`getUserData`, `handleClick`)
- **Константы:** UPPER_SNAKE_CASE (`API_BASE_URL`, `MAX_FILE_SIZE`)
- **Файлы:** PascalCase для компонентов (`Button.tsx`), camelCase для утилит (`helpers.ts`)

## 📦 Создание нового модуля

### Структура модуля

```
new_module/
├── README.md           # Описание модуля
├── components/         # React компоненты
│   └── ComponentName.tsx
├── pages/             # Страницы
│   └── PageName.tsx
├── types/             # TypeScript типы
│   └── index.ts
├── api/               # API методы
│   └── index.ts
├── utils/             # Утилиты
│   └── helpers.ts
└── hooks/             # Custom hooks
    └── useCustomHook.ts
```

### README модуля

```markdown
# Module Name - Описание

Краткое описание модуля.

## 📦 Состав модуля

### Компоненты
- Список компонентов

### Страницы
- Список страниц

## 🚀 Использование

Примеры использования

## 🔧 API методы

Описание API методов

## 🔗 Связанные модули

Зависимости
```

## 🧪 Тестирование

### Unit тесты (планируется)

```typescript
import { render, screen } from '@testing-library/react'
import Button from './Button'

describe('Button', () => {
  it('renders button with text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })
})
```

## 📖 Документация

### JSDoc комментарии

```typescript
/**
 * Загружает изображение на сервер
 * @param file - Файл изображения
 * @returns Promise с URL загруженного изображения
 * @throws Error если загрузка не удалась
 */
async function uploadImage(file: File): Promise<string> {
  // ...
}
```

### Примеры в README

Всегда добавляйте примеры использования:

```tsx
// Пример использования
import { Component } from '@/admin_modules/module_name'

<Component prop="value" />
```

## 🎨 UI/UX Guidelines

### Доступность (a11y)

```tsx
// ✅ Хорошо
<button
  aria-label="Закрыть"
  onClick={handleClose}
>
  <XMarkIcon />
</button>

// ❌ Плохо
<div onClick={handleClose}>×</div>
```

### Responsive дизайн

```tsx
// ✅ Используем responsive утилиты Tailwind
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
```

## 🚀 Релизы

### Версионирование

Следуем [Semantic Versioning](https://semver.org/):

- `MAJOR` версия - несовместимые изменения API
- `MINOR` версия - новая функциональность (обратно совместимая)
- `PATCH` версия - исправления багов

### Процесс релиза

1. Обновить версию в `package.json`
2. Обновить `CHANGELOG.md`
3. Создать git tag
4. Создать GitHub Release

## 💬 Вопросы?

- Создайте issue на GitHub
- Напишите в Discussions
- Свяжитесь с командой

## 📜 Code of Conduct

Будьте уважительны, профессиональны и конструктивны.

---

**Спасибо за вклад в проект!** 🙏

