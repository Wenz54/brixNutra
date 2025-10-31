import Fastify from 'fastify';
import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import helmet from '@fastify/helmet';
import rateLimit from '@fastify/rate-limit';
import swagger from '@fastify/swagger';
import swaggerUI from '@fastify/swagger-ui';
import multipart from '@fastify/multipart';

import { config } from './config/env.js';

// Import module routes
// Note: backend_modules will be imported after they're adapted
// import { authRoutes } from './modules/auth_module/routes/auth.js';
// import { usersRoutes } from './modules/users_module/routes/index.js';
// import { nutritionRoutes } from './modules/nutrition_module/routes/index.js';
// ... other modules

/**
 * Build Fastify application
 */
async function buildApp() {
  const fastify = Fastify({
    logger: {
      level: process.env.LOG_LEVEL || 'info',
      transport:
        config.server.env === 'development'
          ? {
              target: 'pino-pretty',
              options: {
                translateTime: 'HH:MM:ss Z',
                ignore: 'pid,hostname',
              },
            }
          : undefined,
    },
  });

  // ========================================
  // Plugins
  // ========================================

  // CORS
  await fastify.register(cors, {
    origin: config.cors.origin,
    credentials: true,
  });

  // Security Headers
  await fastify.register(helmet, {
    contentSecurityPolicy: config.server.env === 'production',
  });

  // JWT Authentication
  await fastify.register(jwt, {
    secret: config.jwt.secret,
  });

  // Rate Limiting
  await fastify.register(rateLimit, {
    max: config.rateLimit.max,
    timeWindow: config.rateLimit.windowMs,
  });

  // Multipart (File Upload)
  await fastify.register(multipart, {
    limits: {
      fileSize: 10 * 1024 * 1024, // 10MB
      files: 5,
    },
  });

  // Swagger Documentation
  await fastify.register(swagger, {
    openapi: {
      info: {
        title: 'Brix Nutritional App API',
        description: 'API documentation for Brix Nutritional App',
        version: '1.0.0',
      },
      servers: [
        {
          url: `http://${config.server.host}:${config.server.port}`,
          description: 'Development server',
        },
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT',
          },
        },
      },
    },
  });

  await fastify.register(swaggerUI, {
    routePrefix: '/documentation',
    uiConfig: {
      docExpansion: 'list',
      deepLinking: false,
    },
  });

  // ========================================
  // JWT Auth Middleware (Global)
  // ========================================
  // Uncomment to enforce JWT authentication on all routes
  // const { jwtAuthMiddleware } = await import('./modules/core_module/middleware/jwtAuth.js');
  // fastify.addHook('onRequest', jwtAuthMiddleware);

  // ========================================
  // Routes
  // ========================================

  // Health Check
  fastify.get('/health', async () => {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: config.server.env,
    };
  });

  // API Routes
  fastify.get('/api', async () => {
    return {
      message: 'Brix Nutritional App API',
      version: '1.0.0',
      documentation: '/documentation',
    };
  });

  // Register module routes
  // Note: Uncomment as modules are ready
  
  // Auth Module (SMS Verification) ✅
  const { authRoutes, smsVerificationRoutes } = await import('./modules/auth_module/index.ts');
  await fastify.register(authRoutes, { prefix: '/api/auth' });
  await fastify.register(smsVerificationRoutes, { prefix: '/api/auth' });
  
  // Nutrition Module (Recipes + Meal Plans + Diary) ✅
  const { recipesRoutes, mealPlansRoutes, diaryRoutes } = await import('./modules/nutrition_module/index.ts');
  await fastify.register(recipesRoutes, { prefix: '/api' });
  await fastify.register(mealPlansRoutes, { prefix: '/api' });
  await fastify.register(diaryRoutes, { prefix: '/api' });
  
  // Knowledge Module (Courses + Lessons) ✅
  const { knowledgeRoutes } = await import('./modules/knowledge_module/index.ts');
  await fastify.register(knowledgeRoutes, { prefix: '/api' });
  
  // Lab Tests Module ✅
  const { labTestsRoutes } = await import('./modules/lab_module/index.ts');
  await fastify.register(labTestsRoutes, { prefix: '/api' });
  
  // User Profile Module ✅
  const { profileRoutes } = await import('./modules/users_module/index.ts');
  await fastify.register(profileRoutes, { prefix: '/api' });
  
  // AI Chat Module ✅
  const { aiChatRoutes } = await import('./modules/ai_chat_module/index.ts');
  await fastify.register(aiChatRoutes, { prefix: '/api' });
  
  // Blog + Notifications Module ✅
  const { blogRoutes } = await import('./modules/blog_module/index.ts');
  await fastify.register(blogRoutes, { prefix: '/api' });
  
  // Files Upload Module ✅
  const { filesRoutes } = await import('./modules/files_module/index.ts');
  await fastify.register(filesRoutes, { prefix: '/api' });
  
  // Admin CRUD Module ✅
  const { adminRoutes } = await import('./modules/admin_module/index.ts');
  await fastify.register(adminRoutes, { prefix: '/api' });
  
  // TODO: Register other modules as they're ready:
  // await fastify.register(usersRoutes, { prefix: '/api/users' });
  // await fastify.register(diaryRoutes, { prefix: '/api/diary' });
  // await fastify.register(knowledgeRoutes, { prefix: '/api/knowledge' });
  // await fastify.register(labRoutes, { prefix: '/api/lab-tests' });
  // await fastify.register(aiChatRoutes, { prefix: '/api/ai' });
  // await fastify.register(subscriptionRoutes, { prefix: '/api/subscriptions' });
  // await fastify.register(blogRoutes, { prefix: '/api/blog' });
  // await fastify.register(notificationsRoutes, { prefix: '/api/notifications' });

  // ========================================
  // Error Handler
  // ========================================

  fastify.setErrorHandler((error, request, reply) => {
    fastify.log.error(error);

    const statusCode = error.statusCode || 500;
    const message =
      config.server.env === 'production' && statusCode === 500
        ? 'Internal Server Error'
        : error.message;

    reply.status(statusCode).send({
      success: false,
      error: {
        message,
        statusCode,
      },
    });
  });

  return fastify;
}

/**
 * Start server
 */
async function start() {
  try {
    const fastify = await buildApp();

    await fastify.listen({
      port: config.server.port,
      host: config.server.host,
    });

    fastify.log.info(
      `🚀 Brix Nutrition API is running on http://${config.server.host}:${config.server.port}`
    );
    fastify.log.info(
      `📚 API Documentation: http://${config.server.host}:${config.server.port}/documentation`
    );
  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
}

// Auto-start server
start();

export { buildApp };

