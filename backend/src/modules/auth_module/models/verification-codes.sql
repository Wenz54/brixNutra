-- Migration: Create verification_codes table
-- Description: Store verification codes for email and phone authentication
-- Date: 2025-10-10

-- Create verification_codes table
CREATE TABLE IF NOT EXISTS verification_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  identifier VARCHAR(255) NOT NULL,  -- email or phone
  code VARCHAR(6) NOT NULL,          -- 4-digit code
  type VARCHAR(10) NOT NULL CHECK (type IN ('email', 'phone')),
  expires_at TIMESTAMP NOT NULL,
  is_used BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  used_at TIMESTAMP DEFAULT NULL
);

-- Create indexes for performance
CREATE INDEX idx_verification_codes_identifier ON verification_codes(identifier);
CREATE INDEX idx_verification_codes_type ON verification_codes(type);
CREATE INDEX idx_verification_codes_expires_at ON verification_codes(expires_at);
CREATE INDEX idx_verification_codes_is_used ON verification_codes(is_used);

-- Composite index for common query pattern
CREATE INDEX idx_verification_codes_lookup 
ON verification_codes(identifier, code, type, is_used, expires_at);

-- Add comments
COMMENT ON TABLE verification_codes IS 'Verification codes for email and phone authentication';
COMMENT ON COLUMN verification_codes.identifier IS 'Email address or phone number';
COMMENT ON COLUMN verification_codes.code IS '4-digit verification code';
COMMENT ON COLUMN verification_codes.type IS 'Type of verification: email or phone';
COMMENT ON COLUMN verification_codes.expires_at IS 'Expiration timestamp (10 minutes from creation)';
COMMENT ON COLUMN verification_codes.is_used IS 'Whether the code has been used';
COMMENT ON COLUMN verification_codes.used_at IS 'Timestamp when code was used';

-- Cleanup old codes function (optional)
CREATE OR REPLACE FUNCTION cleanup_expired_verification_codes()
RETURNS void AS $$
BEGIN
  DELETE FROM verification_codes
  WHERE expires_at < NOW() - INTERVAL '24 hours'
    OR (is_used = TRUE AND used_at < NOW() - INTERVAL '7 days');
END;
$$ LANGUAGE plpgsql;

-- Example usage:
-- SELECT cleanup_expired_verification_codes();








