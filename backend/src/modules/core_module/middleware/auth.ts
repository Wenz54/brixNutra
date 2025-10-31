import { FastifyRequest, FastifyReply } from 'fastify';

declare module 'fastify' {
  interface FastifyRequest {
    user?: {
      id: string;
      email: string;
      role?: string;
    };
  }
}

export async function authMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
) {
  try {
    await request.jwtVerify();
  } catch (error) {
    reply.status(401).send({
      success: false,
      error: 'UNAUTHORIZED',
      message: 'Invalid or missing authentication token',
    });
  }
}

export async function adminMiddleware(
  request: FastifyRequest,
  reply: FastifyReply
) {
  try {
    await request.jwtVerify();
    
    // Check if user is admin
    if (request.user?.role !== 'admin') {
      reply.status(403).send({
        success: false,
        error: 'FORBIDDEN',
        message: 'Admin access required',
      });
    }
  } catch (error) {
    reply.status(401).send({
      success: false,
      error: 'UNAUTHORIZED',
      message: 'Invalid or missing authentication token',
    });
  }
}

