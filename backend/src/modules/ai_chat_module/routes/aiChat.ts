import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { AIChatService } from '../services/aiChatService.js';

const chatSchema = z.object({
  message: z.string().min(1),
  session_id: z.string().uuid().optional(),
  conversation_history: z.array(z.object({
    role: z.enum(['user', 'assistant', 'system']),
    content: z.string(),
  })).optional(),
});

export async function aiChatRoutes(fastify: FastifyInstance) {
  const chatService = new AIChatService(fastify);

  fastify.post('/ai-chat', {
    schema: {
      description: 'Chat with AI nutrition assistant',
      tags: ['AI Chat'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['message'],
        properties: {
          message: { type: 'string' },
          session_id: { type: 'string', format: 'uuid' },
          conversation_history: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                role: { type: 'string', enum: ['user', 'assistant', 'system'] },
                content: { type: 'string' },
              },
            },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const data = chatSchema.parse(request.body);
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await chatService.chat(userId, data.message, data.conversation_history);

        return reply.send({
          success: true,
          data: {
            response: result.response,
            usage: result.usage,
          },
        });
      } catch (error: any) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({ success: false, error: 'VALIDATION_ERROR', details: error.errors });
        }
        if (error.message === 'OpenAI API key is invalid') {
          return reply.status(500).send({ success: false, error: 'AI_SERVICE_ERROR', message: 'AI service configuration error' });
        }
        throw error;
      }
    },
  });

  fastify.get('/ai-chat/sessions', {
    schema: {
      description: 'Get chat sessions',
      tags: ['AI Chat'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const sessions = await chatService.getChatSessions(userId);
      return reply.send({ success: true, data: sessions });
    },
  });

  fastify.get('/ai-chat/sessions/:id', {
    schema: {
      description: 'Get chat session details',
      tags: ['AI Chat'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      
      const session = await chatService.getChatSession(id, userId);
      
      if (!session) {
        return reply.status(404).send({ success: false, error: 'Session not found' });
      }
      
      return reply.send({ success: true, data: session });
    },
  });

  fastify.delete('/ai-chat/sessions/:id', {
    schema: {
      description: 'Delete chat session',
      tags: ['AI Chat'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const { id } = request.params as { id: string };
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      
      const deleted = await chatService.deleteChatSession(id, userId);
      
      if (!deleted) {
        return reply.status(404).send({ success: false, error: 'Session not found' });
      }
      
      return reply.send({ success: true, message: 'Session deleted' });
    },
  });

  fastify.post('/ai-chat/analyze-diary', {
    schema: {
      description: 'AI analysis of user diary',
      tags: ['AI Chat'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['date'],
        properties: {
          date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
        },
      },
    },
    handler: async (request, reply) => {
      const { date } = request.body as { date: string };
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      
      const analysis = await chatService.analyzeUserDiary(userId, date);
      
      return reply.send({ success: true, data: { analysis } });
    },
  });

  fastify.log.info('✅ AI Chat routes registered');
}

