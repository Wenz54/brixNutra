import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { AuthService } from '../services/authService';
import { registerSchema, loginSchema } from '../../core_module/utils/validation';
import type { RegisterRequest, LoginRequest } from '../../core_module/utils/validation';

export async function authRoutes(fastify: FastifyInstance) {
  const authService = new AuthService(fastify);

  // Register
  fastify.post<{ Body: RegisterRequest }>(
    '/register',
    async (request, reply) => {
      try {
        const validated = registerSchema.parse(request.body);
        const result = await authService.register(validated);
        
        return reply.status(201).send({
          success: true,
          data: result,
        });
      } catch (error) {
        if (error instanceof Error) {
          if (error.message === 'User with this email already exists') {
            return reply.status(409).send({
              success: false,
              error: 'EMAIL_EXISTS',
              message: 'Пользователь с таким email уже существует',
            });
          }
        }
        throw error;
      }
    }
  );

  // Login
  fastify.post<{ Body: LoginRequest }>(
    '/login',
    async (request, reply) => {
      try {
        const validated = loginSchema.parse(request.body);
        const result = await authService.login(validated);
        
        return reply.send({
          success: true,
          data: result,
        });
      } catch (error) {
        if (error instanceof Error) {
          if (error.message === 'Invalid email or password') {
            return reply.status(401).send({
              success: false,
              error: 'INVALID_CREDENTIALS',
              message: 'Неверный email или пароль',
            });
          }
        }
        throw error;
      }
    }
  );
}

