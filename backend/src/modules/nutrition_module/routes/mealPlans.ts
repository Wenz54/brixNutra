import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { MealPlanService } from '../services/mealPlanService.js';

// Validation schemas
const dateSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Invalid date format. Use YYYY-MM-DD'),
});

const replaceMealSchema = z.object({
  meal_slot_id: z.string().uuid('Invalid meal slot ID'),
  new_recipe_id: z.string().uuid('Invalid recipe ID'),
});

export async function mealPlansRoutes(fastify: FastifyInstance) {
  const mealPlanService = new MealPlanService(fastify);

  /**
   * Get user's current active meal plan
   * GET /meal-plan/current
   */
  fastify.get('/meal-plan/current', {
    schema: {
      description: 'Get user\'s active meal plan with progress',
      tags: ['Meal Plans'],
      security: [{ bearerAuth: [] }],
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: {
              type: 'object',
              properties: {
                plan: { type: 'object' },
                userPlan: { type: 'object' },
                progress: { type: 'number' },
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
        // Get user ID from JWT token
        // TODO: Implement auth middleware to extract user ID
        // For now, use a mock user ID
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await mealPlanService.getUserActivePlan(userId);

        if (!result) {
          return reply.status(404).send({
            success: false,
            error: 'NO_ACTIVE_PLAN',
            message: 'У пользователя нет активного плана питания',
          });
        }

        return reply.send({
          success: true,
          data: result,
        });
      } catch (error) {
        fastify.log.error('Error getting current meal plan:', error);
        throw error;
      }
    },
  });

  /**
   * Get meal plan for a specific day
   * GET /meal-plan/day/:date
   */
  fastify.get('/meal-plan/day/:date', {
    schema: {
      description: 'Get meal plan for a specific day',
      tags: ['Meal Plans'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['date'],
        properties: {
          date: { 
            type: 'string', 
            pattern: '^\\d{4}-\\d{2}-\\d{2}$',
            description: 'Date in format YYYY-MM-DD',
          },
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
                dayNumber: { type: 'number' },
                meals: { type: 'array', items: { type: 'object' } },
                totalNutrition: {
                  type: 'object',
                  properties: {
                    calories: { type: 'number' },
                    protein: { type: 'number' },
                    carbs: { type: 'number' },
                    fats: { type: 'number' },
                  },
                },
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
        const { date } = dateSchema.parse(request.params);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await mealPlanService.getPlanForDay(userId, date);

        if (!result) {
          return reply.status(404).send({
            success: false,
            error: 'PLAN_NOT_FOUND',
            message: 'План на указанную дату не найден',
          });
        }

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
        fastify.log.error('Error getting meal plan for day:', error);
        throw error;
      }
    },
  });

  /**
   * Replace a meal in the plan
   * POST /meal-plan/replace
   */
  fastify.post('/meal-plan/replace', {
    schema: {
      description: 'Replace a meal in user\'s meal plan',
      tags: ['Meal Plans'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['meal_slot_id', 'new_recipe_id'],
        properties: {
          meal_slot_id: { type: 'string', format: 'uuid' },
          new_recipe_id: { type: 'string', format: 'uuid' },
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
        const { meal_slot_id, new_recipe_id } = replaceMealSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const result = await mealPlanService.replaceMeal(userId, meal_slot_id, new_recipe_id);

        if (!result.success) {
          return reply.status(400).send({
            success: false,
            error: 'REPLACEMENT_FAILED',
            message: result.message,
          });
        }

        return reply.send({
          success: true,
          message: result.message,
          data: result.newRecipe,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        fastify.log.error('Error replacing meal:', error);
        throw error;
      }
    },
  });

  fastify.log.info('✅ Meal Plans routes registered');
}

