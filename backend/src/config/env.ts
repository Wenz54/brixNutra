import dotenv from 'dotenv';
import { z } from 'zod';

// Load environment variables
dotenv.config();

// Environment schema validation
const envSchema = z.object({
  // Server
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  HOST: z.string().default('0.0.0.0'),
  PORT: z.string().default('3000'),

  // Database
  DATABASE_URL: z.string().optional(),
  DATABASE_HOST: z.string().default('localhost'),
  DATABASE_PORT: z.string().default('5432'),
  DATABASE_NAME: z.string().default('brix_nutrition'),
  DATABASE_USERNAME: z.string().default('postgres'),
  DATABASE_PASSWORD: z.string().default('postgres'),
  DATABASE_SSL: z.string().default('false'),

  // Redis
  REDIS_HOST: z.string().default('localhost'),
  REDIS_PORT: z.string().default('6379'),

  // JWT
  JWT_SECRET: z.string().min(32),
  API_TOKEN_SALT: z.string().optional(),
  ADMIN_JWT_SECRET: z.string().optional(),

  // OpenAI
  OPENAI_API_KEY: z.string().optional(),
  OPENAI_MODEL: z.string().default('gpt-4'),
  OPENAI_MAX_TOKENS: z.string().default('1000'),

  // Twilio
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_PHONE_NUMBER: z.string().optional(),

  // Stripe
  STRIPE_SECRET_KEY: z.string().optional(),
  STRIPE_WEBHOOK_SECRET: z.string().optional(),

  // AWS S3
  AWS_ACCESS_KEY_ID: z.string().optional(),
  AWS_SECRET_ACCESS_KEY: z.string().optional(),
  AWS_REGION: z.string().default('us-east-1'),
  AWS_S3_BUCKET: z.string().optional(),

  // Email (SMTP)
  SMTP_HOST: z.string().default('localhost'),
  SMTP_PORT: z.string().default('1025'), // Mailhog default
  SMTP_USER: z.string().optional(),
  SMTP_PASS: z.string().optional(),

  // Resend (Alternative Email)
  RESEND_API_KEY: z.string().optional(),
  USE_MOCK_EMAIL: z.string().default('true'),

  // Frontend URL (CORS)
  FRONTEND_URL: z.string().default('http://localhost:3000'),

  // Rate Limiting
  RATE_LIMIT_MAX: z.string().default('100'),
  RATE_LIMIT_WINDOW_MS: z.string().default('60000'),

  // Logs
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
});

// Parse and validate environment variables
export const env = envSchema.parse(process.env);

// Build DATABASE_URL if not provided
export const DATABASE_URL = env.DATABASE_URL || 
  `postgresql://${env.DATABASE_USERNAME}:${env.DATABASE_PASSWORD}@${env.DATABASE_HOST}:${env.DATABASE_PORT}/${env.DATABASE_NAME}${env.DATABASE_SSL === 'true' ? '?ssl=true' : ''}`;

// Export config object
export const config = {
  server: {
    host: env.HOST,
    port: parseInt(env.PORT, 10),
    env: env.NODE_ENV,
  },
  database: {
    url: DATABASE_URL,
    ssl: env.DATABASE_SSL === 'true',
  },
  redis: {
    host: env.REDIS_HOST,
    port: parseInt(env.REDIS_PORT, 10),
  },
  jwt: {
    secret: env.JWT_SECRET,
    expiresIn: '7d',
  },
  openai: {
    apiKey: env.OPENAI_API_KEY,
    model: env.OPENAI_MODEL,
    maxTokens: parseInt(env.OPENAI_MAX_TOKENS, 10),
  },
  smtp: {
    host: env.SMTP_HOST,
    port: parseInt(env.SMTP_PORT, 10),
    user: env.SMTP_USER,
    pass: env.SMTP_PASS,
    useMock: env.USE_MOCK_EMAIL === 'true',
  },
  cors: {
    origin: env.FRONTEND_URL,
  },
  rateLimit: {
    max: parseInt(env.RATE_LIMIT_MAX, 10),
    windowMs: parseInt(env.RATE_LIMIT_WINDOW_MS, 10),
  },
};

export type Config = typeof config;


