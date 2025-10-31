import { FastifyReply, FastifyRequest } from 'fastify';

export async function jwtAuthMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
) {
  try {
    // Skip auth for public routes
    const publicRoutes = [
      '/health',
      '/documentation',
      '/api/auth/',
      '/api/knowledge/courses', // Public courses list
      '/api/knowledge/categories', // Public categories
      '/api/recipes', // Public recipes
      '/api/lab-tests/parameters', // Public parameters
    ];

    const isPublic = publicRoutes.some(route => request.url.startsWith(route));

    if (isPublic) {
      return;
    }

    // Verify JWT token
    await request.jwtVerify();

    // User is now available in request.user
    // request.user will contain the decoded JWT payload
  } catch (err) {
    reply.status(401).send({
      success: false,
      error: 'UNAUTHORIZED',
      message: 'Invalid or missing authentication token',
    });
  }
}

