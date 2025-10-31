# Lab Module - Лабораторные анализы

Модуль для работы с лабораторными тестами и результатами.

## 📦 Функциональность

- Лабораторные тесты
- Результаты анализов
- Референсные значения
- История тестов
- Интерпретация результатов

## 🚀 API Endpoints

- `GET /api/lab/tests` - список тестов
- `GET /api/lab/results` - мои результаты
- `POST /api/lab/results` - добавить результат
- `GET /api/lab/tests/:id` - детали теста

## 📊 Типы

```typescript
interface LabTest {
  id: string
  name_ru: string
  description_ru?: string
  category: string
  unit: string
  referenceMin?: number
  referenceMax?: number
}

interface LabResult {
  id: string
  userId: string
  testId: string
  value: number
  date: Date
  notes?: string
  isAbnormal: boolean
}
```

---

**Версия:** 1.0.0

