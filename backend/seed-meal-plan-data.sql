-- ========================================
-- Seed данные для плана питания Brix Nutrition
-- (как будто добавлено через админку)
-- ========================================

-- 1. Создать базовый план питания (7 дней)
INSERT INTO meal_plans (id, name, description, image_url, target_calories, target_protein, target_carbs, target_fats, duration_days, is_premium, is_vegetarian, is_vegan, is_gluten_free, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  'Сбалансированный рацион',
  'Здоровый и питательный план питания на неделю для поддержания веса и энергии',
  'https://images.unsplash.com/photo-1547496502-affa22d38842',
  2000,
  150.0,
  200.0,
  70.0,
  7,
  false,
  false,
  false,
  false,
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING
RETURNING id;

-- Сохраняем ID плана для дальнейшего использования
DO $$
DECLARE
  plan_id uuid;
  recipe_oatmeal uuid;
  recipe_salad uuid;
  recipe_chicken uuid;
  recipe_smoothie uuid;
  recipe_soup uuid;
BEGIN
  -- Получаем ID плана
  SELECT id INTO plan_id FROM meal_plans WHERE name = 'Сбалансированный рацион' LIMIT 1;

  -- 2. Создать рецепты для плана
  
  -- Завтрак: Овсяная каша с фруктами
  INSERT INTO recipes (id, name, description, meal_type, prep_time, calories, protein, carbs, fats, tags, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    'Овсяная каша с фруктами',
    'Полезный завтрак с медленными углеводами',
    'breakfast',
    15,
    350,
    12.0,
    55.0,
    8.0,
    ARRAY['завтрак', 'каша', 'фрукты'],
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING
  RETURNING id INTO recipe_oatmeal;

  -- Обед: Куриная грудка с овощами
  INSERT INTO recipes (id, name, description, meal_type, prep_time, calories, protein, carbs, fats, tags, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    'Куриная грудка с овощами',
    'Легкий белковый обед с клетчаткой',
    'lunch',
    30,
    450,
    45.0,
    35.0,
    12.0,
    ARRAY['обед', 'курица', 'овощи', 'белок'],
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING
  RETURNING id INTO recipe_chicken;

  -- Полдник: Зелёный смузи
  INSERT INTO recipes (id, name, description, meal_type, prep_time, calories, protein, carbs, fats, tags, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    'Зелёный смузи',
    'Витаминный напиток с шпинатом и фруктами',
    'snack',
    10,
    180,
    5.0,
    30.0,
    3.0,
    ARRAY['полдник', 'смузи', 'витамины'],
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING
  RETURNING id INTO recipe_smoothie;

  -- Ужин: Лосось с киноа
  INSERT INTO recipes (id, name, description, meal_type, prep_time, calories, protein, carbs, fats, tags, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    'Лосось с киноа',
    'Омега-3 и полезные жиры для ужина',
    'dinner',
    25,
    500,
    38.0,
    45.0,
    18.0,
    ARRAY['ужин', 'рыба', 'омега-3'],
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING
  RETURNING id INTO recipe_salad;

  -- Овощной суп
  INSERT INTO recipes (id, name, description, meal_type, prep_time, calories, protein, carbs, fats, tags, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    'Овощной суп',
    'Лёгкий суп с сезонными овощами',
    'lunch',
    20,
    220,
    8.0,
    35.0,
    5.0,
    ARRAY['обед', 'суп', 'овощи'],
    NOW(),
    NOW()
  ) ON CONFLICT (id) DO NOTHING
  RETURNING id INTO recipe_soup;

  -- 3. Создать расписание на 7 дней
  FOR day_num IN 1..7 LOOP
    DECLARE
      day_id uuid;
    BEGIN
      -- Вставить день и получить его ID
      INSERT INTO meal_plan_days (id, meal_plan_id, day_number, created_at)
      VALUES (gen_random_uuid(), plan_id, day_num, NOW())
      ON CONFLICT (meal_plan_id, day_number) DO UPDATE SET meal_plan_id = meal_plan_days.meal_plan_id
      RETURNING id INTO day_id;

      -- Если день уже существует, получить его ID
      IF day_id IS NULL THEN
        SELECT id INTO day_id FROM meal_plan_days WHERE meal_plan_id = plan_id AND day_number = day_num;
      END IF;

      -- Завтрак (8:00)
      INSERT INTO meal_plan_slots (id, meal_plan_day_id, recipe_id, time_of_day, meal_type, portion_grams, order_index, created_at, updated_at)
      VALUES (
        gen_random_uuid(),
        day_id,
        recipe_oatmeal,
        '08:00:00'::time,
        'breakfast',
        250,
        1,
        NOW(),
        NOW()
      );

      -- Перекус (11:00)
      INSERT INTO meal_plan_slots (id, meal_plan_day_id, recipe_id, time_of_day, meal_type, portion_grams, order_index, created_at, updated_at)
      VALUES (
        gen_random_uuid(),
        day_id,
        recipe_smoothie,
        '11:00:00'::time,
        'snack',
        300,
        2,
        NOW(),
        NOW()
      );

      -- Обед (14:00) - чередуем курицу и суп
      INSERT INTO meal_plan_slots (id, meal_plan_day_id, recipe_id, time_of_day, meal_type, portion_grams, order_index, created_at, updated_at)
      VALUES (
        gen_random_uuid(),
        day_id,
        CASE WHEN day_num % 2 = 0 THEN recipe_chicken ELSE recipe_soup END,
        '14:00:00'::time,
        'lunch',
        350,
        3,
        NOW(),
        NOW()
      );

      -- Ужин (19:00)
      INSERT INTO meal_plan_slots (id, meal_plan_day_id, recipe_id, time_of_day, meal_type, portion_grams, order_index, created_at, updated_at)
      VALUES (
        gen_random_uuid(),
        day_id,
        recipe_salad,
        '19:00:00'::time,
        'dinner',
        300,
        4,
        NOW(),
        NOW()
      );
    END;
  END LOOP;

  -- 4. Назначить план тестовому пользователю (удалить старые активные планы)
  DELETE FROM user_meal_plans 
  WHERE user_id = '123e4567-e89b-12d3-a456-426614174000' AND is_active = true;
  
  INSERT INTO user_meal_plans (id, user_id, meal_plan_id, start_date, end_date, is_active, completed_days, created_at, updated_at)
  VALUES (
    gen_random_uuid(),
    '123e4567-e89b-12d3-a456-426614174000',
    plan_id,
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '6 days',
    true,
    0,
    NOW(),
    NOW()
  );

  RAISE NOTICE 'Meal plan created successfully with ID: %', plan_id;
END $$;

SELECT 'Meal plan seed data loaded!' AS result;

