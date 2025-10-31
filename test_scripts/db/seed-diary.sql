-- Seed data for Diary module
-- Test diary entries for mock user

-- Ensure test user exists
INSERT INTO users (id, email, is_verified)
VALUES ('33333333-3333-3333-3333-333333333333', 'testuser@example.com', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Set daily goals for test user (today and yesterday)
INSERT INTO daily_stats (user_id, date, goal_calories, goal_protein, goal_carbs, goal_fats)
VALUES 
  ('33333333-3333-3333-3333-333333333333', CURRENT_DATE, 1800, 90, 200, 60),
  ('33333333-3333-3333-3333-333333333333', CURRENT_DATE - INTERVAL '1 day', 1800, 90, 200, 60)
ON CONFLICT (user_id, date) DO UPDATE SET
  goal_calories = EXCLUDED.goal_calories,
  goal_protein = EXCLUDED.goal_protein,
  goal_carbs = EXCLUDED.goal_carbs,
  goal_fats = EXCLUDED.goal_fats;

-- Today's diary entries
INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time,
  notes
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'breakfast',
  r.name,
  r.id,
  300,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE,
  '08:30',
  'Вкусно!'
FROM recipes r
WHERE r.meal_type = 'breakfast'
LIMIT 1;

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time,
  notes
)
VALUES
  (
    '33333333-3333-3333-3333-333333333333',
    'snack',
    'Яблоко',
    150,
    78,
    0.4,
    21,
    0.3,
    CURRENT_DATE,
    '11:00',
    'Перекус'
  );

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'lunch',
  r.name,
  r.id,
  400,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE,
  '13:30'
FROM recipes r
WHERE r.meal_type = 'lunch'
LIMIT 1;

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time
)
VALUES
  (
    '33333333-3333-3333-3333-333333333333',
    'afternoon_snack',
    'Орехи миндаль',
    30,
    173,
    6.4,
    6.4,
    15,
    CURRENT_DATE,
    '16:00'
  );

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time,
  notes
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'dinner',
  r.name,
  r.id,
  350,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE,
  '19:30',
  'Ужин был отличный'
FROM recipes r
WHERE r.meal_type = 'dinner'
LIMIT 1;

-- Yesterday's entries
INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'breakfast',
  r.name,
  r.id,
  300,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE - INTERVAL '1 day',
  '08:00'
FROM recipes r
WHERE r.meal_type = 'breakfast'
LIMIT 1 OFFSET 1;

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'lunch',
  r.name,
  r.id,
  400,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE - INTERVAL '1 day',
  '13:00'
FROM recipes r
WHERE r.meal_type = 'lunch'
LIMIT 1;

INSERT INTO diary_entries (
  user_id,
  meal_type,
  food_name,
  recipe_id,
  portion_grams,
  calories,
  protein,
  carbs,
  fats,
  meal_date,
  meal_time
)
SELECT
  '33333333-3333-3333-3333-333333333333',
  'dinner',
  r.name,
  r.id,
  350,
  r.calories,
  r.protein,
  r.carbs,
  r.fats,
  CURRENT_DATE - INTERVAL '1 day',
  '19:00'
FROM recipes r
WHERE r.meal_type = 'dinner'
LIMIT 1;

-- Water logs for today
INSERT INTO water_logs (user_id, amount_ml, log_date)
VALUES
  ('33333333-3333-3333-3333-333333333333', 250, CURRENT_DATE),
  ('33333333-3333-3333-3333-333333333333', 500, CURRENT_DATE),
  ('33333333-3333-3333-3333-333333333333', 300, CURRENT_DATE),
  ('33333333-3333-3333-3333-333333333333', 400, CURRENT_DATE);

-- Water logs for yesterday
INSERT INTO water_logs (user_id, amount_ml, log_date)
VALUES
  ('33333333-3333-3333-3333-333333333333', 500, CURRENT_DATE - INTERVAL '1 day'),
  ('33333333-3333-3333-3333-333333333333', 500, CURRENT_DATE - INTERVAL '1 day'),
  ('33333333-3333-3333-3333-333333333333', 300, CURRENT_DATE - INTERVAL '1 day');

-- Manually trigger recalculation to ensure daily_stats is accurate
SELECT recalculate_daily_stats('33333333-3333-3333-3333-333333333333', CURRENT_DATE);
SELECT recalculate_daily_stats('33333333-3333-3333-3333-333333333333', CURRENT_DATE - INTERVAL '1 day');

-- Mark yesterday as completed
UPDATE daily_stats
SET is_completed = TRUE, completed_at = CURRENT_TIMESTAMP
WHERE user_id = '33333333-3333-3333-3333-333333333333'
  AND date = CURRENT_DATE - INTERVAL '1 day';

-- Success message
DO $$
DECLARE
  today_total INTEGER;
  yesterday_total INTEGER;
  today_water INTEGER;
BEGIN
  -- Get today's totals
  SELECT COALESCE(total_calories, 0) INTO today_total
  FROM daily_stats
  WHERE user_id = '33333333-3333-3333-3333-333333333333'
    AND date = CURRENT_DATE;
  
  -- Get yesterday's totals
  SELECT COALESCE(total_calories, 0) INTO yesterday_total
  FROM daily_stats
  WHERE user_id = '33333333-3333-3333-3333-333333333333'
    AND date = CURRENT_DATE - INTERVAL '1 day';
  
  -- Get today's water
  SELECT COALESCE(SUM(amount_ml), 0) INTO today_water
  FROM water_logs
  WHERE user_id = '33333333-3333-3333-3333-333333333333'
    AND log_date = CURRENT_DATE;
  
  RAISE NOTICE '✅ Diary seed data created!';
  RAISE NOTICE '   - User: testuser@example.com';
  RAISE NOTICE '   - Today: 5 meals (% kcal)', today_total;
  RAISE NOTICE '   - Yesterday: 3 meals (% kcal, completed)', yesterday_total;
  RAISE NOTICE '   - Today water: % ml', today_water;
  RAISE NOTICE '   - Yesterday water: 1300 ml';
END $$;

