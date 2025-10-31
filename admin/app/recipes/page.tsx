'use client';

/**
 * Recipes List Page - Список рецептов
 */

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { Recipe } from '@/lib/types';
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  BookOpenIcon,
  ClockIcon,
  FireIcon,
} from '@heroicons/react/24/outline';

export default function RecipesPage() {
  const [recipes, setRecipes] = useState<Recipe[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>('all');

  useEffect(() => {
    fetchRecipes();
  }, []);

  const fetchRecipes = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: Recipe[] }>(endpoints.recipes);
      // setRecipes(response.data);
      
      // Mock data для демонстрации
      setRecipes([
        {
          id: '1',
          name: 'Овсяная каша с ягодами',
          description: 'Полезный и сытный завтрак с овсянкой и свежими ягодами',
          imageUrl: '/placeholder-recipe.jpg',
          prepTime: 15,
          calories: 320,
          protein: 12,
          carbs: 55,
          fats: 8,
          instructions: [
            { stepNumber: 1, instruction: 'Вскипятить воду' },
            { stepNumber: 2, instruction: 'Добавить овсяные хлопья' },
            { stepNumber: 3, instruction: 'Варить 5 минут' },
            { stepNumber: 4, instruction: 'Добавить ягоды и мед' },
          ],
          ingredients: [
            { name: 'Овсяные хлопья', amount: 50, unit: 'г' },
            { name: 'Вода', amount: 200, unit: 'мл' },
            { name: 'Ягоды', amount: 100, unit: 'г' },
            { name: 'Мед', amount: 1, unit: 'ст.л.' },
          ],
          tags: ['завтрак', 'здоровое', 'быстро'],
          mealType: 'breakfast',
          createdAt: '2025-01-10T10:00:00Z',
          updatedAt: '2025-01-10T10:00:00Z',
        },
        {
          id: '2',
          name: 'Куриная грудка с овощами',
          description: 'Диетическое блюдо с высоким содержанием белка',
          imageUrl: '/placeholder-recipe.jpg',
          prepTime: 30,
          calories: 450,
          protein: 45,
          carbs: 25,
          fats: 15,
          instructions: [
            { stepNumber: 1, instruction: 'Нарезать куриную грудку' },
            { stepNumber: 2, instruction: 'Обжарить на сковороде' },
            { stepNumber: 3, instruction: 'Добавить овощи' },
            { stepNumber: 4, instruction: 'Тушить 15 минут' },
          ],
          ingredients: [
            { name: 'Куриная грудка', amount: 200, unit: 'г' },
            { name: 'Брокколи', amount: 150, unit: 'г' },
            { name: 'Морковь', amount: 100, unit: 'г' },
            { name: 'Оливковое масло', amount: 1, unit: 'ст.л.' },
          ],
          tags: ['обед', 'белок', 'диета'],
          mealType: 'lunch',
          createdAt: '2025-01-11T10:00:00Z',
          updatedAt: '2025-01-11T10:00:00Z',
        },
        {
          id: '3',
          name: 'Греческий салат',
          description: 'Свежий овощной салат с фетой',
          imageUrl: '/placeholder-recipe.jpg',
          prepTime: 10,
          calories: 220,
          protein: 8,
          carbs: 12,
          fats: 16,
          instructions: [
            { stepNumber: 1, instruction: 'Нарезать овощи кубиками' },
            { stepNumber: 2, instruction: 'Добавить фету и маслины' },
            { stepNumber: 3, instruction: 'Заправить маслом и лимоном' },
          ],
          ingredients: [
            { name: 'Помидоры', amount: 150, unit: 'г' },
            { name: 'Огурцы', amount: 100, unit: 'г' },
            { name: 'Фета', amount: 80, unit: 'г' },
            { name: 'Маслины', amount: 50, unit: 'г' },
          ],
          tags: ['салат', 'легкое', 'вегетарианское'],
          mealType: 'snack',
          createdAt: '2025-01-12T10:00:00Z',
          updatedAt: '2025-01-12T10:00:00Z',
        },
      ]);
    } catch (err) {
      console.error('Error fetching recipes:', err);
      setError('Не удалось загрузить список рецептов');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (recipeId: string) => {
    if (!confirm('Вы уверены, что хотите удалить этот рецепт?')) {
      return;
    }

    try {
      // TODO: Раскомментировать когда API будет готов
      // await api.delete(endpoints.recipe(recipeId));
      
      setRecipes(recipes.filter(r => r.id !== recipeId));
      alert('Рецепт удален');
    } catch (err) {
      console.error('Error deleting recipe:', err);
      alert('Не удалось удалить рецепт');
    }
  };

  const filteredRecipes = filter === 'all' 
    ? recipes 
    : recipes.filter(r => r.mealType === filter);

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка рецептов...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <p className="text-red-600">{error}</p>
          <button
            onClick={fetchRecipes}
            className="mt-4 rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
          >
            Повторить
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Рецепты</h1>
          <p className="mt-2 text-gray-600">
            Управление рецептами ({filteredRecipes.length} из {recipes.length})
          </p>
        </div>
        <Link
          href="/recipes/new"
          className="flex items-center rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
        >
          <PlusIcon className="mr-2 h-5 w-5" />
          Создать рецепт
        </Link>
      </div>

      {/* Filters */}
      <div className="flex space-x-2">
        <FilterButton
          label="Все"
          active={filter === 'all'}
          onClick={() => setFilter('all')}
          count={recipes.length}
        />
        <FilterButton
          label="Завтрак"
          active={filter === 'breakfast'}
          onClick={() => setFilter('breakfast')}
          count={recipes.filter(r => r.mealType === 'breakfast').length}
        />
        <FilterButton
          label="Обед"
          active={filter === 'lunch'}
          onClick={() => setFilter('lunch')}
          count={recipes.filter(r => r.mealType === 'lunch').length}
        />
        <FilterButton
          label="Ужин"
          active={filter === 'dinner'}
          onClick={() => setFilter('dinner')}
          count={recipes.filter(r => r.mealType === 'dinner').length}
        />
        <FilterButton
          label="Перекус"
          active={filter === 'snack'}
          onClick={() => setFilter('snack')}
          count={recipes.filter(r => r.mealType === 'snack').length}
        />
      </div>

      {/* Recipes Grid */}
      {filteredRecipes.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <BookOpenIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Нет рецептов</h3>
          <p className="mt-1 text-sm text-gray-500">
            {filter === 'all' ? 'Создайте первый рецепт' : 'Нет рецептов в этой категории'}
          </p>
          {filter === 'all' && (
            <div className="mt-6">
              <Link
                href="/recipes/new"
                className="inline-flex items-center rounded-md bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-green-700"
              >
                <PlusIcon className="mr-2 h-5 w-5" />
                Создать рецепт
              </Link>
            </div>
          )}
        </div>
      ) : (
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {filteredRecipes.map((recipe) => (
            <RecipeCard
              key={recipe.id}
              recipe={recipe}
              onDelete={() => handleDelete(recipe.id)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

// ==========================================
// Components
// ==========================================

interface FilterButtonProps {
  label: string;
  active: boolean;
  onClick: () => void;
  count: number;
}

function FilterButton({ label, active, onClick, count }: FilterButtonProps) {
  return (
    <button
      onClick={onClick}
      className={`
        rounded-md px-4 py-2 text-sm font-medium transition-colors
        ${
          active
            ? 'bg-green-600 text-white'
            : 'bg-white text-gray-700 hover:bg-gray-50'
        }
      `}
    >
      {label} ({count})
    </button>
  );
}

interface RecipeCardProps {
  recipe: Recipe;
  onDelete: () => void;
}

function RecipeCard({ recipe, onDelete }: RecipeCardProps) {
  const getMealTypeLabel = () => {
    const labels: Record<string, string> = {
      wakeup: 'Пробуждение',
      breakfast: 'Завтрак',
      snack: 'Перекус',
      lunch: 'Обед',
      afternoon_snack: 'Полдник',
      dinner: 'Ужин',
      sleep: 'Перед сном',
    };
    return labels[recipe.mealType] || recipe.mealType;
  };

  return (
    <div className="group relative flex flex-col overflow-hidden rounded-lg bg-white shadow hover:shadow-lg transition-shadow">
      {/* Image */}
      <div className="relative h-48 bg-gray-200">
        {recipe.imageUrl ? (
          <img
            src={recipe.imageUrl}
            alt={recipe.name}
            className="h-full w-full object-cover"
          />
        ) : (
          <div className="flex h-full items-center justify-center">
            <BookOpenIcon className="h-16 w-16 text-gray-400" />
          </div>
        )}
        
        {/* Badge */}
        <div className="absolute left-2 top-2 rounded-full bg-white/90 px-3 py-1 text-xs font-semibold text-gray-800">
          {getMealTypeLabel()}
        </div>
      </div>

      {/* Content */}
      <div className="flex flex-1 flex-col p-4">
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-gray-900 line-clamp-2">
            {recipe.name}
          </h3>
          <p className="mt-2 text-sm text-gray-600 line-clamp-2">
            {recipe.description}
          </p>

          {/* Stats */}
          <div className="mt-4 grid grid-cols-2 gap-2 text-sm">
            <div className="flex items-center text-gray-600">
              <ClockIcon className="mr-1 h-4 w-4" />
              <span>{recipe.prepTime} мин</span>
            </div>
            <div className="flex items-center text-gray-600">
              <FireIcon className="mr-1 h-4 w-4" />
              <span>{recipe.calories} ккал</span>
            </div>
          </div>

          {/* Macros */}
          <div className="mt-3 flex space-x-2 text-xs">
            <span className="rounded-full bg-blue-100 px-2 py-1 text-blue-800">
              Б: {recipe.protein}г
            </span>
            <span className="rounded-full bg-green-100 px-2 py-1 text-green-800">
              Ж: {recipe.fats}г
            </span>
            <span className="rounded-full bg-orange-100 px-2 py-1 text-orange-800">
              У: {recipe.carbs}г
            </span>
          </div>

          {/* Tags */}
          {recipe.tags && recipe.tags.length > 0 && (
            <div className="mt-3 flex flex-wrap gap-1">
              {recipe.tags.slice(0, 3).map((tag) => (
                <span
                  key={tag}
                  className="rounded-md bg-gray-100 px-2 py-1 text-xs text-gray-600"
                >
                  #{tag}
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="mt-4 flex items-center justify-between border-t border-gray-200 pt-4">
          <span className="text-xs text-gray-500">
            {recipe.ingredients.length} ингредиентов
          </span>
          <div className="flex space-x-2">
            <Link
              href={`/recipes/${recipe.id}`}
              className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-blue-600"
              title="Редактировать"
            >
              <PencilIcon className="h-5 w-5" />
            </Link>
            <button
              onClick={onDelete}
              className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-red-600"
              title="Удалить"
            >
              <TrashIcon className="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}



