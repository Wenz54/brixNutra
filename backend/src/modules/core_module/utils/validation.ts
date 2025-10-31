import { z } from 'zod';

// Email validation schema
export const emailSchema = z
  .string()
  .email('Некорректный формат email')
  .min(1, 'Email обязателен');

// Password validation schema
export const passwordSchema = z
  .string()
  .min(8, 'Пароль должен содержать минимум 8 символов')
  .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, 
    'Пароль должен содержать строчные и заглавные буквы, и цифры');

// Name validation schema
export const nameSchema = z
  .string()
  .min(2, 'Имя должно содержать минимум 2 символа')
  .max(50, 'Имя не должно превышать 50 символов');

// Verification code schema
export const verificationCodeSchema = z
  .string()
  .length(4, 'Код подтверждения должен содержать 4 цифры')
  .regex(/^\d{4}$/, 'Код подтверждения должен состоять только из цифр');

// Register request schema
export const registerSchema = z.object({
  email: emailSchema,
  password: passwordSchema,
  name: nameSchema,
});

// Login request schema
export const loginSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, 'Пароль обязателен'),
});

// Verify email request schema
export const verifyEmailSchema = z.object({
  email: emailSchema,
  code: verificationCodeSchema,
});

// Request reset password schema
export const requestResetSchema = z.object({
  email: emailSchema,
});

// Reset password request schema
export const resetPasswordSchema = z.object({
  email: emailSchema,
  token: z.string().min(1, 'Токен обязателен'),
  new_password: passwordSchema,
});

// Type exports
export type RegisterRequest = z.infer<typeof registerSchema>;
export type LoginRequest = z.infer<typeof loginSchema>;
export type VerifyEmailRequest = z.infer<typeof verifyEmailSchema>;
export type RequestResetRequest = z.infer<typeof requestResetSchema>;
export type ResetPasswordRequest = z.infer<typeof resetPasswordSchema>;

