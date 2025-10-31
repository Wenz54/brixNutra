-- Migration 008: AI Chat Sessions
-- Store chat history with AI assistant

CREATE TABLE IF NOT EXISTS chat_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  title VARCHAR(255) DEFAULT 'Новый чат',
  messages JSONB NOT NULL DEFAULT '[]'::jsonb,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_user ON chat_sessions(user_id, updated_at DESC);

COMMENT ON TABLE chat_sessions IS 'AI chat conversation history';
COMMENT ON COLUMN chat_sessions.messages IS 'Array of {role, content} messages';

DO $$
BEGIN
  RAISE NOTICE '✅ Migration 008: Chat sessions table created';
END $$;

