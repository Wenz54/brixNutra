'use client';

/**
 * Courses List Page - Список курсов
 */

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { Course } from '@/lib/types';
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  AcademicCapIcon,
} from '@heroicons/react/24/outline';

export default function CoursesPage() {
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: Course[] }>(endpoints.courses);
      // setCourses(response.data);
      
      // Mock data для демонстрации
      setCourses([
        {
          id: '1',
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
        },
        {
          id: '2',
          title: 'Спортивное питание',
          description: 'Как правильно питаться для достижения спортивных целей',
          imageUrl: '/placeholder-course.jpg',
          author: 'Тренер Петрова',
          isPaid: true,
          price: 2999,
          duration: '6 недель',
          category: 'Спорт',
          orderIndex: 2,
          isPublished: true,
          createdAt: '2025-02-01T10:00:00Z',
          updatedAt: '2025-02-01T10:00:00Z',
        },
        {
          id: '3',
          title: 'Питание при беременности',
          description: 'Рекомендации по питанию для будущих мам',
          imageUrl: '/placeholder-course.jpg',
          author: 'Доктор Сидорова',
          isPaid: true,
          price: 3499,
          duration: '8 недель',
          category: 'Здоровье',
          orderIndex: 3,
          isPublished: false,
          createdAt: '2025-02-10T10:00:00Z',
          updatedAt: '2025-02-10T10:00:00Z',
        },
      ]);
    } catch (err) {
      console.error('Error fetching courses:', err);
      setError('Не удалось загрузить список курсов');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (courseId: string) => {
    if (!confirm('Вы уверены, что хотите удалить этот курс?')) {
      return;
    }

    try {
      // TODO: Раскомментировать когда API будет готов
      // await api.delete(endpoints.course(courseId));
      
      setCourses(courses.filter(c => c.id !== courseId));
      alert('Курс удален');
    } catch (err) {
      console.error('Error deleting course:', err);
      alert('Не удалось удалить курс');
    }
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка курсов...</p>
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
            onClick={fetchCourses}
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
          <h1 className="text-3xl font-bold text-gray-900">Курсы</h1>
          <p className="mt-2 text-gray-600">
            Управление курсами базы знаний ({courses.length})
          </p>
        </div>
        <Link
          href="/courses/new"
          className="flex items-center rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
        >
          <PlusIcon className="mr-2 h-5 w-5" />
          Создать курс
        </Link>
      </div>

      {/* Courses Grid */}
      {courses.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <AcademicCapIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Нет курсов</h3>
          <p className="mt-1 text-sm text-gray-500">
            Создайте первый курс для базы знаний
          </p>
          <div className="mt-6">
            <Link
              href="/courses/new"
              className="inline-flex items-center rounded-md bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-green-700"
            >
              <PlusIcon className="mr-2 h-5 w-5" />
              Создать курс
            </Link>
          </div>
        </div>
      ) : (
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {courses.map((course) => (
            <CourseCard
              key={course.id}
              course={course}
              onDelete={() => handleDelete(course.id)}
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

interface CourseCardProps {
  course: Course;
  onDelete: () => void;
}

function CourseCard({ course, onDelete }: CourseCardProps) {
  return (
    <div className="group relative flex flex-col overflow-hidden rounded-lg bg-white shadow hover:shadow-lg transition-shadow">
      {/* Image */}
      <div className="relative h-48 bg-gray-200">
        {course.imageUrl ? (
          <img
            src={course.imageUrl}
            alt={course.title}
            className="h-full w-full object-cover"
          />
        ) : (
          <div className="flex h-full items-center justify-center">
            <AcademicCapIcon className="h-16 w-16 text-gray-400" />
          </div>
        )}
        
        {/* Badge */}
        {!course.isPublished && (
          <div className="absolute left-2 top-2 rounded-full bg-yellow-100 px-3 py-1 text-xs font-semibold text-yellow-800">
            Черновик
          </div>
        )}
        {course.isPaid && (
          <div className="absolute right-2 top-2 rounded-full bg-green-100 px-3 py-1 text-xs font-semibold text-green-800">
            ₽{course.price}
          </div>
        )}
        {!course.isPaid && (
          <div className="absolute right-2 top-2 rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-800">
            Бесплатно
          </div>
        )}
      </div>

      {/* Content */}
      <div className="flex flex-1 flex-col p-4">
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-gray-900 line-clamp-2">
            {course.title}
          </h3>
          <p className="mt-2 text-sm text-gray-600 line-clamp-2">
            {course.description}
          </p>
          <div className="mt-4 flex items-center justify-between text-sm text-gray-500">
            <span>{course.author}</span>
            <span>{course.duration}</span>
          </div>
        </div>

        {/* Actions */}
        <div className="mt-4 flex items-center justify-between border-t border-gray-200 pt-4">
          <span className="text-xs text-gray-500">{course.category}</span>
          <div className="flex space-x-2">
            <Link
              href={`/courses/${course.id}`}
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
    </div>
  );
}



