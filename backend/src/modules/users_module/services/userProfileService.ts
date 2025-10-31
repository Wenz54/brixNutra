import { FastifyInstance } from 'fastify';

export class UserProfileService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  async getProfile(userId: string): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT up.*, 
        (SELECT json_agg(ug.*) FROM user_goals ug WHERE ug.user_id = up.user_id AND ug.is_active = true) as active_goals
      FROM user_profiles up
      WHERE up.user_id = $1
    `;
    
    const result = await db.query(query, [userId]);
    
    if (result.rows.length === 0) {
      return null;
    }
    
    return result.rows[0];
  }

  async createOrUpdateProfile(userId: string, data: any): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO user_profiles (
        user_id, full_name, date_of_birth, gender, avatar_url,
        height_cm, current_weight_kg, target_weight_kg, activity_level,
        allergies, dietary_preferences, medical_conditions
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      ON CONFLICT (user_id) DO UPDATE SET
        full_name = COALESCE($2, user_profiles.full_name),
        date_of_birth = COALESCE($3, user_profiles.date_of_birth),
        gender = COALESCE($4, user_profiles.gender),
        avatar_url = COALESCE($5, user_profiles.avatar_url),
        height_cm = COALESCE($6, user_profiles.height_cm),
        current_weight_kg = COALESCE($7, user_profiles.current_weight_kg),
        target_weight_kg = COALESCE($8, user_profiles.target_weight_kg),
        activity_level = COALESCE($9, user_profiles.activity_level),
        allergies = COALESCE($10, user_profiles.allergies),
        dietary_preferences = COALESCE($11, user_profiles.dietary_preferences),
        medical_conditions = COALESCE($12, user_profiles.medical_conditions),
        updated_at = NOW()
      RETURNING *
    `;
    
    const values = [
      userId,
      data.full_name,
      data.date_of_birth,
      data.gender,
      data.avatar_url,
      data.height_cm,
      data.current_weight_kg,
      data.target_weight_kg,
      data.activity_level,
      JSON.stringify(data.allergies || []),
      JSON.stringify(data.dietary_preferences || []),
      JSON.stringify(data.medical_conditions || []),
    ];
    
    const result = await db.query(query, values);
    
    this.fastify.log.info(`✅ Profile updated for user ${userId}`);
    
    return result.rows[0];
  }

  async setGoal(userId: string, goalData: any): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    // Deactivate old goals
    await db.query(`UPDATE user_goals SET is_active = false WHERE user_id = $1`, [userId]);
    
    const query = `
      INSERT INTO user_goals (
        user_id, goal_type, daily_calories, daily_protein, daily_carbs, daily_fats,
        daily_water_ml, target_weight_kg, target_date, weekly_goal_kg,
        weekly_workouts, daily_steps
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING *
    `;
    
    const values = [
      userId,
      goalData.goal_type,
      goalData.daily_calories,
      goalData.daily_protein,
      goalData.daily_carbs,
      goalData.daily_fats,
      goalData.daily_water_ml || 2000,
      goalData.target_weight_kg,
      goalData.target_date,
      goalData.weekly_goal_kg,
      goalData.weekly_workouts,
      goalData.daily_steps,
    ];
    
    const result = await db.query(query, values);
    
    this.fastify.log.info(`✅ Goal set for user ${userId}: ${goalData.goal_type}`);
    
    return result.rows[0];
  }

  async addMeasurement(userId: string, measurement: any): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO user_measurements (
        user_id, weight_kg, body_fat_percent, muscle_mass_kg,
        waist_cm, chest_cm, hips_cm, notes, photo_url, measured_at
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
      RETURNING *
    `;
    
    const values = [
      userId,
      measurement.weight_kg,
      measurement.body_fat_percent,
      measurement.muscle_mass_kg,
      measurement.waist_cm,
      measurement.chest_cm,
      measurement.hips_cm,
      measurement.notes,
      measurement.photo_url,
      measurement.measured_at || new Date(),
    ];
    
    const result = await db.query(query, values);
    
    // Update current weight in profile
    await db.query(
      `UPDATE user_profiles SET current_weight_kg = $1, updated_at = NOW() WHERE user_id = $2`,
      [measurement.weight_kg, userId]
    );
    
    this.fastify.log.info(`✅ Measurement added for user ${userId}: ${measurement.weight_kg} kg`);
    
    return result.rows[0];
  }

  async getMeasurements(userId: string, limit: number = 30): Promise<any[]> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM user_measurements
      WHERE user_id = $1
      ORDER BY measured_at DESC
      LIMIT $2
    `;
    
    const result = await db.query(query, [userId, limit]);
    
    return result.rows;
  }

  async logActivity(userId: string, activity: any): Promise<any> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      INSERT INTO user_activities (
        user_id, activity_type, activity_name, duration_minutes,
        calories_burned, distance_km, steps, intensity,
        activity_date, activity_time, notes
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      RETURNING *
    `;
    
    const values = [
      userId,
      activity.activity_type,
      activity.activity_name,
      activity.duration_minutes,
      activity.calories_burned,
      activity.distance_km,
      activity.steps,
      activity.intensity,
      activity.activity_date,
      activity.activity_time,
      activity.notes,
    ];
    
    const result = await db.query(query, values);
    
    this.fastify.log.info(`✅ Activity logged for user ${userId}: ${activity.activity_type}`);
    
    return result.rows[0];
  }

  async getActivities(userId: string, days: number = 30): Promise<any[]> {
    const db = await import('../../database_module/connection.js');
    
    const query = `
      SELECT * FROM user_activities
      WHERE user_id = $1 AND activity_date >= CURRENT_DATE - INTERVAL '${days} days'
      ORDER BY activity_date DESC, activity_time DESC
    `;
    
    const result = await db.query(query, [userId]);
    
    return result.rows;
  }
}

