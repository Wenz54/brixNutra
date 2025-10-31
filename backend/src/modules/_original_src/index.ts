import dotenv from 'dotenv';
import path from 'path';

// Load environment variables FIRST, before any other imports
const envPath = path.join(__dirname, '../.env');
console.log('Loading .env from index.ts:', envPath);

// Check if file exists
const fs = require('fs');
if (fs.existsSync(envPath)) {
  console.log('✅ .env file exists!');
  const content = fs.readFileSync(envPath, 'utf8');
  console.log('📄 .env content preview:', content.substring(0, 200) + '...');
  
  // Check for BOM and fix if needed
  if (content.charCodeAt(0) === 0xFEFF) {
    console.log('⚠️ BOM detected! Removing BOM and rewriting file...');
    const cleanContent = content.slice(1); // Remove BOM
    fs.writeFileSync(envPath, cleanContent, 'utf8');
    console.log('✅ BOM removed and file rewritten!');
  }
} else {
  console.log('❌ .env file does not exist!');
}

const result = dotenv.config({ path: envPath });
console.log('dotenv result:', result);
console.log('DATABASE_URL after dotenv:', process.env['DATABASE_URL']);
console.log('USE_MOCK_EMAIL after dotenv:', process.env['USE_MOCK_EMAIL']);
console.log('RESEND_API_KEY after dotenv:', process.env['RESEND_API_KEY'] ? '***' + process.env['RESEND_API_KEY'].slice(-4) : 'undefined');
console.log('OPENAI_API_KEY after dotenv:', process.env['OPENAI_API_KEY'] ? '***' + process.env['OPENAI_API_KEY'].slice(-4) : 'undefined');

import Fastify from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';

import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import jwt from '@fastify/jwt';

// Import routes
import authRoutes from './routes/auth';
import { diaryRoutes } from './routes/diary';
// import { mockPlansRoutes } from './routes/mock-plans'; // Убрано в пользу реальных роутов
import { surveyRoutes } from './routes/survey';
import labRoutes from './routes/lab';
import aiChatRoutes from './routes/aiChat';
import testJwtRoutes from './routes/test-jwt';
import { initDatabase } from './db/init';
import { initAuthService } from './services/authService';

// Create Fastify instance
const fastify = Fastify({
  logger: {
    level: process.env['NODE_ENV'] === 'development' ? 'info' : 'warn',
    transport: {
      target: 'pino-pretty',
      options: {
        colorize: true,
        translateTime: 'HH:MM:ss Z',
        ignore: 'pid,hostname',
      },
    },
  },
});

// Set default content type with UTF-8 charset for all JSON responses
fastify.addHook('onSend', (_request, reply, _payload, done) => {
  const contentType = reply.getHeader('content-type');
  if (!contentType || contentType === 'application/json') {
    reply.header('Content-Type', 'application/json; charset=utf-8');
  }
  done();
});

// Register plugins
async function registerPlugins() {
  // CORS
  await fastify.register(cors, {
    origin: process.env['NODE_ENV'] === 'production' 
      ? (process.env['CORS_ORIGIN'] || 'https://24supplydiets.ru,https://panel.24supplydiets.ru').split(',').map(o => o.trim())
      : (origin, cb) => {
          // В development разрешаем все localhost origins
          if (!origin || origin.includes('localhost') || origin.includes('127.0.0.1')) {
            cb(null, true);
          } else {
            cb(null, false);
          }
        }, // Development - разрешаем все localhost
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Origin', 'X-Requested-With', 'Accept', 'Cache-Control', 'Pragma', 'X-CSRF-Token'],
  });

  // TODO: Добавить rate limiting когда появится пакет
  // await fastify.register(rateLimit, { max: 100, timeWindow: '1 minute' });

  // Security headers
  await fastify.register(helmet, {
    crossOriginResourcePolicy: { policy: "cross-origin" },
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        imgSrc: ["'self'", "data:", "blob:", "*"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        scriptSrc: ["'self'"],
        connectSrc: ["'self'", "*"]
      }
    },
    // HTTPS enforcement в production
    hsts: process.env['NODE_ENV'] === 'production' ? {
      maxAge: 31536000, // 1 год
      includeSubDomains: true,
      preload: true
    } : false
  });

  // JWT
  await fastify.register(jwt, {
    secret: process.env['JWT_SECRET'] || 'fallback-secret',
    sign: {
      expiresIn: process.env['JWT_EXPIRES_IN'] || '7d',
    },
  });

  // Initialize AuthService with Fastify instance for JWT compatibility
  initAuthService(fastify);

  // Swagger documentation
  await fastify.register(swagger, {
    swagger: {
      info: {
        title: 'Supply Diets API',
        description: 'API for Supply Diets nutrition application',
        version: '1.0.0',
      },
      host: 'localhost:3001',
      schemes: ['http'],
      consumes: ['application/json'],
      produces: ['application/json'],
    },
  });

  await fastify.register(swaggerUi, {
    routePrefix: '/docs',
  });

  // Register multipart support for file uploads
  await fastify.register(require('@fastify/multipart'), {
    limits: {
      fileSize: 10 * 1024 * 1024, // 10MB limit
    }
  });
}

// Register routes
async function registerRoutes() {
  await fastify.register(authRoutes, { prefix: '/api/auth' });
  await fastify.register(diaryRoutes, { prefix: '/api' });
  
  // Реальные роуты планов питания для Flutter
  const plansRoutes = (await import('./routes/plans')).default;
  await fastify.register(plansRoutes, { prefix: '/api/plans' });
  
  await fastify.register(surveyRoutes, { prefix: '/api/survey' });
  await fastify.register(labRoutes, { prefix: '/api/lab' });
  await fastify.register(aiChatRoutes, { prefix: '/api/ai' });
  await fastify.register(testJwtRoutes, { prefix: '/test' });
  
  // Profile routes
  const profileRoutes = (await import('./routes/profile')).default;
  await fastify.register(profileRoutes, { prefix: '/api/profile' });
  
  // Knowledge Base routes (legacy) - ОТКЛЮЧЕНЫ из-за конфликтов с новыми роутами
  // const knowledgeRoutes = (await import('./routes/knowledge')).default;
  // await fastify.register(knowledgeRoutes, { prefix: '/api' });
  
  // New Knowledge Base routes
  const knowledgeAdminRoutes = (await import('./routes/knowledgeAdmin')).default;
  await fastify.register(knowledgeAdminRoutes, { prefix: '/api/admin/knowledge' });
  
  const knowledgeFrontendRoutes = (await import('./routes/knowledgeFrontend')).default;
  await fastify.register(knowledgeFrontendRoutes, { prefix: '/api/knowledge' });
  
  // Analytics routes
  const analyticsRoutes = (await import('./routes/analytics')).default;
  await fastify.register(analyticsRoutes, { prefix: '/api' });
  
  // File upload routes (no prefix for uploads, but /api prefix for admin routes)
  const filesRoutes = (await import('./routes/files')).default;
  await fastify.register(filesRoutes);
  
  // Nutrition admin routes
  const nutritionAdminRoutes = (await import('./routes/nutritionAdmin')).default;
  await fastify.register(nutritionAdminRoutes, { prefix: '/api' });
  
  // Subscription routes
  const subscriptionRoutes = (await import('./routes/subscriptions')).default;
  await fastify.register(subscriptionRoutes, { prefix: '/api/subscriptions' });
  
  // Импортируем и регистрируем test-token роуты
  const testTokenRoutes = (await import('./routes/test-token')).default;
  await fastify.register(testTokenRoutes, { prefix: '/test' });
  
  // Simple Plans routes (новая упрощенная система планов)
  const simplePlansRoutes = (await import('./routes/simplePlans')).default;
  await fastify.register(simplePlansRoutes, { prefix: '/api/simple-plans' });
  
  // Courses routes (система курсов в базе знаний)
  const coursesRoutes = (await import('./routes/courses')).default;
  await fastify.register(coursesRoutes, { prefix: '/api/courses' });
  
  // Author courses routes (расширенная информация об авторских курсах)
  const authorCoursesRoutes = (await import('./routes/author-courses')).default;
  await fastify.register(authorCoursesRoutes, { prefix: '/api/author-courses' });
  
  // Subscription courses routes (расширенная информация о курсах подписки)
  const subscriptionCoursesRoutes = (await import('./routes/subscription-courses')).default;
  await fastify.register(subscriptionCoursesRoutes, { prefix: '/api/subscription-courses' });
  
  // Debug routes (для диагностики и исправления проблем)
  const debugImagesRoutes = (await import('./routes/debug-images')).default;
  await fastify.register(debugImagesRoutes, { prefix: '/api/debug' });
}

// Health check endpoint
fastify.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

// Start server
async function start() {
  try {
    // Initialize database
    await initDatabase();
    
    await registerPlugins();
    await registerRoutes();

    const port = parseInt(process.env['PORT'] || '3001', 10);
    const host = '0.0.0.0';

    await fastify.listen({ port, host });
    
    fastify.log.info(`Server is running on http://localhost:${port}`);
    fastify.log.info(`API documentation available at http://localhost:${port}/docs`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}

// Handle graceful shutdown
process.on('SIGINT', async () => {
  fastify.log.info('Shutting down gracefully...');
  await fastify.close();
  process.exit(0);
});

process.on('SIGTERM', async () => {
  fastify.log.info('Shutting down gracefully...');
  await fastify.close();
  process.exit(0);
});

start(); 