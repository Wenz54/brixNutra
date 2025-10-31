-- Seed data for Knowledge module
-- Courses, lessons, categories

-- Insert categories
INSERT INTO knowledge_categories (id, name, slug, description, icon, order_index)
VALUES
  ('44444444-0001-0001-0001-000000000001', 'Основы питания', 'nutrition-basics', 'Базовые знания о правильном питании', '🍎', 1),
  ('44444444-0002-0002-0002-000000000002', 'Рецепты', 'recipes', 'Кулинарные курсы и мастер-классы', '👨‍🍳', 2),
  ('44444444-0003-0003-0003-000000000003', 'Спорт и фитнес', 'fitness', 'Тренировки и физическая активность', '💪', 3),
  ('44444444-0004-0004-0004-000000000004', 'Здоровье', 'health', 'Здоровый образ жизни', '❤️', 4)
ON CONFLICT (slug) DO NOTHING;

-- Insert free course: "Основы правильного питания"
INSERT INTO courses (
  id,
  title,
  slug,
  description,
  image_url,
  author,
  is_paid,
  duration,
  difficulty,
  category_id,
  order_index,
  is_published,
  published_at
)
VALUES (
  '55555555-0001-0001-0001-000000000001',
  'Основы правильного питания',
  'nutrition-basics-101',
  'Узнайте основы здорового питания, макронутриенты, калорийность и как составить сбалансированный рацион',
  'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
  'Мария Петрова',
  FALSE, -- free course
  '2 weeks',
  'beginner',
  '44444444-0001-0001-0001-000000000001',
  1,
  TRUE,
  NOW()
) ON CONFLICT (slug) DO NOTHING;

-- Lessons for "Основы правильного питания"
INSERT INTO lessons (id, course_id, title, slug, description, order_index, type, content, duration_minutes, is_published, is_free)
VALUES
  (
    '66666666-0001-0001-0001-000000000001',
    '55555555-0001-0001-0001-000000000001',
    'Введение: Что такое правильное питание?',
    'intro-nutrition',
    'Основные принципы здорового питания и почему это важно',
    1,
    'video',
    'https://www.youtube.com/watch?v=example1',
    15,
    TRUE,
    TRUE
  ),
  (
    '66666666-0002-0002-0002-000000000002',
    '55555555-0001-0001-0001-000000000001',
    'Макронутриенты: Белки, жиры, углеводы',
    'macronutrients',
    'Что такое белки, жиры и углеводы, и зачем они нужны организму',
    2,
    'text',
    '# Макронутриенты

## Белки
Белки - это строительный материал для нашего организма...

## Жиры
Жиры необходимы для усвоения витаминов...

## Углеводы
Углеводы - основной источник энергии...',
    20,
    TRUE,
    TRUE
  ),
  (
    '66666666-0003-0003-0003-000000000003',
    '55555555-0001-0001-0001-000000000001',
    'Калории и энергетический баланс',
    'calories-balance',
    'Как рассчитать свою норму калорий и зачем нужен дефицит/профицит',
    3,
    'video',
    'https://www.youtube.com/watch?v=example3',
    18,
    TRUE,
    FALSE
  ),
  (
    '66666666-0004-0004-0004-000000000004',
    '55555555-0001-0001-0001-000000000001',
    'Составление рациона',
    'meal-planning',
    'Практические советы по составлению сбалансированного меню',
    4,
    'text',
    '# Как составить рацион

1. Рассчитайте норму калорий
2. Распределите КБЖУ
3. Выберите продукты
4. Создайте меню на неделю',
    25,
    TRUE,
    FALSE
  ),
  (
    '66666666-0005-0005-0005-000000000005',
    '55555555-0001-0001-0001-000000000001',
    'Практика: Анализ своего рациона',
    'analyze-diet',
    'Практическое задание по анализу вашего текущего рациона',
    5,
    'text',
    '# Задание

Проанализируйте ваш рацион за последние 3 дня:
- Запишите все приёмы пищи
- Рассчитайте калорийность
- Определите КБЖУ
- Сделайте выводы',
    30,
    TRUE,
    FALSE
  )
ON CONFLICT (course_id, slug) DO NOTHING;

-- Insert paid course: "Здоровое питание для снижения веса"
INSERT INTO courses (
  id,
  title,
  slug,
  description,
  image_url,
  author,
  is_paid,
  price,
  duration,
  difficulty,
  category_id,
  order_index,
  is_published,
  published_at
)
VALUES (
  '55555555-0002-0002-0002-000000000002',
  'Здоровое питание для снижения веса',
  'weight-loss-nutrition',
  'Полный курс по снижению веса: питание, тренировки, психология',
  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
  'Анна Соколова',
  TRUE, -- paid course
  2999.00,
  '6 weeks',
  'intermediate',
  '44444444-0001-0001-0001-000000000001',
  2,
  TRUE,
  NOW()
) ON CONFLICT (slug) DO NOTHING;

-- Lessons for "Здоровое питание для снижения веса" (only first 2 as free preview)
INSERT INTO lessons (id, course_id, title, slug, description, order_index, type, content, video_url, duration_minutes, is_published, is_free)
VALUES
  (
    '66666666-0006-0006-0006-000000000006',
    '55555555-0002-0002-0002-000000000002',
    'Введение в курс',
    'intro-weight-loss',
    'О чём этот курс и что вас ждёт',
    1,
    'video',
    NULL,
    'https://www.youtube.com/watch?v=example-intro',
    10,
    TRUE,
    TRUE -- free preview
  ),
  (
    '66666666-0007-0007-0007-000000000007',
    '55555555-0002-0002-0002-000000000002',
    'Мифы о похудении',
    'weight-loss-myths',
    'Разбираем популярные мифы о снижении веса',
    2,
    'video',
    NULL,
    'https://www.youtube.com/watch?v=example-myths',
    20,
    TRUE,
    TRUE -- free preview
  ),
  (
    '66666666-0008-0008-0008-000000000008',
    '55555555-0002-0002-0002-000000000002',
    'Создание дефицита калорий',
    'calorie-deficit',
    'Как правильно создать дефицит калорий без вреда для здоровья',
    3,
    'video',
    NULL,
    'https://www.youtube.com/watch?v=example-deficit',
    25,
    TRUE,
    FALSE -- paid only
  )
ON CONFLICT (course_id, slug) DO NOTHING;

-- Insert progress for test user (first course, 2 lessons completed)
INSERT INTO user_lesson_progress (user_id, lesson_id, course_id, is_completed, completed_at, progress_percent)
VALUES
  (
    '33333333-3333-3333-3333-333333333333',
    '66666666-0001-0001-0001-000000000001',
    '55555555-0001-0001-0001-000000000001',
    TRUE,
    NOW() - INTERVAL '2 days',
    100
  ),
  (
    '33333333-3333-3333-3333-333333333333',
    '66666666-0002-0002-0002-000000000002',
    '55555555-0001-0001-0001-000000000001',
    TRUE,
    NOW() - INTERVAL '1 day',
    100
  )
ON CONFLICT (user_id, lesson_id) DO NOTHING;

-- Add to favorites
INSERT INTO user_favorites (user_id, item_type, item_id)
VALUES
  ('33333333-3333-3333-3333-333333333333', 'course', '55555555-0001-0001-0001-000000000001'),
  ('33333333-3333-3333-3333-333333333333', 'lesson', '66666666-0003-0003-0003-000000000003')
ON CONFLICT (user_id, item_type, item_id) DO NOTHING;

-- Success message
DO $$
DECLARE
  categories_count INTEGER;
  courses_count INTEGER;
  lessons_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO categories_count FROM knowledge_categories;
  SELECT COUNT(*) INTO courses_count FROM courses;
  SELECT COUNT(*) INTO lessons_count FROM lessons;
  
  RAISE NOTICE '✅ Knowledge seed data created!';
  RAISE NOTICE '   - % categories', categories_count;
  RAISE NOTICE '   - % courses (1 free, 1 paid)', courses_count;
  RAISE NOTICE '   - % lessons', lessons_count;
  RAISE NOTICE '   - Test user progress: 2 lessons completed';
  RAISE NOTICE '   - Test user favorites: 1 course, 1 lesson';
END $$;

