'use client';

/**
 * Create Recipe Page - Создание нового рецепта
 */

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { MealType } from '@/lib/types';
import { ArrowLeftIcon, PlusIcon, TrashIcon } from '@heroicons/react/24/outline';

interface RecipeFormData {
  name: string;
  description: string;
  prepTime: number;
  calories: number;
  protein: number;
  carbs: number;
  fats: number;
  mealType: MealType;
  tags: string;
  ingredients: { name: string; amount: number; unit: string }[];
  instructions: { instruction: string }[];
}

export default function NewRecipePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const {
    register,
    control,
    handleSubmit,
    formState: { errors },
  } = useForm<RecipeFormData>({
    defaultValues: {
      prepTime: 15,
      calories: 0,
      protein: 0,
      carbs: 0,
      fats: 0,
      mealType: 'breakfast',
      ingredients: [{ name: '', amount: 0, unit: 'г' }],
      instructions: [{ instruction: '' }],
    },
  });

  const { fields: ingredientFields, append: appendIngredient, remove: removeIngredient } = useFieldArray({
    control,
    name: 'ingredients',
  });

  const { fields: instructionFields, append: appendInstruction, remove: removeInstruction } = useFieldArray({
    control,
    name: 'instructions',
  });

  const onSubmit = async (data: RecipeFormData) => {
    try {
      setLoading(true);
      setError(null);

      // Преобразование данных
      const recipeData = {
        ...data,
        tags: data.tags.split(',').map(t => t.trim()).filter(Boolean),
        instructions: data.instructions.map((inst, idx) => ({
          stepNumber: idx + 1,
          instruction: inst.instruction,
        })),
      };

      // TODO: Раскомментировать когда API будет готов
      // const newRecipe = await api.post(endpoints.recipes, recipeData);
      // router.push(`/recipes/${newRecipe.id}`);

      console.log('Creating recipe:', recipeData);
      alert('Рецепт создан! (mock)');
      router.push('/recipes');
    } catch (err) {
      console.error('Error creating recipe:', err);
      setError('Не удалось создать рецепт');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-4xl space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/recipes"
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к списку рецептов
        </Link>
        <h1 className="mt-4 text-3xl font-bold text-gray-900">Создать рецепт</h1>
        <p className="mt-2 text-gray-600">
          Заполните информацию о новом рецепте
        </p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Основная информация</h2>
          
          <div className="mt-6 space-y-6">
            {/* Name */}
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                Название рецепта *
              </label>
              <input
                type="text"
                id="name"
                {...register('name', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="Овсяная каша с ягодами"
              />
              {errors.name && (
                <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
              )}
            </div>

            {/* Description */}
            <div>
              <label htmlFor="description" className="block text-sm font-medium text-gray-700">
                Описание *
              </label>
              <textarea
                id="description"
                rows={3}
                {...register('description', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="Полезный и сытный завтрак..."
              />
              {errors.description && (
                <p className="mt-1 text-sm text-red-600">{errors.description.message}</p>
              )}
            </div>

            {/* Meal Type & Prep Time */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="mealType" className="block text-sm font-medium text-gray-700">
                  Тип приема пищи *
                </label>
                <select
                  id="mealType"
                  {...register('mealType', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                >
                  <option value="wakeup">Пробуждение</option>
                  <option value="breakfast">Завтрак</option>
                  <option value="snack">Перекус</option>
                  <option value="lunch">Обед</option>
                  <option value="afternoon_snack">Полдник</option>
                  <option value="dinner">Ужин</option>
                  <option value="sleep">Перед сном</option>
                </select>
              </div>

              <div>
                <label htmlFor="prepTime" className="block text-sm font-medium text-gray-700">
                  Время приготовления (мин) *
                </label>
                <input
                  type="number"
                  id="prepTime"
                  {...register('prepTime', { required: 'Обязательное поле', valueAsNumber: true })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  min="1"
                />
              </div>
            </div>

            {/* Tags */}
            <div>
              <label htmlFor="tags" className="block text-sm font-medium text-gray-700">
                Теги (через запятую)
              </label>
              <input
                type="text"
                id="tags"
                {...register('tags')}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="завтрак, здоровое, быстро"
              />
              <p className="mt-1 text-sm text-gray-500">
                Например: завтрак, здоровое, быстро, вегетарианское
              </p>
            </div>
          </div>
        </div>

        {/* Nutrition */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">КБЖУ</h2>
          
          <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-4">
            <div>
              <label htmlFor="calories" className="block text-sm font-medium text-gray-700">
                Калории *
              </label>
              <input
                type="number"
                id="calories"
                {...register('calories', { required: 'Обязательное поле', valueAsNumber: true })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                min="0"
                placeholder="320"
              />
            </div>

            <div>
              <label htmlFor="protein" className="block text-sm font-medium text-gray-700">
                Белки (г) *
              </label>
              <input
                type="number"
                id="protein"
                {...register('protein', { required: 'Обязательное поле', valueAsNumber: true })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                min="0"
                step="0.1"
                placeholder="12"
              />
            </div>

            <div>
              <label htmlFor="fats" className="block text-sm font-medium text-gray-700">
                Жиры (г) *
              </label>
              <input
                type="number"
                id="fats"
                {...register('fats', { required: 'Обязательное поле', valueAsNumber: true })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                min="0"
                step="0.1"
                placeholder="8"
              />
            </div>

            <div>
              <label htmlFor="carbs" className="block text-sm font-medium text-gray-700">
                Углеводы (г) *
              </label>
              <input
                type="number"
                id="carbs"
                {...register('carbs', { required: 'Обязательное поле', valueAsNumber: true })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                min="0"
                step="0.1"
                placeholder="55"
              />
            </div>
          </div>
        </div>

        {/* Ingredients */}
        <div className="rounded-lg bg-white p-6 shadow">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-gray-900">Ингредиенты</h2>
            <button
              type="button"
              onClick={() => appendIngredient({ name: '', amount: 0, unit: 'г' })}
              className="flex items-center text-sm text-green-600 hover:text-green-700"
            >
              <PlusIcon className="mr-1 h-4 w-4" />
              Добавить
            </button>
          </div>

          <div className="mt-6 space-y-4">
            {ingredientFields.map((field, index) => (
              <div key={field.id} className="flex items-start space-x-4">
                <div className="flex-1">
                  <input
                    type="text"
                    {...register(`ingredients.${index}.name`, { required: 'Обязательное поле' })}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    placeholder="Название ингредиента"
                  />
                </div>
                <div className="w-24">
                  <input
                    type="number"
                    {...register(`ingredients.${index}.amount`, { required: true, valueAsNumber: true })}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    placeholder="100"
                    min="0"
                    step="0.1"
                  />
                </div>
                <div className="w-20">
                  <select
                    {...register(`ingredients.${index}.unit`)}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  >
                    <option value="г">г</option>
                    <option value="кг">кг</option>
                    <option value="мл">мл</option>
                    <option value="л">л</option>
                    <option value="шт">шт</option>
                    <option value="ст.л.">ст.л.</option>
                    <option value="ч.л.">ч.л.</option>
                  </select>
                </div>
                {ingredientFields.length > 1 && (
                  <button
                    type="button"
                    onClick={() => removeIngredient(index)}
                    className="text-red-600 hover:text-red-700"
                  >
                    <TrashIcon className="h-5 w-5" />
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Instructions */}
        <div className="rounded-lg bg-white p-6 shadow">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-gray-900">Шаги приготовления</h2>
            <button
              type="button"
              onClick={() => appendInstruction({ instruction: '' })}
              className="flex items-center text-sm text-green-600 hover:text-green-700"
            >
              <PlusIcon className="mr-1 h-4 w-4" />
              Добавить
            </button>
          </div>

          <div className="mt-6 space-y-4">
            {instructionFields.map((field, index) => (
              <div key={field.id} className="flex items-start space-x-4">
                <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-gray-100 text-sm font-semibold text-gray-700">
                  {index + 1}
                </div>
                <div className="flex-1">
                  <textarea
                    rows={2}
                    {...register(`instructions.${index}.instruction`, { required: 'Обязательное поле' })}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    placeholder="Описание шага..."
                  />
                </div>
                {instructionFields.length > 1 && (
                  <button
                    type="button"
                    onClick={() => removeInstruction(index)}
                    className="text-red-600 hover:text-red-700"
                  >
                    <TrashIcon className="h-5 w-5" />
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Error */}
        {error && (
          <div className="rounded-md bg-red-50 p-4">
            <p className="text-sm text-red-800">{error}</p>
          </div>
        )}

        {/* Actions */}
        <div className="flex items-center justify-end space-x-4">
          <Link
            href="/recipes"
            className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50"
          >
            Отмена
          </Link>
          <button
            type="submit"
            disabled={loading}
            className="rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 disabled:opacity-50"
          >
            {loading ? 'Создание...' : 'Создать рецепт'}
          </button>
        </div>
      </form>
    </div>
  );
}



