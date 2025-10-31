-- Seed data for meal plan
-- Test meal plan for Brix Nutrition with 7 days

-- Insert meal plan
INSERT INTO meal_plans (
  id,
  name, 
  description,
  target_calories,
  target_protein,
  target_carbs,
  target_fats,
  duration_days,
  is_premium,
  is_vegetarian
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Сбалансированный план на неделю',
  'Здоровое питание с разнообразными рецептами',
  1800, 
  90,
  200,
  60,
  7,
  FALSE,
  FALSE
);

-- Get recipe IDs (assuming they were created by seed-recipes.sql)
-- Day 1
INSERT INTO meal_plan_days (id, meal_plan_id, day_number) 
VALUES ('22222222-0001-0001-0001-000000000001', '11111111-1111-1111-1111-111111111111', 1);

-- Day 1: Breakfast - Овсянка (first recipe from seed-recipes.sql)
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index,
  importance_note
) 
SELECT 
  '22222222-0001-0001-0001-000000000001',
  id,
  'breakfast',
  '08:00',
  300,
  1,
  'Полезный завтрак для энергии'
FROM recipes WHERE name LIKE '%Овсянка%' LIMIT 1;

-- Day 1: Lunch - Куриная грудка
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0001-0001-0001-000000000001',
  id,
  'lunch',
  '13:00',
  400,
  2
FROM recipes WHERE name LIKE '%Куриная грудка%' LIMIT 1;

-- Day 1: Dinner - Греческий салат
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0001-0001-0001-000000000001',
  id,
  'dinner',
  '19:00',
  350,
  3
FROM recipes WHERE name LIKE '%Греческий салат%' LIMIT 1;

-- Day 2
INSERT INTO meal_plan_days (id, meal_plan_id, day_number) 
VALUES ('22222222-0002-0002-0002-000000000002', '11111111-1111-1111-1111-111111111111', 2);

-- Day 2: Breakfast - Смузи боул
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0002-0002-0002-000000000002',
  id,
  'breakfast',
  '08:00',
  350,
  1
FROM recipes WHERE name LIKE '%Смузи%' LIMIT 1;

-- Day 2: Lunch - Куриная грудка (repeated)
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0002-0002-0002-000000000002',
  id,
  'lunch',
  '13:00',
  400,
  2
FROM recipes WHERE name LIKE '%Куриная грудка%' LIMIT 1;

-- Day 2: Dinner - Греческий салат
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0002-0002-0002-000000000002',
  id,
  'dinner',
  '19:00',
  350,
  3
FROM recipes WHERE name LIKE '%Греческий салат%' LIMIT 1;

-- Day 3
INSERT INTO meal_plan_days (id, meal_plan_id, day_number) 
VALUES ('22222222-0003-0003-0003-000000000003', '11111111-1111-1111-1111-111111111111', 3);

-- Day 3: Breakfast - Омлет
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0003-0003-0003-000000000003',
  id,
  'breakfast',
  '08:00',
  300,
  1
FROM recipes WHERE name LIKE '%Омлет%' LIMIT 1;

-- Day 3: Lunch - Куриная грудка
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0003-0003-0003-000000000003',
  id,
  'lunch',
  '13:00',
  400,
  2
FROM recipes WHERE name LIKE '%Куриная грудка%' LIMIT 1;

-- Day 3: Dinner - Греческий салат
INSERT INTO meal_plan_slots (
  meal_plan_day_id, 
  recipe_id, 
  meal_type, 
  time_of_day, 
  portion_grams,
  order_index
) 
SELECT 
  '22222222-0003-0003-0003-000000000003',
  id,
  'dinner',
  '19:00',
  350,
  3
FROM recipes WHERE name LIKE '%Греческий салат%' LIMIT 1;

-- Days 4-7 (simplified - using same pattern)
INSERT INTO meal_plan_days (id, meal_plan_id, day_number) VALUES 
  ('22222222-0004-0004-0004-000000000004', '11111111-1111-1111-1111-111111111111', 4),
  ('22222222-0005-0005-0005-000000000005', '11111111-1111-1111-1111-111111111111', 5),
  ('22222222-0006-0006-0006-000000000006', '11111111-1111-1111-1111-111111111111', 6),
  ('22222222-0007-0007-0007-000000000007', '11111111-1111-1111-1111-111111111111', 7);

-- Create a test user (if not exists)
INSERT INTO users (id, email, is_verified)
VALUES ('33333333-3333-3333-3333-333333333333', 'testuser@example.com', TRUE)
ON CONFLICT (email) DO NOTHING;

-- Assign meal plan to test user
INSERT INTO user_meal_plans (
  user_id, 
  meal_plan_id, 
  start_date, 
  end_date, 
  is_active,
  completed_days
)
VALUES (
  '33333333-3333-3333-3333-333333333333',
  '11111111-1111-1111-1111-111111111111',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '7 days',
  TRUE,
  2
)
ON CONFLICT (user_id, meal_plan_id, start_date) DO UPDATE
SET is_active = TRUE;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Meal plan seed data created!';
  RAISE NOTICE '   - 1 meal plan (7 days)';
  RAISE NOTICE '   - 7 day entries';
  RAISE NOTICE '   - 9 meal slots (days 1-3 detailed)';
  RAISE NOTICE '   - 1 test user assigned';
END $$;

