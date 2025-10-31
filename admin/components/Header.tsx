'use client';

/**
 * Header Component - Хедер админ-панели
 */

import { BellIcon, MagnifyingGlassIcon } from '@heroicons/react/24/outline';

export default function Header() {
  return (
    <header className="flex h-16 items-center justify-between border-b border-gray-200 bg-white px-6">
      {/* Search */}
      <div className="flex flex-1 items-center">
        <div className="w-full max-w-lg">
          <label htmlFor="search" className="sr-only">
            Поиск
          </label>
          <div className="relative">
            <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
              <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" aria-hidden="true" />
            </div>
            <input
              id="search"
              name="search"
              className="block w-full rounded-md border-0 bg-gray-50 py-2 pl-10 pr-3 text-gray-900 placeholder-gray-400 focus:bg-white focus:ring-2 focus:ring-inset focus:ring-green-600 sm:text-sm"
              placeholder="Поиск..."
              type="search"
            />
          </div>
        </div>
      </div>

      {/* Right side */}
      <div className="ml-4 flex items-center space-x-4">
        {/* Notifications */}
        <button
          type="button"
          className="relative rounded-full bg-white p-1 text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2"
        >
          <span className="sr-only">View notifications</span>
          <BellIcon className="h-6 w-6" aria-hidden="true" />
          {/* Badge */}
          <span className="absolute right-0 top-0 block h-2 w-2 rounded-full bg-red-400 ring-2 ring-white" />
        </button>

        {/* Profile dropdown */}
        <div className="relative">
          <button
            type="button"
            className="flex items-center rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-green-600 focus:ring-offset-2"
          >
            <span className="sr-only">Open user menu</span>
            <div className="h-8 w-8 rounded-full bg-green-600 flex items-center justify-center">
              <span className="text-sm font-medium text-white">AD</span>
            </div>
          </button>
        </div>
      </div>
    </header>
  );
}



