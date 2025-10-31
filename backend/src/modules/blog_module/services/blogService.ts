import { FastifyInstance } from 'fastify';

export class BlogService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  async getArticles(page: number = 1, limit: number = 10, categoryId?: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const offset = (page - 1) * limit;
    
    let query = `
      SELECT * FROM blog_articles
      WHERE is_published = true
    `;
    
    const params: any[] = [];
    
    if (categoryId) {
      params.push(categoryId);
      query += ` AND category_id = $${params.length}`;
    }
    
    query += ` ORDER BY published_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);
    
    const result = await db.query(query, params);
    
    // Get total count
    let countQuery = `SELECT COUNT(*) FROM blog_articles WHERE is_published = true`;
    if (categoryId) {
      countQuery += ` AND category_id = $1`;
    }
    const countResult = await db.query(countQuery, categoryId ? [categoryId] : []);
    const total = parseInt(countResult.rows[0].count);
    
    return {
      articles: result.rows,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    };
  }

  async getArticleById(id: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM blog_articles
      WHERE id = $1 AND is_published = true
    `;
    
    const result = await db.query(query, [id]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    // Increment views
    await db.query(`UPDATE blog_articles SET views_count = views_count + 1 WHERE id = $1`, [id]);
    
    return result.rows[0];
  }

  async getArticleBySlug(slug: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM blog_articles
      WHERE slug = $1 AND is_published = true
    `;
    
    const result = await db.query(query, [slug]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    // Increment views
    await db.query(`UPDATE blog_articles SET views_count = views_count + 1 WHERE id = $1`, [result.rows[0].id]);
    
    return result.rows[0];
  }
}

export class NotificationService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  async getUserNotifications(userId: string, limit: number = 50): Promise<any[]> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM notifications
      WHERE user_id = $1
      ORDER BY created_at DESC
      LIMIT $2
    `;
    
    const result = await db.query(query, [userId, limit]);
    
    return result.rows;
  }

  async getUnreadCount(userId: string): Promise<number> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT COUNT(*) FROM notifications
      WHERE user_id = $1 AND is_read = false
    `;
    
    const result = await db.query(query, [userId]);
    
    return parseInt(result.rows[0].count);
  }

  async markAsRead(notificationId: string, userId: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      UPDATE notifications
      SET is_read = true, read_at = NOW()
      WHERE id = $1 AND user_id = $2
    `;
    
    const result = await db.query(query, [notificationId, userId]);
    
    return (result.rowCount || 0) > 0;
  }

  async markAllAsRead(userId: string): Promise<number> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      UPDATE notifications
      SET is_read = true, read_at = NOW()
      WHERE user_id = $1 AND is_read = false
    `;
    
    const result = await db.query(query, [userId]);
    
    return result.rowCount || 0;
  }

  async deleteNotification(notificationId: string, userId: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      DELETE FROM notifications
      WHERE id = $1 AND user_id = $2
    `;
    
    const result = await db.query(query, [notificationId, userId]);
    
    return (result.rowCount || 0) > 0;
  }

  async createNotification(userId: string, data: {
    title: string;
    message: string;
    type: string;
    action?: any;
  }): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO notifications (user_id, title, message, type, action)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *
    `;
    
    const result = await db.query(query, [
      userId,
      data.title,
      data.message,
      data.type,
      JSON.stringify(data.action || null),
    ]);
    
    this.fastify.log.info(`✅ Notification created for user ${userId}: ${data.title}`);
    
    return result.rows[0];
  }
}

