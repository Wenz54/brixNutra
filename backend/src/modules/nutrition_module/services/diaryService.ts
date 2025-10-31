import { FastifyInstance } from 'fastify';

export interface DiaryEntry {
  id: string;
  user_id: string;
  meal_type: string;
  food_name: string;
  recipe_id?: string;
  meal_plan_slot_id?: string;
  portion_grams?: number;
  calories?: number;
  protein?: number;
  carbs?: number;
  fats?: number;
  logged_at: Date;
  meal_date: string;
  meal_time?: string;
  notes?: string;
  image_url?: string;
}

export interface DailyStats {
  id: string;
  user_id: string;
  date: string;
  total_calories: number;
  total_protein: number;
  total_carbs: number;
  total_fats: number;
  breakfast_count: number;
  lunch_count: number;
  dinner_count: number;
  snack_count: number;
  goal_calories?: number;
  goal_protein?: number;
  goal_carbs?: number;
  goal_fats?: number;
  is_completed: boolean;
  progress?: {
    calories: number;
    protein: number;
    carbs: number;
    fats: number;
  };
}

export interface LogMealInput {
  meal_type: string;
  food_name: string;
  recipe_id?: string;
  meal_plan_slot_id?: string;
  portion_grams?: number;
  calories?: number;
  protein?: number;
  carbs?: number;
  fats?: number;
  meal_date: string; // YYYY-MM-DD
  meal_time?: string; // HH:MM
  notes?: string;
  image_url?: string;
}

export class DiaryService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Log a meal/food entry
   */
  async logMeal(userId: string, input: LogMealInput): Promise<DiaryEntry> {
    const db = await import('../../database_module/connection.js');

    // If recipe_id provided, fetch nutrition data
    let nutritionData = {
      calories: input.calories,
      protein: input.protein,
      carbs: input.carbs,
      fats: input.fats,
    };

    if (input.recipe_id && (!input.calories || !input.protein)) {
      const recipeQuery = `
        SELECT calories, protein, carbs, fats 
        FROM recipes 
        WHERE id = $1
      `;
      const recipeResult = await db.query(recipeQuery, [input.recipe_id]);
      
      if (recipeResult.rows.length > 0) {
        const recipe = recipeResult.rows[0];
        nutritionData = {
          calories: recipe.calories,
          protein: recipe.protein,
          carbs: recipe.carbs,
          fats: recipe.fats,
        };
      }
    }

    // Insert diary entry
    const query = `
      INSERT INTO diary_entries (
        user_id,
        meal_type,
        food_name,
        recipe_id,
        meal_plan_slot_id,
        portion_grams,
        calories,
        protein,
        carbs,
        fats,
        meal_date,
        meal_time,
        notes,
        image_url
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
      RETURNING *
    `;

    const values = [
      userId,
      input.meal_type,
      input.food_name,
      input.recipe_id || null,
      input.meal_plan_slot_id || null,
      input.portion_grams || null,
      nutritionData.calories || null,
      nutritionData.protein || null,
      nutritionData.carbs || null,
      nutritionData.fats || null,
      input.meal_date,
      input.meal_time || null,
      input.notes || null,
      input.image_url || null,
    ];

    const result = await db.query(query, values);

    this.fastify.log.info(`✅ Logged meal for user ${userId}: ${input.food_name} (${nutritionData.calories} kcal)`);

    return result.rows[0];
  }

  /**
   * Get daily stats for a specific date
   */
  async getDayStats(userId: string, date: string): Promise<{
    stats: DailyStats | null;
    entries: DiaryEntry[];
  }> {
    const db = await import('../../database_module/connection.js');

    // Get daily stats
    const statsQuery = `
      SELECT * FROM daily_stats
      WHERE user_id = $1 AND date = $2
    `;
    const statsResult = await db.query(statsQuery, [userId, date]);

    let stats: DailyStats | null = null;

    if (statsResult.rows.length > 0) {
      const row = statsResult.rows[0];
      stats = {
        id: row.id,
        user_id: row.user_id,
        date: row.date,
        total_calories: parseFloat(row.total_calories) || 0,
        total_protein: parseFloat(row.total_protein) || 0,
        total_carbs: parseFloat(row.total_carbs) || 0,
        total_fats: parseFloat(row.total_fats) || 0,
        breakfast_count: row.breakfast_count || 0,
        lunch_count: row.lunch_count || 0,
        dinner_count: row.dinner_count || 0,
        snack_count: row.snack_count || 0,
        goal_calories: row.goal_calories ? parseFloat(row.goal_calories) : undefined,
        goal_protein: row.goal_protein ? parseFloat(row.goal_protein) : undefined,
        goal_carbs: row.goal_carbs ? parseFloat(row.goal_carbs) : undefined,
        goal_fats: row.goal_fats ? parseFloat(row.goal_fats) : undefined,
        is_completed: row.is_completed || false,
      };

      // Calculate progress percentages
      if (stats.goal_calories) {
        stats.progress = {
          calories: Math.round((stats.total_calories / stats.goal_calories) * 100),
          protein: stats.goal_protein 
            ? Math.round((stats.total_protein / stats.goal_protein) * 100)
            : 0,
          carbs: stats.goal_carbs
            ? Math.round((stats.total_carbs / stats.goal_carbs) * 100)
            : 0,
          fats: stats.goal_fats
            ? Math.round((stats.total_fats / stats.goal_fats) * 100)
            : 0,
        };
      }
    }

    // Get entries for the day
    const entriesQuery = `
      SELECT * FROM diary_entries
      WHERE user_id = $1 AND meal_date = $2
      ORDER BY meal_time ASC NULLS LAST, logged_at ASC
    `;
    const entriesResult = await db.query(entriesQuery, [userId, date]);

    const entries: DiaryEntry[] = entriesResult.rows.map(row => ({
      id: row.id,
      user_id: row.user_id,
      meal_type: row.meal_type,
      food_name: row.food_name,
      recipe_id: row.recipe_id,
      meal_plan_slot_id: row.meal_plan_slot_id,
      portion_grams: row.portion_grams,
      calories: row.calories ? parseFloat(row.calories) : undefined,
      protein: row.protein ? parseFloat(row.protein) : undefined,
      carbs: row.carbs ? parseFloat(row.carbs) : undefined,
      fats: row.fats ? parseFloat(row.fats) : undefined,
      logged_at: row.logged_at,
      meal_date: row.meal_date,
      meal_time: row.meal_time,
      notes: row.notes,
      image_url: row.image_url,
    }));

    this.fastify.log.info(`✅ Retrieved day stats for ${date}: ${entries.length} entries`);

    return { stats, entries };
  }

  /**
   * Get history (range of dates)
   */
  async getHistory(
    userId: string,
    startDate: string,
    endDate: string
  ): Promise<DailyStats[]> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT * FROM daily_stats
      WHERE user_id = $1 
        AND date >= $2 
        AND date <= $3
      ORDER BY date DESC
    `;

    const result = await db.query(query, [userId, startDate, endDate]);

    const history: DailyStats[] = result.rows.map(row => ({
      id: row.id,
      user_id: row.user_id,
      date: row.date,
      total_calories: parseFloat(row.total_calories) || 0,
      total_protein: parseFloat(row.total_protein) || 0,
      total_carbs: parseFloat(row.total_carbs) || 0,
      total_fats: parseFloat(row.total_fats) || 0,
      breakfast_count: row.breakfast_count || 0,
      lunch_count: row.lunch_count || 0,
      dinner_count: row.dinner_count || 0,
      snack_count: row.snack_count || 0,
      goal_calories: row.goal_calories ? parseFloat(row.goal_calories) : undefined,
      goal_protein: row.goal_protein ? parseFloat(row.goal_protein) : undefined,
      goal_carbs: row.goal_carbs ? parseFloat(row.goal_carbs) : undefined,
      goal_fats: row.goal_fats ? parseFloat(row.goal_fats) : undefined,
      is_completed: row.is_completed || false,
    }));

    this.fastify.log.info(`✅ Retrieved history for user ${userId}: ${history.length} days`);

    return history;
  }

  /**
   * Delete diary entry
   */
  async deleteEntry(userId: string, entryId: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');

    // Get entry first to recalculate stats
    const getQuery = `
      SELECT meal_date FROM diary_entries 
      WHERE id = $1 AND user_id = $2
    `;
    const getResult = await db.query(getQuery, [entryId, userId]);

    if (getResult.rows.length === 0) {
      return false;
    }

    const mealDate = getResult.rows[0].meal_date;

    // Delete entry
    const deleteQuery = `
      DELETE FROM diary_entries 
      WHERE id = $1 AND user_id = $2
    `;
    await db.query(deleteQuery, [entryId, userId]);

    // Recalculate daily stats
    await db.query(`SELECT recalculate_daily_stats($1, $2)`, [userId, mealDate]);

    this.fastify.log.info(`✅ Deleted diary entry ${entryId} for user ${userId}`);

    return true;
  }

  /**
   * Update daily goals
   */
  async updateDailyGoals(
    userId: string,
    date: string,
    goals: {
      calories?: number;
      protein?: number;
      carbs?: number;
      fats?: number;
    }
  ): Promise<void> {
    const db = await import('../../database_module/connection.js');

    const query = `
      INSERT INTO daily_stats (user_id, date, goal_calories, goal_protein, goal_carbs, goal_fats)
      VALUES ($1, $2, $3, $4, $5, $6)
      ON CONFLICT (user_id, date) DO UPDATE SET
        goal_calories = COALESCE($3, daily_stats.goal_calories),
        goal_protein = COALESCE($4, daily_stats.goal_protein),
        goal_carbs = COALESCE($5, daily_stats.goal_carbs),
        goal_fats = COALESCE($6, daily_stats.goal_fats),
        updated_at = NOW()
    `;

    await db.query(query, [
      userId,
      date,
      goals.calories || null,
      goals.protein || null,
      goals.carbs || null,
      goals.fats || null,
    ]);

    this.fastify.log.info(`✅ Updated daily goals for user ${userId} on ${date}`);
  }

  /**
   * Log water intake
   */
  async logWater(userId: string, amountMl: number, date: string): Promise<void> {
    const db = await import('../../database_module/connection.js');

    const query = `
      INSERT INTO water_logs (user_id, amount_ml, log_date)
      VALUES ($1, $2, $3)
    `;

    await db.query(query, [userId, amountMl, date]);

    this.fastify.log.info(`✅ Logged ${amountMl}ml water for user ${userId}`);
  }

  /**
   * Get water intake for a day
   */
  async getWaterIntake(userId: string, date: string): Promise<number> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT COALESCE(SUM(amount_ml), 0) as total
      FROM water_logs
      WHERE user_id = $1 AND log_date = $2
    `;

    const result = await db.query(query, [userId, date]);

    return parseInt(result.rows[0]?.total) || 0;
  }
}

