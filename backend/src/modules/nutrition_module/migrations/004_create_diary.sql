-- Migration 004: Diary Module
-- Food diary, meal logging, daily stats

-- Diary entries (logged meals/foods)
CREATE TABLE IF NOT EXISTS diary_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- What was eaten
  meal_type VARCHAR(50), -- breakfast, lunch, dinner, snack, etc.
  food_name VARCHAR(255) NOT NULL,
  
  -- Source (optional)
  recipe_id UUID REFERENCES recipes(id) ON DELETE SET NULL,
  meal_plan_slot_id UUID REFERENCES meal_plan_slots(id) ON DELETE SET NULL,
  
  -- Nutrition info
  portion_grams INTEGER,
  calories DECIMAL(8,2),
  protein DECIMAL(8,2),
  carbs DECIMAL(8,2),
  fats DECIMAL(8,2),
  
  -- When
  logged_at TIMESTAMP NOT NULL DEFAULT NOW(),
  meal_date DATE NOT NULL, -- The date this meal belongs to
  meal_time TIME,
  
  -- Notes
  notes TEXT,
  image_url VARCHAR(500),
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Daily stats aggregation (for performance)
CREATE TABLE IF NOT EXISTS daily_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  date DATE NOT NULL,
  
  -- Totals for the day
  total_calories DECIMAL(10,2) DEFAULT 0,
  total_protein DECIMAL(10,2) DEFAULT 0,
  total_carbs DECIMAL(10,2) DEFAULT 0,
  total_fats DECIMAL(10,2) DEFAULT 0,
  
  -- Meal counts
  breakfast_count INTEGER DEFAULT 0,
  lunch_count INTEGER DEFAULT 0,
  dinner_count INTEGER DEFAULT 0,
  snack_count INTEGER DEFAULT 0,
  
  -- Goals (from user profile or meal plan)
  goal_calories DECIMAL(10,2),
  goal_protein DECIMAL(10,2),
  goal_carbs DECIMAL(10,2),
  goal_fats DECIMAL(10,2),
  
  -- Completion
  is_completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMP,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  -- Unique constraint: one row per user per day
  UNIQUE (user_id, date)
);

-- Water intake tracking
CREATE TABLE IF NOT EXISTS water_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- Amount
  amount_ml INTEGER NOT NULL,
  
  -- When
  logged_at TIMESTAMP NOT NULL DEFAULT NOW(),
  log_date DATE NOT NULL,
  
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_diary_entries_user_date ON diary_entries(user_id, meal_date DESC);
CREATE INDEX IF NOT EXISTS idx_diary_entries_user_logged ON diary_entries(user_id, logged_at DESC);
CREATE INDEX IF NOT EXISTS idx_daily_stats_user_date ON daily_stats(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_water_logs_user_date ON water_logs(user_id, log_date DESC);

-- Comments
COMMENT ON TABLE diary_entries IS 'User food diary - logged meals and foods';
COMMENT ON TABLE daily_stats IS 'Aggregated daily nutrition stats for performance';
COMMENT ON TABLE water_logs IS 'Water intake tracking';

COMMENT ON COLUMN diary_entries.meal_date IS 'The calendar date this meal belongs to (not when it was logged)';
COMMENT ON COLUMN diary_entries.logged_at IS 'When user logged this entry';
COMMENT ON COLUMN diary_entries.recipe_id IS 'If from a recipe/meal plan';
COMMENT ON COLUMN diary_entries.meal_plan_slot_id IS 'If from meal plan slot';

COMMENT ON COLUMN daily_stats.is_completed IS 'Did user mark this day as complete';
COMMENT ON COLUMN daily_stats.goal_calories IS 'Daily goal (from profile or active meal plan)';

-- Function to update daily_stats when diary entry is added
CREATE OR REPLACE FUNCTION update_daily_stats()
RETURNS TRIGGER AS $$
BEGIN
  -- Insert or update daily_stats
  INSERT INTO daily_stats (user_id, date, total_calories, total_protein, total_carbs, total_fats)
  VALUES (
    NEW.user_id,
    NEW.meal_date,
    COALESCE(NEW.calories, 0),
    COALESCE(NEW.protein, 0),
    COALESCE(NEW.carbs, 0),
    COALESCE(NEW.fats, 0)
  )
  ON CONFLICT (user_id, date) DO UPDATE SET
    total_calories = daily_stats.total_calories + COALESCE(NEW.calories, 0),
    total_protein = daily_stats.total_protein + COALESCE(NEW.protein, 0),
    total_carbs = daily_stats.total_carbs + COALESCE(NEW.carbs, 0),
    total_fats = daily_stats.total_fats + COALESCE(NEW.fats, 0),
    updated_at = NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update daily_stats
CREATE TRIGGER trigger_update_daily_stats
AFTER INSERT ON diary_entries
FOR EACH ROW
EXECUTE FUNCTION update_daily_stats();

-- Function to recalculate daily stats (for updates/deletes)
CREATE OR REPLACE FUNCTION recalculate_daily_stats(p_user_id UUID, p_date DATE)
RETURNS VOID AS $$
BEGIN
  -- Recalculate from scratch
  INSERT INTO daily_stats (
    user_id,
    date,
    total_calories,
    total_protein,
    total_carbs,
    total_fats,
    breakfast_count,
    lunch_count,
    dinner_count,
    snack_count
  )
  SELECT
    p_user_id,
    p_date,
    COALESCE(SUM(calories), 0),
    COALESCE(SUM(protein), 0),
    COALESCE(SUM(carbs), 0),
    COALESCE(SUM(fats), 0),
    COUNT(*) FILTER (WHERE meal_type = 'breakfast'),
    COUNT(*) FILTER (WHERE meal_type = 'lunch'),
    COUNT(*) FILTER (WHERE meal_type = 'dinner'),
    COUNT(*) FILTER (WHERE meal_type IN ('snack', 'afternoon_snack'))
  FROM diary_entries
  WHERE user_id = p_user_id AND meal_date = p_date
  ON CONFLICT (user_id, date) DO UPDATE SET
    total_calories = EXCLUDED.total_calories,
    total_protein = EXCLUDED.total_protein,
    total_carbs = EXCLUDED.total_carbs,
    total_fats = EXCLUDED.total_fats,
    breakfast_count = EXCLUDED.breakfast_count,
    lunch_count = EXCLUDED.lunch_count,
    dinner_count = EXCLUDED.dinner_count,
    snack_count = EXCLUDED.snack_count,
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 004: Diary tables created';
  RAISE NOTICE '   - diary_entries (food logs)';
  RAISE NOTICE '   - daily_stats (aggregated)';
  RAISE NOTICE '   - water_logs';
  RAISE NOTICE '   - Auto-update trigger installed';
END $$;

