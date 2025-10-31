import { FastifyInstance } from 'fastify';
import { BlogService, NotificationService } from '../services/blogService.js';

export async function blogRoutes(fastify: FastifyInstance) {
  const blogService = new BlogService(fastify);
  const notificationService = new NotificationService(fastify);

  // Blog endpoints
  fastify.get('/blog/articles', {
    schema: {
      description: 'Get blog articles',
      tags: ['Blog'],
      querystring: {
        type: 'object',
        properties: {
          page: { type: 'integer', minimum: 1, default: 1 },
          limit: { type: 'integer', minimum: 1, maximum: 50, default: 10 },
          category_id: { type: 'string', format: 'uuid' },
        },
      },
    },
    handler: async (request, reply) => {
      const query = request.query as any;
      const result = await blogService.getArticles(
        query.page || 1,
        query.limit || 10,
        query.category_id
      );
      return reply.send({ success: true, data: result });
    },
  });

  fastify.get('/blog/articles/:id', {
    schema: {
      description: 'Get article by ID',
      tags: ['Blog'],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const article = await blogService.getArticleById(id);
      
      if (!article) {
        return reply.status(404).send({ success: false, error: 'Article not found' });
      }
      
      return reply.send({ success: true, data: article });
    },
  });

  fastify.get('/blog/articles/slug/:slug', {
    schema: {
      description: 'Get article by slug',
      tags: ['Blog'],
    },
    handler: async (request, reply) => {
      const { slug } = request.params as { slug: string };
      const article = await blogService.getArticleBySlug(slug);
      
      if (!article) {
        return reply.status(404).send({ success: false, error: 'Article not found' });
      }
      
      return reply.send({ success: true, data: article });
    },
  });

  // Notification endpoints
  fastify.get('/notifications', {
    schema: {
      description: 'Get user notifications',
      tags: ['Notifications'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const notifications = await notificationService.getUserNotifications(userId);
      return reply.send({ success: true, data: notifications });
    },
  });

  fastify.get('/notifications/unread-count', {
    schema: {
      description: 'Get unread count',
      tags: ['Notifications'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const count = await notificationService.getUnreadCount(userId);
      return reply.send({ success: true, data: { count } });
    },
  });

  fastify.patch('/notifications/:id/read', {
    schema: {
      description: 'Mark notification as read',
      tags: ['Notifications'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      
      const updated = await notificationService.markAsRead(id, userId);
      
      if (!updated) {
        return reply.status(404).send({ success: false, error: 'Notification not found' });
      }
      
      return reply.send({ success: true, message: 'Marked as read' });
    },
  });

  fastify.post('/notifications/read-all', {
    schema: {
      description: 'Mark all as read',
      tags: ['Notifications'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const count = await notificationService.markAllAsRead(userId);
      return reply.send({ success: true, data: { count } });
    },
  });

  fastify.delete('/notifications/:id', {
    schema: {
      description: 'Delete notification',
      tags: ['Notifications'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      
      const deleted = await notificationService.deleteNotification(id, userId);
      
      if (!deleted) {
        return reply.status(404).send({ success: false, error: 'Notification not found' });
      }
      
      return reply.send({ success: true, message: 'Deleted' });
    },
  });

  fastify.log.info('✅ Blog and Notifications routes registered');
}

