import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { RecipeService } from '../services/recipeService.js';

// Validation schemas
const recipeFiltersSchema = z.object({
  meal_type: z.enum(['wakeup', 'breakfast', 'snack', 'lunch', 'afternoon_snack', 'dinner', 'sleep']).optional(),
  is_vegetarian: z.string().transform(val => val === 'true').optional(),
  is_vegan: z.string().transform(val => val === 'true').optional(),
  is_gluten_free: z.string().transform(val => val === 'true').optional(),
  is_dairy_free: z.string().transform(val => val === 'true').optional(),
  min_calories: z.string().transform(val => parseInt(val)).optional(),
  max_calories: z.string().transform(val => parseInt(val)).optional(),
  tags: z.string().transform(val => val.split(',')).optional(),
  search: z.string().optional(),
  limit: z.string().transform(val => parseInt(val)).default('20'),
  offset: z.string().transform(val => parseInt(val)).default('0'),
});

const recipeIdSchema = z.object({
  id: z.string().uuid('Invalid recipe ID'),
});

export async function recipesRoutes(fastify: FastifyInstance) {
  const recipeService = new RecipeService(fastify);

  /**
   * Get recipes list with filters
   * GET /recipes
   */
  fastify.get('/recipes', {
    schema: {
      description: 'Get list of recipes with optional filters',
      tags: ['Recipes'],
      querystring: {
        type: 'object',
        properties: {
          meal_type: { type: 'string', enum: ['wakeup', 'breakfast', 'snack', 'lunch', 'afternoon_snack', 'dinner', 'sleep'] },
          is_vegetarian: { type: 'string', enum: ['true', 'false'] },
          is_vegan: { type: 'string', enum: ['true', 'false'] },
          is_gluten_free: { type: 'string', enum: ['true', 'false'] },
          is_dairy_free: { type: 'string', enum: ['true', 'false'] },
          min_calories: { type: 'string' },
          max_calories: { type: 'string' },
          tags: { type: 'string', description: 'Comma-separated tags' },
          search: { type: 'string' },
          limit: { type: 'string', default: '20' },
          offset: { type: 'string', default: '0' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: {
              type: 'array',
              items: { type: 'object' },
            },
            pagination: {
              type: 'object',
              properties: {
                total: { type: 'number' },
                limit: { type: 'number' },
                offset: { type: 'number' },
              },
            },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const filters = recipeFiltersSchema.parse(request.query);

        const { recipes, total } = await recipeService.getRecipes(filters);

        return reply.send({
          success: true,
          data: recipes,
          pagination: {
            total,
            limit: filters.limit,
            offset: filters.offset,
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
        throw error;
      }
    },
  });

  /**
   * Get recipe by ID
   * GET /recipes/:id
   */
  fastify.get('/recipes/:id', {
    schema: {
      description: 'Get recipe details by ID',
      tags: ['Recipes'],
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
        const { id } = recipeIdSchema.parse(request.params);

        const recipe = await recipeService.getRecipeById(id);

        if (!recipe) {
          return reply.status(404).send({
            success: false,
            error: 'RECIPE_NOT_FOUND',
            message: 'Рецепт не найден',
          });
        }

        return reply.send({
          success: true,
          data: recipe,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        throw error;
      }
    },
  });

  /**
   * Get alternative recipes
   * GET /recipes/:id/alternatives
   */
  fastify.get('/recipes/:id/alternatives', {
    schema: {
      description: 'Get alternative recipes (similar by meal type, calories, tags)',
      tags: ['Recipes'],
      params: {
        type: 'object',
        required: ['id'],
        properties: {
          id: { type: 'string', format: 'uuid' },
        },
      },
      querystring: {
        type: 'object',
        properties: {
          limit: { type: 'string', default: '5' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: {
              type: 'array',
              items: { type: 'object' },
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
        const { id } = recipeIdSchema.parse(request.params);
        const limit = parseInt((request.query as any).limit || '5');

        // Check if recipe exists
        const recipe = await recipeService.getRecipeById(id);
        if (!recipe) {
          return reply.status(404).send({
            success: false,
            error: 'RECIPE_NOT_FOUND',
            message: 'Рецепт не найден',
          });
        }

        const alternatives = await recipeService.getAlternatives(id, limit);

        return reply.send({
          success: true,
          data: alternatives,
        });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({
            success: false,
            error: 'VALIDATION_ERROR',
            message: error.errors[0].message,
          });
        }
        throw error;
      }
    },
  });

  fastify.log.info('✅ Recipes routes registered');
}

