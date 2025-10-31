'use client';

/**
 * Sidebar Component - Навигация админ-панели
 */

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  HomeIcon,
  BookOpenIcon,
  AcademicCapIcon,
  BeakerIcon,
  UserGroupIcon,
  NewspaperIcon,
  ChartBarIcon,
  Cog6ToothIcon,
} from '@heroicons/react/24/outline';

interface NavItem {
  name: string;
  href: string;
  icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
}

const navigation: NavItem[] = [
  { name: 'Dashboard', href: '/', icon: HomeIcon },
  { name: 'Курсы', href: '/courses', icon: AcademicCapIcon },
  { name: 'Рецепты', href: '/recipes', icon: BookOpenIcon },
  { name: 'Анализы', href: '/lab-tests', icon: BeakerIcon },
  { name: 'Пользователи', href: '/users', icon: UserGroupIcon },
  { name: 'Блог', href: '/blog', icon: NewspaperIcon },
  { name: 'Аналитика', href: '/analytics', icon: ChartBarIcon },
  { name: 'Настройки', href: '/settings', icon: Cog6ToothIcon },
];

export default function Sidebar() {
  const pathname = usePathname();

  return (
    <div className="flex h-screen w-64 flex-col bg-gray-900">
      {/* Logo */}
      <div className="flex h-16 items-center justify-center border-b border-gray-800">
        <h1 className="text-2xl font-bold text-white">Brix Admin</h1>
      </div>

      {/* Navigation */}
      <nav className="flex-1 space-y-1 px-2 py-4">
        {navigation.map((item) => {
          const isActive = pathname === item.href;
          
          return (
            <Link
              key={item.name}
              href={item.href}
              className={`
                group flex items-center rounded-md px-3 py-2 text-sm font-medium
                ${
                  isActive
                    ? 'bg-gray-800 text-white'
                    : 'text-gray-300 hover:bg-gray-800 hover:text-white'
                }
              `}
            >
              <item.icon
                className={`
                  mr-3 h-6 w-6 flex-shrink-0
                  ${isActive ? 'text-white' : 'text-gray-400 group-hover:text-white'}
                `}
                aria-hidden="true"
              />
              {item.name}
            </Link>
          );
        })}
      </nav>

      {/* Footer */}
      <div className="border-t border-gray-800 p-4">
        <div className="flex items-center">
          <div className="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center">
            <span className="text-sm font-medium text-white">AD</span>
          </div>
          <div className="ml-3">
            <p className="text-sm font-medium text-white">Admin</p>
            <p className="text-xs text-gray-400">admin@brix.com</p>
          </div>
        </div>
      </div>
    </div>
  );
}



