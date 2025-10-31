'use client';

/**
 * Lab Parameters List Page - Справочник параметров анализов
 */

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { LabParameter } from '@/lib/types';
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  BeakerIcon,
} from '@heroicons/react/24/outline';

export default function LabTestsPage() {
  const [parameters, setParameters] = useState<LabParameter[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>('all');

  useEffect(() => {
    fetchParameters();
  }, []);

  const fetchParameters = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: LabParameter[] }>(endpoints.labParameters);
      // setParameters(response.data);
      
      // Mock data для демонстрации
      setParameters([
        {
          id: '1',
          parameterId: 'HGB',
          name: 'Гемоглобин',
          category: 'Клинический анализ крови',
          units: ['г/л', 'г/дл'],
          referenceRanges: [
            { gender: 'male', min: 130, max: 160, unit: 'г/л' },
            { gender: 'female', min: 120, max: 150, unit: 'г/л' },
          ],
          description: 'Белок эритроцитов, переносящий кислород',
          lowCauses: ['Анемия', 'Кровопотеря', 'Дефицит железа'],
          highCauses: ['Обезвоживание', 'Полицитемия', 'Курение'],
          recommendations: 'При отклонениях обратитесь к терапевту',
        },
        {
          id: '2',
          parameterId: 'GLU',
          name: 'Глюкоза',
          category: 'Биохимический анализ крови',
          units: ['ммоль/л', 'мг/дл'],
          referenceRanges: [
            { gender: 'all', min: 3.9, max: 5.5, unit: 'ммоль/л' },
          ],
          description: 'Уровень сахара в крови',
          lowCauses: ['Голодание', 'Передозировка инсулина', 'Гипогликемия'],
          highCauses: ['Диабет', 'Стресс', 'Прием пищи'],
          recommendations: 'Контроль уровня глюкозы, консультация эндокринолога',
        },
        {
          id: '3',
          parameterId: 'CHOL',
          name: 'Холестерин общий',
          category: 'Биохимический анализ крови',
          units: ['ммоль/л', 'мг/дл'],
          referenceRanges: [
            { gender: 'all', min: 3.0, max: 5.2, unit: 'ммоль/л' },
          ],
          description: 'Жироподобное вещество в крови',
          lowCauses: ['Недоедание', 'Гипертиреоз', 'Заболевания печени'],
          highCauses: ['Атеросклероз', 'Ожирение', 'Неправильное питание'],
          recommendations: 'Диета, физические нагрузки, консультация кардиолога',
        },
        {
          id: '4',
          parameterId: 'TSH',
          name: 'ТТГ (тиреотропный гормон)',
          category: 'Гормоны',
          units: ['мМЕ/л'],
          referenceRanges: [
            { gender: 'all', min: 0.4, max: 4.0, unit: 'мМЕ/л' },
          ],
          description: 'Гормон, регулирующий функцию щитовидной железы',
          lowCauses: ['Гипертиреоз', 'Тиреотоксикоз'],
          highCauses: ['Гипотиреоз', 'Недостаток йода'],
          recommendations: 'Консультация эндокринолога, УЗИ щитовидной железы',
        },
        {
          id: '5',
          parameterId: 'VIT_D',
          name: 'Витамин D',
          category: 'Витамины',
          units: ['нг/мл', 'нмоль/л'],
          referenceRanges: [
            { gender: 'all', min: 30, max: 100, unit: 'нг/мл' },
          ],
          description: 'Жирорастворимый витамин, важный для костей',
          lowCauses: ['Недостаток солнца', 'Неправильное питание', 'Мальабсорбция'],
          highCauses: ['Передозировка добавок'],
          recommendations: 'Прием витамина D, солнечные ванны (умеренно)',
        },
      ]);
    } catch (err) {
      console.error('Error fetching parameters:', err);
      setError('Не удалось загрузить список параметров');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (parameterId: string) => {
    if (!confirm('Вы уверены, что хотите удалить этот параметр?')) {
      return;
    }

    try {
      // TODO: Раскомментировать когда API будет готов
      // await api.delete(`${endpoints.labParameters}/${parameterId}`);
      
      setParameters(parameters.filter(p => p.id !== parameterId));
      alert('Параметр удален');
    } catch (err) {
      console.error('Error deleting parameter:', err);
      alert('Не удалось удалить параметр');
    }
  };

  const categories = Array.from(new Set(parameters.map(p => p.category)));
  const filteredParameters = filter === 'all' 
    ? parameters 
    : parameters.filter(p => p.category === filter);

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка параметров...</p>
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
            onClick={fetchParameters}
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
          <h1 className="text-3xl font-bold text-gray-900">Параметры анализов</h1>
          <p className="mt-2 text-gray-600">
            Справочник лабораторных показателей ({filteredParameters.length} из {parameters.length})
          </p>
        </div>
        <Link
          href="/lab-tests/new"
          className="flex items-center rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
        >
          <PlusIcon className="mr-2 h-5 w-5" />
          Добавить параметр
        </Link>
      </div>

      {/* Filters */}
      <div className="flex space-x-2 overflow-x-auto">
        <FilterButton
          label="Все"
          active={filter === 'all'}
          onClick={() => setFilter('all')}
          count={parameters.length}
        />
        {categories.map((category) => (
          <FilterButton
            key={category}
            label={category}
            active={filter === category}
            onClick={() => setFilter(category)}
            count={parameters.filter(p => p.category === category).length}
          />
        ))}
      </div>

      {/* Parameters List */}
      {filteredParameters.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <BeakerIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Нет параметров</h3>
          <p className="mt-1 text-sm text-gray-500">
            {filter === 'all' ? 'Добавьте первый параметр' : 'Нет параметров в этой категории'}
          </p>
          {filter === 'all' && (
            <div className="mt-6">
              <Link
                href="/lab-tests/new"
                className="inline-flex items-center rounded-md bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-green-700"
              >
                <PlusIcon className="mr-2 h-5 w-5" />
                Добавить параметр
              </Link>
            </div>
          )}
        </div>
      ) : (
        <div className="space-y-4">
          {filteredParameters.map((parameter) => (
            <ParameterCard
              key={parameter.id}
              parameter={parameter}
              onDelete={() => handleDelete(parameter.id)}
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
        whitespace-nowrap rounded-md px-4 py-2 text-sm font-medium transition-colors
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

interface ParameterCardProps {
  parameter: LabParameter;
  onDelete: () => void;
}

function ParameterCard({ parameter, onDelete }: ParameterCardProps) {
  return (
    <div className="rounded-lg bg-white p-6 shadow hover:shadow-md transition-shadow">
      <div className="flex items-start justify-between">
        {/* Info */}
        <div className="flex-1">
          <div className="flex items-center space-x-3">
            <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-blue-100">
              <BeakerIcon className="h-6 w-6 text-blue-600" />
            </div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900">
                {parameter.name}
                <span className="ml-2 text-sm font-normal text-gray-500">
                  ({parameter.parameterId})
                </span>
              </h3>
              <p className="text-sm text-gray-600">{parameter.category}</p>
            </div>
          </div>

          <p className="mt-3 text-sm text-gray-700">{parameter.description}</p>

          {/* Reference Ranges */}
          <div className="mt-4">
            <h4 className="text-sm font-medium text-gray-900">Референсные значения:</h4>
            <div className="mt-2 space-y-1">
              {parameter.referenceRanges.map((range, idx) => (
                <div key={idx} className="flex items-center text-sm text-gray-600">
                  <span className="w-24 font-medium">
                    {range.gender === 'male' ? '♂ Мужчины' : range.gender === 'female' ? '♀ Женщины' : 'Все'}
                    {range.ageMin && ` (${range.ageMin}-${range.ageMax || '∞'})`}:
                  </span>
                  <span className="ml-2 rounded-full bg-green-100 px-3 py-1 text-xs font-semibold text-green-800">
                    {range.min} - {range.max} {range.unit}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Causes */}
          {(parameter.lowCauses || parameter.highCauses) && (
            <div className="mt-4 grid grid-cols-2 gap-4">
              {parameter.lowCauses && (
                <div>
                  <h4 className="text-sm font-medium text-red-700">↓ Причины снижения:</h4>
                  <ul className="mt-1 list-inside list-disc text-sm text-gray-600">
                    {parameter.lowCauses.slice(0, 3).map((cause, idx) => (
                      <li key={idx}>{cause}</li>
                    ))}
                  </ul>
                </div>
              )}
              {parameter.highCauses && (
                <div>
                  <h4 className="text-sm font-medium text-orange-700">↑ Причины повышения:</h4>
                  <ul className="mt-1 list-inside list-disc text-sm text-gray-600">
                    {parameter.highCauses.slice(0, 3).map((cause, idx) => (
                      <li key={idx}>{cause}</li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          )}

          {/* Recommendations */}
          {parameter.recommendations && (
            <div className="mt-4 rounded-md bg-blue-50 p-3">
              <p className="text-sm text-blue-900">
                <span className="font-medium">💡 Рекомендации:</span> {parameter.recommendations}
              </p>
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="ml-4 flex space-x-2">
          <Link
            href={`/lab-tests/${parameter.id}`}
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
  );
}



