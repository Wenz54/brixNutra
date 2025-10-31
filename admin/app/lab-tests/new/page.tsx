'use client';

/**
 * Create Lab Parameter Page - Добавление параметра анализа
 */

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm, useFieldArray } from 'react-hook-form';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import { ArrowLeftIcon, PlusIcon, TrashIcon } from '@heroicons/react/24/outline';

interface LabParameterFormData {
  parameterId: string;
  name: string;
  category: string;
  units: string;
  description: string;
  referenceRanges: {
    gender: 'male' | 'female' | 'all';
    ageMin?: number;
    ageMax?: number;
    min: number;
    max: number;
    unit: string;
  }[];
  lowCauses: { value: string }[];
  highCauses: { value: string }[];
  recommendations: string;
}

export default function NewLabParameterPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const {
    register,
    control,
    handleSubmit,
    formState: { errors },
  } = useForm<LabParameterFormData>({
    defaultValues: {
      category: 'Клинический анализ крови',
      referenceRanges: [{ gender: 'all', min: 0, max: 0, unit: 'г/л' }],
      lowCauses: [{ value: '' }],
      highCauses: [{ value: '' }],
    },
  });

  const { fields: rangeFields, append: appendRange, remove: removeRange } = useFieldArray({
    control,
    name: 'referenceRanges',
  });

  const { fields: lowCausesFields, append: appendLowCause, remove: removeLowCause } = useFieldArray({
    control,
    name: 'lowCauses',
  });

  const { fields: highCausesFields, append: appendHighCause, remove: removeHighCause } = useFieldArray({
    control,
    name: 'highCauses',
  });

  const onSubmit = async (data: LabParameterFormData) => {
    try {
      setLoading(true);
      setError(null);

      // Преобразование данных
      const parameterData = {
        ...data,
        units: data.units.split(',').map(u => u.trim()).filter(Boolean),
        lowCauses: data.lowCauses.map(c => c.value).filter(Boolean),
        highCauses: data.highCauses.map(c => c.value).filter(Boolean),
      };

      // TODO: Раскомментировать когда API будет готов
      // const newParameter = await api.post(endpoints.labParameters, parameterData);
      // router.push(`/lab-tests/${newParameter.id}`);

      console.log('Creating parameter:', parameterData);
      alert('Параметр создан! (mock)');
      router.push('/lab-tests');
    } catch (err) {
      console.error('Error creating parameter:', err);
      setError('Не удалось создать параметр');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-4xl space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/lab-tests"
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к списку параметров
        </Link>
        <h1 className="mt-4 text-3xl font-bold text-gray-900">Добавить параметр</h1>
        <p className="mt-2 text-gray-600">
          Заполните информацию о лабораторном показателе
        </p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Основная информация</h2>
          
          <div className="mt-6 space-y-6">
            {/* Parameter ID & Name */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="parameterId" className="block text-sm font-medium text-gray-700">
                  Код параметра *
                </label>
                <input
                  type="text"
                  id="parameterId"
                  {...register('parameterId', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="HGB"
                />
                {errors.parameterId && (
                  <p className="mt-1 text-sm text-red-600">{errors.parameterId.message}</p>
                )}
              </div>

              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                  Название *
                </label>
                <input
                  type="text"
                  id="name"
                  {...register('name', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="Гемоглобин"
                />
                {errors.name && (
                  <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
                )}
              </div>
            </div>

            {/* Category & Units */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="category" className="block text-sm font-medium text-gray-700">
                  Категория *
                </label>
                <select
                  id="category"
                  {...register('category', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                >
                  <option value="Клинический анализ крови">Клинический анализ крови</option>
                  <option value="Биохимический анализ крови">Биохимический анализ крови</option>
                  <option value="Гормоны">Гормоны</option>
                  <option value="Витамины">Витамины</option>
                  <option value="Минералы">Минералы</option>
                  <option value="Иммунология">Иммунология</option>
                </select>
              </div>

              <div>
                <label htmlFor="units" className="block text-sm font-medium text-gray-700">
                  Единицы измерения *
                </label>
                <input
                  type="text"
                  id="units"
                  {...register('units', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="г/л, г/дл"
                />
                <p className="mt-1 text-sm text-gray-500">Через запятую</p>
              </div>
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
                placeholder="Белок эритроцитов, переносящий кислород..."
              />
              {errors.description && (
                <p className="mt-1 text-sm text-red-600">{errors.description.message}</p>
              )}
            </div>
          </div>
        </div>

        {/* Reference Ranges */}
        <div className="rounded-lg bg-white p-6 shadow">
          <div className="flex items-center justify-between">
            <h2 className="text-lg font-semibold text-gray-900">Референсные значения</h2>
            <button
              type="button"
              onClick={() => appendRange({ gender: 'all', min: 0, max: 0, unit: 'г/л' })}
              className="flex items-center text-sm text-green-600 hover:text-green-700"
            >
              <PlusIcon className="mr-1 h-4 w-4" />
              Добавить
            </button>
          </div>

          <div className="mt-6 space-y-4">
            {rangeFields.map((field, index) => (
              <div key={field.id} className="rounded-lg border border-gray-200 p-4">
                <div className="grid grid-cols-6 gap-4">
                  {/* Gender */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Пол</label>
                    <select
                      {...register(`referenceRanges.${index}.gender`)}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    >
                      <option value="all">Все</option>
                      <option value="male">Муж</option>
                      <option value="female">Жен</option>
                    </select>
                  </div>

                  {/* Age Min */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Возр. от</label>
                    <input
                      type="number"
                      {...register(`referenceRanges.${index}.ageMin`, { valueAsNumber: true })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                      placeholder="18"
                      min="0"
                    />
                  </div>

                  {/* Age Max */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Возр. до</label>
                    <input
                      type="number"
                      {...register(`referenceRanges.${index}.ageMax`, { valueAsNumber: true })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                      placeholder="65"
                      min="0"
                    />
                  </div>

                  {/* Min */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Мин *</label>
                    <input
                      type="number"
                      {...register(`referenceRanges.${index}.min`, { required: true, valueAsNumber: true })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                      step="0.01"
                    />
                  </div>

                  {/* Max */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Макс *</label>
                    <input
                      type="number"
                      {...register(`referenceRanges.${index}.max`, { required: true, valueAsNumber: true })}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                      step="0.01"
                    />
                  </div>

                  {/* Unit */}
                  <div className="flex items-end space-x-2">
                    <div className="flex-1">
                      <label className="block text-sm font-medium text-gray-700">Ед.</label>
                      <input
                        type="text"
                        {...register(`referenceRanges.${index}.unit`)}
                        className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                        placeholder="г/л"
                      />
                    </div>
                    {rangeFields.length > 1 && (
                      <button
                        type="button"
                        onClick={() => removeRange(index)}
                        className="text-red-600 hover:text-red-700"
                      >
                        <TrashIcon className="h-5 w-5" />
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Causes */}
        <div className="grid grid-cols-2 gap-6">
          {/* Low Causes */}
          <div className="rounded-lg bg-white p-6 shadow">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">Причины снижения</h2>
              <button
                type="button"
                onClick={() => appendLowCause({ value: '' })}
                className="flex items-center text-sm text-green-600 hover:text-green-700"
              >
                <PlusIcon className="mr-1 h-4 w-4" />
                Добавить
              </button>
            </div>

            <div className="mt-4 space-y-3">
              {lowCausesFields.map((field, index) => (
                <div key={field.id} className="flex items-center space-x-2">
                  <input
                    type="text"
                    {...register(`lowCauses.${index}.value`)}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    placeholder="Причина..."
                  />
                  {lowCausesFields.length > 1 && (
                    <button
                      type="button"
                      onClick={() => removeLowCause(index)}
                      className="text-red-600 hover:text-red-700"
                    >
                      <TrashIcon className="h-5 w-5" />
                    </button>
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* High Causes */}
          <div className="rounded-lg bg-white p-6 shadow">
            <div className="flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">Причины повышения</h2>
              <button
                type="button"
                onClick={() => appendHighCause({ value: '' })}
                className="flex items-center text-sm text-green-600 hover:text-green-700"
              >
                <PlusIcon className="mr-1 h-4 w-4" />
                Добавить
              </button>
            </div>

            <div className="mt-4 space-y-3">
              {highCausesFields.map((field, index) => (
                <div key={field.id} className="flex items-center space-x-2">
                  <input
                    type="text"
                    {...register(`highCauses.${index}.value`)}
                    className="block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                    placeholder="Причина..."
                  />
                  {highCausesFields.length > 1 && (
                    <button
                      type="button"
                      onClick={() => removeHighCause(index)}
                      className="text-red-600 hover:text-red-700"
                    >
                      <TrashIcon className="h-5 w-5" />
                    </button>
                  )}
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Recommendations */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Рекомендации</h2>
          
          <div className="mt-6">
            <textarea
              id="recommendations"
              rows={4}
              {...register('recommendations')}
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
              placeholder="Что делать при отклонениях..."
            />
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
            href="/lab-tests"
            className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50"
          >
            Отмена
          </Link>
          <button
            type="submit"
            disabled={loading}
            className="rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 disabled:opacity-50"
          >
            {loading ? 'Создание...' : 'Создать параметр'}
          </button>
        </div>
      </form>
    </div>
  );
}



