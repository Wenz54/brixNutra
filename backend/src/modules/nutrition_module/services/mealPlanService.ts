import { FastifyInstance } from 'fastify';
import { MealPlan, MealPlanSlot, UserMealPlan } from '../types/index.js';

export class MealPlanService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Get user's active meal plan
   */
  async getUserActivePlan(userId: string): Promise<{
    plan: MealPlan;
    userPlan: UserMealPlan;
    progress: number;
  } | null> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT 
        ump.id as user_plan_id,
        ump.start_date,
        ump.end_date,
        ump.is_active,
        ump.completed_days,
        mp.id,
        mp.name,
        mp.description,
        mp.image_url,
        mp.target_calories,
        mp.target_protein,
        mp.target_carbs,
        mp.target_fats,
        mp.duration_days,
        mp.is_premium,
        mp.is_vegetarian,
        mp.is_vegan,
        mp.is_gluten_free
      FROM user_meal_plans ump
      INNER JOIN meal_plans mp ON ump.meal_plan_id = mp.id
      WHERE ump.user_id = $1 
        AND ump.is_active = true
      ORDER BY ump.start_date DESC
      LIMIT 1
    `;

    const result = await db.query(query, [userId]);

    if (result.rows.length === 0) {
      return null;
    }

    const row = result.rows[0];

    const plan: MealPlan = {
      id: row.id,
      name: row.name,
      description: row.description,
      image_url: row.image_url,
      target_calories: row.target_calories,
      target_protein: row.target_protein,
      target_carbs: row.target_carbs,
      target_fats: row.target_fats,
      duration_days: row.duration_days,
      is_premium: row.is_premium,
      is_vegetarian: row.is_vegetarian,
      is_vegan: row.is_vegan,
      is_gluten_free: row.is_gluten_free,
    };

    const userPlan: UserMealPlan = {
      id: row.user_plan_id,
      user_id: userId,
      meal_plan_id: row.id,
      start_date: row.start_date,
      end_date: row.end_date,
      is_active: row.is_active,
      completed_days: row.completed_days || 0,
    };

    const progress = row.duration_days > 0 
      ? Math.round((row.completed_days / row.duration_days) * 100)
      : 0;

    this.fastify.log.info(`✅ Retrieved active plan for user ${userId}: ${plan.name}`);

    return {
      plan,
      userPlan,
      progress,
    };
  }

  /**
   * Get meal plan for a specific day
   * @param userId - User ID
   * @param date - Date in format YYYY-MM-DD
   */
  async getPlanForDay(userId: string, date: string): Promise<{
    date: string;
    dayNumber: number;
    meals: MealPlanSlot[];
    totalNutrition: {
      calories: number;
      protein: number;
      carbs: number;
      fats: number;
    };
  } | null> {
    const db = await import('../../database_module/connection.js');

    // Get user's active plan
    const activePlan = await this.getUserActivePlan(userId);
    
    if (!activePlan) {
      return null;
    }

    // Calculate day number based on start date
    const startDate = new Date(activePlan.userPlan.start_date);
    const targetDate = new Date(date);
    const diffTime = targetDate.getTime() - startDate.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    // Day number starts from 1
    const dayNumber = diffDays + 1;

    // If day number is out of range, return null
    if (dayNumber < 1 || dayNumber > (activePlan.plan.duration_days || 7)) {
      return null;
    }

    // Get meal slots for this day
    const query = `
      SELECT 
        mps.id,
        mps.meal_plan_day_id,
        mps.recipe_id,
        mps.meal_type,
        mps.time_of_day,
        mps.portion_grams,
        mps.order_index,
        mps.importance_note,
        r.name as recipe_name,
        r.description as recipe_description,
        r.image_url as recipe_image_url,
        r.prep_time,
        r.cook_time,
        r.calories,
        r.protein,
        r.carbs,
        r.fats,
        r.ingredients,
        r.instructions,
        r.tags,
        r.difficulty
      FROM meal_plan_days mpd
      INNER JOIN meal_plan_slots mps ON mpd.id = mps.meal_plan_day_id
      INNER JOIN recipes r ON mps.recipe_id = r.id
      WHERE mpd.meal_plan_id = $1 
        AND mpd.day_number = $2
      ORDER BY mps.order_index ASC, mps.time_of_day ASC
    `;

    const result = await db.query(query, [activePlan.plan.id, dayNumber]);

    const meals: MealPlanSlot[] = result.rows.map(row => ({
      id: row.id,
      meal_plan_day_id: row.meal_plan_day_id,
      recipe_id: row.recipe_id,
      meal_type: row.meal_type,
      time_of_day: row.time_of_day,
      portion_grams: row.portion_grams,
      order_index: row.order_index,
      importance_note: row.importance_note,
      recipe: {
        id: row.recipe_id,
        name: row.recipe_name,
        description: row.recipe_description,
        image_url: row.recipe_image_url,
        prep_time: row.prep_time,
        cook_time: row.cook_time,
        calories: row.calories,
        protein: row.protein,
        carbs: row.carbs,
        fats: row.fats,
        ingredients: row.ingredients,
        instructions: row.instructions,
        tags: row.tags,
        difficulty: row.difficulty,
      },
    }));

    // Calculate total nutrition
    const totalNutrition = meals.reduce(
      (acc, meal) => ({
        calories: acc.calories + (meal.recipe?.calories || 0),
        protein: acc.protein + (meal.recipe?.protein || 0),
        carbs: acc.carbs + (meal.recipe?.carbs || 0),
        fats: acc.fats + (meal.recipe?.fats || 0),
      }),
      { calories: 0, protein: 0, carbs: 0, fats: 0 }
    );

    this.fastify.log.info(`✅ Retrieved plan for day ${dayNumber} (${date}): ${meals.length} meals`);

    return {
      date,
      dayNumber,
      meals,
      totalNutrition,
    };
  }

  /**
   * Replace a meal in user's plan
   */
  async replaceMeal(
    userId: string,
    mealSlotId: string,
    newRecipeId: string
  ): Promise<{
    success: boolean;
    message: string;
    newRecipe?: any;
  }> {
    const db = await import('../../database_module/connection.js');

    // Get the original meal slot
    const slotQuery = `
      SELECT mps.*, r.meal_type, r.calories
      FROM meal_plan_slots mps
      INNER JOIN recipes r ON mps.recipe_id = r.id
      WHERE mps.id = $1
    `;

    const slotResult = await db.query(slotQuery, [mealSlotId]);

    if (slotResult.rows.length === 0) {
      return {
        success: false,
        message: 'Meal slot not found',
      };
    }

    const originalSlot = slotResult.rows[0];

    // Get the new recipe
    const recipeQuery = `
      SELECT id, name, meal_type, calories, protein, carbs, fats, image_url, description
      FROM recipes
      WHERE id = $1 AND is_published = true
    `;

    const recipeResult = await db.query(recipeQuery, [newRecipeId]);

    if (recipeResult.rows.length === 0) {
      return {
        success: false,
        message: 'New recipe not found',
      };
    }

    const newRecipe = recipeResult.rows[0];

    // Validate: same meal_type
    if (newRecipe.meal_type !== originalSlot.meal_type) {
      return {
        success: false,
        message: `Recipe meal type mismatch. Expected ${originalSlot.meal_type}, got ${newRecipe.meal_type}`,
      };
    }

    // Validate: similar calories (±20%)
    const caloriesDiff = Math.abs(newRecipe.calories - originalSlot.calories);
    const caloriesTolerance = originalSlot.calories * 0.2;

    if (caloriesDiff > caloriesTolerance) {
      return {
        success: false,
        message: `Calorie difference too large. Original: ${originalSlot.calories}, New: ${newRecipe.calories}`,
      };
    }

    // Save replacement
    const replaceQuery = `
      INSERT INTO user_meal_replacements (user_id, meal_plan_slot_id, original_recipe_id, replacement_recipe_id)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (user_id, meal_plan_slot_id) 
      DO UPDATE SET 
        replacement_recipe_id = $4,
        replaced_at = NOW()
      RETURNING id
    `;

    await db.query(replaceQuery, [userId, mealSlotId, originalSlot.recipe_id, newRecipeId]);

    this.fastify.log.info(`✅ User ${userId} replaced meal ${mealSlotId} with recipe ${newRecipeId}`);

    return {
      success: true,
      message: 'Meal replaced successfully',
      newRecipe,
    };
  }

  /**
   * Get user's meal replacements
   */
  async getUserReplacements(userId: string): Promise<any[]> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT 
        umr.id,
        umr.meal_plan_slot_id,
        umr.replaced_at,
        r.id as recipe_id,
        r.name as recipe_name,
        r.image_url,
        r.calories
      FROM user_meal_replacements umr
      INNER JOIN recipes r ON umr.replacement_recipe_id = r.id
      WHERE umr.user_id = $1
    `;

    const result = await db.query(query, [userId]);

    return result.rows;
  }

  /**
   * Assign a meal plan to user
   */
  async assignPlanToUser(
    userId: string,
    mealPlanId: string,
    startDate: string
  ): Promise<UserMealPlan> {
    const db = await import('../../database_module/connection.js');

    // Deactivate current active plan
    await db.query(
      `UPDATE user_meal_plans SET is_active = false WHERE user_id = $1 AND is_active = true`,
      [userId]
    );

    // Get plan duration
    const planQuery = `SELECT duration_days FROM meal_plans WHERE id = $1`;
    const planResult = await db.query(planQuery, [mealPlanId]);
    const durationDays = planResult.rows[0]?.duration_days || 7;

    // Calculate end date
    const start = new Date(startDate);
    const end = new Date(start);
    end.setDate(end.getDate() + durationDays);

    // Create new assignment
    const query = `
      INSERT INTO user_meal_plans (user_id, meal_plan_id, start_date, end_date, is_active)
      VALUES ($1, $2, $3, $4, true)
      RETURNING *
    `;

    const result = await db.query(query, [userId, mealPlanId, startDate, end.toISOString().split('T')[0]]);

    this.fastify.log.info(`✅ Assigned meal plan ${mealPlanId} to user ${userId}`);

    return result.rows[0];
  }
}

