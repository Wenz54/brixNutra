import { FastifyInstance } from 'fastify';
import twilio from 'twilio';
import crypto from 'crypto';
import bcrypt from 'bcryptjs';

interface VerificationCode {
  id: string;
  identifier: string;
  code: string;
  type: 'email' | 'phone';
  expiresAt: Date;
  isUsed: boolean;
}

export class SmsService {
  private fastify: FastifyInstance;
  private twilioClient: twilio.Twilio | null = null;
  private useMockSms: boolean;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
    this.useMockSms = !process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN;

    if (!this.useMockSms) {
      this.twilioClient = twilio(
        process.env.TWILIO_ACCOUNT_SID!,
        process.env.TWILIO_AUTH_TOKEN!
      );
    }
  }

  /**
   * Generate 4-digit verification code
   */
  private generateCode(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }

  /**
   * Generate unique ID
   */
  private generateId(): string {
    return crypto.randomUUID();
  }

  /**
   * Send verification code to email
   */
  async sendCodeToEmail(email: string): Promise<{ success: boolean; message: string }> {
    try {
      const code = this.generateCode();
      const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

      // Save code to database
      await this.saveVerificationCode(email, code, 'email', expiresAt);

      // Send email (using SMTP or mock)
      if (process.env.USE_MOCK_EMAIL === 'true') {
        this.fastify.log.info(`📧 Mock Email to ${email}: Your verification code is ${code}`);
        return {
          success: true,
          message: 'Verification code sent to email (mock mode)',
        };
      }

      // TODO: Integrate with real email service (Resend, SendGrid, etc.)
      // For now, just log
      this.fastify.log.info(`📧 Email to ${email}: Code ${code}`);

      return {
        success: true,
        message: 'Verification code sent to email',
      };
    } catch (error) {
      this.fastify.log.error('Error sending email code:', error);
      throw new Error('Failed to send verification code to email');
    }
  }

  /**
   * Send verification code to phone (SMS)
   */
  async sendCodeToPhone(phone: string): Promise<{ success: boolean; message: string }> {
    try {
      const code = this.generateCode();
      const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

      // Save code to database
      await this.saveVerificationCode(phone, code, 'phone', expiresAt);

      // Send SMS
      if (this.useMockSms) {
        this.fastify.log.info(`📱 Mock SMS to ${phone}: Your verification code is ${code}`);
        return {
          success: true,
          message: 'Verification code sent to phone (mock mode)',
        };
      }

      // Send via Twilio
      const message = await this.twilioClient!.messages.create({
        body: `Ваш код подтверждения Brix: ${code}`,
        from: process.env.TWILIO_PHONE_NUMBER!,
        to: phone,
      });

      this.fastify.log.info(`📱 SMS sent to ${phone}, SID: ${message.sid}`);

      return {
        success: true,
        message: 'Verification code sent to phone',
      };
    } catch (error) {
      this.fastify.log.error('Error sending SMS:', error);
      throw new Error('Failed to send verification code to phone');
    }
  }

  /**
   * Verify code for email
   */
  async verifyEmailCode(
    email: string,
    code: string
  ): Promise<{ success: boolean; isNewUser: boolean; token?: string; user?: any }> {
    try {
      // Check code in database
      const isValid = await this.checkVerificationCode(email, code, 'email');

      if (!isValid) {
        throw new Error('Invalid or expired verification code');
      }

      // Mark code as used
      await this.markCodeAsUsed(email, code, 'email');

      // Check if user exists
      const existingUser = await this.findUserByEmail(email);

      if (existingUser) {
        // Existing user with password - generate token
        if (existingUser.password_hash) {
          const token = await this.generateToken(existingUser.id);

          return {
            success: true,
            isNewUser: false,
            token,
            user: {
              id: existingUser.id,
              email: existingUser.email,
              name: existingUser.name,
            },
          };
        } else {
          // Existing user but no password yet
          return {
            success: true,
            isNewUser: true,
          };
        }
      } else {
        // New user - create account without password
        await this.createUserByEmail(email);
        
        return {
          success: true,
          isNewUser: true,
        };
      }
    } catch (error) {
      this.fastify.log.error('Error verifying email code:', error);
      throw error;
    }
  }

  /**
   * Verify code for phone
   */
  async verifyPhoneCode(
    phone: string,
    code: string
  ): Promise<{ success: boolean; isNewUser: boolean; token?: string; user?: any }> {
    try {
      // Check code in database
      const isValid = await this.checkVerificationCode(phone, code, 'phone');

      if (!isValid) {
        throw new Error('Invalid or expired verification code');
      }

      // Mark code as used
      await this.markCodeAsUsed(phone, code, 'phone');

      // Check if user exists
      const existingUser = await this.findUserByPhone(phone);

      if (existingUser) {
        // Existing user - generate token
        const token = await this.generateToken(existingUser.id);

        return {
          success: true,
          isNewUser: false,
          token,
          user: {
            id: existingUser.id,
            phone: existingUser.phone,
            name: existingUser.name,
          },
        };
      } else {
        // New user - create account (phone auth doesn't require password)
        const newUser = await this.createUserByPhone(phone);
        const token = await this.generateToken(newUser.id);

        return {
          success: true,
          isNewUser: true,
          token,
          user: {
            id: newUser.id,
            phone: newUser.phone,
          },
        };
      }
    } catch (error) {
      this.fastify.log.error('Error verifying phone code:', error);
      throw error;
    }
  }

  /**
   * Save verification code to database
   */
  private async saveVerificationCode(
    identifier: string,
    code: string,
    type: 'email' | 'phone',
    expiresAt: Date
  ): Promise<void> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO verification_codes (id, identifier, code, type, expires_at, is_used, created_at)
      VALUES (gen_random_uuid(), $1, $2, $3, $4, false, NOW())
    `;
    
    await db.query(query, [identifier, code, type, expiresAt]);
    
    this.fastify.log.info(`✅ Verification code saved: ${identifier} (${type})`);
  }

  /**
   * Check verification code
   */
  private async checkVerificationCode(
    identifier: string,
    code: string,
    type: 'email' | 'phone'
  ): Promise<boolean> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM verification_codes
      WHERE identifier = $1 
        AND code = $2 
        AND type = $3
        AND expires_at > NOW() 
        AND is_used = false
      LIMIT 1
    `;
    
    const result = await db.query(query, [identifier, code, type]);
    
    const isValid = result.rows.length > 0;
    
    this.fastify.log.info(`${isValid ? '✅' : '❌'} Code check for ${identifier}: ${isValid ? 'VALID' : 'INVALID'}`);
    
    return isValid;
  }

  /**
   * Mark code as used
   */
  private async markCodeAsUsed(
    identifier: string,
    code: string,
    type: 'email' | 'phone'
  ): Promise<void> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      UPDATE verification_codes
      SET is_used = true, used_at = NOW()
      WHERE identifier = $1 AND code = $2 AND type = $3
    `;
    
    await db.query(query, [identifier, code, type]);
    
    this.fastify.log.info(`✅ Code marked as used: ${identifier}`);
  }

  /**
   * Find user by email
   */
  private async findUserByEmail(email: string): Promise<any | null> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT id, email, phone, name, password_hash, is_verified, created_at
      FROM users 
      WHERE email = $1 
      LIMIT 1
    `;
    
    const result = await db.query(query, [email]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    return result.rows[0];
  }

  /**
   * Find user by phone
   */
  private async findUserByPhone(phone: string): Promise<any | null> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT id, email, phone, name, password_hash, is_verified, created_at
      FROM users 
      WHERE phone = $1 
      LIMIT 1
    `;
    
    const result = await db.query(query, [phone]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    return result.rows[0];
  }

  /**
   * Create user by phone
   */
  private async createUserByPhone(phone: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO users (id, phone, is_verified, created_at)
      VALUES (gen_random_uuid(), $1, true, NOW())
      RETURNING id, phone, is_verified, created_at
    `;
    
    const result = await db.query(query, [phone]);
    
    const user = result.rows[0];
    
    this.fastify.log.info(`✅ Created new user with phone: ${phone}`);
    
    return user;
  }

  /**
   * Set password for new email user
   */
  async setPasswordForEmailUser(
    email: string,
    password: string
  ): Promise<{ success: boolean; token: string; user: any }> {
    const db = await import('../../database_module/connection.js');
    
    // Find user by email
    const user = await this.findUserByEmail(email);
    
    if (!user) {
      throw new Error('User not found');
    }
    
    // Check if user already has password
    if (user.password_hash) {
      throw new Error('User already has password set');
    }
    
    // Hash password
    const saltRounds = 12;
    const passwordHash = await bcrypt.hash(password, saltRounds);
    
    // Update user with password
    const query = `
      UPDATE users
      SET password_hash = $1, is_verified = true, updated_at = NOW()
      WHERE id = $2
      RETURNING id, email, name, is_verified
    `;
    
    const result = await db.query(query, [passwordHash, user.id]);
    const updatedUser = result.rows[0];
    
    // Generate JWT token
    const token = await this.generateToken(user.id);
    
    this.fastify.log.info(`✅ Password set for user: ${email}`);
    
    return {
      success: true,
      token,
      user: updatedUser,
    };
  }

  /**
   * Create user by email (no password yet)
   */
  async createUserByEmail(email: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO users (id, email, is_verified, created_at)
      VALUES (gen_random_uuid(), $1, false, NOW())
      RETURNING id, email, is_verified, created_at
    `;
    
    const result = await db.query(query, [email]);
    const user = result.rows[0];
    
    this.fastify.log.info(`✅ Created new user with email: ${email} (password pending)`);
    
    return user;
  }

  /**
   * Generate JWT token
   */
  private async generateToken(userId: string): Promise<string> {
    const token = this.fastify.jwt.sign({
      id: userId,
    });

    return token;
  }
}




