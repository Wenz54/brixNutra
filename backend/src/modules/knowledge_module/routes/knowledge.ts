import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { KnowledgeService } from '../services/knowledgeService.js';

// Validation schemas
const coursesQuerySchema = z.object({
  filter: z.enum(['free', 'paid', 'all']).optional(),
  category_id: z.string().uuid().optional(),
});

const favoritesSchema = z.object({
  item_type: z.enum(['course', 'lesson', 'recipe', 'article']),
  item_id: z.string().uuid(),
});

export async function knowledgeRoutes(fastify: FastifyInstance) {
  const knowledgeService = new KnowledgeService(fastify);

  /**
   * Get all courses
   * GET /knowledge/courses?filter=free|paid|all&category_id=uuid
   */
  fastify.get('/knowledge/courses', {
    schema: {
      description: 'Get all courses with optional filtering',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      querystring: {
        type: 'object',
        properties: {
          filter: { type: 'string', enum: ['free', 'paid', 'all'] },
          category_id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'array', items: { type: 'object' } },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const query = coursesQuerySchema.parse(request.query);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || undefined;

        const courses = await knowledgeService.getCourses(
          userId,
          query.filter,
          query.category_id
        );

        return reply.send({
          success: true,
          data: courses,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error getting courses:', error);
        throw error;
      }
    },
  });

  /**
   * Get course by ID with lessons
   * GET /knowledge/courses/:id
   */
  fastify.get('/knowledge/courses/:id', {
    schema: {
      description: 'Get course details with lessons',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['id'],
        properties: {
          id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: {
              type: 'object',
              properties: {
                course: { type: 'object' },
                lessons: { type: 'array', items: { type: 'object' } },
              },
            },
          },
        },
        404: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            error: { type: 'string' },
            message: { type: 'string' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { id } = request.params as { id: string };

        // Get user ID from JWT token
        const userId = (request as any).user?.id || undefined;

        const result = await knowledgeService.getCourseById(id, userId);

        if (!result) {
          return reply.status(404).send({
            success: false,
            error: 'COURSE_NOT_FOUND',
            message: 'Course not found',
          });
        }

        return reply.send({
          success: true,
          data: result,
        });
      } catch (error) {
        fastify.log.error('Error getting course:', error);
        throw error;
      }
    },
  });

  /**
   * Get lesson by ID
   * GET /knowledge/lessons/:id
   */
  fastify.get('/knowledge/lessons/:id', {
    schema: {
      description: 'Get lesson details',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['id'],
        properties: {
          id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'object' },
          },
        },
        404: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            error: { type: 'string' },
            message: { type: 'string' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { id } = request.params as { id: string };

        // Get user ID from JWT token
        const userId = (request as any).user?.id || undefined;

        const lesson = await knowledgeService.getLessonById(id, userId);

        if (!lesson) {
          return reply.status(404).send({
            success: false,
            error: 'LESSON_NOT_FOUND',
            message: 'Lesson not found',
          });
        }

        return reply.send({
          success: true,
          data: lesson,
        });
      } catch (error) {
        fastify.log.error('Error getting lesson:', error);
        throw error;
      }
    },
  });

  /**
   * Mark lesson as complete
   * POST /knowledge/lessons/:id/complete
   */
  fastify.post('/knowledge/lessons/:id/complete', {
    schema: {
      description: 'Mark lesson as completed',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['id'],
        properties: {
          id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            message: { type: 'string' },
            data: { type: 'object' },
          },
        },
        400: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            error: { type: 'string' },
            message: { type: 'string' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { id } = request.params as { id: string };

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await knowledgeService.markLessonComplete(userId, id);

        if (!result.success) {
          return reply.status(400).send({
            success: false,
            error: 'COMPLETION_FAILED',
            message: result.message,
          });
        }

        return reply.send({
          success: true,
          message: result.message,
          data: result.course_progress,
        });
      } catch (error) {
        fastify.log.error('Error marking lesson complete:', error);
        throw error;
      }
    },
  });

  /**
   * Get all categories
   * GET /knowledge/categories
   */
  fastify.get('/knowledge/categories', {
    schema: {
      description: 'Get all knowledge categories',
      tags: ['Knowledge'],
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'array', items: { type: 'object' } },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const categories = await knowledgeService.getCategories();

        return reply.send({
          success: true,
          data: categories,
        });
      } catch (error) {
        fastify.log.error('Error getting categories:', error);
        throw error;
      }
    },
  });

  /**
   * Add to favorites
   * POST /knowledge/favorites
   */
  fastify.post('/knowledge/favorites', {
    schema: {
      description: 'Add item to favorites',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['item_type', 'item_id'],
        properties: {
          item_type: { type: 'string', enum: ['course', 'lesson', 'recipe', 'article'] },
          item_id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            message: { type: 'string' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { item_type, item_id } = favoritesSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        await knowledgeService.addToFavorites(userId, item_type, item_id);

        return reply.send({
          success: true,
          message: 'Added to favorites',
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error adding to favorites:', error);
        throw error;
      }
    },
  });

  /**
   * Remove from favorites
   * DELETE /knowledge/favorites
   */
  fastify.delete('/knowledge/favorites', {
    schema: {
      description: 'Remove item from favorites',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['item_type', 'item_id'],
        properties: {
          item_type: { type: 'string', enum: ['course', 'lesson', 'recipe', 'article'] },
          item_id: { type: 'string', format: 'uuid' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            message: { type: 'string' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { item_type, item_id } = favoritesSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const removed = await knowledgeService.removeFromFavorites(userId, item_type, item_id);

        return reply.send({
          success: true,
          message: removed ? 'Removed from favorites' : 'Not in favorites',
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error removing from favorites:', error);
        throw error;
      }
    },
  });

  /**
   * Get user favorites
   * GET /knowledge/favorites?item_type=course
   */
  fastify.get('/knowledge/favorites', {
    schema: {
      description: 'Get user favorites',
      tags: ['Knowledge'],
      security: [{ bearerAuth: [] }],
      querystring: {
        type: 'object',
        properties: {
          item_type: { type: 'string', enum: ['course', 'lesson', 'recipe', 'article'] },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'array', items: { type: 'object' } },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const query = request.query as { item_type?: string };

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const favorites = await knowledgeService.getUserFavorites(userId, query.item_type);

        return reply.send({
          success: true,
          data: favorites,
        });
      } catch (error) {
        fastify.log.error('Error getting favorites:', error);
        throw error;
      }
    },
  });

  fastify.log.info('✅ Knowledge routes registered');
}

