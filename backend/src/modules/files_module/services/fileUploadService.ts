import { supabase } from './supabaseClient';
import { v4 as uuidv4 } from 'uuid';

/**
 * Upload result interface
 */
export interface UploadResult {
  url: string;
  path: string;
  bucket: string;
}

/**
 * File Upload Service для работы с Supabase Storage
 * 
 * Функции:
 * - Загрузка файлов в Supabase buckets
 * - Генерация публичных/подписанных URLs
 * - Удаление файлов
 */
export class FileUploadService {
  /**
   * Загрузить файл в Supabase Storage
   * 
   * @param bucket - название bucket (avatars, recipes, diary-photos, lab-tests, course-materials)
   * @param file - Buffer с данными файла
   * @param fileName - оригинальное имя файла
   * @param userId - ID пользователя (для организации папок)
   * @param contentType - MIME тип файла
   * @returns Promise<UploadResult>
   */
  async uploadFile(
    bucket: string,
    file: Buffer,
    fileName: string,
    userId: string,
    contentType: string
  ): Promise<UploadResult> {
    if (!supabase) {
      throw new Error('Supabase client is not initialized');
    }

    try {
      // Генерируем уникальное имя файла
      const fileExt = fileName.split('.').pop();
      const uniqueFileName = `${uuidv4()}.${fileExt}`;
      const filePath = `${userId}/${uniqueFileName}`;

      console.log(`📤 Uploading file to ${bucket}/${filePath}`);

      // Загружаем файл
      const { data, error } = await supabase.storage
        .from(bucket)
        .upload(filePath, file, {
          contentType,
          upsert: false,
        });

      if (error) {
        console.error(`❌ Upload error:`, error);
        throw new Error(`File upload failed: ${error.message}`);
      }

      // Получаем публичный URL
      const { data: urlData } = supabase.storage
        .from(bucket)
        .getPublicUrl(filePath);

      console.log(`✅ File uploaded: ${urlData.publicUrl}`);

      return {
        url: urlData.publicUrl,
        path: filePath,
        bucket,
      };
    } catch (error) {
      console.error(`❌ Upload file error:`, error);
      throw error;
    }
  }

  /**
   * Удалить файл из Supabase Storage
   * 
   * @param bucket - название bucket
   * @param filePath - путь к файлу
   */
  async deleteFile(bucket: string, filePath: string): Promise<void> {
    if (!supabase) {
      throw new Error('Supabase client is not initialized');
    }

    try {
      console.log(`🗑️ Deleting file from ${bucket}/${filePath}`);

      const { error } = await supabase.storage
        .from(bucket)
        .remove([filePath]);

      if (error) {
        throw new Error(`File delete failed: ${error.message}`);
      }

      console.log(`✅ File deleted`);
    } catch (error) {
      console.error(`❌ Delete file error:`, error);
      throw error;
    }
  }

  /**
   * Получить подписанный URL (для приватных файлов)
   * 
   * @param bucket - название bucket
   * @param filePath - путь к файлу
   * @param expiresIn - время жизни URL в секундах (по умолчанию 1 час)
   * @returns Promise<string> - подписанный URL
   */
  async getSignedUrl(
    bucket: string,
    filePath: string,
    expiresIn: number = 3600
  ): Promise<string> {
    if (!supabase) {
      throw new Error('Supabase client is not initialized');
    }

    try {
      const { data, error } = await supabase.storage
        .from(bucket)
        .createSignedUrl(filePath, expiresIn);

      if (error) {
        throw new Error(`Failed to get signed URL: ${error.message}`);
      }

      return data.signedUrl;
    } catch (error) {
      console.error(`❌ Get signed URL error:`, error);
      throw error;
    }
  }

  // ==================== SPECIFIC UPLOAD METHODS ====================

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
  async uploadRecipePhoto(recipeId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('recipes', file, fileName, recipeId, 'image/jpeg');
    return result.url;
  }

  /**
   * Загрузить фото из дневника
   */
  async uploadDiaryPhoto(userId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('diary-photos', file, fileName, userId, 'image/jpeg');
    return result.url;
  }

  /**
   * Загрузить PDF анализа
   */
  async uploadLabTest(userId: string, file: Buffer, fileName: string): Promise<string> {
    const result = await this.uploadFile('lab-tests', file, fileName, userId, 'application/pdf');
    
    // Для приватных файлов возвращаем подписанный URL (1 год)
    return await this.getSignedUrl('lab-tests', result.path, 31536000);
  }

  /**
   * Загрузить материал курса
   */
  async uploadCourseMaterial(
    courseId: string,
    lessonId: string,
    file: Buffer,
    fileName: string,
    contentType: string
  ): Promise<string> {
    // Путь: courseId/lessonId/file
    const fileExt = fileName.split('.').pop();
    const uniqueFileName = `${uuidv4()}.${fileExt}`;
    const filePath = `${courseId}/${lessonId}/${uniqueFileName}`;

    if (!supabase) {
      throw new Error('Supabase client is not initialized');
    }

    const { error } = await supabase.storage
      .from('course-materials')
      .upload(filePath, file, {
        contentType,
        upsert: false,
      });

    if (error) {
      throw new Error(`File upload failed: ${error.message}`);
    }

    // Возвращаем подписанный URL (1 год)
    return await this.getSignedUrl('course-materials', filePath, 31536000);
  }
}

// Singleton instance
export const fileUploadService = new FileUploadService();




