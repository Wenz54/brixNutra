-- Migration 002: Add verification fields to users table
-- Description: Add verification_code and verification_code_expires for email verification
-- Date: 2025-10-13

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS verification_code VARCHAR(6),
ADD COLUMN IF NOT EXISTS verification_code_expires TIMESTAMP;

-- Add index
CREATE INDEX IF NOT EXISTS idx_users_verification_code ON users(verification_code);

-- Comment
COMMENT ON COLUMN users.verification_code IS 'Email verification code (4 digits)';
COMMENT ON COLUMN users.verification_code_expires IS 'Expiration time for verification code';

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 002 completed successfully!';
  RAISE NOTICE '   - Added verification_code field to users';
  RAISE NOTICE '   - Added verification_code_expires field to users';
END $$;


