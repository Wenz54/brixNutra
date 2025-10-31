// Types for Nutrition Module (Brix Nutrition)

export interface Recipe {
  id: string;
  name: string;
  description?: string;
  image_url?: string;
  prep_time?: number; // minutes
  cook_time?: number; // minutes
  servings?: number;
  
  // Nutrition per serving
  calories?: number;
  protein?: number;
  carbs?: number;
  fats?: number;
  
  // Instructions and ingredients
  instructions?: RecipeStep[];
  ingredients?: Ingredient[];
  
  // Categorization
  meal_type?: MealType;
  tags?: string[];
  
  // Dietary flags
  is_vegetarian?: boolean;
  is_vegan?: boolean;
  is_gluten_free?: boolean;
  is_dairy_free?: boolean;
  
  // Meta
  difficulty?: 'easy' | 'medium' | 'hard';
  is_published?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export interface RecipeStep {
  step: number;
  text: string;
}

export interface Ingredient {
  name: string;
  amount: number;
  unit: string; // "g", "ml", "шт", "ст.л."
}

export type MealType = 'wakeup' | 'breakfast' | 'snack' | 'lunch' | 'afternoon_snack' | 'dinner' | 'sleep';

export interface MealPlan {
  id: string;
  name: string;
  description?: string;
  image_url?: string;
  
  // Nutrition targets per day
  target_calories?: number;
  target_protein?: number;
  target_carbs?: number;
  target_fats?: number;
  
  // Plan details
  duration_days?: number;
  is_premium?: boolean;
  
  // Dietary flags
  is_vegetarian?: boolean;
  is_vegan?: boolean;
  is_gluten_free?: boolean;
  
  // Meta
  is_published?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export interface MealPlanDay {
  id: string;
  meal_plan_id: string;
  day_number: number;
  created_at?: Date;
}

export interface MealPlanSlot {
  id: string;
  meal_plan_day_id: string;
  recipe_id: string;
  recipe?: Recipe; // Populated
  
  meal_type: MealType;
  time_of_day?: string; // "08:00"
  portion_grams?: number;
  order_index?: number;
  importance_note?: string;
  
  created_at?: Date;
  updated_at?: Date;
}

export interface UserMealPlan {
  id: string;
  user_id: string;
  meal_plan_id: string;
  meal_plan?: MealPlan; // Populated
  
  start_date: Date;
  end_date?: Date;
  is_active: boolean;
  completed_days?: number;
  
  created_at?: Date;
  updated_at?: Date;
}

export interface Supplement {
  id: string;
  name: string;
  description?: string;
  dosage?: string;
  time_of_day?: string;
  created_at?: Date;
}

export interface RecipeFilters {
  meal_type?: MealType;
  is_vegetarian?: boolean;
  is_vegan?: boolean;
  is_gluten_free?: boolean;
  is_dairy_free?: boolean;
  min_calories?: number;
  max_calories?: number;
  tags?: string[];
  search?: string; // search in name/description
  limit?: number;
  offset?: number;
}

export interface MealPlanFilters {
  is_premium?: boolean;
  is_vegetarian?: boolean;
  is_vegan?: boolean;
  is_gluten_free?: boolean;
  limit?: number;
  offset?: number;
}

