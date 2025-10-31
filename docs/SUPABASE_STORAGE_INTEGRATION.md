# 📦 Supabase Storage Integration

**Дата:** 14 октября 2025  
**Цель:** Интеграция Supabase Storage для хранения файлов (фото, документы, медиа)

---

## 📋 Обзор

**Важно:** Supabase используется **ТОЛЬКО для Storage (файлов)**, НЕ для базы данных!

**Архитектура проекта:**
- ✅ **Backend**: Fastify + TypeScript (как есть)
- ✅ **База данных**: PostgreSQL 14+ (как есть)
- ✅ **Кэш**: Redis 7+ (как есть)
- 🆕 **Storage**: Supabase Storage (добавляем)

---

## 🎯 Зачем Supabase Storage?

1. **Бесплатный план**: 1 GB storage
2. **CDN из коробки**: быстрая доставка файлов
3. **Автоматическая оптимизация изображений**: resize, transform
4. **Row Level Security**: безопасность на уровне бакетов
5. **SDK для всех платформ**: JavaScript, Flutter, etc.

---

## 📦 Что будем хранить?

### Buckets (корзины):

1. **`avatars`** - аватары пользователей
   - Формат: JPEG, PNG, WEBP
   - Max size: 2 MB
   - Access: Authenticated users

2. **`recipes`** - фото рецептов
   - Формат: JPEG, PNG, WEBP
   - Max size: 5 MB
   - Access: Public read, Admin write

3. **`diary-photos`** - фото блюд из дневника
   - Формат: JPEG, PNG, WEBP
   - Max size: 5 MB
   - Access: User own files

4. **`lab-tests`** - PDF анализов
   - Формат: PDF, JPEG, PNG
   - Max size: 10 MB
   - Access: User own files

5. **`course-materials`** - материалы курсов (PDF, видео)
   - Формат: PDF, MP4, MP3
   - Max size: 50 MB
   - Access: Authenticated users

---

## 🚀 Setup

### 1. Создать проект в Supabase

```bash
# Зарегистрироваться на https://supabase.com
# Создать новый проект: brix-nutrition-storage
# Получить:
# - SUPABASE_URL
# - SUPABASE_ANON_KEY
# - SUPABASE_SERVICE_ROLE_KEY (для backend)
```

### 2. Создать buckets через Supabase Dashboard

```sql
-- Storage > Buckets > Create bucket

-- 1. avatars
CREATE BUCKET avatars (
  public = false,
  file_size_limit = 2097152, -- 2 MB
  allowed_mime_types = ['image/jpeg', 'image/png', 'image/webp']
);

-- 2. recipes
CREATE BUCKET recipes (
  public = true,
  file_size_limit = 5242880, -- 5 MB
  allowed_mime_types = ['image/jpeg', 'image/png', 'image/webp']
);

-- 3. diary-photos
CREATE BUCKET diary_photos (
  public = false,
  file_size_limit = 5242880, -- 5 MB
  allowed_mime_types = ['image/jpeg', 'image/png', 'image/webp']
);

-- 4. lab-tests
CREATE BUCKET lab_tests (
  public = false,
  file_size_limit = 10485760, -- 10 MB
  allowed_mime_types = ['application/pdf', 'image/jpeg', 'image/png']
);

-- 5. course-materials
CREATE BUCKET course_materials (
  public = false,
  file_size_limit = 52428800, -- 50 MB
  allowed_mime_types = ['application/pdf', 'video/mp4', 'audio/mpeg']
);
```

### 3. Настроить Storage Policies

```sql
-- Политики для avatars (пользователи могут загружать свои аватары)
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view own avatar"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Политики для recipes (публичное чтение, только админы загружают)
CREATE POLICY "Anyone can view recipes"
ON storage.objects FOR SELECT
USING (bucket_id = 'recipes');

CREATE POLICY "Service role can upload recipes"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'recipes');

-- Политики для diary-photos (только свои файлы)
CREATE POLICY "Users can manage own diary photos"
ON storage.objects FOR ALL
USING (bucket_id = 'diary_photos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Политики для lab-tests (только свои файлы)
CREATE POLICY "Users can manage own lab tests"
ON storage.objects FOR ALL
USING (bucket_id = 'lab_tests' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Политики для course-materials (аутентифицированные пользователи)
CREATE POLICY "Authenticated users can view course materials"
ON storage.objects FOR SELECT
USING (bucket_id = 'course_materials' AND auth.role() = 'authenticated');
```

---

## 🔧 Backend Integration

### 1. Установить Supabase SDK

```bash
cd backend
npm install @supabase/supabase-js
```

### 2. Создать Supabase Client

```typescript
// backend/src/modules/files_module/services/supabaseClient.ts

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

export const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});
```

### 3. Создать File Upload Service

```typescript
// backend/src/modules/files_module/services/fileUploadService.ts

import { supabase } from './supabaseClient';
import { v4 as uuidv4 } from 'uuid';

interface UploadResult {
  url: string;
  path: string;
  bucket: string;
}

export class FileUploadService {
  /**
   * Загрузить файл в Supabase Storage
   */
  async uploadFile(
    bucket: string,
    file: Buffer,
    fileName: string,
    userId: string,
    contentType: string
  ): Promise<UploadResult> {
    // Генерируем уникальное имя файла
    const fileExt = fileName.split('.').pop();
    const uniqueFileName = `${uuidv4()}.${fileExt}`;
    const filePath = `${userId}/${uniqueFileName}`;

    // Загружаем файл
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(filePath, file, {
        contentType,
        upsert: false
      });

    if (error) {
      throw new Error(`File upload failed: ${error.message}`);
    }

    // Получаем публичный URL
    const { data: urlData } = supabase.storage
      .from(bucket)
      .getPublicUrl(filePath);

    return {
      url: urlData.publicUrl,
      path: filePath,
      bucket
    };
  }

  /**
   * Удалить файл
   */
  async deleteFile(bucket: string, filePath: string): Promise<void> {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([filePath]);

    if (error) {
      throw new Error(`File delete failed: ${error.message}`);
    }
  }

  /**
   * Получить подписанный URL (для приватных файлов)
   */
  async getSignedUrl(bucket: string, filePath: string, expiresIn: number = 3600): Promise<string> {
    const { data, error } = await supabase.storage
      .from(bucket)
      .createSignedUrl(filePath, expiresIn);

    if (error) {
      throw new Error(`Failed to get signed URL: ${error.message}`);
    }

    return data.signedUrl;
  }

  /**
   * Загрузить аватар пользователя
   */
  async uploadAvatar(userId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('avatars', file, fileName, userId, 'image/jpeg');
    return result.url;
  }

  /**
   * Загрузить фото рецепта
   */
  async uploadRecipePhoto(file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('recipes', file, fileName, 'admin', 'image/jpeg');
    return result.url;
  }

  /**
   * Загрузить фото из дневника
   */
  async uploadDiaryPhoto(userId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('diary_photos', file, fileName, userId, 'image/jpeg');
    return result.url;
  }

  /**
   * Загрузить PDF анализа
   */
  async uploadLabTest(userId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('lab_tests', file, fileName, userId, 'application/pdf');
    return result.url;
  }
}

export const fileUploadService = new FileUploadService();
```

### 4. Обновить Files Routes

```typescript
// backend/src/modules/files_module/routes/files.ts

import { FastifyPluginAsync } from 'fastify';
import { fileUploadService } from '../services/fileUploadService';
import { authMiddleware } from '../../core_module/middleware/auth';

export const filesRoutes: FastifyPluginAsync = async (fastify) => {
  // Загрузка аватара
  fastify.post('/upload/avatar', {
    preHandler: authMiddleware,
    handler: async (request, reply) => {
      const data = await request.file();
      if (!data) {
        return reply.code(400).send({ error: 'No file provided' });
      }

      const buffer = await data.toBuffer();
      const userId = request.user.id; // из JWT

      const url = await fileUploadService.uploadAvatar(userId, buffer, data.filename);

      reply.send({ url });
    }
  });

  // Загрузка фото рецепта (только админ)
  fastify.post('/upload/recipe-photo', {
    preHandler: authMiddleware,
    handler: async (request, reply) => {
      const data = await request.file();
      if (!data) {
        return reply.code(400).send({ error: 'No file provided' });
      }

      const buffer = await data.toBuffer();
      const url = await fileUploadService.uploadRecipePhoto(buffer, data.filename);

      reply.send({ url });
    }
  });

  // Загрузка фото из дневника
  fastify.post('/upload/diary-photo', {
    preHandler: authMiddleware,
    handler: async (request, reply) => {
      const data = await request.file();
      if (!data) {
        return reply.code(400).send({ error: 'No file provided' });
      }

      const buffer = await data.toBuffer();
      const userId = request.user.id;

      const url = await fileUploadService.uploadDiaryPhoto(userId, buffer, data.filename);

      reply.send({ url });
    }
  });

  // Загрузка PDF анализа
  fastify.post('/upload/lab-test', {
    preHandler: authMiddleware,
    handler: async (request, reply) => {
      const data = await request.file();
      if (!data) {
        return reply.code(400).send({ error: 'No file provided' });
      }

      const buffer = await data.toBuffer();
      const userId = request.user.id;

      const url = await fileUploadService.uploadLabTest(userId, buffer, data.filename);

      reply.send({ url });
    }
  });
};
```

### 5. Обновить .env

```env
# Supabase Storage
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

---

## 📱 Flutter Integration

### 1. Установить Supabase SDK

```yaml
# mobile/pubspec.yaml

dependencies:
  supabase_flutter: ^2.0.0
```

### 2. Инициализировать Supabase

```dart
// mobile/lib/main.dart

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );
  
  runApp(const BrixNutritionApp());
}

// Global reference
final supabase = Supabase.instance.client;
```

### 3. Создать Storage Service

```dart
// mobile/lib/shared/services/storage_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  /// Загрузить аватар
  Future<String> uploadAvatar(File file, String userId) async {
    final fileName = '${_uuid.v4()}.jpg';
    final filePath = '$userId/$fileName';

    await _supabase.storage.from('avatars').upload(
      filePath,
      file,
      fileOptions: const FileOptions(
        upsert: false,
        contentType: 'image/jpeg',
      ),
    );

    final url = _supabase.storage.from('avatars').getPublicUrl(filePath);
    return url;
  }

  /// Загрузить фото из дневника
  Future<String> uploadDiaryPhoto(File file, String userId) async {
    final fileName = '${_uuid.v4()}.jpg';
    final filePath = '$userId/$fileName';

    await _supabase.storage.from('diary_photos').upload(
      filePath,
      file,
      fileOptions: const FileOptions(
        upsert: false,
        contentType: 'image/jpeg',
      ),
    );

    final url = _supabase.storage.from('diary_photos').getPublicUrl(filePath);
    return url;
  }

  /// Загрузить PDF анализа
  Future<String> uploadLabTest(File file, String userId) async {
    final fileName = '${_uuid.v4()}.pdf';
    final filePath = '$userId/$fileName';

    await _supabase.storage.from('lab_tests').upload(
      filePath,
      file,
      fileOptions: const FileOptions(
        upsert: false,
        contentType: 'application/pdf',
      ),
    );

    final url = _supabase.storage.from('lab_tests').getPublicUrl(filePath);
    return url;
  }

  /// Удалить файл
  Future<void> deleteFile(String bucket, String filePath) async {
    await _supabase.storage.from(bucket).remove([filePath]);
  }

  /// Получить подписанный URL (для приватных файлов)
  Future<String> getSignedUrl(String bucket, String filePath) async {
    final url = await _supabase.storage
        .from(bucket)
        .createSignedUrl(filePath, 3600); // 1 час
    return url;
  }

  /// Выбрать и загрузить фото
  Future<String?> pickAndUploadPhoto(String userId, String bucket) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image == null) return null;

    final file = File(image.path);
    
    if (bucket == 'avatars') {
      return await uploadAvatar(file, userId);
    } else if (bucket == 'diary_photos') {
      return await uploadDiaryPhoto(file, userId);
    }
    
    return null;
  }
}
```

### 4. Использовать в UI

```dart
// Пример: Загрузка аватара в Profile Screen

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  bool _isUploading = false;
  String? _avatarUrl;

  Future<void> _uploadAvatar() async {
    setState(() => _isUploading = true);

    try {
      final userId = 'user-id-here'; // Получить из auth
      final url = await _storageService.pickAndUploadPhoto(userId, 'avatars');
      
      if (url != null) {
        setState(() => _avatarUrl = url);
        // Обновить профиль в БД
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _avatarUrl != null 
                  ? NetworkImage(_avatarUrl!) 
                  : null,
              child: _avatarUrl == null ? Icon(Icons.person) : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadAvatar,
              child: _isUploading 
                  ? CircularProgressIndicator() 
                  : Text('Загрузить фото'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔐 Security Best Practices

1. **Всегда используйте RLS (Row Level Security)** в Supabase Storage
2. **Service Role Key ТОЛЬКО на backend** (никогда не в клиенте)
3. **Anon Key в Flutter** - безопасно, но с RLS
4. **Валидация типов файлов** на backend И frontend
5. **Ограничение размеров** файлов
6. **Scan uploaded files** на вирусы (опционально, через Lambda)

---

## 📊 Monitoring

1. **Supabase Dashboard** → Storage → Usage
2. **Отслеживать:**
   - Storage size (max 1 GB на Free tier)
   - Bandwidth usage
   - Request count
   - Error rate

---

## ✅ Checklist

- [ ] Создан проект в Supabase
- [ ] Созданы buckets (avatars, recipes, diary_photos, lab_tests, course_materials)
- [ ] Настроены Storage Policies
- [ ] Backend: установлен @supabase/supabase-js
- [ ] Backend: создан supabaseClient.ts
- [ ] Backend: создан fileUploadService.ts
- [ ] Backend: обновлены routes/files.ts
- [ ] Backend: добавлены env переменные
- [ ] Flutter: установлен supabase_flutter
- [ ] Flutter: инициализирован Supabase
- [ ] Flutter: создан StorageService
- [ ] Flutter: интегрирован в UI
- [ ] Тестирование загрузки файлов
- [ ] Тестирование удаления файлов

---

**Готово!** Теперь у нас Supabase Storage для файлов, а PostgreSQL для данных! 🎉




