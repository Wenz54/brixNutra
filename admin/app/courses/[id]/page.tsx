'use client';

/**
 * Edit Course Page - Редактирование курса
 */

import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { useForm } from 'react-hook-form';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { Course } from '@/lib/types';
import { ArrowLeftIcon, AcademicCapIcon } from '@heroicons/react/24/outline';

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

export default function EditCoursePage() {
  const router = useRouter();
  const params = useParams();
  const courseId = params.id as string;

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [course, setCourse] = useState<Course | null>(null);

  const {
    register,
    handleSubmit,
    watch,
    reset,
    formState: { errors },
  } = useForm<CourseFormData>();

  const isPaid = watch('isPaid');

  useEffect(() => {
    fetchCourse();
  }, [courseId]);

  const fetchCourse = async () => {
    try {
      setLoading(true);
      setError(null);

      // TODO: Раскомментировать когда API будет готов
      // const courseData = await api.get<Course>(endpoints.course(courseId));
      // setCourse(courseData);
      // reset(courseData);

      // Mock data
      const mockCourse: Course = {
        id: courseId,
        title: 'Основы здорового питания',
        description: 'Научитесь основам сбалансированного питания и здорового образа жизни',
        imageUrl: '/placeholder-course.jpg',
        author: 'Доктор Иванов',
        isPaid: false,
        duration: '4 недели',
        category: 'Питание',
        orderIndex: 1,
        isPublished: true,
        createdAt: '2025-01-15T10:00:00Z',
        updatedAt: '2025-01-15T10:00:00Z',
      };

      setCourse(mockCourse);
      reset(mockCourse);
    } catch (err) {
      console.error('Error fetching course:', err);
      setError('Не удалось загрузить курс');
    } finally {
      setLoading(false);
    }
  };

  const onSubmit = async (data: CourseFormData) => {
    try {
      setSaving(true);
      setError(null);

      // Валидация
      if (data.isPaid && (!data.price || data.price <= 0)) {
        setError('Укажите цену для платного курса');
        return;
      }

      // TODO: Раскомментировать когда API будет готов
      // await api.put(endpoints.course(courseId), data);

      console.log('Updating course:', data);
      alert('Курс обновлен! (mock)');
      router.push('/courses');
    } catch (err) {
      console.error('Error updating course:', err);
      setError('Не удалось обновить курс');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка курса...</p>
        </div>
      </div>
    );
  }

  if (error && !course) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <p className="text-red-600">{error}</p>
          <button
            onClick={fetchCourse}
            className="mt-4 rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
          >
            Повторить
          </button>
        </div>
      </div>
    );
  }

  if (!course) {
    return null;
  }

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
        <h1 className="mt-4 text-3xl font-bold text-gray-900">Редактировать курс</h1>
        <p className="mt-2 text-gray-600">
          ID: {courseId}
        </p>
      </div>

      {/* Quick Actions */}
      <div className="flex space-x-4">
        <Link
          href={`/courses/${courseId}/lessons`}
          className="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
        >
          <AcademicCapIcon className="mr-2 h-5 w-5" />
          Управление уроками
        </Link>
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
                Курс опубликован
              </label>
            </div>
            <p className="mt-2 text-sm text-gray-500">
              Если не отмечено, курс будет скрыт от пользователей
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
            disabled={saving}
            className="rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 disabled:opacity-50"
          >
            {saving ? 'Сохранение...' : 'Сохранить изменения'}
          </button>
        </div>
      </form>
    </div>
  );
}



