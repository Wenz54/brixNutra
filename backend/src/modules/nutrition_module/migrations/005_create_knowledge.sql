-- Migration 005: Knowledge Module
-- Courses, Lessons, Categories, User Progress

-- Categories for courses and content
CREATE TABLE IF NOT EXISTS knowledge_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  icon VARCHAR(50),
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Courses
CREATE TABLE IF NOT EXISTS courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  image_url VARCHAR(500),
  author VARCHAR(100),
  
  -- Pricing
  is_paid BOOLEAN DEFAULT FALSE,
  price DECIMAL(10,2),
  
  -- Meta
  duration VARCHAR(50), -- "4 weeks", "10 hours"
  difficulty VARCHAR(20), -- beginner, intermediate, advanced
  category_id UUID REFERENCES knowledge_categories(id) ON DELETE SET NULL,
  
  -- Publishing
  order_index INTEGER DEFAULT 0,
  is_published BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMP,
  
  -- Stats
  total_lessons INTEGER DEFAULT 0,
  total_duration_minutes INTEGER DEFAULT 0,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Lessons
CREATE TABLE IF NOT EXISTS lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  description TEXT,
  
  -- Order
  order_index INTEGER NOT NULL,
  
  -- Content
  type VARCHAR(20) NOT NULL, -- video, text, audio, quiz
  content TEXT, -- URL or Markdown
  video_url VARCHAR(500),
  duration_minutes INTEGER DEFAULT 0,
  
  -- Materials
  materials JSONB, -- [{name: "PDF", url: "..."}]
  
  -- Publishing
  is_published BOOLEAN DEFAULT FALSE,
  is_free BOOLEAN DEFAULT FALSE, -- Free preview lesson
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (course_id, slug)
);

-- User lesson progress
CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP,
  
  -- Progress tracking
  progress_percent INTEGER DEFAULT 0, -- 0-100
  last_position INTEGER DEFAULT 0, -- For video/audio (seconds)
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (user_id, lesson_id)
);

-- User course progress (aggregated)
CREATE TABLE IF NOT EXISTS user_course_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  
  completed_lessons INTEGER DEFAULT 0,
  total_lessons INTEGER DEFAULT 0,
  progress_percent INTEGER DEFAULT 0,
  
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP,
  
  last_lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
  last_accessed_at TIMESTAMP DEFAULT NOW(),
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (user_id, course_id)
);

-- User favorites
CREATE TABLE IF NOT EXISTS user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- What is favorited
  item_type VARCHAR(50) NOT NULL, -- course, lesson, recipe, article
  item_id UUID NOT NULL,
  
  created_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (user_id, item_type, item_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_courses_category ON courses(category_id);
CREATE INDEX IF NOT EXISTS idx_courses_published ON courses(is_published, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_lessons_course ON lessons(course_id, order_index);
CREATE INDEX IF NOT EXISTS idx_user_lesson_progress_user ON user_lesson_progress(user_id, course_id);
CREATE INDEX IF NOT EXISTS idx_user_course_progress_user ON user_course_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_user ON user_favorites(user_id, item_type);

-- Comments
COMMENT ON TABLE knowledge_categories IS 'Categories for courses and knowledge content';
COMMENT ON TABLE courses IS 'Educational courses';
COMMENT ON TABLE lessons IS 'Lessons within courses';
COMMENT ON TABLE user_lesson_progress IS 'User progress tracking for individual lessons';
COMMENT ON TABLE user_course_progress IS 'Aggregated course progress';
COMMENT ON TABLE user_favorites IS 'User bookmarks/favorites';

COMMENT ON COLUMN courses.is_paid IS 'Whether course requires payment';
COMMENT ON COLUMN lessons.is_free IS 'Free preview lesson (even if course is paid)';
COMMENT ON COLUMN lessons.materials IS 'Downloadable materials as JSON array';

-- Function to update course stats
CREATE OR REPLACE FUNCTION update_course_stats()
RETURNS TRIGGER AS $$
BEGIN
  -- Update total lessons and duration
  UPDATE courses
  SET 
    total_lessons = (
      SELECT COUNT(*) FROM lessons 
      WHERE course_id = NEW.course_id AND is_published = true
    ),
    total_duration_minutes = (
      SELECT COALESCE(SUM(duration_minutes), 0) FROM lessons
      WHERE course_id = NEW.course_id AND is_published = true
    )
  WHERE id = NEW.course_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update course stats
CREATE TRIGGER trigger_update_course_stats
AFTER INSERT OR UPDATE ON lessons
FOR EACH ROW
EXECUTE FUNCTION update_course_stats();

-- Function to update user course progress
CREATE OR REPLACE FUNCTION update_user_course_progress()
RETURNS TRIGGER AS $$
DECLARE
  v_total_lessons INTEGER;
  v_completed_lessons INTEGER;
  v_progress_percent INTEGER;
BEGIN
  -- Get total lessons in course
  SELECT COUNT(*) INTO v_total_lessons
  FROM lessons
  WHERE course_id = NEW.course_id AND is_published = true;
  
  -- Get completed lessons
  SELECT COUNT(*) INTO v_completed_lessons
  FROM user_lesson_progress
  WHERE user_id = NEW.user_id 
    AND course_id = NEW.course_id 
    AND is_completed = true;
  
  -- Calculate progress
  IF v_total_lessons > 0 THEN
    v_progress_percent := (v_completed_lessons * 100) / v_total_lessons;
  ELSE
    v_progress_percent := 0;
  END IF;
  
  -- Insert or update user_course_progress
  INSERT INTO user_course_progress (
    user_id,
    course_id,
    completed_lessons,
    total_lessons,
    progress_percent,
    is_completed,
    completed_at,
    last_lesson_id,
    last_accessed_at
  )
  VALUES (
    NEW.user_id,
    NEW.course_id,
    v_completed_lessons,
    v_total_lessons,
    v_progress_percent,
    (v_completed_lessons >= v_total_lessons AND v_total_lessons > 0),
    CASE WHEN v_completed_lessons >= v_total_lessons AND v_total_lessons > 0 THEN NOW() ELSE NULL END,
    NEW.lesson_id,
    NOW()
  )
  ON CONFLICT (user_id, course_id) DO UPDATE SET
    completed_lessons = v_completed_lessons,
    total_lessons = v_total_lessons,
    progress_percent = v_progress_percent,
    is_completed = (v_completed_lessons >= v_total_lessons AND v_total_lessons > 0),
    completed_at = CASE WHEN v_completed_lessons >= v_total_lessons AND v_total_lessons > 0 THEN NOW() ELSE NULL END,
    last_lesson_id = NEW.lesson_id,
    last_accessed_at = NOW(),
    updated_at = NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update course progress
CREATE TRIGGER trigger_update_user_course_progress
AFTER INSERT OR UPDATE ON user_lesson_progress
FOR EACH ROW
EXECUTE FUNCTION update_user_course_progress();

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 005: Knowledge tables created';
  RAISE NOTICE '   - knowledge_categories';
  RAISE NOTICE '   - courses';
  RAISE NOTICE '   - lessons';
  RAISE NOTICE '   - user_lesson_progress';
  RAISE NOTICE '   - user_course_progress';
  RAISE NOTICE '   - user_favorites';
  RAISE NOTICE '   - Auto-update triggers installed';
END $$;

