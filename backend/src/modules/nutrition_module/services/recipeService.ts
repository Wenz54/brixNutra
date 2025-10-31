import { FastifyInstance } from 'fastify';
import { Recipe, RecipeFilters } from '../types/index.js';

export class RecipeService {
  private fastify: FastifyInstance;

  constructor(fastify: FastifyInstance) {
    this.fastify = fastify;
  }

  /**
   * Get recipes with filters
   */
  async getRecipes(filters: RecipeFilters = {}): Promise<{ recipes: Recipe[]; total: number }> {
    const db = await import('../../database_module/connection.js');

    const {
      meal_type,
      is_vegetarian,
      is_vegan,
      is_gluten_free,
      is_dairy_free,
      min_calories,
      max_calories,
      tags,
      search,
      limit = 20,
      offset = 0,
    } = filters;

    // Build WHERE conditions
    const conditions: string[] = ['is_published = true'];
    const params: any[] = [];
    let paramIndex = 1;

    if (meal_type) {
      conditions.push(`meal_type = $${paramIndex}`);
      params.push(meal_type);
      paramIndex++;
    }

    if (is_vegetarian !== undefined) {
      conditions.push(`is_vegetarian = $${paramIndex}`);
      params.push(is_vegetarian);
      paramIndex++;
    }

    if (is_vegan !== undefined) {
      conditions.push(`is_vegan = $${paramIndex}`);
      params.push(is_vegan);
      paramIndex++;
    }

    if (is_gluten_free !== undefined) {
      conditions.push(`is_gluten_free = $${paramIndex}`);
      params.push(is_gluten_free);
      paramIndex++;
    }

    if (is_dairy_free !== undefined) {
      conditions.push(`is_dairy_free = $${paramIndex}`);
      params.push(is_dairy_free);
      paramIndex++;
    }

    if (min_calories) {
      conditions.push(`calories >= $${paramIndex}`);
      params.push(min_calories);
      paramIndex++;
    }

    if (max_calories) {
      conditions.push(`calories <= $${paramIndex}`);
      params.push(max_calories);
      paramIndex++;
    }

    if (tags && tags.length > 0) {
      conditions.push(`tags && $${paramIndex}`);
      params.push(tags);
      paramIndex++;
    }

    if (search) {
      conditions.push(`(name ILIKE $${paramIndex} OR description ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Count total
    const countQuery = `SELECT COUNT(*) FROM recipes ${whereClause}`;
    const countResult = await db.query(countQuery, params);
    const total = parseInt(countResult.rows[0].count);

    // Get recipes
    const query = `
      SELECT 
        id, name, description, image_url, prep_time, cook_time, servings,
        calories, protein, carbs, fats,
        instructions, ingredients,
        meal_type, tags,
        is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
        difficulty, created_at, updated_at
      FROM recipes
      ${whereClause}
      ORDER BY created_at DESC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;

    params.push(limit, offset);

    const result = await db.query(query, params);

    this.fastify.log.info(`✅ Retrieved ${result.rows.length} recipes (total: ${total})`);

    return {
      recipes: result.rows,
      total,
    };
  }

  /**
   * Get recipe by ID
   */
  async getRecipeById(id: string): Promise<Recipe | null> {
    const db = await import('../../database_module/connection.js');

    const query = `
      SELECT 
        id, name, description, image_url, prep_time, cook_time, servings,
        calories, protein, carbs, fats,
        instructions, ingredients,
        meal_type, tags,
        is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
        difficulty, created_at, updated_at
      FROM recipes
      WHERE id = $1 AND is_published = true
      LIMIT 1
    `;

    const result = await db.query(query, [id]);

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  }

  /**
   * Get alternative recipes (similar recipes)
   * Criteria: same meal_type, similar calories (±20%), similar tags
   */
  async getAlternatives(recipeId: string, limit: number = 5): Promise<Recipe[]> {
    const db = await import('../../database_module/connection.js');

    // Get the original recipe first
    const original = await this.getRecipeById(recipeId);

    if (!original) {
      return [];
    }

    const { meal_type, calories, tags } = original;

    // Build query for alternatives
    const conditions: string[] = [
      'id != $1',
      'is_published = true',
    ];
    const params: any[] = [recipeId];
    let paramIndex = 2;

    // Same meal type
    if (meal_type) {
      conditions.push(`meal_type = $${paramIndex}`);
      params.push(meal_type);
      paramIndex++;
    }

    // Similar calories (±20%)
    if (calories) {
      const minCal = calories * 0.8;
      const maxCal = calories * 1.2;
      conditions.push(`calories BETWEEN $${paramIndex} AND $${paramIndex + 1}`);
      params.push(minCal, maxCal);
      paramIndex += 2;
    }

    const whereClause = conditions.join(' AND ');

    // Query with similarity scoring based on tags
    let query: string;
    let queryParams: any[];

    if (tags && tags.length > 0) {
      // Use tags overlap for sorting
      query = `
        SELECT 
          id, name, description, image_url, prep_time, cook_time, servings,
          calories, protein, carbs, fats,
          meal_type, tags,
          is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
          difficulty,
          -- Calculate tag similarity score
          COALESCE(array_length(array(SELECT unnest(tags) INTERSECT SELECT unnest($${paramIndex}::TEXT[])), 1), 0) as similarity
        FROM recipes
        WHERE ${whereClause}
        ORDER BY similarity DESC, ABS(calories - $${paramIndex + 1}) ASC
        LIMIT $${paramIndex + 2}
      `;
      queryParams = [...params, tags, calories || 0, limit];
    } else {
      // No tags, just order by calorie difference
      query = `
        SELECT 
          id, name, description, image_url, prep_time, cook_time, servings,
          calories, protein, carbs, fats,
          meal_type, tags,
          is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
          difficulty
        FROM recipes
        WHERE ${whereClause}
        ORDER BY ABS(calories - $${paramIndex}) ASC
        LIMIT $${paramIndex + 1}
      `;
      queryParams = [...params, calories || 0, limit];
    }

    const result = await db.query(query, queryParams);

    this.fastify.log.info(`✅ Found ${result.rows.length} alternatives for recipe ${recipeId}`);

    return result.rows;
  }

  /**
   * Create a new recipe (Admin only)
   */
  async createRecipe(data: Partial<Recipe>): Promise<Recipe> {
    const db = await import('../../database_module/connection.js');

    const query = `
      INSERT INTO recipes (
        name, description, image_url, prep_time, cook_time, servings,
        calories, protein, carbs, fats,
        instructions, ingredients,
        meal_type, tags,
        is_vegetarian, is_vegan, is_gluten_free, is_dairy_free,
        difficulty, is_published
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)
      RETURNING *
    `;

    const params = [
      data.name,
      data.description || null,
      data.image_url || null,
      data.prep_time || null,
      data.cook_time || null,
      data.servings || 1,
      data.calories || null,
      data.protein || null,
      data.carbs || null,
      data.fats || null,
      JSON.stringify(data.instructions || []),
      JSON.stringify(data.ingredients || []),
      data.meal_type || null,
      data.tags || [],
      data.is_vegetarian || false,
      data.is_vegan || false,
      data.is_gluten_free || false,
      data.is_dairy_free || false,
      data.difficulty || 'medium',
      data.is_published !== undefined ? data.is_published : true,
    ];

    const result = await db.query(query, params);

    this.fastify.log.info(`✅ Created recipe: ${data.name}`);

    return result.rows[0];
  }

  /**
   * Update recipe (Admin only)
   */
  async updateRecipe(id: string, data: Partial<Recipe>): Promise<Recipe | null> {
    const db = await import('../../database_module/connection.js');

    const updates: string[] = [];
    const params: any[] = [];
    let paramIndex = 1;

    if (data.name !== undefined) {
      updates.push(`name = $${paramIndex}`);
      params.push(data.name);
      paramIndex++;
    }

    if (data.description !== undefined) {
      updates.push(`description = $${paramIndex}`);
      params.push(data.description);
      paramIndex++;
    }

    if (data.image_url !== undefined) {
      updates.push(`image_url = $${paramIndex}`);
      params.push(data.image_url);
      paramIndex++;
    }

    if (data.calories !== undefined) {
      updates.push(`calories = $${paramIndex}`);
      params.push(data.calories);
      paramIndex++;
    }

    if (data.instructions !== undefined) {
      updates.push(`instructions = $${paramIndex}`);
      params.push(JSON.stringify(data.instructions));
      paramIndex++;
    }

    if (data.ingredients !== undefined) {
      updates.push(`ingredients = $${paramIndex}`);
      params.push(JSON.stringify(data.ingredients));
      paramIndex++;
    }

    if (data.tags !== undefined) {
      updates.push(`tags = $${paramIndex}`);
      params.push(data.tags);
      paramIndex++;
    }

    if (updates.length === 0) {
      return this.getRecipeById(id);
    }

    updates.push('updated_at = NOW()');

    const query = `
      UPDATE recipes
      SET ${updates.join(', ')}
      WHERE id = $${paramIndex}
      RETURNING *
    `;

    params.push(id);

    const result = await db.query(query, params);

    if (result.rows.length === 0) {
      return null;
    }

    this.fastify.log.info(`✅ Updated recipe: ${id}`);

    return result.rows[0];
  }

  /**
   * Delete recipe (Admin only)
   */
  async deleteRecipe(id: string): Promise<boolean> {
    const db = await import('../../database_module/connection.js');

    const query = 'DELETE FROM recipes WHERE id = $1';
    const result = await db.query(query, [id]);

    const deleted = result.rowCount !== null && result.rowCount > 0;

    if (deleted) {
      this.fastify.log.info(`✅ Deleted recipe: ${id}`);
    }

    return deleted;
  }
}

