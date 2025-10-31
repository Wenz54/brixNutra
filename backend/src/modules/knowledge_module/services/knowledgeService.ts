import { FastifyInstance } from 'fastify';

export interface Course {
  id: string;
  title: string;
  slug: string;
  description?: string;
  image_url?: string;
  author?: string;
  is_paid: boolean;
  price?: number;
  duration?: string;
  difficulty?: string;
  category_id?: string;
  order_index: number;
  is_published: boolean;
  total_lessons: number;
  total_duration_minutes: number;
  user_progress?: {
    completed_lessons: number;
    progress_percent: number;
    is_completed: boolean;
    last_lesson_id?: string;
  };
}

export interface Lesson {
  id: string;
  course_id: string;
  title: string;
  slug: string;
  description?: string;
  order_index: number;
  type: string;
  content?: string;
  video_url?: string;
  duration_minutes: number;
  materials?: any[];
  is_published: boolean;
  is_free: boolean;
  user_progress?: {
    is_completed: boolean;
    completed_at?: Date;
    progress_percent: number;
    last_position: number;
  };
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  description?: string;
  icon?: string;
  order_index: number;
}

export class KnowledgeService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Get all courses with optional filtering
   */
  async getCourses(
    userId?: string,
    filter?: 'free' | 'paid' | 'all',
    categoryId?: string
  ): Promise<Course[]> {
    const db = await import('../../database_module/connection.js');

    let query = `
      SELECT 
        c.*,
        ucp.completed_lessons,
        ucp.progress_percent,
        ucp.is_completed as user_is_completed,
        ucp.last_lesson_id
      FROM courses c
      LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = $1
      WHERE c.is_published = true
    `;

    const params: any[] = [userId || null];

    // Apply filters
    if (filter === 'free') {
      query += ` AND c.is_paid = false`;
    } else if (filter === 'paid') {
      query += ` AND c.is_paid = true`;
    }

    if (categoryId) {
      params.push(categoryId);
      query += ` AND c.category_id = $${params.length}`;
    }

    query += ` ORDER BY c.order_index ASC, c.created_at DESC`;

    const result = await db.query(query, params);

    const courses: Course[] = result.rows.map(row => ({
      id: row.id,
      title: row.title,
      slug: row.slug,
      description: row.description,
      image_url: row.image_url,
      author: row.author,
      is_paid: row.is_paid,
      price: row.price ? parseFloat(row.price) : undefined,
      duration: row.duration,
      difficulty: row.difficulty,
      category_id: row.category_id,
      order_index: row.order_index,
      is_published: row.is_published,
      total_lessons: row.total_lessons,
      total_duration_minutes: row.total_duration_minutes,
      user_progress: row.completed_lessons !== null ? {
        completed_lessons: row.completed_lessons,
        progress_percent: row.progress_percent,
        is_completed: row.user_is_completed,
        last_lesson_id: row.last_lesson_id,
      } : undefined,
    }));

    this.fastify.log.info(`✅ Retrieved ${courses.length} courses`);

    return courses;
  }

  /**
   * Get course by ID with lessons
   */
  async getCourseById(courseId: string, userId?: string): Promise<{
    course: Course;
    lessons: Lesson[];
  } | null> {
    const db = await import('../../database_module/connection.js');

    // Get course
    const courseQuery = `
      SELECT 
        c.*,
        ucp.completed_lessons,
        ucp.progress_percent,
        ucp.is_completed as user_is_completed,
        ucp.last_lesson_id,
        ucp.last_accessed_at
      FROM courses c
      LEFT JOIN user_course_progress ucp ON c.id = ucp.course_id AND ucp.user_id = $1
      WHERE c.id = $2 AND c.is_published = true
    `;

    const courseResult = await db.query(courseQuery, [userId || null, courseId]);

    if (courseResult.rows.length === 0) {
      return null;
    }

    const row = courseResult.rows[0];

    const course: Course = {
      id: row.id,
      title: row.title,
      slug: row.slug,
      description: row.description,
      image_url: row.image_url,
      author: row.author,
      is_paid: row.is_paid,
      price: row.price ? parseFloat(row.price) : undefined,
      duration: row.duration,
      difficulty: row.difficulty,
      category_id: row.category_id,
      order_index: row.order_index,
      is_published: row.is_published,
      total_lessons: row.total_lessons,
      total_duration_minutes: row.total_duration_minutes,
      user_progress: row.completed_lessons !== null ? {
        completed_lessons: row.completed_lessons,
        progress_percent: row.progress_percent,
        is_completed: row.user_is_completed,
        last_lesson_id: row.last_lesson_id,
      } : undefined,
    };

    // Get lessons
    const lessonsQuery = `
      SELECT 
        l.*,
        ulp.is_completed as user_is_completed,
        ulp.completed_at as user_completed_at,
        ulp.progress_percent as user_progress_percent,
        ulp.last_position as user_last_position
      FROM lessons l
      LEFT JOIN user_lesson_progress ulp ON l.id = ulp.lesson_id AND ulp.user_id = $1
      WHERE l.course_id = $2 AND l.is_published = true
      ORDER BY l.order_index ASC
    `;

    const lessonsResult = await db.query(lessonsQuery, [userId || null, courseId]);

    const lessons: Lesson[] = lessonsResult.rows.map(lessonRow => ({
      id: lessonRow.id,
      course_id: lessonRow.course_id,
      title: lessonRow.title,
      slug: lessonRow.slug,
      description: lessonRow.description,
      order_index: lessonRow.order_index,
      type: lessonRow.type,
      content: lessonRow.content,
      video_url: lessonRow.video_url,
      duration_minutes: lessonRow.duration_minutes,
      materials: lessonRow.materials,
      is_published: lessonRow.is_published,
      is_free: lessonRow.is_free,
      user_progress: lessonRow.user_is_completed !== null ? {
        is_completed: lessonRow.user_is_completed,
        completed_at: lessonRow.user_completed_at,
        progress_percent: lessonRow.user_progress_percent || 0,
        last_position: lessonRow.user_last_position || 0,
      } : undefined,
    }));

    this.fastify.log.info(`✅ Retrieved course ${courseId} with ${lessons.length} lessons`);

    return { course, lessons };
  }

  /**
   * Get lesson by ID
   */
  async getLessonById(lessonId: string, userId?: string): Promise<Lesson | null> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT 
        l.*,
        ulp.is_completed as user_is_completed,
        ulp.completed_at as user_completed_at,
        ulp.progress_percent as user_progress_percent,
        ulp.last_position as user_last_position
      FROM lessons l
      LEFT JOIN user_lesson_progress ulp ON l.id = ulp.lesson_id AND ulp.user_id = $1
      WHERE l.id = $2 AND l.is_published = true
    `;

    const result = await db.query(query, [userId || null, lessonId]);

    if (result.rows.length === 0) {
      return null;
    }

    const row = result.rows[0];

    const lesson: Lesson = {
      id: row.id,
      course_id: row.course_id,
      title: row.title,
      slug: row.slug,
      description: row.description,
      order_index: row.order_index,
      type: row.type,
      content: row.content,
      video_url: row.video_url,
      duration_minutes: row.duration_minutes,
      materials: row.materials,
      is_published: row.is_published,
      is_free: row.is_free,
      user_progress: row.user_is_completed !== null ? {
        is_completed: row.user_is_completed,
        completed_at: row.user_completed_at,
        progress_percent: row.user_progress_percent || 0,
        last_position: row.user_last_position || 0,
      } : undefined,
    };

    this.fastify.log.info(`✅ Retrieved lesson ${lessonId}`);

    return lesson;
  }

  /**
   * Mark lesson as complete
   */
  async markLessonComplete(
    userId: string,
    lessonId: string
  ): Promise<{ success: boolean; message: string; course_progress?: any }> {
    const db = await import('../../database_module/connection.js');

    // Get lesson info
    const lessonQuery = `SELECT course_id FROM lessons WHERE id = $1`;
    const lessonResult = await db.query(lessonQuery, [lessonId]);

    if (lessonResult.rows.length === 0) {
      return { success: false, message: 'Lesson not found' };
    }

    const courseId = lessonResult.rows[0].course_id;

    // Mark as complete
    const query = `
      INSERT INTO user_lesson_progress (user_id, lesson_id, course_id, is_completed, completed_at, progress_percent)
      VALUES ($1, $2, $3, true, NOW(), 100)
      ON CONFLICT (user_id, lesson_id) DO UPDATE SET
        is_completed = true,
        completed_at = NOW(),
        progress_percent = 100,
        updated_at = NOW()
      RETURNING *
    `;

    await db.query(query, [userId, lessonId, courseId]);

    // Get updated course progress (trigger will update it automatically)
    const progressQuery = `
      SELECT * FROM user_course_progress
      WHERE user_id = $1 AND course_id = $2
    `;

    const progressResult = await db.query(progressQuery, [userId, courseId]);

    const courseProgress = progressResult.rows[0] ? {
      completed_lessons: progressResult.rows[0].completed_lessons,
      total_lessons: progressResult.rows[0].total_lessons,
      progress_percent: progressResult.rows[0].progress_percent,
      is_completed: progressResult.rows[0].is_completed,
    } : undefined;

    this.fastify.log.info(`✅ Lesson ${lessonId} marked as complete for user ${userId}`);

    return {
      success: true,
      message: 'Lesson marked as complete',
      course_progress: courseProgress,
    };
  }

  /**
   * Get all categories
   */
  async getCategories(): Promise<Category[]> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT * FROM knowledge_categories
      ORDER BY order_index ASC, name ASC
    `;

    const result = await db.query(query);

    const categories: Category[] = result.rows.map(row => ({
      id: row.id,
      name: row.name,
      slug: row.slug,
      description: row.description,
      icon: row.icon,
      order_index: row.order_index,
    }));

    return categories;
  }

  /**
   * Add to favorites
   */
  async addToFavorites(
    userId: string,
    itemType: string,
    itemId: string
  ): Promise<void> {
    const db = await import('../../database_module/connection.js');

    const query = `
      INSERT INTO user_favorites (user_id, item_type, item_id)
      VALUES ($1, $2, $3)
      ON CONFLICT (user_id, item_type, item_id) DO NOTHING
    `;

    await db.query(query, [userId, itemType, itemId]);

    this.fastify.log.info(`✅ Added to favorites: ${itemType} ${itemId} for user ${userId}`);
  }

  /**
   * Remove from favorites
   */
  async removeFromFavorites(
    userId: string,
    itemType: string,
    itemId: string
  ): Promise<boolean> {
    const db = await import('../../database_module/connection.js');

    const query = `
      DELETE FROM user_favorites
      WHERE user_id = $1 AND item_type = $2 AND item_id = $3
    `;

    const result = await db.query(query, [userId, itemType, itemId]);

    return (result.rowCount || 0) > 0;
  }

  /**
   * Get user favorites
   */
  async getUserFavorites(userId: string, itemType?: string): Promise<any[]> {
    const db = await import('../../database_module/connection.js');

    let query = `SELECT * FROM user_favorites WHERE user_id = $1`;
    const params: any[] = [userId];

    if (itemType) {
      params.push(itemType);
      query += ` AND item_type = $${params.length}`;
    }

    query += ` ORDER BY created_at DESC`;

    const result = await db.query(query, params);

    return result.rows;
  }
}

