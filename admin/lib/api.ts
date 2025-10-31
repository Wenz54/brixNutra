/**
 * API Client for Brix Nutrition Admin Panel
 * 
 * Подключается к Fastify backend (http://localhost:3000/api)
 */

import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api';

/**
 * Axios instance с настроенными interceptors
 */
const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10 seconds
});

/**
 * Request interceptor - добавляет JWT token если есть
 */
apiClient.interceptors.request.use(
  (config) => {
    // TODO: В будущем добавить JWT token из localStorage/cookies
    // const token = localStorage.getItem('admin_token');
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`;
    // }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

/**
 * Response interceptor - обработка ошибок
 */
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // Сервер ответил с ошибкой
      console.error('API Error:', error.response.data);
      
      if (error.response.status === 401) {
        // Unauthorized - redirect to login
        // TODO: Добавить редирект на страницу входа
        console.error('Unauthorized - please login');
      }
    } else if (error.request) {
      // Запрос был отправлен, но ответа нет
      console.error('No response from server');
    } else {
      // Ошибка при настройке запроса
      console.error('Request setup error:', error.message);
    }
    
    return Promise.reject(error);
  }
);

/**
 * API service methods
 */
export const api = {
  /**
   * GET request
   */
  get: async <T = any>(
    endpoint: string,
    config?: AxiosRequestConfig
  ): Promise<T> => {
    const response: AxiosResponse<T> = await apiClient.get(endpoint, config);
    return response.data;
  },

  /**
   * POST request
   */
  post: async <T = any>(
    endpoint: string,
    data?: any,
    config?: AxiosRequestConfig
  ): Promise<T> => {
    const response: AxiosResponse<T> = await apiClient.post(endpoint, data, config);
    return response.data;
  },

  /**
   * PUT request
   */
  put: async <T = any>(
    endpoint: string,
    data?: any,
    config?: AxiosRequestConfig
  ): Promise<T> => {
    const response: AxiosResponse<T> = await apiClient.put(endpoint, data, config);
    return response.data;
  },

  /**
   * DELETE request
   */
  delete: async <T = any>(
    endpoint: string,
    config?: AxiosRequestConfig
  ): Promise<T> => {
    const response: AxiosResponse<T> = await apiClient.delete(endpoint, config);
    return response.data;
  },

  /**
   * PATCH request
   */
  patch: async <T = any>(
    endpoint: string,
    data?: any,
    config?: AxiosRequestConfig
  ): Promise<T> => {
    const response: AxiosResponse<T> = await apiClient.patch(endpoint, data, config);
    return response.data;
  },
};

/**
 * API endpoints constants
 */
export const endpoints = {
  // Dashboard
  dashboard: '/home/dashboard',
  
  // Courses
  courses: '/knowledge/courses',
  course: (id: string) => `/knowledge/courses/${id}`,
  
  // Lessons
  lessons: '/knowledge/lessons',
  lesson: (id: string) => `/knowledge/lessons/${id}`,
  
  // Recipes
  recipes: '/recipes',
  recipe: (id: string) => `/recipes/${id}`,
  
  // Meal Plans
  mealPlans: '/meal-plan',
  mealPlan: (id: string) => `/meal-plan/${id}`,
  
  // Users
  users: '/users',
  user: (id: string) => `/users/${id}`,
  
  // Lab Tests
  labTests: '/lab-tests',
  labTest: (id: string) => `/lab-tests/${id}`,
  labParameters: '/lab-tests/parameters',
  
  // Blog
  blogArticles: '/blog/articles',
  blogArticle: (id: string) => `/blog/articles/${id}`,
  
  // Notifications
  notifications: '/notifications',
  notification: (id: string) => `/notifications/${id}`,
  
  // Subscriptions
  subscriptions: '/subscriptions',
  subscription: (id: string) => `/subscriptions/${id}`,
  
  // Analytics
  analytics: '/analytics',
};

export default api;



