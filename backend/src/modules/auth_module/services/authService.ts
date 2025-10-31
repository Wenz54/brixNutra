import bcrypt from 'bcryptjs';
import { FastifyInstance } from 'fastify';
import { query } from '../../database_module/connection';

export interface RegisterRequest {
  email: string;
  password: string;
  name: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: {
    id: string;
    email: string;
    name: string;
    is_verified: boolean;
  };
  token: string;
}

export class AuthService {
  private readonly saltRounds = 12;
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Register new user
   */
  async register(userData: RegisterRequest): Promise<AuthResponse> {
    const { email, password, name } = userData;

    // Check if user already exists
    const existingUser = await query(
      'SELECT id FROM users WHERE email = $1',
      [email]
    );

    if (existingUser.rows.length > 0) {
      throw new Error('User with this email already exists');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, this.saltRounds);

    // Generate verification code
    const verificationCode = Math.floor(1000 + Math.random() * 9000).toString();
    const verificationCodeExpires = new Date(Date.now() + 10 * 60 * 1000);

    // Create user
    const result = await query(
      `INSERT INTO users (email, password_hash, name, verification_code, verification_code_expires, is_verified, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
       RETURNING id, email, name, is_verified, created_at, updated_at`,
      [email, passwordHash, name, verificationCode, verificationCodeExpires, false]
    );

    const user = result.rows[0];

    // Generate JWT token
    const token = this.fastify.jwt.sign(
      { userId: user.id, email: user.email },
      { expiresIn: '7d' }
    );

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        is_verified: user.is_verified,
      },
      token,
    };
  }

  /**
   * Login user
   */
  async login(loginData: LoginRequest): Promise<AuthResponse> {
    const { email, password } = loginData;

    // Find user by email
    const result = await query(
      'SELECT id, email, name, password_hash, is_verified FROM users WHERE email = $1',
      [email]
    );

    if (result.rows.length === 0) {
      throw new Error('Invalid email or password');
    }

    const user = result.rows[0];

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      throw new Error('Invalid email or password');
    }

    // Generate JWT token
    const token = this.fastify.jwt.sign(
      { userId: user.id, email: user.email },
      { expiresIn: '7d' }
    );

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        is_verified: user.is_verified,
      },
      token,
    };
  }
}

