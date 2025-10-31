import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { LabTestService } from '../services/labTestService.js';

// Validation schemas
const uploadTestSchema = z.object({
  test_type: z.string().min(1),
  test_name: z.string().optional(),
  test_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  file_url: z.string().url().optional(),
  results: z.array(z.object({
    parameter_code: z.string().min(1),
    value: z.number(),
    unit: z.string().min(1),
  })).min(1),
  doctor_notes: z.string().optional(),
  user_notes: z.string().optional(),
});

export async function labTestsRoutes(fastify: FastifyInstance) {
  const labTestService = new LabTestService(fastify);

  /**
   * Upload lab test with results
   * POST /lab-tests/upload
   */
  fastify.post('/lab-tests/upload', {
    schema: {
      description: 'Upload lab test results with automatic interpretation',
      tags: ['Lab Tests'],
      security: [{ bearerAuth: [] }],
      body: {
        type: 'object',
        required: ['test_type', 'test_date', 'results'],
        properties: {
          test_type: { type: 'string' },
          test_name: { type: 'string' },
          test_date: { type: 'string', pattern: '^\\d{4}-\\d{2}-\\d{2}$' },
          file_url: { type: 'string', format: 'uri' },
          results: {
            type: 'array',
            items: {
              type: 'object',
              required: ['parameter_code', 'value', 'unit'],
              properties: {
                parameter_code: { type: 'string' },
                value: { type: 'number' },
                unit: { type: 'string' },
              },
            },
          },
          doctor_notes: { type: 'string' },
          user_notes: { type: 'string' },
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
        const data = uploadTestSchema.parse(request.body);

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const test = await labTestService.uploadTest(userId, data);

        return reply.send({
          success: true,
          data: test,
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
        fastify.log.error('Error uploading lab test:', error);
        throw error;
      }
    },
  });

  /**
   * Get all user's lab tests
   * GET /lab-tests/my
   */
  fastify.get('/lab-tests/my', {
    schema: {
      description: 'Get all user\'s lab tests',
      tags: ['Lab Tests'],
      security: [{ bearerAuth: [] }],
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
        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const tests = await labTestService.getUserTests(userId);

        return reply.send({
          success: true,
          data: tests,
        });
      } catch (error) {
        fastify.log.error('Error getting lab tests:', error);
        throw error;
      }
    },
  });

  /**
   * Get lab test by ID with results and interpretation
   * GET /lab-tests/:id
   */
  fastify.get('/lab-tests/:id', {
    schema: {
      description: 'Get lab test details with interpreted results',
      tags: ['Lab Tests'],
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
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const test = await labTestService.getTestById(id, userId);

        if (!test) {
          return reply.status(404).send({
            success: false,
            error: 'TEST_NOT_FOUND',
            message: 'Lab test not found',
          });
        }

        return reply.send({
          success: true,
          data: test,
        });
      } catch (error) {
        fastify.log.error('Error getting lab test:', error);
        throw error;
      }
    },
  });

  /**
   * Get available lab parameters
   * GET /lab-tests/parameters?category=blood_general
   */
  fastify.get('/lab-tests/parameters', {
    schema: {
      description: 'Get available lab parameters',
      tags: ['Lab Tests'],
      querystring: {
        type: 'object',
        properties: {
          category: { type: 'string', enum: ['blood_general', 'biochemistry', 'hormones', 'vitamins'] },
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
        const query = request.query as { category?: string };

        const parameters = await labTestService.getParameters(query.category);

        return reply.send({
          success: true,
          data: parameters,
        });
      } catch (error) {
        fastify.log.error('Error getting lab parameters:', error);
        throw error;
      }
    },
  });

  /**
   * Get parameter trend
   * GET /lab-tests/trend/:parameterCode
   */
  fastify.get('/lab-tests/trend/:parameterCode', {
    schema: {
      description: 'Get parameter trend over time',
      tags: ['Lab Tests'],
      security: [{ bearerAuth: [] }],
      params: {
        type: 'object',
        required: ['parameterCode'],
        properties: {
          parameterCode: { type: 'string' },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            data: { type: 'object', nullable: true },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { parameterCode } = request.params as { parameterCode: string };

        // Get user ID from JWT token
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';

        const trend = await labTestService.getParameterTrend(userId, parameterCode);

        return reply.send({
          success: true,
          data: trend,
        });
      } catch (error) {
        fastify.log.error('Error getting parameter trend:', error);
        throw error;
      }
    },
  });

  /**
   * Delete lab test
   * DELETE /lab-tests/:id
   */
  fastify.delete('/lab-tests/:id', {
    schema: {
      description: 'Delete lab test',
      tags: ['Lab Tests'],
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

        const deleted = await labTestService.deleteTest(id, userId);

        if (!deleted) {
          return reply.status(404).send({
            success: false,
            error: 'TEST_NOT_FOUND',
            message: 'Lab test not found',
          });
        }

        return reply.send({
          success: true,
          message: 'Lab test deleted successfully',
        });
      } catch (error) {
        fastify.log.error('Error deleting lab test:', error);
        throw error;
      }
    },
  });

  fastify.log.info('✅ Lab Tests routes registered');
}

