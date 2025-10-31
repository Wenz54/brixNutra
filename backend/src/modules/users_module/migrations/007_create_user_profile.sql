-- Migration 007: User Profile and Goals
-- User profiles, goals, measurements tracking

-- User profiles (extended user info)
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  
  -- Personal info
  full_name VARCHAR(255),
  date_of_birth DATE,
  gender VARCHAR(20), -- male, female, other
  avatar_url VARCHAR(500),
  
  -- Physical measurements
  height_cm INTEGER,
  current_weight_kg DECIMAL(5,2),
  target_weight_kg DECIMAL(5,2),
  
  -- Activity level
  activity_level VARCHAR(50), -- sedentary, lightly_active, moderately_active, very_active, extra_active
  
  -- Health info
  allergies JSONB, -- ["gluten", "lactose"]
  dietary_preferences JSONB, -- ["vegetarian", "vegan"]
  medical_conditions JSONB, -- ["diabetes", "hypertension"]
  
  -- Calculated values
  bmi DECIMAL(4,2),
  bmr INTEGER, -- Basal Metabolic Rate
  tdee INTEGER, -- Total Daily Energy Expenditure
  
  -- Settings
  preferred_language VARCHAR(10) DEFAULT 'ru',
  timezone VARCHAR(50) DEFAULT 'Europe/Moscow',
  notifications_enabled BOOLEAN DEFAULT TRUE,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- User goals
CREATE TABLE IF NOT EXISTS user_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- Goal type
  goal_type VARCHAR(50) NOT NULL, -- weight_loss, weight_gain, muscle_gain, maintenance, health_improvement
  
  -- Nutrition goals
  daily_calories INTEGER,
  daily_protein INTEGER,
  daily_carbs INTEGER,
  daily_fats INTEGER,
  daily_water_ml INTEGER DEFAULT 2000,
  
  -- Weight goals
  target_weight_kg DECIMAL(5,2),
  target_date DATE,
  weekly_goal_kg DECIMAL(4,2), -- e.g., -0.5 kg per week
  
  -- Activity goals
  weekly_workouts INTEGER,
  daily_steps INTEGER,
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  started_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP,
  
  -- Progress
  progress_percent INTEGER DEFAULT 0,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Weight measurements
CREATE TABLE IF NOT EXISTS user_measurements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- Measurements
  weight_kg DECIMAL(5,2) NOT NULL,
  body_fat_percent DECIMAL(4,2),
  muscle_mass_kg DECIMAL(5,2),
  
  -- Body measurements (optional)
  waist_cm DECIMAL(5,2),
  chest_cm DECIMAL(5,2),
  hips_cm DECIMAL(5,2),
  
  -- Calculated
  bmi DECIMAL(4,2),
  
  -- When
  measured_at TIMESTAMP NOT NULL DEFAULT NOW(),
  
  -- Notes
  notes TEXT,
  photo_url VARCHAR(500),
  
  created_at TIMESTAMP DEFAULT NOW()
);

-- Activity logs
CREATE TABLE IF NOT EXISTS user_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  
  -- Activity
  activity_type VARCHAR(50) NOT NULL, -- workout, walk, run, yoga, etc.
  activity_name VARCHAR(255),
  duration_minutes INTEGER NOT NULL,
  
  -- Calories burned
  calories_burned INTEGER,
  
  -- Details
  distance_km DECIMAL(5,2),
  steps INTEGER,
  intensity VARCHAR(20), -- low, moderate, high
  
  -- When
  activity_date DATE NOT NULL,
  activity_time TIME,
  
  -- Notes
  notes TEXT,
  
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_user_profiles_user ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_goals_user ON user_goals(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_user_measurements_user ON user_measurements(user_id, measured_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_activities_user ON user_activities(user_id, activity_date DESC);

-- Comments
COMMENT ON TABLE user_profiles IS 'Extended user information and settings';
COMMENT ON TABLE user_goals IS 'User health and fitness goals';
COMMENT ON TABLE user_measurements IS 'Weight and body measurements tracking';
COMMENT ON TABLE user_activities IS 'Physical activity logs';

COMMENT ON COLUMN user_profiles.bmi IS 'Body Mass Index = weight / (height^2)';
COMMENT ON COLUMN user_profiles.bmr IS 'Basal Metabolic Rate (calories at rest)';
COMMENT ON COLUMN user_profiles.tdee IS 'Total Daily Energy Expenditure';

-- Function to calculate BMI
CREATE OR REPLACE FUNCTION calculate_bmi(weight_kg DECIMAL, height_cm INTEGER)
RETURNS DECIMAL(4,2) AS $$
BEGIN
  IF height_cm IS NULL OR height_cm = 0 OR weight_kg IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN ROUND((weight_kg / ((height_cm / 100.0) * (height_cm / 100.0)))::numeric, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to calculate BMR (Mifflin-St Jeor Equation)
CREATE OR REPLACE FUNCTION calculate_bmr(weight_kg DECIMAL, height_cm INTEGER, age INTEGER, gender VARCHAR)
RETURNS INTEGER AS $$
DECLARE
  bmr DECIMAL;
BEGIN
  IF weight_kg IS NULL OR height_cm IS NULL OR age IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Base calculation: 10 * weight + 6.25 * height - 5 * age
  bmr := (10 * weight_kg) + (6.25 * height_cm) - (5 * age);
  
  -- Gender adjustment
  IF gender = 'male' THEN
    bmr := bmr + 5;
  ELSIF gender = 'female' THEN
    bmr := bmr - 161;
  ELSE
    bmr := bmr - 78; -- average
  END IF;
  
  RETURN ROUND(bmr);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function to calculate TDEE
CREATE OR REPLACE FUNCTION calculate_tdee(bmr INTEGER, activity_level VARCHAR)
RETURNS INTEGER AS $$
DECLARE
  multiplier DECIMAL;
BEGIN
  IF bmr IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Activity multipliers
  CASE activity_level
    WHEN 'sedentary' THEN multiplier := 1.2;
    WHEN 'lightly_active' THEN multiplier := 1.375;
    WHEN 'moderately_active' THEN multiplier := 1.55;
    WHEN 'very_active' THEN multiplier := 1.725;
    WHEN 'extra_active' THEN multiplier := 1.9;
    ELSE multiplier := 1.2;
  END CASE;
  
  RETURN ROUND(bmr * multiplier);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger to auto-update BMI in profile
CREATE OR REPLACE FUNCTION update_profile_calculations()
RETURNS TRIGGER AS $$
DECLARE
  age INTEGER;
BEGIN
  -- Calculate age from date_of_birth
  IF NEW.date_of_birth IS NOT NULL THEN
    age := EXTRACT(YEAR FROM AGE(NEW.date_of_birth));
  ELSE
    age := 30; -- default
  END IF;
  
  -- Calculate BMI
  NEW.bmi := calculate_bmi(NEW.current_weight_kg, NEW.height_cm);
  
  -- Calculate BMR
  NEW.bmr := calculate_bmr(NEW.current_weight_kg, NEW.height_cm, age, NEW.gender);
  
  -- Calculate TDEE
  NEW.tdee := calculate_tdee(NEW.bmr, NEW.activity_level);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_profile_calculations
BEFORE INSERT OR UPDATE ON user_profiles
FOR EACH ROW
EXECUTE FUNCTION update_profile_calculations();

-- Trigger to auto-update BMI in measurements
CREATE OR REPLACE FUNCTION update_measurement_bmi()
RETURNS TRIGGER AS $$
DECLARE
  height_cm INTEGER;
BEGIN
  -- Get user's height
  SELECT up.height_cm INTO height_cm
  FROM user_profiles up
  WHERE up.user_id = NEW.user_id;
  
  -- Calculate BMI
  NEW.bmi := calculate_bmi(NEW.weight_kg, height_cm);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_measurement_bmi
BEFORE INSERT ON user_measurements
FOR EACH ROW
EXECUTE FUNCTION update_measurement_bmi();

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration 007: User Profile tables created';
  RAISE NOTICE '   - user_profiles (extended info + calculations)';
  RAISE NOTICE '   - user_goals (health and fitness goals)';
  RAISE NOTICE '   - user_measurements (weight tracking)';
  RAISE NOTICE '   - user_activities (activity logs)';
  RAISE NOTICE '   - Auto-calculation triggers installed (BMI, BMR, TDEE)';
END $$;

