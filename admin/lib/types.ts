/**
 * TypeScript types for Brix Nutrition Admin Panel
 */

// ==========================================
// Dashboard
// ==========================================

export interface DashboardStats {
  users: {
    total: number;
    newThisWeek: number;
  };
  subscriptions: {
    active: number;
    cancelled: number;
    revenueMrr: number;
  };
  content: {
    courses: number;
    recipes: number;
    mealPlans: number;
    articles: number;
  };
  activity: {
    diaryEntriesToday: number;
    aiChatsToday: number;
  };
}

// ==========================================
// Courses & Lessons
// ==========================================

export interface Course {
  id: string;
  title: string;
  description: string;
  imageUrl?: string;
  author: string;
  isPaid: boolean;
  price?: number;
  duration: string;
  category: string;
  orderIndex: number;
  isPublished: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface Lesson {
  id: string;
  courseId: string;
  title: string;
  description: string;
  orderIndex: number;
  type: 'video' | 'text' | 'audio';
  content: string;
  duration?: number;
  materials?: Material[];
  createdAt: string;
  updatedAt: string;
}

export interface Material {
  name: string;
  url: string;
  type: string;
}

// ==========================================
// Recipes
// ==========================================

export interface Recipe {
  id: string;
  name: string;
  description: string;
  imageUrl?: string;
  prepTime: number;
  calories: number;
  protein: number;
  carbs: number;
  fats: number;
  instructions: RecipeStep[];
  ingredients: Ingredient[];
  tags: string[];
  mealType: MealType;
  createdAt: string;
  updatedAt: string;
}

export interface Ingredient {
  name: string;
  amount: number;
  unit: string;
}

export interface RecipeStep {
  stepNumber: number;
  instruction: string;
}

export type MealType = 'wakeup' | 'breakfast' | 'snack' | 'lunch' | 'afternoon_snack' | 'dinner' | 'sleep';

// ==========================================
// Meal Plans
// ==========================================

export interface MealPlan {
  id: string;
  name: string;
  description: string;
  durationDays: number;
  targetCalories: number;
  targetProtein: number;
  targetCarbs: number;
  targetFats: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

// ==========================================
// Users
// ==========================================

export interface User {
  id: string;
  email: string;
  phone?: string;
  name: string;
  birthDate?: string;
  goal?: UserGoal;
  gender?: 'male' | 'female' | 'other';
  height?: number;
  weight?: number;
  activityLevel?: ActivityLevel;
  isActive: boolean;
  subscriptionStatus?: 'active' | 'cancelled' | 'expired';
  createdAt: string;
  updatedAt: string;
}

export type UserGoal = 'weight_loss' | 'weight_gain' | 'muscle_gain' | 'health';
export type ActivityLevel = 'sedentary' | 'light' | 'moderate' | 'active' | 'very_active';

// ==========================================
// Lab Tests
// ==========================================

export interface LabParameter {
  id: string;
  parameterId: string;
  name: string;
  category: string;
  units: string[];
  referenceRanges: ReferenceRange[];
  description: string;
  lowCauses?: string[];
  highCauses?: string[];
  recommendations?: string;
}

export interface ReferenceRange {
  gender: 'male' | 'female' | 'all';
  ageMin?: number;
  ageMax?: number;
  min: number;
  max: number;
  unit: string;
}

// ==========================================
// Blog
// ==========================================

export interface Article {
  id: string;
  title: string;
  slug: string;
  content: string;
  preview: string;
  imageUrl?: string;
  author: string;
  category: string;
  publishedAt?: string;
  isPublished: boolean;
  createdAt: string;
  updatedAt: string;
}

// ==========================================
// Notifications
// ==========================================

export interface Notification {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: 'info' | 'reminder' | 'alert';
  isRead: boolean;
  action?: NotificationAction;
  createdAt: string;
}

export interface NotificationAction {
  type: string;
  target: string;
}

// ==========================================
// Subscriptions
// ==========================================

export interface Subscription {
  id: string;
  userId: string;
  planId: string;
  planName: string;
  status: 'active' | 'cancelled' | 'expired';
  startDate: string;
  endDate?: string;
  nextBillingDate?: string;
  paymentProvider: 'stripe' | 'apple' | 'google';
  externalId?: string;
}

// ==========================================
// API Response
// ==========================================

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T = any> {
  success: boolean;
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}



