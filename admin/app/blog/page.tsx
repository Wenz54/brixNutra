'use client';

/**
 * Blog Articles List Page - Список статей блога
 */

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import type { Article } from '@/lib/types';
import {
  PlusIcon,
  PencilIcon,
  TrashIcon,
  NewspaperIcon,
  EyeIcon,
} from '@heroicons/react/24/outline';

export default function BlogPage() {
  const [articles, setArticles] = useState<Article[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>('all');

  useEffect(() => {
    fetchArticles();
  }, []);

  const fetchArticles = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // TODO: Раскомментировать когда API будет готов
      // const response = await api.get<{ data: Article[] }>(endpoints.blogArticles);
      // setArticles(response.data);
      
      // Mock data для демонстрации
      setArticles([
        {
          id: '1',
          title: '10 правил здорового питания для начинающих',
          slug: '10-pravil-zdorovogo-pitaniya',
          content: '# Введение\n\nЗдоровое питание - это...',
          preview: 'Узнайте основные принципы здорового питания, которые помогут вам начать путь к здоровому образу жизни.',
          imageUrl: 'https://via.placeholder.com/800x400/90EE90/000000?text=Article1',
          author: 'Анна Иванова',
          category: 'Здоровье',
          publishedAt: '2025-10-10T10:00:00Z',
          isPublished: true,
          createdAt: '2025-10-01T10:00:00Z',
          updatedAt: '2025-10-10T10:00:00Z',
        },
        {
          id: '2',
          title: 'Как читать этикетки продуктов: подробный гид',
          slug: 'kak-chitat-etiketki-produktov',
          content: '# Состав\n\nПервое, на что нужно обращать внимание...',
          preview: 'Научитесь расшифровывать информацию на этикетках продуктов и делать осознанный выбор.',
          imageUrl: 'https://via.placeholder.com/800x400/FFD700/000000?text=Article2',
          author: 'Петр Сидоров',
          category: 'Питание',
          publishedAt: '2025-10-12T14:00:00Z',
          isPublished: true,
          createdAt: '2025-10-02T10:00:00Z',
          updatedAt: '2025-10-12T14:00:00Z',
        },
        {
          id: '3',
          title: 'Витамин D: всё, что нужно знать',
          slug: 'vitamin-d-vse-chto-nuzhno-znat',
          content: '# Зачем нужен витамин D\n\n...',
          preview: 'Подробный разбор роли витамина D, норм потребления и источников.',
          imageUrl: 'https://via.placeholder.com/800x400/ADD8E6/000000?text=Article3',
          author: 'Анна Иванова',
          category: 'Витамины',
          publishedAt: undefined, // Draft
          isPublished: false,
          createdAt: '2025-10-05T10:00:00Z',
          updatedAt: '2025-10-05T10:00:00Z',
        },
        {
          id: '4',
          title: 'Топ-10 суперфудов для иммунитета',
          slug: 'top-10-superfudov-dlya-immuniteta',
          content: '# Суперфуды\n\n...',
          preview: 'Список продуктов, которые помогут укрепить ваш иммунитет.',
          imageUrl: 'https://via.placeholder.com/800x400/DDA0DD/000000?text=Article4',
          author: 'Петр Сидоров',
          category: 'Здоровье',
          publishedAt: '2025-10-14T09:00:00Z',
          isPublished: true,
          createdAt: '2025-10-08T10:00:00Z',
          updatedAt: '2025-10-14T09:00:00Z',
        },
      ]);
    } catch (err) {
      console.error('Error fetching articles:', err);
      setError('Не удалось загрузить статьи');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (articleId: string) => {
    if (!confirm('Вы уверены, что хотите удалить эту статью?')) {
      return;
    }

    try {
      // TODO: Раскомментировать когда API будет готов
      // await api.delete(`${endpoints.blogArticles}/${articleId}`);
      
      setArticles(articles.filter(a => a.id !== articleId));
      alert('Статья удалена');
    } catch (err) {
      console.error('Error deleting article:', err);
      alert('Не удалось удалить статью');
    }
  };

  const categories = Array.from(new Set(articles.map(a => a.category)));
  
  const filteredArticles = (() => {
    switch (filter) {
      case 'published':
        return articles.filter(a => a.isPublished);
      case 'draft':
        return articles.filter(a => !a.isPublished);
      default:
        if (categories.includes(filter)) {
          return articles.filter(a => a.category === filter);
        }
        return articles;
    }
  })();

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center">
          <div className="mx-auto h-12 w-12 animate-spin rounded-full border-4 border-gray-300 border-t-green-600" />
          <p className="mt-4 text-gray-600">Загрузка статей...</p>
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
            onClick={fetchArticles}
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
          <h1 className="text-3xl font-bold text-gray-900">Блог</h1>
          <p className="mt-2 text-gray-600">
            Управление статьями ({filteredArticles.length} из {articles.length})
          </p>
        </div>
        <Link
          href="/blog/new"
          className="flex items-center rounded-md bg-green-600 px-4 py-2 text-white hover:bg-green-700"
        >
          <PlusIcon className="mr-2 h-5 w-5" />
          Создать статью
        </Link>
      </div>

      {/* Filters */}
      <div className="flex space-x-2 overflow-x-auto">
        <FilterButton
          label="Все"
          active={filter === 'all'}
          onClick={() => setFilter('all')}
          count={articles.length}
        />
        <FilterButton
          label="Опубликовано"
          active={filter === 'published'}
          onClick={() => setFilter('published')}
          count={articles.filter(a => a.isPublished).length}
        />
        <FilterButton
          label="Черновики"
          active={filter === 'draft'}
          onClick={() => setFilter('draft')}
          count={articles.filter(a => !a.isPublished).length}
        />
        <div className="h-6 w-px bg-gray-300" />
        {categories.map((category) => (
          <FilterButton
            key={category}
            label={category}
            active={filter === category}
            onClick={() => setFilter(category)}
            count={articles.filter(a => a.category === category).length}
          />
        ))}
      </div>

      {/* Articles List */}
      {filteredArticles.length === 0 ? (
        <div className="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
          <NewspaperIcon className="mx-auto h-12 w-12 text-gray-400" />
          <h3 className="mt-2 text-sm font-semibold text-gray-900">Нет статей</h3>
          <p className="mt-1 text-sm text-gray-500">
            {filter === 'all' ? 'Создайте первую статью' : 'Нет статей в этом фильтре'}
          </p>
          {filter === 'all' && (
            <div className="mt-6">
              <Link
                href="/blog/new"
                className="inline-flex items-center rounded-md bg-green-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-green-700"
              >
                <PlusIcon className="mr-2 h-5 w-5" />
                Создать статью
              </Link>
            </div>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {filteredArticles.map((article) => (
            <ArticleCard
              key={article.id}
              article={article}
              onDelete={() => handleDelete(article.id)}
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

interface ArticleCardProps {
  article: Article;
  onDelete: () => void;
}

function ArticleCard({ article, onDelete }: ArticleCardProps) {
  const publishedDate = article.publishedAt
    ? new Date(article.publishedAt).toLocaleDateString('ru-RU', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      })
    : null;

  return (
    <div className="rounded-lg bg-white shadow hover:shadow-lg transition-shadow overflow-hidden">
      {/* Image */}
      {article.imageUrl && (
        <div className="relative h-48 w-full">
          <img
            src={article.imageUrl}
            alt={article.title}
            className="h-full w-full object-cover"
          />
          <div className="absolute top-2 right-2 flex space-x-2">
            <span
              className={`rounded-full px-3 py-1 text-xs font-semibold ${
                article.isPublished
                  ? 'bg-green-100 text-green-800'
                  : 'bg-gray-100 text-gray-800'
              }`}
            >
              {article.isPublished ? 'Опубликовано' : 'Черновик'}
            </span>
          </div>
        </div>
      )}

      {/* Content */}
      <div className="p-6">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <span className="rounded-full bg-blue-100 px-2 py-1 text-xs font-medium text-blue-800">
                {article.category}
              </span>
              {publishedDate && <span>• {publishedDate}</span>}
            </div>

            <h3 className="mt-2 text-xl font-semibold text-gray-900 line-clamp-2">
              {article.title}
            </h3>

            <p className="mt-2 text-sm text-gray-600 line-clamp-3">
              {article.preview}
            </p>

            <div className="mt-4 flex items-center text-sm text-gray-500">
              <span>Автор: {article.author}</span>
            </div>
          </div>
        </div>

        {/* Actions */}
        <div className="mt-4 flex space-x-3">
          <Link
            href={`/blog/${article.id}`}
            className="flex-1 inline-flex justify-center items-center rounded-md bg-white border border-gray-300 px-3 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            <PencilIcon className="h-4 w-4 mr-2" />
            Редактировать
          </Link>
          {article.isPublished && (
            <button
              className="flex items-center rounded-md bg-blue-50 border border-blue-200 px-3 py-2 text-sm font-medium text-blue-700 hover:bg-blue-100"
              title="Просмотр"
            >
              <EyeIcon className="h-4 w-4" />
            </button>
          )}
          <button
            onClick={onDelete}
            className="flex items-center rounded-md bg-red-50 border border-red-200 px-3 py-2 text-sm font-medium text-red-700 hover:bg-red-100"
            title="Удалить"
          >
            <TrashIcon className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}



