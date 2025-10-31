import Fastify from 'fastify';

console.log('Starting minimal server...');

const fastify = Fastify({ logger: true });

fastify.get('/health', async () => {
  return { status: 'ok', message: 'Minimal server works!' };
});

fastify.get('/test', async () => {
  return { test: 'SUCCESS' };
});

async function start() {
  try {
    await fastify.listen({ port: 3000, host: '0.0.0.0' });
    console.log('✅ Server running on http://localhost:3000');
    console.log('Test: http://localhost:3000/health');
  } catch (err) {
    console.error('Failed to start:', err);
    process.exit(1);
  }
}

start();


