-- Создание тестового пользователя
INSERT INTO users (id, email, phone, name, created_at) 
VALUES ('123e4567-e89b-12d3-a456-426614174000', 'test@example.com', '+79991234567', 'Test User', NOW()) 
ON CONFLICT (id) DO NOTHING;

-- Назначить тестовому пользователю план питания
INSERT INTO user_meal_plans (id, user_id, plan_id, start_date, status, created_at)
VALUES (gen_random_uuid(), '123e4567-e89b-12d3-a456-426614174000', 1, CURRENT_DATE, 'active', NOW())
ON CONFLICT DO NOTHING;

SELECT 'Test user created!' as result;




