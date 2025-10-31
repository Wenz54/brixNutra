'use client';

/**
 * Create Course Page - Создание нового курса
 */

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import { ArrowLeftIcon } from '@heroicons/react/24/outline';

interface CourseFormData {
  title: string;
  description: string;
  author: string;
  category: string;
  duration: string;
  isPaid: boolean;
  price?: number;
  orderIndex: number;
  isPublished: boolean;
}

export default function NewCoursePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<CourseFormData>({
    defaultValues: {
      isPaid: false,
      isPublished: false,
      orderIndex: 1,
    },
  });

  const isPaid = watch('isPaid');

  const onSubmit = async (data: CourseFormData) => {
    try {
      setLoading(true);
      setError(null);

      // Валидация
      if (data.isPaid && (!data.price || data.price <= 0)) {
        setError('Укажите цену для платного курса');
        return;
      }

      // TODO: Раскомментировать когда API будет готов
      // const newCourse = await api.post(endpoints.courses, data);
      // router.push(`/courses/${newCourse.id}`);

      // Mock - просто редирект
      console.log('Creating course:', data);
      alert('Курс создан! (mock)');
      router.push('/courses');
    } catch (err) {
      console.error('Error creating course:', err);
      setError('Не удалось создать курс');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-3xl space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/courses"
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к списку курсов
        </Link>
        <h1 className="mt-4 text-3xl font-bold text-gray-900">Создать курс</h1>
        <p className="mt-2 text-gray-600">
          Заполните информацию о новом курсе базы знаний
        </p>
      </div>

      {/* Form */}
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Main Info Card */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Основная информация</h2>
          
          <div className="mt-6 space-y-6">
            {/* Title */}
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700">
                Название курса *
              </label>
              <input
                type="text"
                id="title"
                {...register('title', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="Основы здорового питания"
              />
              {errors.title && (
                <p className="mt-1 text-sm text-red-600">{errors.title.message}</p>
              )}
            </div>

            {/* Description */}
            <div>
              <label htmlFor="description" className="block text-sm font-medium text-gray-700">
                Описание *
              </label>
              <textarea
                id="description"
                rows={4}
                {...register('description', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="Подробное описание курса..."
              />
              {errors.description && (
                <p className="mt-1 text-sm text-red-600">{errors.description.message}</p>
              )}
            </div>

            {/* Author & Category */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="author" className="block text-sm font-medium text-gray-700">
                  Автор *
                </label>
                <input
                  type="text"
                  id="author"
                  {...register('author', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="Доктор Иванов"
                />
                {errors.author && (
                  <p className="mt-1 text-sm text-red-600">{errors.author.message}</p>
                )}
              </div>

              <div>
                <label htmlFor="category" className="block text-sm font-medium text-gray-700">
                  Категория *
                </label>
                <select
                  id="category"
                  {...register('category', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                >
                  <option value="">Выберите категорию</option>
                  <option value="Питание">Питание</option>
                  <option value="Спорт">Спорт</option>
                  <option value="Здоровье">Здоровье</option>
                  <option value="Психология">Психология</option>
                  <option value="Рецепты">Рецепты</option>
                </select>
                {errors.category && (
                  <p className="mt-1 text-sm text-red-600">{errors.category.message}</p>
                )}
              </div>
            </div>

            {/* Duration & Order */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="duration" className="block text-sm font-medium text-gray-700">
                  Длительность *
                </label>
                <input
                  type="text"
                  id="duration"
                  {...register('duration', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="4 недели"
                />
                {errors.duration && (
                  <p className="mt-1 text-sm text-red-600">{errors.duration.message}</p>
                )}
              </div>

              <div>
                <label htmlFor="orderIndex" className="block text-sm font-medium text-gray-700">
                  Порядок сортировки
                </label>
                <input
                  type="number"
                  id="orderIndex"
                  {...register('orderIndex', { valueAsNumber: true })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  min="1"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Pricing Card */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Ценообразование</h2>
          
          <div className="mt-6 space-y-4">
            {/* Is Paid Toggle */}
            <div className="flex items-center">
              <input
                type="checkbox"
                id="isPaid"
                {...register('isPaid')}
                className="h-4 w-4 rounded border-gray-300 text-green-600 focus:ring-green-500"
              />
              <label htmlFor="isPaid" className="ml-2 block text-sm text-gray-900">
                Платный курс
              </label>
            </div>

            {/* Price (if paid) */}
            {isPaid && (
              <div>
                <label htmlFor="price" className="block text-sm font-medium text-gray-700">
                  Цена (₽) *
                </label>
                <input
                  type="number"
                  id="price"
                  {...register('price', { valueAsNumber: true })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="2999"
                  min="0"
                  step="1"
                />
              </div>
            )}
          </div>
        </div>

        {/* Publishing Card */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Публикация</h2>
          
          <div className="mt-6">
            <div className="flex items-center">
              <input
                type="checkbox"
                id="isPublished"
                {...register('isPublished')}
                className="h-4 w-4 rounded border-gray-300 text-green-600 focus:ring-green-500"
              />
              <label htmlFor="isPublished" className="ml-2 block text-sm text-gray-900">
                Опубликовать курс сразу
              </label>
            </div>
            <p className="mt-2 text-sm text-gray-500">
              Если не отмечено, курс будет сохранен как черновик
            </p>
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
            href="/courses"
            className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50"
          >
            Отмена
          </Link>
          <button
            type="submit"
            disabled={loading}
            className="rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 disabled:opacity-50"
          >
            {loading ? 'Создание...' : 'Создать курс'}
          </button>
        </div>
      </form>
    </div>
  );
}



