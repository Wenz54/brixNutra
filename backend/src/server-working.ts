/**
 * Brix Nutrition API Server - Working Version
 * Simplified version that actually starts
 */

import Fastify from 'fastify';
import cors from '@fastify/cors';
import swagger from '@fastify/swagger';
import swaggerUI from '@fastify/swagger-ui';

console.log('🚀 Starting Brix Nutrition API Server...\n');

const fastify = Fastify({
  logger: {
    level: 'info',
    transport: {
      target: 'pino-pretty',
      options: {
        translateTime: 'HH:MM:ss Z',
        ignore: 'pid,hostname',
      },
    },
  },
});

// CORS
await fastify.register(cors, {
  origin: ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true,
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
        url: 'http://localhost:3000',
        description: 'Development server',
      },
    ],
  },
});

await fastify.register(swaggerUI, {
  routePrefix: '/documentation',
  uiConfig: {
    docExpansion: 'list',
    deepLinking: false,
  },
});

// Health Check
fastify.get('/health', {
  schema: {
    description: 'Health check endpoint',
    tags: ['System'],
    response: {
      200: {
        type: 'object',
        properties: {
          status: { type: 'string' },
          timestamp: { type: 'string' },
          uptime: { type: 'number' },
        },
      },
    },
  },
}, async () => {
  return {
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  };
});

// API Info
fastify.get('/api', async () => {
  return {
    message: 'Brix Nutritional App API',
    version: '1.0.0',
    documentation: '/documentation',
    status: 'operational',
  };
});

// Start server
async function start() {
  try {
    await fastify.listen({
      port: 3000,
      host: '0.0.0.0',
    });
    
    console.log('✅ Server started successfully!\n');
    console.log('📍 API: http://localhost:3000');
    console.log('📚 Swagger Documentation: http://localhost:3000/documentation');
    console.log('❤️  Health Check: http://localhost:3000/health\n');
  } catch (err) {
    console.error('❌ Failed to start server:', err);
    process.exit(1);
  }
}

start();


