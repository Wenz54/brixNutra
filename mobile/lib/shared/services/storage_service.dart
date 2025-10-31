import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:mobile/shared/config/supabase_config.dart';
import 'package:mobile/dev_modules/core_module/services/token_manager.dart';

/// Сервис для работы с Supabase Storage
///
/// Функции:
/// - Загрузка аватаров пользователей
/// - Загрузка фото рецептов
/// - Загрузка фото из дневника
/// - Загрузка PDF анализов
/// - Загрузка материалов курсов
class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== AVATARS ====================

  /// Загрузить аватар пользователя
  ///
  /// [file] - файл изображения
  /// [userId] - ID пользователя
  ///
  /// Возвращает публичный URL загруженного файла
  Future<String> uploadAvatar(File file, String userId) async {
    try {
      final fileName = _generateFileName(file.path);
      final filePath = '$userId/$fileName';

      debugPrint('📤 Uploading avatar: $filePath');

      await _supabase.storage.from(SupabaseConfig.avatarsBucket).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true, // Перезаписать если уже существует
              contentType: 'image/jpeg',
            ),
          );

      final url = _supabase.storage
          .from(SupabaseConfig.avatarsBucket)
          .getPublicUrl(filePath);

      debugPrint('✅ Avatar uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Avatar upload error: $e');
      rethrow;
    }
  }

  /// Выбрать и загрузить аватар
  ///
  /// Открывает галерею, пользователь выбирает фото, загружает
  Future<String?> pickAndUploadAvatar() async {
    try {
      // Получить User ID
      final userId = await TokenManager.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Выбрать изображение
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Загрузить
      final file = File(image.path);
      return await uploadAvatar(file, userId);
    } catch (e) {
      debugPrint('❌ Pick and upload avatar error: $e');
      rethrow;
    }
  }

  // ==================== RECIPE PHOTOS ====================

  /// Загрузить фото рецепта (только admin)
  ///
  /// [file] - файл изображения
  /// [recipeId] - ID рецепта
  Future<String> uploadRecipePhoto(File file, String recipeId) async {
    try {
      final fileName = _generateFileName(file.path);
      final filePath = '$recipeId/$fileName';

      debugPrint('📤 Uploading recipe photo: $filePath');

      await _supabase.storage.from(SupabaseConfig.recipesBucket).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final url = _supabase.storage
          .from(SupabaseConfig.recipesBucket)
          .getPublicUrl(filePath);

      debugPrint('✅ Recipe photo uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Recipe photo upload error: $e');
      rethrow;
    }
  }

  // ==================== DIARY PHOTOS ====================

  /// Загрузить фото блюда из дневника
  ///
  /// [file] - файл изображения
  /// [userId] - ID пользователя
  Future<String> uploadDiaryPhoto(File file, String userId) async {
    try {
      final fileName = _generateFileName(file.path);
      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      debugPrint('📤 Uploading diary photo: $filePath');

      await _supabase.storage.from(SupabaseConfig.diaryPhotosBucket).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: false,
              contentType: 'image/jpeg',
            ),
          );

      final url = _supabase.storage
          .from(SupabaseConfig.diaryPhotosBucket)
          .getPublicUrl(filePath);

      debugPrint('✅ Diary photo uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Diary photo upload error: $e');
      rethrow;
    }
  }

  /// Выбрать и загрузить фото блюда
  ///
  /// Открывает камеру или галерею
  Future<String?> pickAndUploadDiaryPhoto({ImageSource source = ImageSource.camera}) async {
    try {
      // Получить User ID
      final userId = await TokenManager.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Выбрать изображение
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      // Загрузить
      final file = File(image.path);
      return await uploadDiaryPhoto(file, userId);
    } catch (e) {
      debugPrint('❌ Pick and upload diary photo error: $e');
      rethrow;
    }
  }

  // ==================== LAB TESTS ====================

  /// Загрузить PDF анализа
  ///
  /// [file] - файл PDF
  /// [userId] - ID пользователя
  Future<String> uploadLabTest(File file, String userId) async {
    try {
      final fileName = _generateFileName(file.path);
      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      debugPrint('📤 Uploading lab test: $filePath');

      await _supabase.storage.from(SupabaseConfig.labTestsBucket).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: false,
              contentType: 'application/pdf',
            ),
          );

      // Для приватных файлов создаем подписанный URL
      final url = await _supabase.storage
          .from(SupabaseConfig.labTestsBucket)
          .createSignedUrl(filePath, 31536000); // 1 год

      debugPrint('✅ Lab test uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Lab test upload error: $e');
      rethrow;
    }
  }

  /// Выбрать и загрузить PDF анализа
  Future<String?> pickAndUploadLabTest() async {
    try {
      // Получить User ID
      final userId = await TokenManager.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Выбрать файл
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result == null) return null;

      // Загрузить
      final file = File(result.files.single.path!);
      return await uploadLabTest(file, userId);
    } catch (e) {
      debugPrint('❌ Pick and upload lab test error: $e');
      rethrow;
    }
  }

  // ==================== COURSE MATERIALS ====================

  /// Загрузить материал курса
  ///
  /// [file] - файл (PDF, видео, аудио)
  /// [courseId] - ID курса
  /// [lessonId] - ID урока
  Future<String> uploadCourseMaterial(File file, String courseId, String lessonId) async {
    try {
      final fileName = _generateFileName(file.path);
      final filePath = '$courseId/$lessonId/$fileName';

      debugPrint('📤 Uploading course material: $filePath');

      // Определить content type
      final extension = path.extension(file.path).toLowerCase();
      String contentType = 'application/octet-stream';
      if (extension == '.pdf') {
        contentType = 'application/pdf';
      } else if (extension == '.mp4') {
        contentType = 'video/mp4';
      } else if (extension == '.mp3') {
        contentType = 'audio/mpeg';
      }

      await _supabase.storage.from(SupabaseConfig.courseMaterialsBucket).upload(
            filePath,
            file,
            fileOptions: FileOptions(
              upsert: false,
              contentType: contentType,
            ),
          );

      // Создать подписанный URL (1 год)
      final url = await _supabase.storage
          .from(SupabaseConfig.courseMaterialsBucket)
          .createSignedUrl(filePath, 31536000);

      debugPrint('✅ Course material uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Course material upload error: $e');
      rethrow;
    }
  }

  // ==================== DELETE FILES ====================

  /// Удалить файл
  ///
  /// [bucket] - название bucket
  /// [filePath] - путь к файлу
  Future<void> deleteFile(String bucket, String filePath) async {
    try {
      debugPrint('🗑️ Deleting file: $bucket/$filePath');

      await _supabase.storage.from(bucket).remove([filePath]);

      debugPrint('✅ File deleted');
    } catch (e) {
      debugPrint('❌ Delete file error: $e');
      rethrow;
    }
  }

  // ==================== HELPERS ====================

  /// Генерировать уникальное имя файла
  String _generateFileName(String originalPath) {
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'file_$timestamp$extension';
  }

  /// Получить размер файла в MB
  double getFileSizeMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Проверить размер файла
  bool checkFileSize(File file, double maxSizeMB) {
    return getFileSizeMB(file) <= maxSizeMB;
  }
}




