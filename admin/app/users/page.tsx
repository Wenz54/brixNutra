'use client';

/**
 * Users List Page - Список пользователей
 */

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { User } from '@/lib/types';
import {
  UserGroupIcon,
  MagnifyingGlassIcon,
  FunnelIcon,
  EyeIcon,
} from '@heroicons/react/24/outline';

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: User[] }>(endpoints.users);
      // setUsers(response.data);
      
      // Mock data для демонстрации
      setUsers([
        {
          id: '1',
          email: 'anna.ivanova@example.com',
          phone: '+7 (999) 123-45-67',
          name: 'Анна Иванова',
          birthDate: '1995-05-15',
          goal: 'weight_loss',
          gender: 'female',
          height: 165,
          weight: 70,
          activityLevel: 'moderate',
          isActive: true,
          subscriptionStatus: 'active',
          createdAt: '2025-09-01T10:00:00Z',
          updatedAt: '2025-10-14T12:00:00Z',
        },
        {
          id: '2',
          email: 'petr.sidorov@example.com',
          phone: '+7 (999) 234-56-78',
          name: 'Петр Сидоров',
          birthDate: '1988-11-20',
          goal: 'muscle_gain',
          gender: 'male',
          height: 180,
          weight: 85,
          activityLevel: 'active',
          isActive: true,
          subscriptionStatus: 'active',
          createdAt: '2025-08-15T10:00:00Z',
          updatedAt: '2025-10-13T15:00:00Z',
        },
        {
          id: '3',
          email: 'maria.petrova@example.com',
          name: 'Мария Петрова',
          birthDate: '2000-03-10',
          goal: 'health',
          gender: 'female',
          height: 170,
          weight: 58,
          activityLevel: 'light',
          isActive: true,
          subscriptionStatus: 'cancelled',
          createdAt: '2025-07-20T10:00:00Z',
          updatedAt: '2025-10-10T10:00:00Z',
        },
        {
          id: '4',
          email: 'dmitry.kozlov@example.com',
          phone: '+7 (999) 456-78-90',
          name: 'Дмитрий Козлов',
          birthDate: '1992-08-05',
          goal: 'weight_loss',
          gender: 'male',
          height: 175,
          weight: 92,
          activityLevel: 'sedentary',
          isActive: false,
          subscriptionStatus: 'expired',
          createdAt: '2025-06-01T10:00:00Z',
          updatedAt: '2025-09-30T10:00:00Z',
        },
      ]);
    } catch (err) {
      console.error('Error fetching users:', err);
      setError('Не удалось загрузить пользователей');
    } finally {
      setLoading(false);
    }
  };

  // Фильтрация пользователей
  const filteredUsers = (() => {
    let result = users;

    // Фильтр по статусу подписки
    if (filter === 'active_subscription') {
      result = result.filter(u => u.subscriptionStatus === 'active');
    } else if (filter === 'cancelled_subscription') {
      result = result.filter(u => u.subscriptionStatus === 'cancelled');
    } else if (filter === 'expired_subscription') {
      result = result.filter(u => u.subscriptionStatus === 'expired');
    } else if (filter === 'active_users') {
      result = result.filter(u => u.isActive);
    } else if (filter === 'inactive_users') {
      result = result.filter(u => !u.isActive);
    }

    // Поиск
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      result = result.filter(u =>
        u.name.toLowerCase().includes(query) ||
        u.email.toLowerCase().includes(query) ||
        u.phone?.toLowerCase().includes(query)
      );
    }

    return result;
  })();

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка пользователей...</p>
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
            onClick={fetchUsers}
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
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Пользователи</h1>
        <p className="mt-2 text-gray-600">
          Управление пользователями приложения ({filteredUsers.length} из {users.length})
        </p>
      </div>

      {/* Search & Filters */}
      <div className="flex flex-col space-y-4 sm:flex-row sm:items-center sm:justify-between sm:space-y-0 sm:space-x-4">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <MagnifyingGlassIcon className="absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            placeholder="Поиск по имени, email, телефону..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="block w-full rounded-md border-gray-300 pl-10 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
          />
        </div>

        {/* Filter Dropdown */}
        <div className="flex items-center space-x-2">
          <FunnelIcon className="h-5 w-5 text-gray-400" />
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="block rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
          >
            <option value="all">Все пользователи</option>
            <option value="active_users">Активные</option>
            <option value="inactive_users">Неактивные</option>
            <option value="active_subscription">Активная подписка</option>
            <option value="cancelled_subscription">Отменена подписка</option>
            <option value="expired_subscription">Истекла подписка</option>
          </select>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-4">
        <StatCard
          label="Всего"
          value={users.length}
          color="bg-blue-100 text-blue-800"
        />
        <StatCard
          label="Активные"
          value={users.filter(u => u.isActive).length}
          color="bg-green-100 text-green-800"
        />
        <StatCard
          label="С подпиской"
          value={users.filter(u => u.subscriptionStatus === 'active').length}
          color="bg-purple-100 text-purple-800"
        />
        <StatCard
          label="Отменили"
          value={users.filter(u => u.subscriptionStatus === 'cancelled').length}
          color="bg-orange-100 text-orange-800"
        />
      </div>

      {/* Users Table */}
      {filteredUsers.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <UserGroupIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Пользователи не найдены</h3>
          <p className="mt-1 text-sm text-gray-500">
            {searchQuery ? 'Попробуйте другой поисковый запрос' : 'Нет пользователей в выбранном фильтре'}
          </p>
        </div>
      ) : (
        <div className="overflow-hidden rounded-lg bg-white shadow">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  Пользователь
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  Контакты
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  Цель
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  Подписка
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  Статус
                </th>
                <th className="px-6 py-3 text-right text-xs font-medium uppercase tracking-wider text-gray-500">
                  Действия
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 bg-white">
              {filteredUsers.map((user) => (
                <tr key={user.id} className="hover:bg-gray-50">
                  <td className="whitespace-nowrap px-6 py-4">
                    <div className="flex items-center">
                      <div className="h-10 w-10 flex-shrink-0">
                        <div className="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                          <span className="text-sm font-medium text-green-800">
                            {user.name.split(' ').map(n => n[0]).join('')}
                          </span>
                        </div>
                      </div>
                      <div className="ml-4">
                        <div className="text-sm font-medium text-gray-900">{user.name}</div>
                        <div className="text-sm text-gray-500">ID: {user.id}</div>
                      </div>
                    </div>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <div className="text-sm text-gray-900">{user.email}</div>
                    {user.phone && <div className="text-sm text-gray-500">{user.phone}</div>}
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <span className="inline-flex rounded-full bg-blue-100 px-2 py-1 text-xs font-semibold text-blue-800">
                      {getGoalLabel(user.goal)}
                    </span>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <span
                      className={`inline-flex rounded-full px-2 py-1 text-xs font-semibold ${getSubscriptionBadgeColor(
                        user.subscriptionStatus
                      )}`}
                    >
                      {getSubscriptionLabel(user.subscriptionStatus)}
                    </span>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4">
                    <span
                      className={`inline-flex rounded-full px-2 py-1 text-xs font-semibold ${
                        user.isActive ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                      }`}
                    >
                      {user.isActive ? 'Активен' : 'Неактивен'}
                    </span>
                  </td>
                  <td className="whitespace-nowrap px-6 py-4 text-right text-sm font-medium">
                    <Link
                      href={`/users/${user.id}`}
                      className="inline-flex items-center text-green-600 hover:text-green-900"
                    >
                      <EyeIcon className="mr-1 h-4 w-4" />
                      Просмотр
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ==========================================
// Components & Helpers
// ==========================================

interface StatCardProps {
  label: string;
  value: number;
  color: string;
}

function StatCard({ label, value, color }: StatCardProps) {
  return (
    <div className="rounded-lg bg-white p-6 shadow">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-500">{label}</p>
          <p className="mt-1 text-3xl font-semibold text-gray-900">{value}</p>
        </div>
        <div className={`rounded-full p-3 ${color}`}>
          <UserGroupIcon className="h-6 w-6" />
        </div>
      </div>
    </div>
  );
}

function getGoalLabel(goal?: string): string {
  const labels: Record<string, string> = {
    weight_loss: 'Снижение веса',
    weight_gain: 'Набор веса',
    muscle_gain: 'Набор мышечной массы',
    health: 'Здоровье',
  };
  return goal ? labels[goal] || goal : 'Не указано';
}

function getSubscriptionLabel(status?: string): string {
  const labels: Record<string, string> = {
    active: 'Активна',
    cancelled: 'Отменена',
    expired: 'Истекла',
  };
  return status ? labels[status] || status : 'Нет подписки';
}

function getSubscriptionBadgeColor(status?: string): string {
  switch (status) {
    case 'active':
      return 'bg-green-100 text-green-800';
    case 'cancelled':
      return 'bg-orange-100 text-orange-800';
    case 'expired':
      return 'bg-red-100 text-red-800';
    default:
      return 'bg-gray-100 text-gray-800';
  }
}



