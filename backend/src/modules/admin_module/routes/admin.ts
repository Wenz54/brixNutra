import { FastifyInstance } from 'fastify';
import { z } from 'zod';

// Admin CRUD for Recipes
export async function adminRoutes(fastify: FastifyInstance) {
  const db = await import('../../database_module/connection.js');

  // ============================================
  // RECIPES CRUD
  // ============================================

  fastify.post('/admin/recipes', {
    schema: {
      description: 'Create recipe (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const data = request.body as any;
      
      const query = `
        INSERT INTO recipes (
          name, description, meal_type, calories, protein, carbs, fats,
          prep_time, cook_time, servings, difficulty, ingredients, instructions,
          tags, image_url, is_published
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
        RETURNING *
      `;
      
      const result = await db.query(query, [
        data.name, data.description, data.meal_type, data.calories,
        data.protein, data.carbs, data.fats, data.prep_time, data.cook_time,
        data.servings, data.difficulty, JSON.stringify(data.ingredients || []),
        JSON.stringify(data.instructions || []), JSON.stringify(data.tags || []),
        data.image_url, data.is_published || false,
      ]);
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.put('/admin/recipes/:id', {
    schema: {
      description: 'Update recipe (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const data = request.body as any;
      
      const query = `
        UPDATE recipes SET
          name = COALESCE($1, name),
          description = COALESCE($2, description),
          meal_type = COALESCE($3, meal_type),
          calories = COALESCE($4, calories),
          protein = COALESCE($5, protein),
          carbs = COALESCE($6, carbs),
          fats = COALESCE($7, fats),
          is_published = COALESCE($8, is_published),
          updated_at = NOW()
        WHERE id = $9
        RETURNING *
      `;
      
      const result = await db.query(query, [
        data.name, data.description, data.meal_type, data.calories,
        data.protein, data.carbs, data.fats, data.is_published, id,
      ]);
      
      if (result.rows.length === 0) {
        return reply.status(404).send({ success: false, error: 'Recipe not found' });
      }
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.delete('/admin/recipes/:id', {
    schema: {
      description: 'Delete recipe (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      
      const result = await db.query(`DELETE FROM recipes WHERE id = $1`, [id]);
      
      if ((result.rowCount || 0) === 0) {
        return reply.status(404).send({ success: false, error: 'Recipe not found' });
      }
      
      return reply.send({ success: true, message: 'Recipe deleted' });
    },
  });

  // ============================================
  // COURSES CRUD
  // ============================================

  fastify.post('/admin/courses', {
    schema: {
      description: 'Create course (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const data = request.body as any;
      
      const query = `
        INSERT INTO courses (
          title, slug, description, image_url, author, is_paid, price,
          duration, difficulty, category_id, is_published
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING *
      `;
      
      const result = await db.query(query, [
        data.title, data.slug, data.description, data.image_url, data.author,
        data.is_paid || false, data.price, data.duration, data.difficulty,
        data.category_id, data.is_published || false,
      ]);
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.put('/admin/courses/:id', {
    schema: {
      description: 'Update course (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const data = request.body as any;
      
      const query = `
        UPDATE courses SET
          title = COALESCE($1, title),
          description = COALESCE($2, description),
          is_published = COALESCE($3, is_published),
          updated_at = NOW()
        WHERE id = $4
        RETURNING *
      `;
      
      const result = await db.query(query, [data.title, data.description, data.is_published, id]);
      
      if (result.rows.length === 0) {
        return reply.status(404).send({ success: false, error: 'Course not found' });
      }
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.delete('/admin/courses/:id', {
    schema: {
      description: 'Delete course (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      
      const result = await db.query(`DELETE FROM courses WHERE id = $1`, [id]);
      
      if ((result.rowCount || 0) === 0) {
        return reply.status(404).send({ success: false, error: 'Course not found' });
      }
      
      return reply.send({ success: true, message: 'Course deleted' });
    },
  });

  // ============================================
  // LESSONS CRUD
  // ============================================

  fastify.post('/admin/lessons', {
    schema: {
      description: 'Create lesson (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const data = request.body as any;
      
      const query = `
        INSERT INTO lessons (
          course_id, title, slug, description, order_index, type,
          content, video_url, duration_minutes, is_published, is_free
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING *
      `;
      
      const result = await db.query(query, [
        data.course_id, data.title, data.slug, data.description, data.order_index,
        data.type, data.content, data.video_url, data.duration_minutes,
        data.is_published || false, data.is_free || false,
      ]);
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.put('/admin/lessons/:id', {
    schema: {
      description: 'Update lesson (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const data = request.body as any;
      
      const query = `
        UPDATE lessons SET
          title = COALESCE($1, title),
          content = COALESCE($2, content),
          is_published = COALESCE($3, is_published),
          updated_at = NOW()
        WHERE id = $4
        RETURNING *
      `;
      
      const result = await db.query(query, [data.title, data.content, data.is_published, id]);
      
      if (result.rows.length === 0) {
        return reply.status(404).send({ success: false, error: 'Lesson not found' });
      }
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.delete('/admin/lessons/:id', {
    schema: {
      description: 'Delete lesson (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      
      const result = await db.query(`DELETE FROM lessons WHERE id = $1`, [id]);
      
      if ((result.rowCount || 0) === 0) {
        return reply.status(404).send({ success: false, error: 'Lesson not found' });
      }
      
      return reply.send({ success: true, message: 'Lesson deleted' });
    },
  });

  // ============================================
  // BLOG CRUD
  // ============================================

  fastify.post('/admin/blog/articles', {
    schema: {
      description: 'Create blog article (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const data = request.body as any;
      
      const query = `
        INSERT INTO blog_articles (
          title, slug, content, preview, image_url, author, is_published
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING *
      `;
      
      const result = await db.query(query, [
        data.title, data.slug, data.content, data.preview, data.image_url,
        data.author, data.is_published || false,
      ]);
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.put('/admin/blog/articles/:id', {
    schema: {
      description: 'Update blog article (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const data = request.body as any;
      
      const query = `
        UPDATE blog_articles SET
          title = COALESCE($1, title),
          content = COALESCE($2, content),
          is_published = COALESCE($3, is_published),
          published_at = CASE WHEN $3 = true AND published_at IS NULL THEN NOW() ELSE published_at END,
          updated_at = NOW()
        WHERE id = $4
        RETURNING *
      `;
      
      const result = await db.query(query, [data.title, data.content, data.is_published, id]);
      
      if (result.rows.length === 0) {
        return reply.status(404).send({ success: false, error: 'Article not found' });
      }
      
      return reply.send({ success: true, data: result.rows[0] });
    },
  });

  fastify.delete('/admin/blog/articles/:id', {
    schema: {
      description: 'Delete blog article (Admin)',
      tags: ['Admin'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      
      const result = await db.query(`DELETE FROM blog_articles WHERE id = $1`, [id]);
      
      if ((result.rowCount || 0) === 0) {
        return reply.status(404).send({ success: false, error: 'Article not found' });
      }
      
      return reply.send({ success: true, message: 'Article deleted' });
    },
  });

  fastify.log.info('✅ Admin routes registered');
}

