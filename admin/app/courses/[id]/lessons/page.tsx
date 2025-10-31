'use client';

/**
 * Course Lessons Page - Управление уроками курса
 */

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { Lesson } from '@/lib/types';
import {
  ArrowLeftIcon,
  PlusIcon,
  PencilIcon,
  TrashIcon,
  PlayIcon,
  DocumentTextIcon,
  MusicalNoteIcon,
} from '@heroicons/react/24/outline';

export default function CourseLessonsPage() {
  const params = useParams();
  const courseId = params.id as string;

  const [lessons, setLessons] = useState<Lesson[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchLessons();
  }, [courseId]);

  const fetchLessons = async () => {
    try {
      setLoading(true);
      setError(null);

      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: Lesson[] }>(`${endpoints.courses}/${courseId}/lessons`);
      // setLessons(response.data);

      // Mock data
      setLessons([
        {
          id: '1',
          courseId,
          title: 'Введение в здоровое питание',
          description: 'Основные принципы и подходы',
          orderIndex: 1,
          type: 'video',
          content: 'https://youtube.com/watch?v=example',
          duration: 15,
          materials: [
            { name: 'Презентация.pdf', url: '/files/presentation.pdf', type: 'pdf' },
            { name: 'Конспект.docx', url: '/files/notes.docx', type: 'docx' },
          ],
          createdAt: '2025-01-15T10:00:00Z',
          updatedAt: '2025-01-15T10:00:00Z',
        },
        {
          id: '2',
          courseId,
          title: 'Макронутриенты и их роль',
          description: 'Белки, жиры, углеводы',
          orderIndex: 2,
          type: 'text',
          content: '# Макронутриенты\n\nБелки, жиры и углеводы...',
          duration: 20,
          createdAt: '2025-01-16T10:00:00Z',
          updatedAt: '2025-01-16T10:00:00Z',
        },
        {
          id: '3',
          courseId,
          title: 'Аудио-медитация: Осознанное питание',
          description: 'Практика осознанности во время еды',
          orderIndex: 3,
          type: 'audio',
          content: 'https://soundcloud.com/track/example',
          duration: 10,
          createdAt: '2025-01-17T10:00:00Z',
          updatedAt: '2025-01-17T10:00:00Z',
        },
      ]);
    } catch (err) {
      console.error('Error fetching lessons:', err);
      setError('Не удалось загрузить список уроков');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (lessonId: string) => {
    if (!confirm('Вы уверены, что хотите удалить этот урок?')) {
      return;
    }

    try {
      // TODO: Раскомментировать когда API будет готов
      // await api.delete(endpoints.lesson(lessonId));

      setLessons(lessons.filter(l => l.id !== lessonId));
      alert('Урок удален');
    } catch (err) {
      console.error('Error deleting lesson:', err);
      alert('Не удалось удалить урок');
    }
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка уроков...</p>
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
            onClick={fetchLessons}
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
        <Link
          href={`/courses/${courseId}`}
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к курсу
        </Link>
        <div className="mt-4 flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Уроки курса</h1>
            <p className="mt-2 text-gray-600">
              Управление уроками ({lessons.length})
            </p>
          </div>
          <button
            onClick={() => alert('Функция добавления урока (TODO)')}
            className="flex items-center rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
          >
            <PlusIcon className="mr-2 h-5 w-5" />
            Добавить урок
          </button>
        </div>
      </div>

      {/* Lessons List */}
      {lessons.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <DocumentTextIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Нет уроков</h3>
          <p className="mt-1 text-sm text-gray-500">
            Добавьте первый урок для этого курса
          </p>
          <div className="mt-6">
            <button
              onClick={() => alert('Функция добавления урока (TODO)')}
              className="inline-flex items-center rounded-md bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-green-700"
            >
              <PlusIcon className="mr-2 h-5 w-5" />
              Добавить урок
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          {lessons.map((lesson) => (
            <LessonCard
              key={lesson.id}
              lesson={lesson}
              onDelete={() => handleDelete(lesson.id)}
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

interface LessonCardProps {
  lesson: Lesson;
  onDelete: () => void;
}

function LessonCard({ lesson, onDelete }: LessonCardProps) {
  const getTypeIcon = () => {
    switch (lesson.type) {
      case 'video':
        return PlayIcon;
      case 'audio':
        return MusicalNoteIcon;
      case 'text':
      default:
        return DocumentTextIcon;
    }
  };

  const getTypeLabel = () => {
    switch (lesson.type) {
      case 'video':
        return 'Видео';
      case 'audio':
        return 'Аудио';
      case 'text':
      default:
        return 'Текст';
    }
  };

  const TypeIcon = getTypeIcon();

  return (
    <div className="flex items-center justify-between rounded-lg bg-white p-6 shadow hover:shadow-md transition-shadow">
      <div className="flex items-center space-x-4">
        {/* Order */}
        <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-gray-100">
          <span className="text-sm font-semibold text-gray-700">{lesson.orderIndex}</span>
        </div>

        {/* Icon */}
        <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-blue-100">
          <TypeIcon className="h-5 w-5 text-blue-600" />
        </div>

        {/* Info */}
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-gray-900">{lesson.title}</h3>
          <p className="mt-1 text-sm text-gray-600">{lesson.description}</p>
          <div className="mt-2 flex items-center space-x-4 text-sm text-gray-500">
            <span>{getTypeLabel()}</span>
            {lesson.duration && <span>• {lesson.duration} мин</span>}
            {lesson.materials && lesson.materials.length > 0 && (
              <span>• {lesson.materials.length} материал(ов)</span>
            )}
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="flex space-x-2">
        <button
          onClick={() => alert(`Редактирование урока ${lesson.id} (TODO)`)}
          className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-blue-600"
          title="Редактировать"
        >
          <PencilIcon className="h-5 w-5" />
        </button>
        <button
          onClick={onDelete}
          className="rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-red-600"
          title="Удалить"
        >
          <TrashIcon className="h-5 w-5" />
        </button>
      </div>
    </div>
  );
}



