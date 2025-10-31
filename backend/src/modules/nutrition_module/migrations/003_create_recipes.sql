-- Migration 003: Create recipes and meal plans tables
-- Description: Tables for recipes, meal plans, ingredients for Brix Nutrition
-- Date: 2025-10-13

-- ============================================
-- RECIPES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS recipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url TEXT,
  prep_time INTEGER,  -- minutes
  cook_time INTEGER,  -- minutes
  servings INTEGER DEFAULT 1,
  
  -- Nutrition per serving
  calories INTEGER,
  protein DECIMAL(10,2),
  carbs DECIMAL(10,2),
  fats DECIMAL(10,2),
  
  -- Instructions
  instructions JSONB,  -- [{step: 1, text: "..."}]
  ingredients JSONB,   -- [{name: "...", amount: 100, unit: "g"}]
  
  -- Categorization
  meal_type VARCHAR(50) CHECK (meal_type IN ('wakeup', 'breakfast', 'snack', 'lunch', 'afternoon_snack', 'dinner', 'sleep')),
  tags TEXT[],
  
  -- Dietary flags
  is_vegetarian BOOLEAN DEFAULT FALSE,
  is_vegan BOOLEAN DEFAULT FALSE,
  is_gluten_free BOOLEAN DEFAULT FALSE,
  is_dairy_free BOOLEAN DEFAULT FALSE,
  
  -- Meta
  difficulty VARCHAR(20) CHECK (difficulty IN ('easy', 'medium', 'hard')),
  is_published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_recipes_meal_type ON recipes(meal_type);
CREATE INDEX idx_recipes_calories ON recipes(calories);
CREATE INDEX idx_recipes_tags ON recipes USING GIN(tags);
CREATE INDEX idx_recipes_vegetarian ON recipes(is_vegetarian) WHERE is_vegetarian = TRUE;
CREATE INDEX idx_recipes_vegan ON recipes(is_vegan) WHERE is_vegan = TRUE;
CREATE INDEX idx_recipes_published ON recipes(is_published) WHERE is_published = TRUE;

-- Comments
COMMENT ON TABLE recipes IS 'Recipes database for Brix Nutrition';
COMMENT ON COLUMN recipes.instructions IS 'Array of cooking steps in JSON format';
COMMENT ON COLUMN recipes.ingredients IS 'Array of ingredients with amounts in JSON format';
COMMENT ON COLUMN recipes.meal_type IS 'Type of meal: wakeup, breakfast, snack, lunch, afternoon_snack, dinner, sleep';

-- ============================================
-- MEAL PLANS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS meal_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_url TEXT,
  
  -- Nutrition targets per day
  target_calories INTEGER,
  target_protein DECIMAL(10,2),
  target_carbs DECIMAL(10,2),
  target_fats DECIMAL(10,2),
  
  -- Plan details
  duration_days INTEGER DEFAULT 7,
  is_premium BOOLEAN DEFAULT FALSE,
  
  -- Dietary flags
  is_vegetarian BOOLEAN DEFAULT FALSE,
  is_vegan BOOLEAN DEFAULT FALSE,
  is_gluten_free BOOLEAN DEFAULT FALSE,
  
  -- Meta
  is_published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_meal_plans_premium ON meal_plans(is_premium);
CREATE INDEX idx_meal_plans_published ON meal_plans(is_published) WHERE is_published = TRUE;

-- Comments
COMMENT ON TABLE meal_plans IS 'Meal plans for users';

-- ============================================
-- USER MEAL PLANS TABLE (Assignment)
-- ============================================
CREATE TABLE IF NOT EXISTS user_meal_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  meal_plan_id UUID NOT NULL REFERENCES meal_plans(id) ON DELETE CASCADE,
  
  -- Assignment details
  start_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN DEFAULT TRUE,
  
  -- Progress
  completed_days INTEGER DEFAULT 0,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(user_id, meal_plan_id, start_date)
);

-- Indexes
CREATE INDEX idx_user_meal_plans_user ON user_meal_plans(user_id);
CREATE INDEX idx_user_meal_plans_active ON user_meal_plans(user_id, is_active) WHERE is_active = TRUE;

-- Comments
COMMENT ON TABLE user_meal_plans IS 'Assignment of meal plans to users';

-- ============================================
-- MEAL PLAN DAYS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS meal_plan_days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_plan_id UUID NOT NULL REFERENCES meal_plans(id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL,  -- 1, 2, 3...
  
  -- Meta
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(meal_plan_id, day_number)
);

-- Indexes
CREATE INDEX idx_meal_plan_days_plan ON meal_plan_days(meal_plan_id);

-- Comments
COMMENT ON TABLE meal_plan_days IS 'Days in a meal plan';

-- ============================================
-- MEAL PLAN SLOTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS meal_plan_slots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_plan_day_id UUID NOT NULL REFERENCES meal_plan_days(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  
  -- Slot details
  meal_type VARCHAR(50) NOT NULL,
  time_of_day TIME,  -- e.g., 08:00
  portion_grams INTEGER,
  order_index INTEGER DEFAULT 0,  -- for sorting
  
  -- Optional info
  importance_note TEXT,  -- "Важно выпить утром" и т.д.
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_meal_plan_slots_day ON meal_plan_slots(meal_plan_day_id);
CREATE INDEX idx_meal_plan_slots_recipe ON meal_plan_slots(recipe_id);
CREATE INDEX idx_meal_plan_slots_type ON meal_plan_slots(meal_type);

-- Comments
COMMENT ON TABLE meal_plan_slots IS 'Individual meal slots in a meal plan day';
COMMENT ON COLUMN meal_plan_slots.portion_grams IS 'Portion size in grams';

-- ============================================
-- USER MEAL REPLACEMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS user_meal_replacements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  meal_plan_slot_id UUID NOT NULL REFERENCES meal_plan_slots(id) ON DELETE CASCADE,
  
  -- Replacement
  original_recipe_id UUID NOT NULL REFERENCES recipes(id),
  replacement_recipe_id UUID NOT NULL REFERENCES recipes(id),
  
  -- When replaced
  replaced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE(user_id, meal_plan_slot_id)
);

-- Indexes
CREATE INDEX idx_user_meal_replacements_user ON user_meal_replacements(user_id);

-- Comments
COMMENT ON TABLE user_meal_replacements IS 'User-specific recipe replacements in meal plans';

-- ============================================
-- SUPPLEMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS supplements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  dosage VARCHAR(100),  -- "500mg", "1 таблетка"
  time_of_day VARCHAR(50),  -- "утро", "вечер", "с едой"
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- MEAL PLAN SUPPLEMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS meal_plan_supplements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_plan_id UUID NOT NULL REFERENCES meal_plans(id) ON DELETE CASCADE,
  supplement_id UUID NOT NULL REFERENCES supplements(id) ON DELETE CASCADE,
  
  UNIQUE(meal_plan_id, supplement_id)
);

-- Indexes
CREATE INDEX idx_meal_plan_supplements_plan ON meal_plan_supplements(meal_plan_id);

-- Comments
COMMENT ON TABLE meal_plan_supplements IS 'Supplements included in meal plans';

-- ============================================
-- TRIGGERS
-- ============================================

-- Auto-update updated_at for recipes
CREATE TRIGGER trigger_recipes_updated_at
  BEFORE UPDATE ON recipes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at for meal_plans
CREATE TRIGGER trigger_meal_plans_updated_at
  BEFORE UPDATE ON meal_plans
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at for user_meal_plans
CREATE TRIGGER trigger_user_meal_plans_updated_at
  BEFORE UPDATE ON user_meal_plans
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SUCCESS
-- ============================================
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 003 completed successfully!';
  RAISE NOTICE '   - recipes table created';
  RAISE NOTICE '   - meal_plans table created';
  RAISE NOTICE '   - user_meal_plans table created';
  RAISE NOTICE '   - meal_plan_days table created';
  RAISE NOTICE '   - meal_plan_slots table created';
  RAISE NOTICE '   - user_meal_replacements table created';
  RAISE NOTICE '   - supplements tables created';
END $$;

