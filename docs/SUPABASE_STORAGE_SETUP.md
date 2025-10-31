# 📦 Supabase Storage - Setup Guide

**Дата:** 14 октября 2025  
**Цель:** Настроить Supabase Storage для хранения файлов (фото, PDF, документы)

---

## 🎯 Что будем хранить?

| Bucket | Содержимое | Max Size | Access |
|--------|-----------|----------|--------|
| `avatars` | Аватары пользователей | 2 MB | Authenticated users |
| `recipes` | Фото рецептов | 5 MB | Public read, Admin write |
| `diary-photos` | Фото блюд из дневника | 5 MB | User own files |
| `lab-tests` | PDF анализов | 10 MB | User own files |
| `course-materials` | Материалы курсов | 50 MB | Authenticated users |

---

## 📝 Шаг 1: Создать проект в Supabase

### 1.1 Регистрация

1. Перейдите на: https://supabase.com
2. Нажмите **"Start your project"**
3. Войдите через GitHub или Email

### 1.2 Создать проект

1. Нажмите **"New Project"**
2. Заполните:
   - **Name:** `brix-nutrition`
   - **Database Password:** (сохраните его!)
   - **Region:** `Central EU (Frankfurt)` или ближайший к вам
   - **Pricing Plan:** Free (1 GB storage, достаточно для начала)
3. Нажмите **"Create new project"**
4. Ждите ~2 минуты пока проект создаётся

### 1.3 Получить API ключи

1. После создания проекта перейдите в **Settings** (иконка шестеренки внизу слева)
2. Выберите **API** в меню
3. Скопируйте:
   - **Project URL** (например: `https://abcdefghijklmnop.supabase.co`)
   - **anon public key** (начинается с `eyJhbGci...`)
   - **service_role key** (секретный ключ для backend)

⚠️ **ВАЖНО:** 
- `anon public` ключ - можно использовать в Flutter (клиент)
- `service_role` ключ - ТОЛЬКО в Backend! (полный доступ ко всему)

---

## 📦 Шаг 2: Создать Buckets

### 2.1 Перейти в Storage

1. В левом меню нажмите **Storage** (иконка папки)
2. Нажмите **"New Bucket"**

### 2.2 Создать bucket: avatars

1. **Name:** `avatars`
2. **Public bucket:** ❌ OFF (приватный)
3. **File size limit:** 2 MB
4. **Allowed MIME types:** `image/jpeg, image/png, image/webp`
5. Нажмите **"Create bucket"**

### 2.3 Создать bucket: recipes

1. **Name:** `recipes`
2. **Public bucket:** ✅ ON (публичный, чтобы все могли видеть фото)
3. **File size limit:** 5 MB
4. **Allowed MIME types:** `image/jpeg, image/png, image/webp`
5. Нажмите **"Create bucket"**

### 2.4 Создать bucket: diary-photos

1. **Name:** `diary-photos`
2. **Public bucket:** ❌ OFF
3. **File size limit:** 5 MB
4. **Allowed MIME types:** `image/jpeg, image/png, image/webp`
5. Нажмите **"Create bucket"**

### 2.5 Создать bucket: lab-tests

1. **Name:** `lab-tests`
2. **Public bucket:** ❌ OFF
3. **File size limit:** 10 MB
4. **Allowed MIME types:** `application/pdf, image/jpeg, image/png`
5. Нажмите **"Create bucket"**

### 2.6 Создать bucket: course-materials

1. **Name:** `course-materials`
2. **Public bucket:** ❌ OFF
3. **File size limit:** 50 MB
4. **Allowed MIME types:** `application/pdf, video/mp4, audio/mpeg`
5. Нажмите **"Create bucket"**

---

## 🔐 Шаг 3: Настроить Storage Policies (RLS)

**Важно:** По умолчанию все buckets защищены Row Level Security. Нужно настроить политики доступа.

### 3.1 Политики для avatars

1. Выберите bucket **avatars**
2. Нажмите **"New Policy"**
3. Выберите **"Create a policy from scratch"**

**Policy 1: Users can upload own avatar**
```sql
-- Name: Users can upload own avatar
-- Operation: INSERT
-- Policy:
(bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1])
```

**Policy 2: Users can view own avatar**
```sql
-- Name: Users can view own avatar
-- Operation: SELECT
-- Policy:
(bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1])
```

**Policy 3: Users can delete own avatar**
```sql
-- Name: Users can delete own avatar
-- Operation: DELETE
-- Policy:
(bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1])
```

### 3.2 Политики для recipes (публичные)

**Policy 1: Anyone can view recipes**
```sql
-- Name: Public read access
-- Operation: SELECT
-- Policy:
bucket_id = 'recipes'
```

**Policy 2: Service role can upload recipes**
```sql
-- Name: Service role can upload
-- Operation: INSERT, UPDATE, DELETE
-- Policy:
bucket_id = 'recipes'
```

### 3.3 Политики для diary-photos

**Policy: Users can manage own photos**
```sql
-- Name: Users can manage own diary photos
-- Operation: SELECT, INSERT, UPDATE, DELETE
-- Policy:
(bucket_id = 'diary-photos' AND auth.uid()::text = (storage.foldername(name))[1])
```

### 3.4 Политики для lab-tests

**Policy: Users can manage own lab tests**
```sql
-- Name: Users can manage own lab tests
-- Operation: SELECT, INSERT, UPDATE, DELETE
-- Policy:
(bucket_id = 'lab-tests' AND auth.uid()::text = (storage.foldername(name))[1])
```

### 3.5 Политики для course-materials

**Policy: Authenticated users can view**
```sql
-- Name: Authenticated users can view materials
-- Operation: SELECT
-- Policy:
(bucket_id = 'course-materials' AND auth.role() = 'authenticated')
```

---

## 💾 Шаг 4: Сохранить ключи

### Для Backend (.env)

Создайте/обновите `backend/.env`:

```env
# Supabase Storage
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...your-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...your-service-role-key
```

⚠️ **НЕ коммитьте .env в Git!**

### Для Flutter (в коде)

Будем использовать в `mobile/lib/shared/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String url = 'https://your-project.supabase.co';
  static const String anonKey = 'eyJhbGci...your-anon-key';
}
```

---

## ✅ Checklist

- [ ] Зарегистрирован в Supabase
- [ ] Создан проект `brix-nutrition`
- [ ] Скопированы API ключи (Project URL, anon key, service_role key)
- [ ] Создан bucket `avatars` (приватный, 2 MB)
- [ ] Создан bucket `recipes` (публичный, 5 MB)
- [ ] Создан bucket `diary-photos` (приватный, 5 MB)
- [ ] Создан bucket `lab-tests` (приватный, 10 MB)
- [ ] Создан bucket `course-materials` (приватный, 50 MB)
- [ ] Настроены Storage Policies для avatars
- [ ] Настроены Storage Policies для recipes
- [ ] Настроены Storage Policies для diary-photos
- [ ] Настроены Storage Policies для lab-tests
- [ ] Настроены Storage Policies для course-materials
- [ ] API ключи сохранены в `backend/.env`
- [ ] API ключи добавлены в Flutter config

---

## 🔗 Полезные ссылки

- [Supabase Storage Docs](https://supabase.com/docs/guides/storage)
- [Storage Policies Guide](https://supabase.com/docs/guides/storage/security/access-control)
- [Flutter Supabase Client](https://pub.dev/packages/supabase_flutter)

---

## 📊 Pricing (на будущее)

**Free Tier:**
- ✅ 1 GB storage
- ✅ Unlimited uploads/downloads
- ✅ CDN included
- ✅ Подходит для начала!

**Pro Tier ($25/мес):**
- 100 GB storage
- Приоритетная поддержка

---

**Следующий шаг:** После создания buckets → интеграция в Flutter и Backend! 🚀




