import Fastify from 'fastify';
import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import jwt from '@fastify/jwt';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Import routes
import mockAuthRoutes from './routes/mock-auth';
import mockDiaryRoutes from './routes/mock-diary';
import mockPlansRoutes from './routes/mock-plans';
import mockLabRoutes from './routes/mock-lab';
import aiChatRoutes from './routes/aiChat';


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

// Register plugins
async function registerPlugins() {
  // CORS
  await fastify.register(cors, {
    origin: true, // Разрешаем все origins для разработки
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Security headers
  await fastify.register(helmet);

  // JWT
  await fastify.register(jwt, {
    secret: process.env['JWT_SECRET'] || 'fallback-secret',
    sign: {
      expiresIn: process.env['JWT_EXPIRES_IN'] || '7d',
    },
  });
}

// Register routes
async function registerRoutes() {
  await fastify.register(mockAuthRoutes);
  await fastify.register(mockDiaryRoutes, { prefix: '/api' });
  await fastify.register(mockPlansRoutes, { prefix: '/api' });
  await fastify.register(mockLabRoutes, { prefix: '/api/lab' });
  await fastify.register(aiChatRoutes, { prefix: '/api/ai' });
}

// Health check endpoint
fastify.get('/health', async () => {
  return { status: 'ok', timestamp: new Date().toISOString() };
});

// API info endpoint
fastify.get('/', async () => {
  return { 
    message: 'Supply Diets API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/auth/*',
      lab: '/api/lab/*',
      ai: '/api/ai/*'
    }
  };
});

// Start server
async function start() {
  try {
    await registerPlugins();
    await registerRoutes();

    const port = parseInt(process.env['PORT'] || '3001', 10);
    const host = '0.0.0.0';

    await fastify.listen({ port, host });
    
    fastify.log.info(`Server is running on http://localhost:${port}`);
    fastify.log.info(`Health check: http://localhost:${port}/health`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}

start(); 