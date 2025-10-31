-- Migration 009: Blog and Notifications

-- Blog articles
CREATE TABLE IF NOT EXISTS blog_articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  content TEXT NOT NULL,
  preview TEXT,
  
  image_url VARCHAR(500),
  author VARCHAR(100),
  
  category_id UUID,
  tags JSONB DEFAULT '[]'::jsonb,
  
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMP,
  
  views_count INTEGER DEFAULT 0,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL, -- info, reminder, alert, success
  
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMP,
  
  action JSONB, -- {type: 'navigate', target: '/profile'}
  
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_blog_articles_published ON blog_articles(is_published, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_blog_articles_slug ON blog_articles(slug);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON notifications(user_id, is_read);

COMMENT ON TABLE blog_articles IS 'Blog articles and educational content';
COMMENT ON TABLE notifications IS 'User notifications';

DO $$
BEGIN
  RAISE NOTICE '✅ Migration 009: Blog and Notifications tables created';
END $$;

