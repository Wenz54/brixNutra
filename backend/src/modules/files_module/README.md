# Files Module - Загрузка файлов

Модуль для загрузки и управления файлами.

## 📦 Функциональность

- Загрузка изображений
- Загрузка видео
- Загрузка аудио
- Валидация размера и типа
- Автоматическая очистка старых файлов

## 🚀 API Endpoints

- `POST /api/admin/files/upload/image` - загрузить изображение
- `POST /api/admin/files/upload/video` - загрузить видео
- `POST /api/admin/files/upload/audio` - загрузить аудио
- `DELETE /api/admin/files/:filename` - удалить файл

## 📊 Ограничения

```typescript
const FILE_LIMITS = {
  image: {
    maxSize: 10 * 1024 * 1024, // 10 MB
    allowedTypes: ['image/jpeg', 'image/png', 'image/webp']
  },
  video: {
    maxSize: 100 * 1024 * 1024, // 100 MB
    allowedTypes: ['video/mp4', 'video/webm']
  },
  audio: {
    maxSize: 20 * 1024 * 1024, // 20 MB
    allowedTypes: ['audio/mpeg', 'audio/mp3', 'audio/wav']
  }
}
```

## 🔧 Использование

```typescript
// Загрузка изображения
const formData = new FormData()
formData.append('image', file)

const response = await fetch('/api/admin/files/upload/image', {
  method: 'POST',
  body: formData,
  headers: {
    'Authorization': `Bearer ${token}`
  }
})

const { filename, url } = await response.json()
```

---

**Версия:** 1.0.0

