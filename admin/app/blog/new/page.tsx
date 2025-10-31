'use client';

/**
 * Create Blog Article Page - Создание статьи блога
 */

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import Link from 'next/link';
import { api, endpoints } from '@/lib/api';
import { ArrowLeftIcon, EyeIcon } from '@heroicons/react/24/outline';

interface ArticleFormData {
  title: string;
  slug: string;
  preview: string;
  content: string;
  imageUrl?: string;
  author: string;
  category: string;
  isPublished: boolean;
}

export default function NewArticlePage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [preview, setPreview] = useState(false);

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<ArticleFormData>({
    defaultValues: {
      category: 'Здоровье',
      isPublished: false,
      author: 'Admin',
    },
  });

  const watchTitle = watch('title');
  const watchContent = watch('content');

  // Auto-generate slug from title
  const handleTitleChange = (title: string) => {
    const slug = title
      .toLowerCase()
      .replace(/[^a-zа-яё0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .slice(0, 100);
    setValue('slug', slug);
  };

  const onSubmit = async (data: ArticleFormData) => {
    try {
      setLoading(true);
      setError(null);

      // TODO: Раскомментировать когда API будет готов
      // const newArticle = await api.post(endpoints.blogArticles, data);
      // router.push(`/blog/${newArticle.id}`);

      console.log('Creating article:', data);
      alert('Статья создана! (mock)');
      router.push('/blog');
    } catch (err) {
      console.error('Error creating article:', err);
      setError('Не удалось создать статью');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-5xl space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/blog"
          className="inline-flex items-center text-sm text-gray-600 hover:text-gray-900"
        >
          <ArrowLeftIcon className="mr-2 h-4 w-4" />
          Назад к блогу
        </Link>
        <h1 className="mt-4 text-3xl font-bold text-gray-900">Создать статью</h1>
        <p className="mt-2 text-gray-600">
          Напишите и опубликуйте новую статью в блоге
        </p>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900">Основная информация</h2>
          
          <div className="mt-6 space-y-6">
            {/* Title & Slug */}
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700">
                Заголовок *
              </label>
              <input
                type="text"
                id="title"
                {...register('title', { required: 'Обязательное поле' })}
                onChange={(e) => {
                  register('title').onChange(e);
                  handleTitleChange(e.target.value);
                }}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="10 правил здорового питания"
              />
              {errors.title && (
                <p className="mt-1 text-sm text-red-600">{errors.title.message}</p>
              )}
            </div>

            <div>
              <label htmlFor="slug" className="block text-sm font-medium text-gray-700">
                URL slug *
              </label>
              <input
                type="text"
                id="slug"
                {...register('slug', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="10-pravil-zdorovogo-pitaniya"
              />
              {errors.slug && (
                <p className="mt-1 text-sm text-red-600">{errors.slug.message}</p>
              )}
            </div>

            {/* Category & Author */}
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
                  <option value="Здоровье">Здоровье</option>
                  <option value="Питание">Питание</option>
                  <option value="Витамины">Витамины</option>
                  <option value="Рецепты">Рецепты</option>
                  <option value="Фитнес">Фитнес</option>
                  <option value="Новости">Новости</option>
                </select>
              </div>

              <div>
                <label htmlFor="author" className="block text-sm font-medium text-gray-700">
                  Автор *
                </label>
                <input
                  type="text"
                  id="author"
                  {...register('author', { required: 'Обязательное поле' })}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                  placeholder="Анна Иванова"
                />
                {errors.author && (
                  <p className="mt-1 text-sm text-red-600">{errors.author.message}</p>
                )}
              </div>
            </div>

            {/* Image URL */}
            <div>
              <label htmlFor="imageUrl" className="block text-sm font-medium text-gray-700">
                URL изображения
              </label>
              <input
                type="text"
                id="imageUrl"
                {...register('imageUrl')}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="https://example.com/image.jpg"
              />
              <p className="mt-1 text-sm text-gray-500">
                Рекомендуемый размер: 800x400px
              </p>
            </div>

            {/* Preview */}
            <div>
              <label htmlFor="preview" className="block text-sm font-medium text-gray-700">
                Краткое описание *
              </label>
              <textarea
                id="preview"
                rows={3}
                {...register('preview', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm"
                placeholder="Краткое описание статьи для превью..."
              />
              {errors.preview && (
                <p className="mt-1 text-sm text-red-600">{errors.preview.message}</p>
              )}
            </div>
          </div>
        </div>

        {/* Content (Markdown) */}
        <div className="rounded-lg bg-white p-6 shadow">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-900">Содержание (Markdown)</h2>
            <button
              type="button"
              onClick={() => setPreview(!preview)}
              className="flex items-center text-sm text-green-600 hover:text-green-700"
            >
              <EyeIcon className="mr-1 h-4 w-4" />
              {preview ? 'Редактор' : 'Превью'}
            </button>
          </div>

          {!preview ? (
            <div>
              <textarea
                id="content"
                rows={20}
                {...register('content', { required: 'Обязательное поле' })}
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500 sm:text-sm font-mono"
                placeholder="# Заголовок&#10;&#10;Текст статьи..."
              />
              {errors.content && (
                <p className="mt-1 text-sm text-red-600">{errors.content.message}</p>
              )}
              
              <div className="mt-2 rounded-md bg-gray-50 p-3">
                <p className="text-xs text-gray-600">
                  <span className="font-semibold">Markdown синтаксис:</span> # Заголовок, **жирный**, *курсив*, [ссылка](url), ![изображение](url)
                </p>
              </div>
            </div>
          ) : (
            <div className="min-h-[500px] rounded-md border border-gray-300 bg-white p-6 prose prose-sm max-w-none">
              <MarkdownPreview content={watchContent || ''} />
            </div>
          )}
        </div>

        {/* Publication */}
        <div className="rounded-lg bg-white p-6 shadow">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Публикация</h2>
          
          <div className="flex items-center">
            <input
              id="isPublished"
              type="checkbox"
              {...register('isPublished')}
              className="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded"
            />
            <label htmlFor="isPublished" className="ml-2 block text-sm font-medium text-gray-900">
              Опубликовать статью
            </label>
          </div>
          <p className="mt-2 text-sm text-gray-500">
            Если не отмечено, статья будет сохранена как черновик
          </p>
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
            href="/blog"
            className="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50"
          >
            Отмена
          </Link>
          <button
            type="submit"
            disabled={loading}
            className="rounded-md bg-green-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-green-700 disabled:opacity-50"
          >
            {loading ? 'Создание...' : 'Создать статью'}
          </button>
        </div>
      </form>
    </div>
  );
}

// ==========================================
// Markdown Preview Component
// ==========================================

function MarkdownPreview({ content }: { content: string }) {
  // Простое преобразование Markdown -> HTML
  // В продакшене лучше использовать библиотеку типа react-markdown
  
  const lines = content.split('\n');
  const html: React.ReactNode[] = [];

  lines.forEach((line, idx) => {
    if (line.startsWith('# ')) {
      html.push(<h1 key={idx} className="text-3xl font-bold mt-6 mb-4">{line.slice(2)}</h1>);
    } else if (line.startsWith('## ')) {
      html.push(<h2 key={idx} className="text-2xl font-bold mt-5 mb-3">{line.slice(3)}</h2>);
    } else if (line.startsWith('### ')) {
      html.push(<h3 key={idx} className="text-xl font-semibold mt-4 mb-2">{line.slice(4)}</h3>);
    } else if (line.trim() === '') {
      html.push(<br key={idx} />);
    } else {
      // Базовое форматирование
      let formatted = line
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.*?)\*/g, '<em>$1</em>')
        .replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2" class="text-blue-600 hover:underline">$1</a>');
      
      html.push(<p key={idx} className="mb-3" dangerouslySetInnerHTML={{ __html: formatted }} />);
    }
  });

  return <div>{html}</div>;
}



