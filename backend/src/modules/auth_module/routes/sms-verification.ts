import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { SmsService } from '../services/smsService';

// Validation schemas
const sendCodeEmailSchema = z.object({
  email: z.string().email('Invalid email format'),
});

const sendCodePhoneSchema = z.object({
  phone: z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone format'),
});

const verifyCodeEmailSchema = z.object({
  email: z.string().email('Invalid email format'),
  code: z.string().length(4, 'Code must be 4 digits'),
});

const verifyCodePhoneSchema = z.object({
  phone: z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid phone format'),
  code: z.string().length(4, 'Code must be 4 digits'),
});

const setPasswordSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[a-z]/, 'Password must contain lowercase letter')
    .regex(/[A-Z]/, 'Password must contain uppercase letter')
    .regex(/[0-9]/, 'Password must contain number'),
});

export async function smsVerificationRoutes(fastify: FastifyInstance) {
  const smsService = new SmsService(fastify);

  /**
   * Send verification code to email
   * POST /auth/email/send-code
   */
  fastify.post('/email/send-code', {
    schema: {
      description: 'Send 4-digit verification code to email',
      tags: ['Authentication'],
      body: {
        type: 'object',
        required: ['email'],
        properties: {
          email: { type: 'string', format: 'email' },
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
        const { email } = sendCodeEmailSchema.parse(request.body);

        const result = await smsService.sendCodeToEmail(email);

        return reply.send({
          success: result.success,
          message: result.message,
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
   * Verify email code
   * POST /auth/email/verify-code
   */
  fastify.post('/email/verify-code', {
    schema: {
      description: 'Verify email verification code',
      tags: ['Authentication'],
      body: {
        type: 'object',
        required: ['email', 'code'],
        properties: {
          email: { type: 'string', format: 'email' },
          code: { type: 'string', minLength: 4, maxLength: 4 },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            isNewUser: { type: 'boolean' },
            token: { type: 'string' },
            user: { type: 'object' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { email, code } = verifyCodeEmailSchema.parse(request.body);

        const result = await smsService.verifyEmailCode(email, code);

        return reply.send(result);
      } catch (error) {
        if (error instanceof Error) {
          if (error.message === 'Invalid or expired verification code') {
            return reply.status(400).send({
              success: false,
              error: 'INVALID_CODE',
              message: 'Неверный или истекший код подтверждения',
            });
          }
        }
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
   * Send verification code to phone (SMS)
   * POST /auth/phone/send-code
   */
  fastify.post('/phone/send-code', {
    schema: {
      description: 'Send 4-digit verification code via SMS',
      tags: ['Authentication'],
      body: {
        type: 'object',
        required: ['phone'],
        properties: {
          phone: { type: 'string', pattern: '^\\+?[1-9]\\d{1,14}$' },
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
        const { phone } = sendCodePhoneSchema.parse(request.body);

        const result = await smsService.sendCodeToPhone(phone);

        return reply.send({
          success: result.success,
          message: result.message,
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
   * Verify phone code (SMS)
   * POST /auth/phone/verify-code
   */
  fastify.post('/phone/verify-code', {
    schema: {
      description: 'Verify phone verification code (SMS)',
      tags: ['Authentication'],
      body: {
        type: 'object',
        required: ['phone', 'code'],
        properties: {
          phone: { type: 'string', pattern: '^\\+?[1-9]\\d{1,14}$' },
          code: { type: 'string', minLength: 4, maxLength: 4 },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            isNewUser: { type: 'boolean' },
            token: { type: 'string' },
            user: { type: 'object' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { phone, code } = verifyCodePhoneSchema.parse(request.body);

        const result = await smsService.verifyPhoneCode(phone, code);

        return reply.send(result);
      } catch (error) {
        if (error instanceof Error) {
          if (error.message === 'Invalid or expired verification code') {
            return reply.status(400).send({
              success: false,
              error: 'INVALID_CODE',
              message: 'Неверный или истекший код подтверждения',
            });
          }
        }
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
   * Set password for new email user
   * POST /auth/email/set-password
   */
  fastify.post('/email/set-password', {
    schema: {
      description: 'Set password for new user (after email verification)',
      tags: ['Authentication'],
      body: {
        type: 'object',
        required: ['email', 'password'],
        properties: {
          email: { type: 'string', format: 'email' },
          password: { type: 'string', minLength: 8 },
        },
      },
      response: {
        200: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            token: { type: 'string' },
            user: { type: 'object' },
          },
        },
      },
    },
    handler: async (request, reply) => {
      try {
        const { email, password } = setPasswordSchema.parse(request.body);

        const result = await smsService.setPasswordForEmailUser(email, password);

        return reply.send(result);
      } catch (error) {
        if (error instanceof Error) {
          if (error.message === 'User not found') {
            return reply.status(404).send({
              success: false,
              error: 'USER_NOT_FOUND',
              message: 'Пользователь не найден',
            });
          }
          if (error.message === 'User already has password set') {
            return reply.status(400).send({
              success: false,
              error: 'PASSWORD_ALREADY_SET',
              message: 'Пароль уже установлен',
            });
          }
        }
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
}




