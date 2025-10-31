import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { DiaryService } from '../services/diaryService.js';

// Validation schemas
const logMealSchema = z.object({
  meal_type: z.enum(['wakeup', 'breakfast', 'snack', 'lunch', 'afternoon_snack', 'dinner', 'sleep']),
  food_name: z.string().min(1, 'Food name is required'),
  recipe_id: z.string().uuid().optional(),
  meal_plan_slot_id: z.string().uuid().optional(),
  portion_grams: z.number().int().positive().optional(),
  calories: z.number().nonnegative().optional(),
  protein: z.number().nonnegative().optional(),
  carbs: z.number().nonnegative().optional(),
  fats: z.number().nonnegative().optional(),
  meal_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Use YYYY-MM-DD'),
  meal_time: z.string().regex(/^\d{2}:\d{2}$/, 'Invalid time format. Use HH:MM').optional(),
  notes: z.string().optional(),
  image_url: z.string().url().optional(),
});

const dateParamSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Use YYYY-MM-DD'),
});

const historyQuerySchema = z.object({
  start_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  end_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
});

const updateGoalsSchema = z.object({
  calories: z.number().positive().optional(),
  protein: z.number().positive().optional(),
  carbs: z.number().positive().optional(),
  fats: z.number().positive().optional(),
});

const logWaterSchema = z.object({
  amount_ml: z.number().int().positive(),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
});

export async function diaryRoutes(fastify: FastifyInstance) {
  const diaryService = new DiaryService(fastify);

  /**
   * Log a meal/food entry
   * POST /diary/log
   */
  fastify.post('/diary/log', {
    schema: {
      description: 'Log a meal or food entry',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['meal_type', 'food_name', 'meal_date'],
        properties: {
          meal_type: { type: 'string', enum: ['wakeup', 'breakfast', 'snack', 'lunch', 'afternoon_snack', 'dinner', 'sleep'] },
          food_name: { type: 'string' },
          recipe_id: { type: 'string', format: 'uuid' },
          meal_plan_slot_id: { type: 'string', format: 'uuid' },
          portion_grams: { type: 'number' },
          calories: { type: 'number' },
          protein: { type: 'number' },
          carbs: { type: 'number' },
          fats: { type: 'number' },
          meal_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
          meal_time: { type: 'string', pattern: '^\\d{2}:\\d{2}$' },
          notes: { type: 'string' },
          image_url: { type: 'string', format: 'uri' },
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
      },
    },
    handler: async (request, reply) => {
      try {
        const input = logMealSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const entry = await diaryService.logMeal(userId, input);

        return reply.send({
          success: true,
          data: entry,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
            details: error.errors,
          });
        }
        fastify.log.error('Error logging meal:', error);
        throw error;
      }
    },
  });

  /**
   * Get daily stats and entries
   * GET /diary/day/:date
   */
  fastify.get('/diary/day/:date', {
    schema: {
      description: 'Get daily stats and all entries for a specific date',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['date'],
        properties: {
          date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
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
                stats: { type: 'object', nullable: true },
                entries: { type: 'array', items: { type: 'object' } },
              },
            },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { date } = dateParamSchema.parse(request.params);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await diaryService.getDayStats(userId, date);

        return reply.send({
          success: true,
          data: result,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error getting day stats:', error);
        throw error;
      }
    },
  });

  /**
   * Get history (date range)
   * GET /diary/history?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
   */
  fastify.get('/diary/history', {
    schema: {
      description: 'Get daily stats history for a date range',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      querystring: {
        type: 'object',
        required: ['start_date', 'end_date'],
        properties: {
          start_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
          end_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
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
        const { start_date, end_date } = historyQuerySchema.parse(request.query);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const history = await diaryService.getHistory(userId, start_date, end_date);

        return reply.send({
          success: true,
          data: history,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error getting history:', error);
        throw error;
      }
    },
  });

  /**
   * Delete diary entry
   * DELETE /diary/entry/:id
   */
  fastify.delete('/diary/entry/:id', {
    schema: {
      description: 'Delete a diary entry',
      tags: ['Diary'],
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
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const deleted = await diaryService.deleteEntry(userId, id);

        if (!deleted) {
          return reply.status(404).send({
            success: false,
            error: 'NOT_FOUND',
            message: 'Diary entry not found',
          });
        }

        return reply.send({
          success: true,
          message: 'Entry deleted successfully',
        });
      } catch (error) {
        fastify.log.error('Error deleting entry:', error);
        throw error;
      }
    },
  });

  /**
   * Update daily goals
   * PUT /diary/goals/:date
   */
  fastify.put('/diary/goals/:date', {
    schema: {
      description: 'Update daily nutrition goals for a specific date',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['date'],
        properties: {
          date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
        },
      },
      body: {
        type: 'object',
        properties: {
          calories: { type: 'number' },
          protein: { type: 'number' },
          carbs: { type: 'number' },
          fats: { type: 'number' },
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
        const { date } = dateParamSchema.parse(request.params);
        const goals = updateGoalsSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        await diaryService.updateDailyGoals(userId, date, goals);

        return reply.send({
          success: true,
          message: 'Daily goals updated',
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error updating goals:', error);
        throw error;
      }
    },
  });

  /**
   * Log water intake
   * POST /diary/water
   */
  fastify.post('/diary/water', {
    schema: {
      description: 'Log water intake',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['amount_ml', 'date'],
        properties: {
          amount_ml: { type: 'number' },
          date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
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
        const { amount_ml, date } = logWaterSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        await diaryService.logWater(userId, amount_ml, date);

        return reply.send({
          success: true,
          message: `Logged ${amount_ml}ml water`,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error logging water:', error);
        throw error;
      }
    },
  });

  /**
   * Get water intake for a day
   * GET /diary/water/:date
   */
  fastify.get('/diary/water/:date', {
    schema: {
      description: 'Get total water intake for a specific date',
      tags: ['Diary'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['date'],
        properties: {
          date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
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
                date: { type: 'string' },
                total_ml: { type: 'number' },
              },
            },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { date } = dateParamSchema.parse(request.params);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const totalMl = await diaryService.getWaterIntake(userId, date);

        return reply.send({
          success: true,
          data: {
            date,
            total_ml: totalMl,
          },
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error getting water intake:', error);
        throw error;
      }
    },
  });

  fastify.log.info('✅ Diary routes registered');
}

