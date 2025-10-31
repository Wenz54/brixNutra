'use client';

/**
 * User Detail Page - Детальная информация о пользователе
 */

import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { User } from '@/lib/types';
import {
  ArrowLeftIcon,
  UserIcon,
  EnvelopeIcon,
  PhoneIcon,
  CalendarIcon,
  ChartBarIcon,
  HeartIcon,
  FireIcon,
} from '@heroicons/react/24/outline';

export default function UserDetailPage() {
  const router = useRouter();
  const params = useParams();
  const userId = params.id as string;

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    fetchUser();
  }, [userId]);

  const fetchUser = async () => {
    try {
      setLoading(true);
      setError(null);

      // TODO: Раскомментировать когда API будет готов
      // const userData = await api.get<User>(`${endpoints.users}/${userId}`);
      // setUser(userData);

      // Mock data
      const mockUser: User = {
        id: userId,
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
      };

      setUser(mockUser);
    } catch (err) {
      console.error('Error fetching user:', err);
      setError('Не удалось загрузить данные пользователя');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка пользователя...</p>
        </div>
      </div>
    );
  }

  if (error || !user) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <p className="text-red-600">{error || 'Пользователь не найден'}</p>
          <button
            onClick={fetchUser}
            className="mt-4 rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
          >
            Повторить
          </button>
        </div>
      </div>
    );
  }

  const age = calculateAge(user.birthDate);
  const bmi = user.height && user.weight ? calculateBMI(user.height, user.weight) : null;

  return (
    <div className="mx-auto max-w-5xl space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/users"
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к списку пользователей
        </Link>
        <h1 className="mt-4 text-3xl font-bold text-gray-900">{user.name}</h1>
        <p className="mt-2 text-gray-600">ID: {user.id}</p>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Left Column - Basic Info */}
        <div className="space-y-6 lg:col-span-2">
          {/* Profile Info */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Основная информация</h2>
            
            <div className="space-y-4">
              <InfoRow icon={EnvelopeIcon} label="Email" value={user.email} />
              {user.phone && <InfoRow icon={PhoneIcon} label="Телефон" value={user.phone} />}
              <InfoRow icon={CalendarIcon} label="Дата рождения" value={`${formatDate(user.birthDate)} (${age} лет)`} />
              <InfoRow icon={UserIcon} label="Пол" value={getGenderLabel(user.gender)} />
            </div>
          </div>

          {/* Physical Data */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Физические данные</h2>
            
            <div className="grid grid-cols-2 gap-4">
              <StatBox label="Рост" value={user.height ? `${user.height} см` : 'Не указан'} />
              <StatBox label="Вес" value={user.weight ? `${user.weight} кг` : 'Не указан'} />
              <StatBox
                label="ИМТ"
                value={bmi ? bmi.value.toFixed(1) : 'N/A'}
                badge={bmi?.category}
              />
              <StatBox
                label="Активность"
                value={getActivityLabel(user.activityLevel)}
              />
            </div>
          </div>

          {/* Goal & Activity */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Цель и активность</h2>
            
            <div className="space-y-4">
              <div>
                <p className="text-sm font-medium text-gray-500">Цель</p>
                <div className="mt-1 flex items-center">
                  <HeartIcon className="h-5 w-5 text-red-500 mr-2" />
                  <p className="text-lg font-medium text-gray-900">
                    {getGoalLabel(user.goal)}
                  </p>
                </div>
              </div>

              <div>
                <p className="text-sm font-medium text-gray-500">Уровень активности</p>
                <div className="mt-1 flex items-center">
                  <FireIcon className="h-5 w-5 text-orange-500 mr-2" />
                  <p className="text-lg font-medium text-gray-900">
                    {getActivityLabel(user.activityLevel)}
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Mock Activity Stats */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Статистика активности (за 30 дней)</h2>
            
            <div className="grid grid-cols-3 gap-4">
              <ActivityStat label="Записи в дневнике" value="87" icon={ChartBarIcon} color="text-blue-600" />
              <ActivityStat label="Тренировки" value="24" icon={FireIcon} color="text-orange-600" />
              <ActivityStat label="AI консультации" value="12" icon={HeartIcon} color="text-pink-600" />
            </div>

            <div className="mt-6 pt-6 border-t border-gray-200">
              <h3 className="text-sm font-medium text-gray-900 mb-3">Последняя активность</h3>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Записал завтрак (сегодня, 08:30)</li>
                <li>• Завершил урок "Макронутриенты" (вчера, 20:15)</li>
                <li>• Провел AI консультацию (вчера, 19:40)</li>
                <li>• Записал обед (вчера, 13:20)</li>
              </ul>
            </div>
          </div>
        </div>

        {/* Right Column - Status & Meta */}
        <div className="space-y-6">
          {/* Status Card */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Статус</h2>
            
            <div className="space-y-3">
              <StatusRow label="Аккаунт" value={user.isActive ? 'Активен' : 'Неактивен'} status={user.isActive ? 'success' : 'danger'} />
              <StatusRow
                label="Подписка"
                value={getSubscriptionLabel(user.subscriptionStatus)}
                status={user.subscriptionStatus === 'active' ? 'success' : user.subscriptionStatus === 'cancelled' ? 'warning' : 'danger'}
              />
            </div>
          </div>

          {/* Metadata */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Метаданные</h2>
            
            <div className="space-y-3 text-sm">
              <div>
                <p className="font-medium text-gray-500">Регистрация</p>
                <p className="text-gray-900">{formatDate(user.createdAt)}</p>
              </div>
              <div>
                <p className="font-medium text-gray-500">Последнее обновление</p>
                <p className="text-gray-900">{formatDate(user.updatedAt)}</p>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="rounded-lg bg-white p-6 shadow">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Действия</h2>
            
            <div className="space-y-3">
              <button className="w-full rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700">
                Отправить уведомление
              </button>
              <button className="w-full rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                Просмотр планов питания
              </button>
              <button className="w-full rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
                Просмотр анализов
              </button>
              <button className="w-full rounded-md border border-red-300 bg-white px-4 py-2 text-sm font-medium text-red-700 hover:bg-red-50">
                {user.isActive ? 'Деактивировать' : 'Активировать'}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ==========================================
// Components & Helpers
// ==========================================

interface InfoRowProps {
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  label: string;
  value: string;
}

function InfoRow({ icon: Icon, label, value }: InfoRowProps) {
  return (
    <div className="flex items-center">
      <Icon className="h-5 w-5 text-gray-400 mr-3" />
      <div className="flex-1">
        <p className="text-sm font-medium text-gray-500">{label}</p>
        <p className="text-sm text-gray-900">{value}</p>
      </div>
    </div>
  );
}

interface StatBoxProps {
  label: string;
  value: string;
  badge?: string;
}

function StatBox({ label, value, badge }: StatBoxProps) {
  return (
    <div className="rounded-lg bg-gray-50 p-4">
      <p className="text-sm font-medium text-gray-500">{label}</p>
      <p className="mt-1 text-2xl font-semibold text-gray-900">{value}</p>
      {badge && (
        <span className="mt-2 inline-block rounded-full bg-blue-100 px-2 py-1 text-xs font-semibold text-blue-800">
          {badge}
        </span>
      )}
    </div>
  );
}

interface ActivityStatProps {
  label: string;
  value: string;
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  color: string;
}

function ActivityStat({ label, value, icon: Icon, color }: ActivityStatProps) {
  return (
    <div className="text-center">
      <Icon className={`h-8 w-8 mx-auto ${color}`} />
      <p className="mt-2 text-2xl font-bold text-gray-900">{value}</p>
      <p className="text-xs text-gray-500">{label}</p>
    </div>
  );
}

interface StatusRowProps {
  label: string;
  value: string;
  status: 'success' | 'warning' | 'danger';
}

function StatusRow({ label, value, status }: StatusRowProps) {
  const colors = {
    success: 'bg-green-100 text-green-800',
    warning: 'bg-orange-100 text-orange-800',
    danger: 'bg-red-100 text-red-800',
  };

  return (
    <div className="flex items-center justify-between">
      <p className="text-sm font-medium text-gray-500">{label}</p>
      <span className={`rounded-full px-2 py-1 text-xs font-semibold ${colors[status]}`}>
        {value}
      </span>
    </div>
  );
}

// Helpers
function calculateAge(birthDate?: string): number {
  if (!birthDate) return 0;
  const today = new Date();
  const birth = new Date(birthDate);
  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  return age;
}

function calculateBMI(height: number, weight: number): { value: number; category: string } {
  const heightInMeters = height / 100;
  const bmi = weight / (heightInMeters * heightInMeters);

  let category = 'Норма';
  if (bmi < 18.5) category = 'Недостаточный вес';
  else if (bmi >= 25 && bmi < 30) category = 'Избыточный вес';
  else if (bmi >= 30) category = 'Ожирение';

  return { value: bmi, category };
}

function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

function getGenderLabel(gender?: string): string {
  const labels: Record<string, string> = {
    male: 'Мужской',
    female: 'Женский',
    other: 'Другой',
  };
  return gender ? labels[gender] || gender : 'Не указан';
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

function getActivityLabel(level?: string): string {
  const labels: Record<string, string> = {
    sedentary: 'Сидячий образ жизни',
    light: 'Легкая активность',
    moderate: 'Умеренная активность',
    active: 'Высокая активность',
    very_active: 'Очень высокая активность',
  };
  return level ? labels[level] || level : 'Не указано';
}

function getSubscriptionLabel(status?: string): string {
  const labels: Record<string, string> = {
    active: 'Активна',
    cancelled: 'Отменена',
    expired: 'Истекла',
  };
  return status ? labels[status] || status : 'Нет подписки';
}



