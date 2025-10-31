-- Seed data for recipes
-- Test recipes for Brix Nutrition

-- Recipe 1: Овсянка с фруктами (Breakfast)
INSERT INTO recipes (
  name, description, image_url,
  prep_time, cook_time, servings,
  calories, protein, carbs, fats,
  instructions, ingredients,
  meal_type, tags,
  is_vegetarian, is_vegan, is_gluten_free,
  difficulty
) VALUES (
  'Овсянка с фруктами и орехами',
  'Полезный завтрак, богатый клетчаткой и витаминами',
  '/images/oatmeal.jpg',
  5, 10, 1,
  350, 12, 58, 8,
  '[
    {"step": 1, "text": "Залейте овсяные хлопья молоком в кастрюле"},
    {"step": 2, "text": "Варите на среднем огне 7-10 минут, помешивая"},
    {"step": 3, "text": "Нарежьте банан и яблоко"},
    {"step": 4, "text": "Добавьте фрукты и орехи в готовую кашу"},
    {"step": 5, "text": "По желанию добавьте мёд"}
  ]',
  '[
    {"name": "Овсяные хлопья", "amount": 50, "unit": "г"},
    {"name": "Молоко", "amount": 200, "unit": "мл"},
    {"name": "Банан", "amount": 1, "unit": "шт"},
    {"name": "Яблоко", "amount": 0.5, "unit": "шт"},
    {"name": "Грецкие орехи", "amount": 20, "unit": "г"},
    {"name": "Мёд", "amount": 1, "unit": "ст.л."}
  ]',
  'breakfast',
  ARRAY['завтрак', 'овсянка', 'фрукты', 'полезное'],
  TRUE, FALSE, TRUE,
  'easy'
);

-- Recipe 2: Куриная грудка с овощами (Lunch)
INSERT INTO recipes (
  name, description, image_url,
  prep_time, cook_time, servings,
  calories, protein, carbs, fats,
  instructions, ingredients,
  meal_type, tags,
  is_vegetarian, is_vegan, is_gluten_free,
  difficulty
) VALUES (
  'Куриная грудка на гриле с овощами',
  'Белковый обед с минимумом калорий',
  '/images/chicken-grill.jpg',
  10, 20, 1,
  420, 45, 25, 12,
  '[
    {"step": 1, "text": "Промойте и обсушите куриную грудку"},
    {"step": 2, "text": "Натрите специями и оливковым маслом"},
    {"step": 3, "text": "Разогрейте гриль до средней температуры"},
    {"step": 4, "text": "Жарьте курицу по 7-8 минут с каждой стороны"},
    {"step": 5, "text": "Нарежьте овощи и обжарьте на гриле 5 минут"},
    {"step": 6, "text": "Подавайте с гречкой"}
  ]',
  '[
    {"name": "Куриная грудка", "amount": 200, "unit": "г"},
    {"name": "Гречка", "amount": 60, "unit": "г"},
    {"name": "Брокколи", "amount": 100, "unit": "г"},
    {"name": "Болгарский перец", "amount": 80, "unit": "г"},
    {"name": "Оливковое масло", "amount": 1, "unit": "ст.л."},
    {"name": "Специи", "amount": 5, "unit": "г"}
  ]',
  'lunch',
  ARRAY['обед', 'курица', 'белок', 'пп'],
  FALSE, FALSE, TRUE,
  'medium'
);

-- Recipe 3: Греческий салат (Snack/Dinner)
INSERT INTO recipes (
  name, description, image_url,
  prep_time, cook_time, servings,
  calories, protein, carbs, fats,
  instructions, ingredients,
  meal_type, tags,
  is_vegetarian, is_vegan, is_gluten_free,
  difficulty
) VALUES (
  'Греческий салат с фетой',
  'Легкий салат с сыром и овощами',
  '/images/greek-salad.jpg',
  15, 0, 1,
  280, 12, 18, 18,
  '[
    {"step": 1, "text": "Нарежьте помидоры кубиками"},
    {"step": 2, "text": "Огурцы нарежьте полукольцами"},
    {"step": 3, "text": "Лук нарежьте тонкими кольцами"},
    {"step": 4, "text": "Добавьте оливки и фету кубиками"},
    {"step": 5, "text": "Заправьте оливковым маслом и лимонным соком"},
    {"step": 6, "text": "Посыпьте орегано"}
  ]',
  '[
    {"name": "Помидоры", "amount": 150, "unit": "г"},
    {"name": "Огурцы", "amount": 100, "unit": "г"},
    {"name": "Красный лук", "amount": 30, "unit": "г"},
    {"name": "Фета", "amount": 50, "unit": "г"},
    {"name": "Оливки", "amount": 30, "unit": "г"},
    {"name": "Оливковое масло", "amount": 2, "unit": "ст.л."},
    {"name": "Лимонный сок", "amount": 1, "unit": "ст.л."},
    {"name": "Орегано", "amount": 2, "unit": "г"}
  ]',
  'dinner',
  ARRAY['салат', 'овощи', 'средиземноморская кухня', 'лёгкое'],
  TRUE, FALSE, TRUE,
  'easy'
);

-- Recipe 4: Смузи боул (Breakfast)
INSERT INTO recipes (
  name, description, image_url,
  prep_time, cook_time, servings,
  calories, protein, carbs, fats,
  instructions, ingredients,
  meal_type, tags,
  is_vegetarian, is_vegan, is_gluten_free,
  difficulty
) VALUES (
  'Ягодный смузи боул',
  'Витаминный завтрак с ягодами и топпингами',
  '/images/smoothie-bowl.jpg',
  10, 0, 1,
  320, 10, 52, 9,
  '[
    {"step": 1, "text": "Смешайте замороженные ягоды с бананом в блендере"},
    {"step": 2, "text": "Добавьте йогурт и взбейте до однородности"},
    {"step": 3, "text": "Перелейте в миску"},
    {"step": 4, "text": "Украсьте свежими ягодами"},
    {"step": 5, "text": "Посыпьте гранолой и семенами чиа"}
  ]',
  '[
    {"name": "Замороженные ягоды", "amount": 150, "unit": "г"},
    {"name": "Банан", "amount": 1, "unit": "шт"},
    {"name": "Греческий йогурт", "amount": 100, "unit": "г"},
    {"name": "Гранола", "amount": 30, "unit": "г"},
    {"name": "Семена чиа", "amount": 1, "unit": "ч.л."},
    {"name": "Свежие ягоды", "amount": 50, "unit": "г"}
  ]',
  'breakfast',
  ARRAY['завтрак', 'смузи', 'ягоды', 'пп', 'быстро'],
  TRUE, FALSE, TRUE,
  'easy'
);

-- Recipe 5: Омлет с овощами (Breakfast)
INSERT INTO recipes (
  name, description, image_url,
  prep_time, cook_time, servings,
  calories, protein, carbs, fats,
  instructions, ingredients,
  meal_type, tags,
  is_vegetarian, is_vegan, is_gluten_free,
  difficulty
) VALUES (
  'Омлет с овощами и зеленью',
  'Белковый завтрак с овощами',
  '/images/omelette.jpg',
  5, 10, 1,
  280, 20, 8, 18,
  '[
    {"step": 1, "text": "Взбейте яйца с молоком"},
    {"step": 2, "text": "Нарежьте помидоры и перец"},
    {"step": 3, "text": "Обжарьте овощи на сковороде 3 минуты"},
    {"step": 4, "text": "Влейте яичную смесь"},
    {"step": 5, "text": "Готовьте под крышкой 5-7 минут"},
    {"step": 6, "text": "Посыпьте зеленью перед подачей"}
  ]',
  '[
    {"name": "Яйца", "amount": 3, "unit": "шт"},
    {"name": "Молоко", "amount": 50, "unit": "мл"},
    {"name": "Помидоры черри", "amount": 80, "unit": "г"},
    {"name": "Болгарский перец", "amount": 50, "unit": "г"},
    {"name": "Зелёный лук", "amount": 10, "unit": "г"},
    {"name": "Оливковое масло", "amount": 1, "unit": "ч.л."}
  ]',
  'breakfast',
  ARRAY['завтрак', 'омлет', 'яйца', 'белок', 'пп'],
  TRUE, FALSE, TRUE,
  'easy'
);

