'use client';

/**
 * Dashboard Page - Главная страница админ-панели
 */

import { useEffect, useState } from 'react';
import { api } from '@/lib/api';
import type { DashboardStats } from '@/lib/types';
import {
  UserGroupIcon,
  CreditCardIcon,
  BookOpenIcon,
  ChatBubbleLeftRightIcon,
} from '@heroicons/react/24/outline';

export default function DashboardPage() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchDashboardStats();
  }, []);

  const fetchDashboardStats = async () => {
    try {
      setLoading(true);
      // TODO: Раскомментировать когда backend будет готов
      // const data = await api.get<DashboardStats>('/home/dashboard');
      // setStats(data);
      
      // Mock data для демонстрации
      setStats({
        users: {
          total: 1247,
          newThisWeek: 32,
        },
        subscriptions: {
          active: 856,
          cancelled: 41,
          revenueMrr: 42800,
        },
        content: {
          courses: 24,
          recipes: 312,
          mealPlans: 18,
          articles: 89,
        },
        activity: {
          diaryEntriesToday: 1523,
          aiChatsToday: 234,
        },
      });
    } catch (err) {
      console.error('Error fetching dashboard stats:', err);
      setError('Не удалось загрузить статистику');
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка статистики...</p>
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
            onClick={fetchDashboardStats}
            className="mt-4 rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
          >
            Повторить
          </button>
        </div>
      </div>
    );
  }

  if (!stats) {
    return null;
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-2 text-gray-600">
          Обзор ключевых метрик и статистики Brix Nutrition
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        {/* Users */}
        <StatCard
          title="Пользователи"
          value={stats.users.total.toLocaleString()}
          change={`+${stats.users.newThisWeek} за неделю`}
          icon={UserGroupIcon}
          iconBg="bg-blue-100"
          iconColor="text-blue-600"
        />

        {/* Active Subscriptions */}
        <StatCard
          title="Активные подписки"
          value={stats.subscriptions.active.toLocaleString()}
          change={`${stats.subscriptions.cancelled} отменено`}
          icon={CreditCardIcon}
          iconBg="bg-green-100"
          iconColor="text-green-600"
        />

        {/* Recipes */}
        <StatCard
          title="Рецепты"
          value={stats.content.recipes.toLocaleString()}
          change={`${stats.content.courses} курсов`}
          icon={BookOpenIcon}
          iconBg="bg-purple-100"
          iconColor="text-purple-600"
        />

        {/* AI Chats Today */}
        <StatCard
          title="AI чаты сегодня"
          value={stats.activity.aiChatsToday.toLocaleString()}
          change={`${stats.activity.diaryEntriesToday} записей в дневнике`}
          icon={ChatBubbleLeftRightIcon}
          iconBg="bg-orange-100"
          iconColor="text-orange-600"
        />
      </div>

      {/* Revenue Card */}
      <div className="rounded-lg bg-gradient-to-br from-green-500 to-green-700 p-6 text-white shadow-lg">
        <h3 className="text-lg font-semibold">Ежемесячный доход (MRR)</h3>
        <p className="mt-2 text-4xl font-bold">
          ${stats.subscriptions.revenueMrr.toLocaleString()}
        </p>
        <p className="mt-1 text-green-100">
          {stats.subscriptions.active} активных подписок
        </p>
      </div>

      {/* Quick Actions */}
      <div className="grid gap-6 lg:grid-cols-2">
        {/* Content Stats */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h3 className="text-lg font-semibold text-gray-900">Контент</h3>
          <div className="mt-4 space-y-3">
            <ContentStat label="Курсы" value={stats.content.courses} />
            <ContentStat label="Рецепты" value={stats.content.recipes} />
            <ContentStat label="Планы питания" value={stats.content.mealPlans} />
            <ContentStat label="Статьи блога" value={stats.content.articles} />
          </div>
        </div>

        {/* Activity Stats */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h3 className="text-lg font-semibold text-gray-900">Активность сегодня</h3>
          <div className="mt-4 space-y-3">
            <ContentStat label="Записи в дневнике" value={stats.activity.diaryEntriesToday} />
            <ContentStat label="AI чаты" value={stats.activity.aiChatsToday} />
            <ContentStat label="Новые пользователи" value={stats.users.newThisWeek} />
          </div>
        </div>
      </div>
    </div>
  );
}

// ==========================================
// Components
// ==========================================

interface StatCardProps {
  title: string;
  value: string;
  change: string;
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
  iconBg: string;
  iconColor: string;
}

function StatCard({ title, value, change, icon: Icon, iconBg, iconColor }: StatCardProps) {
  return (
    <div className="rounded-lg bg-white p-6 shadow">
      <div className="flex items-center">
        <div className={`flex-shrink-0 rounded-lg ${iconBg} p-3`}>
          <Icon className={`h-6 w-6 ${iconColor}`} />
        </div>
        <div className="ml-4 flex-1">
          <p className="text-sm font-medium text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900">{value}</p>
        </div>
      </div>
      <p className="mt-3 text-sm text-gray-500">{change}</p>
    </div>
  );
}

interface ContentStatProps {
  label: string;
  value: number;
}

function ContentStat({ label, value }: ContentStatProps) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-sm text-gray-600">{label}</span>
      <span className="text-sm font-semibold text-gray-900">{value}</span>
    </div>
  );
}
