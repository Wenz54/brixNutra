import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { UserProfileService } from '../services/userProfileService.js';

const updateProfileSchema = z.object({
  full_name: z.string().optional(),
  date_of_birth: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  gender: z.enum(['male', 'female', 'other']).optional(),
  avatar_url: z.string().url().optional(),
  height_cm: z.number().int().positive().optional(),
  current_weight_kg: z.number().positive().optional(),
  target_weight_kg: z.number().positive().optional(),
  activity_level: z.enum(['sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active']).optional(),
  allergies: z.array(z.string()).optional(),
  dietary_preferences: z.array(z.string()).optional(),
  medical_conditions: z.array(z.string()).optional(),
});

const setGoalSchema = z.object({
  goal_type: z.enum(['weight_loss', 'weight_gain', 'muscle_gain', 'maintenance', 'health_improvement']),
  daily_calories: z.number().int().positive().optional(),
  daily_protein: z.number().int().positive().optional(),
  daily_carbs: z.number().int().positive().optional(),
  daily_fats: z.number().int().positive().optional(),
  daily_water_ml: z.number().int().positive().optional(),
  target_weight_kg: z.number().positive().optional(),
  target_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  weekly_goal_kg: z.number().optional(),
  weekly_workouts: z.number().int().nonnegative().optional(),
  daily_steps: z.number().int().positive().optional(),
});

const addMeasurementSchema = z.object({
  weight_kg: z.number().positive(),
  body_fat_percent: z.number().nonnegative().optional(),
  muscle_mass_kg: z.number().positive().optional(),
  waist_cm: z.number().positive().optional(),
  chest_cm: z.number().positive().optional(),
  hips_cm: z.number().positive().optional(),
  notes: z.string().optional(),
  photo_url: z.string().url().optional(),
  measured_at: z.string().datetime().optional(),
});

const logActivitySchema = z.object({
  activity_type: z.string().min(1),
  activity_name: z.string().optional(),
  duration_minutes: z.number().int().positive(),
  calories_burned: z.number().int().nonnegative().optional(),
  distance_km: z.number().nonnegative().optional(),
  steps: z.number().int().nonnegative().optional(),
  intensity: z.enum(['low', 'moderate', 'high']).optional(),
  activity_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  activity_time: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  notes: z.string().optional(),
});

export async function profileRoutes(fastify: FastifyInstance) {
  const profileService = new UserProfileService(fastify);

  fastify.get('/profile', {
    schema: {
      description: 'Get user profile',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const profile = await profileService.getProfile(userId);
      
      if (!profile) {
        return reply.status(404).send({ success: false, error: 'Profile not found' });
      }
      
      return reply.send({ success: true, data: profile });
    },
  });

  fastify.put('/profile', {
    schema: {
      description: 'Update user profile',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      try {
        const data = updateProfileSchema.parse(request.body);
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
        
        const profile = await profileService.createOrUpdateProfile(userId, data);
        
        return reply.send({ success: true, data: profile });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({ success: false, error: 'VALIDATION_ERROR', details: error.errors });
        }
        throw error;
      }
    },
  });

  fastify.post('/profile/goals', {
    schema: {
      description: 'Set user goal',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      try {
        const data = setGoalSchema.parse(request.body);
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
        
        const goal = await profileService.setGoal(userId, data);
        
        return reply.send({ success: true, data: goal });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({ success: false, error: 'VALIDATION_ERROR', details: error.errors });
        }
        throw error;
      }
    },
  });

  fastify.post('/profile/measurements', {
    schema: {
      description: 'Add measurement',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      try {
        const data = addMeasurementSchema.parse(request.body);
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
        
        const measurement = await profileService.addMeasurement(userId, data);
        
        return reply.send({ success: true, data: measurement });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({ success: false, error: 'VALIDATION_ERROR', details: error.errors });
        }
        throw error;
      }
    },
  });

  fastify.get('/profile/measurements', {
    schema: {
      description: 'Get measurements history',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const measurements = await profileService.getMeasurements(userId);
      
      return reply.send({ success: true, data: measurements });
    },
  });

  fastify.post('/profile/activities', {
    schema: {
      description: 'Log activity',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      try {
        const data = logActivitySchema.parse(request.body);
        const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
        
        const activity = await profileService.logActivity(userId, data);
        
        return reply.send({ success: true, data: activity });
      } catch (error) {
        if (error instanceof z.ZodError) {
          return reply.status(400).send({ success: false, error: 'VALIDATION_ERROR', details: error.errors });
        }
        throw error;
      }
    },
  });

  fastify.get('/profile/activities', {
    schema: {
      description: 'Get activities history',
      tags: ['Profile'],
      security: [{ bearerAuth: [] }],
    },
    handler: async (request, reply) => {
      const userId = (request as any).user?.id || '123e4567-e89b-12d3-a456-426614174000';
      const activities = await profileService.getActivities(userId);
      
      return reply.send({ success: true, data: activities });
    },
  });

  fastify.log.info('✅ Profile routes registered');
}

