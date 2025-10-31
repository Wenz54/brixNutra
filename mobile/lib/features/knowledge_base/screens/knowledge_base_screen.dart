import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/knowledge_base/knowledge_base.dart';
import '../../../dev_modules/ui_kit_module/theme/brix_theme.dart';
import '../../../dev_modules/ui_kit_module/cards/brix_card.dart';

/// Экран базы знаний (курсы и уроки)
///
/// Функции:
/// - Список курсов (бесплатные и платные)
/// - Фильтрация по категориям
/// - Просмотр прогресса
/// - Избранное
/// - Доступ к урокам
class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  String _selectedFilter = 'all'; // all, free, paid, favorite

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    // TODO: Implement filtering logic in service
    // For now, load all courses and filter on UI side
    context.read<KnowledgeBaseBloc>().add(const LoadCoursesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrixColors.background,
      appBar: AppBar(
        backgroundColor: BrixColors.surface,
        elevation: 0,
        title: Text('База знаний', style: BrixTypography.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: BrixColors.textPrimary),
            onPressed: () {
              // TODO: Search courses
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),

          // Courses list
          Expanded(
            child: BlocBuilder<KnowledgeBaseBloc, KnowledgeBaseState>(
              builder: (context, state) {
                if (state is KnowledgeBaseLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is KnowledgeBaseError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Ошибка: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCourses,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CoursesLoaded) {
                  final allCourses = state.courses;
                  
                  // Client-side filtering
                  final courses = _filterCourses(allCourses);

                  if (courses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Курсы не найдены',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadCourses();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return _buildCourseCard(course);
                      },
                    ),
                  );
                }

                return const Center(child: Text('Загрузка...'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Все', 'all'),
            _buildFilterChip('Бесплатные', 'free'),
            _buildFilterChip('Платные', 'paid'),
            _buildFilterChip('Избранное', 'favorite'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
          _loadCourses();
        },
        selectedColor: const Color(0xFF9C27B0),
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseWithProgress course) {
    final isPremium = course.course.isPremium;
    final hasProgress = course.completedLessons > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to course detail
          context.read<KnowledgeBaseBloc>().add(
            LoadCourseRequested(course.course.id),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Открыть курс ${course.course.title}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: course.course.imageUrl != null
                      ? Image.network(
                          course.course.imageUrl!,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 160,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.school, size: 60),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: 160,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.school, size: 60),
                        ),
                ),
                if (isPremium)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.workspace_premium, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'PRO',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (course.course.description != null)
                    Text(
                      course.course.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.play_circle_outline,
                        '${course.course.lessonsCount} уроков',
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.timer,
                        course.course.formattedDuration,
                        Colors.green,
                      ),
                    ],
                  ),
                  if (hasProgress) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Прогресс',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              '${((course.completedLessons / course.totalLessons) * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: course.completedLessons / course.totalLessons,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<CourseWithProgress> _filterCourses(List<CourseWithProgress> courses) {
    switch (_selectedFilter) {
      case 'free':
        return courses.where((c) => !c.course.isPremium).toList();
      case 'paid':
        return courses.where((c) => c.course.isPremium).toList();
      case 'favorite':
        return courses.where((c) => c.isFavorite).toList();
      default:
        return courses;
    }
  }
}

